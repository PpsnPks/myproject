import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myproject/app/main/secureStorage.dart';
import 'package:myproject/auth_service.dart';
import 'package:myproject/environment.dart';

class UserService {
  // URL ของ API
  final String registerUrl = "${Environment.baseUrl}/customers";

  // ตัวแปรเพื่อเก็บ guidetag ที่เลือก
  String guidetag = '';

  // ฟังก์ชันสำหรับการเก็บค่าของ selectedTags
  void setGuidetag(List<String> tags) {
    guidetag = tags.join(', ');
    print("✅ Guidetag set: $guidetag"); // ✅ Debugging log
  }

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
    String guidetag,
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
        "guidetag": guidetag, // เพิ่ม guidetag ที่เก็บไว้ในคลาสนี้
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

  Future<Map<String, dynamic>> formEdit(
    String name,
    String pic,
    String email,
    String mobile,
    String address,
    String faculty,
    String department,
    String classyear,
    String role,
    String guidetag,
  ) async {
    try {
      String? token = await AuthService().getAccessToken();
      String? userId = await Securestorage().readSecureData('userId');

      print('$registerUrl/$userId');
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
        "guidetag": guidetag, // เพิ่ม guidetag ที่เก็บไว้ในคลาสนี้
      };

      print('kkk3 $body');

      // POST Request
      final response = await http.put(
        Uri.parse('$registerUrl/$userId'),
        headers: headers,
        body: jsonEncode(body),
      );

      // ตรวจสอบสถานะของ Response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('data $data');
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

  // ฟังก์ชันสำหรับดึงข้อมูลผู้ใช้ตาม ID
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

      // GET Request
      final response = await http.get(
        Uri.parse('$registerUrl/$id'),
        headers: headers,
      );

      // ตรวจสอบสถานะของ Response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);

        // ตรวจสอบว่า key "customer" มีอยู่จริงและไม่ใช่ null
        if (data.containsKey('customer') && data['customer'] != null) {
          var customer = data['customer'];

          // ตรวจสอบว่ามี key "pic" หรือไม่ก่อนใช้งาน
          if (customer.containsKey('pic') && customer['pic'] != null) {
            customer['pic'] = '${Environment.imgUrl}/${customer['pic']}';
          }

          return {
            "success": true,
            "data": customer, // ส่งเฉพาะข้อมูลของลูกค้ากลับไป
          };
        } else {
          return {
            "success": false,
            "message": "ไม่พบข้อมูลลูกค้า",
          };
        }
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
