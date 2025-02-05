import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myproject/auth_service.dart';
import 'package:myproject/environment.dart';

class UserService {
  // URL ของ API
  final String registerUrl = "${Environment.baseUrl}/customers";

  // ฟังก์ชันสำหรับ register
  Future<Map<String, dynamic>> form(
    String name,
    String pic,
    String email,
    String mobile,
    String address,
    String faculty,
    String department,
    String classyear,
    String role,
  ) async {
    try {
      String? token = await AuthService().getAccessToken();
      // Header
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

      // Body
      Map<String, dynamic> body = {
        "name": name,
        "pic": pic,
        "email": email,
        "mobile": mobile,
        "address": address,
        "faculty": faculty,
        "department": department,
        "classyear": classyear,
        "role": role,
      };

      print(body);

      // POST Request
      final response = await http.post(
        Uri.parse(registerUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      // ตรวจสอบสถานะของ Response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          "success": true,
          "data": data, // รับข้อมูลจาก API
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          "success": false,
          "message": errorData['message'] ?? "เกิดข้อผิดพลาดในการเข้าสู่ระบบ",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้: $e",
      };
    }
  }

  Future<Map<dynamic, dynamic>> getUserById(int id) async {
    try {
      // Header
      AuthService authService = AuthService();
      String? accessToken = await authService.getAccessToken();
      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

      // POST Request
      final response = await http.get(
        Uri.parse('$registerUrl/$id'),
        headers: headers,
      );

      // ตรวจสอบสถานะของ Response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        return {
          "success": true,
          "data": data, // รับข้อมูลจาก API
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          "success": false,
          "message": errorData['message'] ?? "เกิดข้อผิดพลาดในการเข้าสู่ระบบ",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้: $e",
      };
    }
  }
}
