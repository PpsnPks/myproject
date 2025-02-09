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
      String productName,
      List productImages,
      int productQty,
      String productPrice,
      String productDescription,
      String productCategory,
      String productType,
      String dateExp,
      String productLocation,
      String productCondition,
      String productDefect,
      String productYears,
      String tag) async {
    try {
      // ดึง accessToken จาก AuthService
      AuthService authService = AuthService();
      String? accessToken = await authService.getAccessToken();
      String userId = await Securestorage().readSecureData('userId') ?? '99999';
      String? productConditionValue = productType == 'preorder' ? 'มือหนึ่ง' : productCondition;
      // print(productName);
      // print(productConditionValue);
      print(
          'productName = $productName \n productImages = $productImages \n productQty = $productQty \n productPrice = $productPrice \n productDescription = $productDescription \n productCategory = $productCategory \n productType = $productType \n dateExp = $dateExp \n productLocation = $productLocation \n productCondition = $productCondition \n productDefect = $productDefect \n productYears = $productYears \n tag = $tag');
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
        "product_name": productName.isEmpty ? "N/A" : productName,
        "product_images": productImages,
        "product_qty": productQty,
        "product_price": int.parse(productPrice),
        "product_description": productDescription,
        "product_category": productCategory,
        "product_type": productType,
        "seller_id": int.parse(userId),
        "date_exp": dateExp,
        "product_location": productLocation,
        "product_condition": productConditionValue,
        "product_defect": productDefect,
        "product_years": productYears,
        "tag": tag,
      };

      // แปลง Map เป็น JSON string ก่อนส่ง
      String jsonBody = json.encode(body);
      print(jsonBody);
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
          "message": 'error ${response.statusCode} ${response.body}',
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้นะจ๊ะ 555 $e",
      };
    }
  }
}
