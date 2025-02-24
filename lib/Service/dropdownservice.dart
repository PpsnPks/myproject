import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myproject/auth_service.dart';
import 'package:myproject/environment.dart';

class Dropdownservice {
  Future<List<dynamic>> getCategory() async {
    const url = "${Environment.baseUrl}/categories";

    try {
      // ดึง accessToken จาก AuthService
      AuthService authService = AuthService();
      String? accessToken = await authService.getAccessToken();

      // Header
      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        "Accept": "application/json",
        'Content-Type': 'application/json',
      };

      // ส่ง GET request
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data']['data'];
        return data;
      } else {
        print('❌ Error: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('❌ Exception: $e');
      return [];
    }
  }

  /// 🔹 ฟังก์ชันสำหรับดึง Tags ตาม categoryId
  Future<List<dynamic>> _fetchTagsForCategory(int categoryId) async {
    final String url = "${Environment.baseUrl}/tagsbycategories/$categoryId";
    print("🔍 Requesting: $url");

    try {
      AuthService authService = AuthService();
      String? accessToken = await authService.getAccessToken();

      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        "Accept": "application/json",
        'Content-Type': 'application/json',
      };

      final response = await http.get(Uri.parse(url), headers: headers);
      print("🛠 Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final body = response.body.trim();

        if (body.isEmpty) {
          print("❌ Error: Response body ว่างเปล่า");
          return [];
        }

        try {
          final jsonResponse = jsonDecode(body);
          if (jsonResponse is List) {
            return jsonResponse;
          } else if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
            final data = jsonResponse['data'];
            return (data is List) ? data : [];
          } else {
            print("❌ Error: Response ไม่ใช่ JSON ที่คาดหวัง");
          }
        } catch (jsonError) {
          print("❌ JSON Decode Error: $jsonError");
        }
      } else {
        print("❌ Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("❌ Exception: $e");
    }
    return [];
  }

  /// 🔹 ดึง Tags ตาม List ของ categoryIds
  Future<List<dynamic>> getTag(List<int> categoryIds) async {
    if (categoryIds.isEmpty) {
      print("❌ Error: ต้องเลือกหมวดหมู่ก่อน!");
      return [];
    }

    try {
      // ดึงข้อมูล Tags สำหรับทุก categoryId ที่ส่งมาแบบ async
      final results = await Future.wait(
        categoryIds.map((categoryId) => _fetchTagsForCategory(categoryId)),
      );

      // รวมผลลัพธ์จากหลาย categoryId ให้อยู่ใน List เดียวกัน
      return results.expand((list) => list).toList();
    } catch (e) {
      print("❌ Exception while fetching tags: $e");
      return [];
    }
  }
}
