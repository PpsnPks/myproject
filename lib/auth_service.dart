// lib/services/auth_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // เก็บ accessToken
  Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    print("Token saved: $token");  // เพิ่ม log เมื่อบันทึก token
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_id");
  }

  // ดึง accessToken
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    print("Access Token retrieved: $accessToken");  // เพิ่ม log เมื่อดึง token
    return accessToken;
  }

  // ลบ accessToken (ออกจากระบบ)
  Future<void> removeAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    print("Token removed");  // เพิ่ม log เมื่อทำการลบ token
  }
}
