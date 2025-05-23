import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myproject/app/main/secureStorage.dart';
import 'package:myproject/auth_service.dart';
import 'package:myproject/environment.dart';

class CustomerService {
  Future<Map<String, dynamic>> getUserByMyID() async {
    String userId = await Securestorage().readSecureData('userId');
    try {
      String? accessToken = await AuthService().getAccessToken();
      String url = "${Environment.baseUrl}/customers/$userId";
      print('${Environment.baseUrl}/customers/$userId');
      if (accessToken == null) {
        return {"success": false, "message": "กรุณาเข้าสู่ระบบก่อนทำรายการ"};
      }

      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        "Accept": "application/json",
        'Content-Type': 'application/json',
      };

      final response = await http.get(Uri.parse(url), headers: headers);
      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseBody == null || responseBody["customer"] is! Map<String, dynamic>) {
          return {"success": false, "message": "ข้อมูลผู้ใช้ไม่ถูกต้อง"};
        }
        print(responseBody);
        return {
          "success": true,
          "customer": Customer.fromJson(responseBody["customer"]),
          "tags": responseBody["customer"]["guidetag"].split(', '),
          "userpost": responseBody["userpost"],
          "userproduct": responseBody["userproduct"],
          "userhistory": responseBody["userhistory"],
        };
      } else {
        return {"success": false, "message": 'Error ${response.statusCode} ${response.body}'};
      }
    } catch (e) {
      return {"success": false, "message": "เกิดข้อผิดพลาด: $e"};
    }
  }

  Future<Map<String, dynamic>> getUserByID(String userId) async {
    try {
      String? accessToken = await AuthService().getAccessToken();
      String url = "${Environment.baseUrl}/customers/$userId";

      if (accessToken == null) {
        return {"success": false, "message": "กรุณาเข้าสู่ระบบก่อนทำรายการ"};
      }

      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        "Accept": "application/json",
        'Content-Type': 'application/json',
      };

      final response = await http.get(Uri.parse(url), headers: headers);
      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseBody == null || responseBody["customer"] is! Map<String, dynamic>) {
          return {"success": false, "message": "ข้อมูลผู้ใช้ไม่ถูกต้อง"};
        }

        return {
          "success": true,
          "customer": Customer.fromJson(responseBody["customer"]),
          "userpost":
              (responseBody["userpost"] is List) ? (responseBody["userpost"] as List).whereType<Map<String, dynamic>>().toList() : [],
          "userproduct":
              (responseBody["userproduct"] is List) ? (responseBody["userproduct"] as List).whereType<Map<String, dynamic>>().toList() : [],
          "userhistory":
              (responseBody["userhistory"] is List) ? (responseBody["userhistory"] as List).whereType<Map<String, dynamic>>().toList() : [],
        };
      } else {
        return {"success": false, "message": 'Error ${response.statusCode} ${response.body}'};
      }
    } catch (e) {
      return {"success": false, "message": "เกิดข้อผิดพลาด: $e"};
    }
  }
}

class Customer {
  final String id;
  final String name;
  final String pic;
  final String email;
  final String mobile;
  final String address;
  final String faculty;
  final String department;
  final String classyear;
  final String role;
  final String? guidetag;
  final String createdAt;
  final String updatedAt;
  final String userId;

  Customer({
    required this.id,
    required this.name,
    required this.pic,
    required this.email,
    required this.mobile,
    required this.address,
    required this.faculty,
    required this.department,
    required this.classyear,
    required this.role,
    this.guidetag,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  factory Customer.fromJson(Map<String, dynamic> data) {
    return Customer(
      id: data['id'].toString(),
      name: data['name'] ?? "",
      pic: '${Environment.imgUrl}/${data['pic']}',
      email: data['email'] ?? "",
      mobile: data['mobile'] ?? "",
      address: data['address'] ?? "",
      faculty: data['faculty'] ?? "",
      department: data['department'] ?? "",
      classyear: data['classyear'] ?? "",
      role: data['role'] ?? "",
      guidetag: data['guidetag'],
      createdAt: data['created_at'] ?? "",
      updatedAt: data['updated_at'] ?? "",
      userId: data['user_id'].toString(),
    );
  }
}
