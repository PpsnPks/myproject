import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:myproject/app/main/secureStorage.dart';
import 'package:myproject/auth_service.dart';
import 'package:myproject/environment.dart';

class Chatservice {
  Future<List<ProductChat>> getLikedProducts() async {
    // จำลองข้อมูล
    await Future.delayed(const Duration(seconds: 1)); // จำลองเวลาโหลดข้อมูล
    return [
      ProductChat(
        imageUrl: 'assets/images/a.jpg',
        title: '64010724',
        detail: 'พัดลม Xiaomi สภาพดี',
        types: 'เครื่องใช้ไฟฟ้า',
        price: '200',
        category: 'เครื่องใช้ไฟฟ้า',
      ),
      ProductChat(
        imageUrl: 'assets/images/image1.png',
        title: '64525879',
        detail: 'พัดลม Xiaomi สภาพดี',
        types: 'เครื่องใช้ไฟฟ้า',
        price: '150',
        category: 'หนังสือ',
      ),
    ];
  }

  Future<Map<String, dynamic>> getAllChat() async {
    try {
      // ดึง accessToken จาก AuthService
      String? accessToken = await AuthService().getAccessToken();
      String userId = await Securestorage().readSecureData('userId');
      String url = "${Environment.baseUrl}/seechat/$userId";

      if (accessToken == null) {
        return {
          "success": false,
          "message": "กรุณาเข้าสู่ระบบก่อนทำรายการ",
        };
      }
      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        "Accept": "application/json",
        'Content-Type': 'application/json',
      };

      final response = await http.post(Uri.parse(url), headers: headers);
      print('qqq ${response.statusCode}');

      // ตรวจสอบสถานะของ Response
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        print('qqq1 $decodedResponse');
        if (decodedResponse != null) {
          List<Chat> data = (decodedResponse as List).map((postJson) => Chat.fromJson(postJson)).toList();
          return {"success": true, "data": data};
        } else {
          return {"success": false, "message": "status code: ${response.statusCode}"};
        }
      } else {
        return {
          "success": false,
          "message": 'Error ${response.statusCode} ${response.body}',
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์: $e",
      };
    }
  }
}

class Chat {
  final String userId;
  final String pic;
  final String name;
  final String latestTime;
  final String latestMessage;
  final int unread;
  final String time;

  Chat({
    required this.userId,
    required this.pic,
    required this.name,
    required this.latestTime,
    required this.latestMessage,
    required this.unread,
    required this.time,
  });

  factory Chat.fromJson(Map<String, dynamic> data) {
    DateTime dateTime = DateTime.parse(data['latest_message_time']).toLocal(); // แปลงเป็นเวลาท้องถิ่น
    DateTime now = DateTime.now(); // เวลาปัจจุบัน
    String time = '';

    // ถ้าเป็นวันนี้
    if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
      time = DateFormat('HH:mm').format(dateTime); // แสดงเป็นเวลา (12:46)
    }
    // ถ้าเป็นปีนี้
    else if (dateTime.year == now.year) {
      time = DateFormat('d MMM').format(dateTime); // แสดงเป็นวันที่ เช่น (22 ก.พ.)
    }
    // ถ้าไม่ใช่ปีนี้
    else {
      time = DateFormat('d MMM yyyy').format(dateTime); // แสดงเป็นวันที่และปี เช่น (22 ก.พ. 2568)
    }
    return Chat(
      userId: data['user_id']?.toString() ?? "",
      pic: '${Environment.imgUrl}/${data['user']['pic']}',
      name: data['user']['name'],
      latestTime: data['latest_message_time'],
      latestMessage: data['latest_message'],
      unread: data['unread_count'],
      time: time,
    );
  }
}

class ProductChat {
  final String imageUrl;
  final String title;
  final String detail;
  final String price;
  final String category;
  final String types;

  ProductChat({
    required this.imageUrl,
    required this.title,
    required this.detail,
    required this.price,
    required this.category,
    required this.types,
  });
}
