import 'package:flutter/material.dart';
import 'package:myproject/Service/loginservice.dart'; 

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LoginService _loginService = LoginService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _handleLogin(BuildContext context) async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกอีเมลและรหัสผ่าน')),
      );
      return;
    }

    final result = await _loginService.login(email, password);

    if (result['success']) {
      // เก็บ token หรือทำการ Redirect
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('เข้าสู่ระบบสำเร็จ')),
      );
      Navigator.pushNamed(context, '/role'); // แก้ไขตาม route ของคุณ
    } else {
      // แสดงข้อความผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
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
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'อีเมล',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'รหัสผ่าน',
                  suffixIcon: const Icon(Icons.visibility),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),

              SizedBox(height: 10),
              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context,'/otp');
                  },
                  child: Text(
                    'ลืมรหัสผ่าน?',
                    style: TextStyle(
                      color: const Color(0XFFE35205)
                      ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0XFFE35205),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () => _handleLogin(context),
                child: const Text(
                  'เข้าสู่ระบบ',
                  style: TextStyle(fontSize: 18, color: Color(0XFFFFFFFF)),
                ),
              ),

              SizedBox(height: 20),
              // Register link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ยังไม่มีบัญชีผู้ใช้งาน?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context,'/register');
                    },
                    child: Text(
                      'ลงทะเบียน',
                      style: TextStyle(color: const Color(0XFFE35205)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
