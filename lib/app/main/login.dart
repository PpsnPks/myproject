import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:myproject/app/main/secureStorage.dart';
import 'package:myproject/environment.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // bool _isLoading = false; // ใช้เพื่อตรวจสอบว่าอยู่ในระหว่างการทำงานหรือไม่
  bool _obscureText = true;
  String _errorMessage = "";

  // ฟังก์ชันสำหรับล็อกอิน
  Future<void> login() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: SizedBox(
            height: 90.0, // กำหนดความสูง
            width: 90.0, // กำหนดความกว้าง
            child: CircularProgressIndicator(
              color: Colors.orange,
              strokeWidth: 12.0, // ปรับความหนาของวงกลม
              strokeCap: StrokeCap.round,
            ),
          ),
        );
      },
    );
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // ตรวจสอบข้อมูลก่อน
    if (email.isEmpty || password.isEmpty) {
      // แสดงข้อความเตือนถ้าข้อมูลยังไม่ครบ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter username and password")),
      );
      return;
    }

    // setState(() {
    //   _isLoading = true; // เปลี่ยนสถานะเป็นกำลังโหลด
    // });

    try {
      // สร้าง URL ของ API
      final Uri apiUrl = Uri.parse('${Environment.baseUrl}/auth/login');

      // ส่งข้อมูล login (username, password) ผ่าน HTTP POST
      final response = await http.post(
        apiUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      // ตรวจสอบสถานะการตอบกลับ
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // ตัวอย่างการใช้งานข้อมูลจาก API (เช่น token)
        String token = data['token'];
        String userId = data['user_id'].toString();
        Securestorage().writeSecureData('token', token);
        Securestorage().writeSecureData('userId', userId);
        final test = await Securestorage().readSecureData('token');
        print('okk === $test');
        if (mounted) {
          Navigator.pop(context);
        }
        Navigator.pushNamed(context, '/role');
        // แสดงข้อความสำเร็จ
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text("Login successful")),
        // );
      } else {
        _errorMessage = "อีเมลหรือรหัสผ่านไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง";
        // หาก API ตอบกลับไม่สำเร็จ
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login failed")),
        );
      }
    } catch (e) {
      // จัดการกับข้อผิดพลาดที่อาจเกิดขึ้น
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
      print("777777 $e");
    } finally {
      if (mounted) {
        Navigator.pop(context);
      }
      // setState(() {
      //   _isLoading = false; // เปลี่ยนสถานะกลับมาเป็นไม่กำลังโหลด
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'เข้าสู่ระบบ',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                // Email Input
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'อีเมล',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Password Input
                TextField(
                  obscureText: _obscureText,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'รหัสผ่าน',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off, // เปลี่ยนไอคอนตามสถานะ
                      ),
                      onPressed: () => {
                        setState(() {
                          _obscureText = !_obscureText; // สลับค่า _obscureText
                        })
                      }, // คลิกไอคอนเพื่อสลับสถานะ
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                _errorMessage.isNotEmpty
                    ? SizedBox(
                        height: 23,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _errorMessage,
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'Segoe UI',
                                height: 1.5,
                                textBaseline: TextBaseline.alphabetic,
                                letterSpacing: 0.4,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFFb3261e), // เปลี่ยนสีข้อความเป็นแดง
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(height: 10), // หากไม่มีข้อความผิดพลาด แสดงขนาดเว้นช่องว่าง
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgotpassword');
                    },
                    child: const Text(
                      'ลืมรหัสผ่าน?',
                      style: TextStyle(color: Color(0XFFE35205)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Login Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color(0XFFE35205),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    login();
                    // Navigator.pushNamed(context, '/role');
                  },
                  child: const Text(
                    'เข้าสู่ระบบ',
                    style: TextStyle(fontSize: 18, color: Color(0XFFFFFFFF)),
                  ),
                ),
                const SizedBox(height: 20),
                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('ยังไม่มีบัญชีผู้ใช้งาน?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                        'ลงทะเบียน',
                        style: TextStyle(color: Color(0XFFE35205)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
