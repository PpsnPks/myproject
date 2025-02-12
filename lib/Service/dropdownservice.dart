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

      // ตรวจสอบสถานะของ Response
      if (response.statusCode == 200) {
        print('44444 ${response.statusCode}');
        List data = jsonDecode(response.body)['data']['data'];
        print('44444 $data');
        return data;
      } else {
        print('44444 ${response.statusCode}');
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
