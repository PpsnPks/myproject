import 'dart:convert'; // เพิ่มการนำเข้า dart:convert
import 'package:myproject/app/main/secureStorage.dart';
import 'package:myproject/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:myproject/environment.dart';

class AddService {
  // URL ของ API
  final String postUrl = "${Environment.baseUrl}/products";

  // ฟังก์ชันสำหรับ post
  Future<Map<String, dynamic>> addproduct(
      String product_name,
      String product_images,
      String product_qty,
      String product_price,
      String product_description,
      String product_category,
      String product_type,
      String date_exp,
      String product_location,
      String product_condition,
      String product_defect,
      String product_years,
      String tag) async {
    try {
      // ดึง accessToken จาก AuthService
      AuthService authService = AuthService();
      String? accessToken = await authService.getAccessToken();
      String userId = await Securestorage().readSecureData('userId') ?? '99999';

      if (accessToken == null) {
        return {
          "success": false,
          "message": "ไม่พบ access token",
        };
      }

      // Header
      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

      // Body (แปลงข้อมูลให้เป็น JSON string)
      Map<String, dynamic> body = {
        "product_name": product_name.isEmpty ? "N/A" : product_name,
        "product_images": product_images,
        "product_qty": int.parse(product_qty),
        "product_price": int.parse(product_price),
        "product_description": product_description,
        "product_category": product_category,
        "product_type": product_type,
        "seller_id": int.parse(userId),
        "date_exp": date_exp,
        "product_location": product_location,
        "product_condition": product_condition,
        "product_defect": product_defect,
        "product_years": product_years,
        "tag": tag,
      };

      // แปลง Map เป็น JSON string ก่อนส่ง
      String jsonBody = json.encode(body);

      // POST Request
      final response = await http.post(
        Uri.parse(postUrl),
        headers: headers,
        body: jsonBody, // ส่งข้อมูลในรูปแบบ JSON
      );

      // ตรวจสอบสถานะของ Response
      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": response.body,
        };
      } else {
        return {
          "success": false,
          "message": response.body ?? "เกิดข้อผิดพลาดในการเข้าสู่ระบบ",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้นะจ๊ะ",
      };
    }
  }
}
