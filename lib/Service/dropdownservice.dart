import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myproject/auth_service.dart';
import 'package:myproject/environment.dart';

class Dropdownservice {
  Future<dynamic> getCategory() async {
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

      // Get Request
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data']['data'];
        return data;
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Exception: $e');
      return [];
    }
  }

  Future<List<dynamic>> getTag(List<int> categoryIds) async {
  if (categoryIds.isEmpty) {
    print("❌ Error: ต้องเลือกหมวดหมู่ก่อน!");
    return [];
  }

  Future<List<dynamic>> fetchTagsForCategory(int categoryId) async {
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
    print("🛠 Raw Response Body: '${response.body}'"); // ⭐ Debug ตรงนี้

    if (response.statusCode == 200) {
      final body = response.body.trim(); // ลบช่องว่างหรือ newline

      // ✅ ตรวจสอบว่า response.body เป็น JSON หรือไม่
      if (body.isEmpty) {
        print("❌ Error: Response body ว่างเปล่า");
        return [];
      }

      try {
        final jsonResponse = jsonDecode(body);

        if (jsonResponse is List) {
          return jsonResponse; // 🔥 ถ้า API ส่ง List มาโดยตรง
        } else if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
          final data = jsonResponse['data'];
          if (data is List) {
            return data; // 🔥 ถ้า API หุ้ม List ไว้ใน 'data'
          } else {
            print("❌ Error: 'data' ไม่ใช่ List แต่เป็น ${data.runtimeType}");
          }
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

  try {
    final results = await Future.wait(
      categoryIds.map((categoryId) => fetchTagsForCategory(categoryId)).toList(),
    );

    List<dynamic> combinedResults = results.expand((list) => list).toList();
    return combinedResults;
  } catch (e) {
    print("❌ Exception while fetching tags: $e");
    return [];
  }
}

}
