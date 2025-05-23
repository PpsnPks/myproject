import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myproject/app/main/secureStorage.dart';
import 'package:myproject/environment.dart';
import 'package:myproject/auth_service.dart';

class LoginService {
  // URL ของ API
  final String url = "${Environment.baseUrl}/auth/login";
  final String url1 = "${Environment.baseUrl}/auth/checkemail";
  final String url2 = "${Environment.baseUrl}/auth/resetPassword";

  // ฟังก์ชันสำหรับ login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Header
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

      // Body
      Map<String, String> body = {
        "email": email,
        "password": password,
      };

      // POST Request
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      // พิมพ์ response.body เพื่อดูข้อมูลที่ได้รับจาก API
      print("aa Response body: ${response.statusCode}} ${response.body}");
      // ตรวจสอบสถานะของ Response
      if (response.statusCode == 200) {
        // แปลง JSON เป็น Map

        var data = jsonDecode(response.body);
        String accessToken = data['token'];

        // บันทึก access_token โดยใช้ AuthService
        AuthService authService = AuthService();
        await authService.saveAccessToken(accessToken);
        // เก็บ data
        String token = data['token'];
        Securestorage().writeSecureData('token', token);
        if (data['user_data'].isNotEmpty) {
          print('kkk1 ${data['user_data']}');
          // print('kkk2 ${data['user_data'][0]['id']}');
          String userId = data['user_data'][0]['id'].toString(); // ตอนนี้เก็บ id ตาราง customer
          String userId2 = data['user_data'][0]['user_id'].toString(); // ตอนนี้เก็บ id ตาราง customer
          Securestorage().writeSecureData('userId', userId);
          Securestorage().writeSecureData('userId2', userId2);
        }
        Securestorage().writeSecureData('email', email);
        Securestorage().writeSecureData('password', password);

        // final test = await Securestorage().readSecureData('token');
        // print('okk === $test');
        if (data['user_data'].isEmpty) {
          return {"success": true, "data": jsonDecode(response.body), "first": true}; // ไปที่ role
        } else {
          if (data['user_data'][0]['guidetag'] != null) {
            return {"success": true, "data": jsonDecode(response.body), "first": false, "second": false}; // ไปที่ role
          } else {
            return {"success": true, "data": jsonDecode(response.body), "first": false, "second": true}; // ไปที่ categoryform
          }
        }
      } else {
        // กรณีเกิดข้อผิดพลาดจาก API
        return {
          "success": false,
          "message": jsonDecode(response.body)['message'] ?? "เกิดข้อผิดพลาดในการเข้าสู่ระบบ",
        };
      }
    } catch (e) {
      // กรณีเกิดข้อผิดพลาดทั่วไป
      return {
        "success": false,
        "message": "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้ $e",
      };
    }
  }

  Future<Map<String, dynamic>> forgotpassword(String email) async {
    try {
      // Header
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
      };
      // Body
      Map<String, String> body = {"email": email};
      // POST Request
      final response = await http.post(
        Uri.parse(url1),
        headers: headers,
        body: jsonEncode(body),
      );
      // พิมพ์ response.body เพื่อดูข้อมูลที่ได้รับจาก API
      print("aa Response body: ${response.statusCode} ${response.body}");
      // ตรวจสอบสถานะของ Response
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return {"success": true, "data": jsonDecode(response.body)};
      } else {
        return {
          "success": false,
          "message": jsonDecode(response.body)['message'] ?? "เกิดข้อผิดพลาดในการเข้าสู่ระบบ",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้ $e",
      };
    }
  }

  Future<Map<String, dynamic>> newpassword(Map<String, dynamic> userData) async {
    try {
      // Header
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
      };
      // Body
      Map<String, dynamic> body = userData;
      // POST Request
      final response = await http.post(
        Uri.parse(url2),
        headers: headers,
        body: jsonEncode(body),
      );
      // พิมพ์ response.body เพื่อดูข้อมูลที่ได้รับจาก API
      print("aa Response body: ${response.statusCode} ${response.body}");
      // ตรวจสอบสถานะของ Response
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return {"success": true, "data": jsonDecode(response.body)};
      } else {
        return {
          "success": false,
          "message": jsonDecode(response.body)['message'] ?? "เกิดข้อผิดพลาดในการเข้าสู่ระบบ",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้ $e",
      };
    }
  }

  // Future<Map<String, dynamic>> checkFirstTime() async {
  //   try {
  //     AuthService authService = AuthService();
  //     String? accessToken = await authService.getAccessToken(); // Header
  //     String userId = await Securestorage().readSecureData('userId');
  //     Map<String, String> headers = {
  //       'Authorization': 'Bearer $accessToken',
  //       "Accept": "application/json",
  //       "Content-Type": "application/json",
  //     };

  //     // POST Request
  //     final response = await http.get(
  //       Uri.parse("$url2/${int.parse(userId)}"),
  //       headers: headers,
  //     );

  //     // พิมพ์ response.body เพื่อดูข้อมูลที่ได้รับจาก API
  //     print("Response body: ${response.body}");

  //     // ตรวจสอบสถานะของ Response
  //     if (response.statusCode == 404) {
  //       return {
  //         "success": true,
  //         "first": true,
  //       };
  //     } else {
  //       return {
  //         "success": true,
  //         "first": false,
  //       };
  //     }
  //   } catch (e) {
  //     // กรณีเกิดข้อผิดพลาดทั่วไป
  //     return {
  //       "success": false,
  //       "message": "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้",
  //     };
  //   }
  // }
}
