// Non-use
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myproject/environment.dart';

class RegisterService {
  // URL ของ API
  final String registerUrl = "${Environment.baseUrl}/auth/register";

  // ฟังก์ชันสำหรับ register
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    try {
      // Header
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

      // Body
      Map<String, String> body = {"name": name, "email": email, "password": password, "password_confirmation": passwordConfirmation};

      // POST Request
      final response = await http.post(
        Uri.parse(registerUrl),
        headers: headers,
        body: jsonEncode(body),
      );
      // ตรวจสอบสถานะของ Response
      if (response.statusCode == 200 || response.statusCode == 201) {
        // แปลง JSON เป็น Map
        final data = jsonDecode(response.body);
        return {
          "success": true,
          // "data": jsonDecode(response.body),
          "data": data, // รับข้อมูล user_id และอื่นๆ จาก API
        };
      } else {
        // กรณีเกิดข้อผิดพลาดจาก API
        return {
          "success": false,
          "message": "${response.statusCode} ${jsonDecode(response.body)['message']}" ?? "เกิดข้อผิดพลาดในการเข้าสู่ระบบ",
        };
      }
    } catch (e) {
      // กรณีเกิดข้อผิดพลาดทั่วไป
      return {
        "success": false,
        "message": "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้",
      };
    }
  }
}
