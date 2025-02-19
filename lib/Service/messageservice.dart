import 'package:http/http.dart' as http;
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
      String? accessToken = await AuthService().getAccessToken();
      String senderId = await Securestorage().readSecureData('userId');
      String url = "${Environment.baseUrl}/chat/fetch/$receiveId/$senderId";

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
        var decodedResponse = jsonDecode(response.body);
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
  Function(String)? onNewMessage;

  Future<void> initPusher(String userId) async {
    pusher = PusherChannelsFlutter();

    try {
      await pusher.init(
        apiKey: "e5bdc31db695b897c05a",
        cluster: "ap1",
        onEvent: (event) {
          print("Received event: ${event.eventName}, data: ${event.data}");
          if (onNewMessage != null) {
            onNewMessage!(event.data);
            print('22222222222222222222222');
          }

          if (event.eventName == "ChatMessageSent") {
            print('ok');
          }
        },
      );

      String channelName = "Chat";
      // String channelName = "private-chat-$userId";
      await pusher.subscribe(channelName: channelName);
      // await pusher.bind("ChatMessageSent", (event) {
      //   print("New message: ${event.data}");
      // });

      await pusher.connect();
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

  OldMessage({
    required this.id,
    required this.senderId, //sender_id
    required this.receiverId, //receiver_id
    required this.message,
    required this.image,
    required this.statusread,
  });

  factory OldMessage.fromJson(Map<String, dynamic> data) {
    return OldMessage(
      id: data['id'].toString(),
      senderId: data['sender_id'].toString(),
      receiverId: data['receiver_id'].toString(),
      message: data['message'].toString(),
      image: data['image'].toString(),
      statusread: data['statusread'].toString(),
    );
  }
}

class NewMessage {
  final String id;
  final String senderId; // sender_id
  final String receiverId; // receiver_id
  final String message;
  final String create;

  NewMessage({
    required this.id,
    required this.senderId, //sender_id
    required this.receiverId, //receiver_id
    required this.message,
    required this.create,
  });

  factory NewMessage.fromJson(Map<String, dynamic> data) {
    return NewMessage(
      id: data['id'].toString(),
      senderId: data['sender_id'].toString(),
      receiverId: data['receiver_id'].toString(),
      message: data['message'],
      create: data['created_at'],
    );
  }
}
