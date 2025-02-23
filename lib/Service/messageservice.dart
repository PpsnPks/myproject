import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:myproject/app/main/secureStorage.dart';
import 'package:myproject/auth_service.dart';
import 'dart:convert';

import 'package:myproject/environment.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class MessageService {
  final String baseUrl = '{{base_url}}/chat';

  Future<void> sendMessage({
    required String buyerId,
    required String sellerId,
    required String message,
  }) async {
    try {
      await initializeDateFormatting("th", null);
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'buyer_id': buyerId,
          'seller_id': sellerId,
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        print('Message sent successfully');
      } else {
        print('Failed to send message: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<List<OldMessage>> getoldMessage(String receiveId) async {
    try {
      await initializeDateFormatting("th", null);
      String? accessToken = await AuthService().getAccessToken();
      String senderId = await Securestorage().readSecureData('userId');
      String url = "${Environment.baseUrl}/chat/fetch/$senderId/$receiveId";

      if (accessToken == null) {
        throw Exception('กรุณาเข้าสู่ระบบก่อนทำรายการ');
      }

      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        "Accept": "application/json",
        'Content-Type': 'application/json',
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        print('before jsonDecode');
        print(response.body);
        var decodedResponse = jsonDecode(response.body) ?? response.body;
        print('after jsonDecode');
        if (decodedResponse != null) {
          List<OldMessage> data = (decodedResponse as List).map((postJson) => OldMessage.fromJson(postJson)).toList();
          return data;
        } else {
          throw Exception('ไม่พบข้อมูลสินค้า');
        }
      } else {
        throw Exception('Error ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์: $e");
    }
  }

  Future<NewMessage> sendChat(String receiveId, String message) async {
    try {
      await initializeDateFormatting("th", null);
      String? accessToken = await AuthService().getAccessToken();
      String senderId = await Securestorage().readSecureData('userId');
      String url = "${Environment.baseUrl}/chat";

      if (accessToken == null) {
        throw Exception('กรุณาเข้าสู่ระบบก่อนทำรายการ');
      }

      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        "Accept": "application/json",
        'Content-Type': 'application/json',
      };

      Map<String, dynamic> body = {"sender_id": int.parse(senderId), "receiver_id": int.parse(receiveId), "message": message};

      final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));

      if (response.statusCode == 201) {
        var decodedResponse = jsonDecode(response.body);
        print('decodedResponse');
        if (decodedResponse != null) {
          NewMessage data = NewMessage.fromJson(decodedResponse);
          return data;
        } else {
          throw Exception('ไม่พบข้อมูลสินค้า');
        }
      } else {
        throw Exception('Error ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์: $e");
    }
  }
}

class PusherService {
  late PusherChannelsFlutter pusher;
  Function(dynamic)? onNewMessage;

  Future<void> initPusher(String receiveId, Function() addMessage) async {
    await initializeDateFormatting("th", null);
    pusher = PusherChannelsFlutter();

    try {
      String senderId = await Securestorage().readSecureData('userId');
      await pusher.init(
        apiKey: "e5bdc31db695b897c05a",
        cluster: "ap1",
        onEvent: (event) {
          print("pusher Received event: ${event.eventName}, data: ${event.data}");
          if (event.eventName == "ChatMessageSent") {
            addMessage();
          } else if (event.eventName == "ChatMessageRead") {
            addMessage();
          }
        },
      );
      int send = int.parse(senderId);
      int receive = int.parse(receiveId);

      String channelName = "chat.${send < receive ? send : receiveId}.${send > receive ? send : receive}";

      // String channelName = "private-chat-$userId";
      await pusher.subscribe(channelName: channelName).then((_) {
        print("✅ Pusher Subscribed to $channelName");
      }).catchError((error) {
        print("❌ Pusher Failed to subscribe: $error");
      });

      await pusher.connect().then((_) {
        print("✅ Pusher Connected");
      }).catchError((error) {
        print("❌ Pusher Connection Failed: $error");
      });
    } catch (e) {
      print("Pusher error: $e");
    }
  }
}

class OldMessage {
  final String id;
  final String senderId; // sender_id
  final String receiverId; // receiver_id
  final String message;
  final String image;
  final String statusread;
  final String timeStamp;
  final String thaiDate;
  final String time;

  OldMessage({
    required this.id,
    required this.senderId, //sender_id
    required this.receiverId, //receiver_id
    required this.message,
    required this.image,
    required this.statusread,
    required this.timeStamp,
    required this.thaiDate,
    required this.time,
  });

  factory OldMessage.fromJson(Map<String, dynamic> data) {
    print('1');
    DateTime dateTime = DateTime.parse(data['created_at']).toLocal(); // แปลงเป็นเวลาท้องถิ่น
    print('2');
    DateTime now = DateTime.now().add(const Duration(seconds: 3)); // เวลาปัจจุบัน
    print('3');
    DateTime sevenDaysAgo = now.subtract(const Duration(days: 7)); // เวลาย้อนหลัง 7 วัน
    print('4');

    String thaiDate;
    if (dateTime.isAfter(sevenDaysAgo) && dateTime.isBefore(now)) {
      print('Yes! 7 day');
      print(data);
      // ถ้าอยู่ใน 7 วันล่าสุด ให้แสดงเป็นชื่อวัน
      thaiDate = DateFormat("EEEE", "th").format(dateTime);
    } else {
      print('No! 7 day');
      // ถ้าไม่อยู่ในช่วง ให้แสดงเป็นวันที่แบบเต็ม
      int buddhistYear = dateTime.year + 543; // แปลง ค.ศ. เป็น พ.ศ.
      thaiDate = DateFormat("dd MMMM yyyy", "th").format(dateTime).replaceAll(dateTime.year.toString(), buddhistYear.toString());
    }
    String formattedTime = DateFormat("HH:mm").format(dateTime);
    return OldMessage(
      id: data['id'].toString(),
      senderId: data['sender_id'].toString(),
      receiverId: data['receiver_id'].toString(),
      message: data['message'].toString(),
      image: data['image'].toString(),
      statusread: data['statusread'].toString(),
      timeStamp: data['created_at'].toString(),
      thaiDate: thaiDate,
      time: formattedTime,
    );
  }
}

class NewMessage {
  final String id;
  final String senderId; // sender_id
  final String receiverId; // receiver_id
  final String message;
  final String statusread;
  final String timeStamp;
  final String thaiDate;
  final String time;

  NewMessage({
    required this.id,
    required this.senderId, //sender_id
    required this.receiverId, //receiver_id
    required this.message,
    required this.statusread,
    required this.timeStamp,
    required this.thaiDate,
    required this.time,
  });

  factory NewMessage.fromJson(Map<String, dynamic> data) {
    print('aa $data');
    DateTime dateTime = DateTime.parse(data['created_at']).toLocal(); // แปลงเป็นเวลาท้องถิ่น
    print('1');
    DateTime now = DateTime.now().add(const Duration(seconds: 3)); // เวลาปัจจุบัน
    print('2');
    DateTime sevenDaysAgo = now.subtract(const Duration(days: 7)); // เวลาย้อนหลัง 7 วัน
    print('3 ${data['message']}');

    String thaiDate;
    if (dateTime.isAfter(sevenDaysAgo) && dateTime.isBefore(now)) {
      // ถ้าอยู่ใน 7 วันล่าสุด ให้แสดงเป็นชื่อวัน
      thaiDate = DateFormat("EEEE", "th").format(dateTime);
    } else {
      // ถ้าไม่อยู่ในช่วง ให้แสดงเป็นวันที่แบบเต็ม
      int buddhistYear = dateTime.year + 543; // แปลง ค.ศ. เป็น พ.ศ.
      thaiDate = DateFormat("dd MMMM yyyy", "th").format(dateTime).replaceAll(dateTime.year.toString(), buddhistYear.toString());
    }
    String formattedTime = DateFormat("HH:mm").format(dateTime);
    print('4 $thaiDate $formattedTime');

    // final messageTime = DateFormat('HH:mm').format(DateTime.now());
    return NewMessage(
      id: data['id'].toString(),
      senderId: data['sender_id'].toString(),
      receiverId: data['receiver_id'].toString(),
      message: data['message'],
      statusread: data['statusread'].toString(),
      timeStamp: data['created_at'],
      thaiDate: thaiDate,
      time: formattedTime,
    );
  }
}
