import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myproject/environment.dart';

class OtpService {
  // URL ของ API
  final String otpUrl = "${Environment.baseUrl}/auth/verifyemail";

  // ฟังก์ชันสำหรับ verifyemail
  Future<Map<String, dynamic>> verifyemail(String userId, String email, String verificationCode) async {
    try {
      // Header
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

      // Body
      Map<String, String> body = {"user_id": userId, "email": email, "verification_code": verificationCode};

      // POST Request
      final response = await http.post(
        Uri.parse(otpUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      // ตรวจสอบสถานะของ Response
      if (response.statusCode == 200) {
        // แปลง JSON เป็น Map
        return {
          "success": true,
          "data": jsonDecode(response.body),
        };
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
        "message": "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้",
      };
    }
  }
}
