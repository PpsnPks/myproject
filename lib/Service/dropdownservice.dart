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
    print("❌ Error: categoryIds is empty!");
    return [];
  }

  final String url = "${Environment.baseUrl}/tagsbycategories/${categoryIds.join(',')}";
  print("🔍 Requesting: $url");

  try {
    final response = await http.get(Uri.parse(url));

    print("🛠 Response Status: ${response.statusCode}");
    print("🛠 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      return [];
    }
  } catch (e) {
    print("❌ Exception: $e");
    return [];
  }
}

}
