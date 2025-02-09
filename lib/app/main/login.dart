import 'package:flutter/material.dart';
import 'package:myproject/Service/loginservice.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final LoginService _loginService = LoginService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // bool _isLoading = false; // ใช้เพื่อตรวจสอบว่าอยู่ในระหว่างการทำงานหรือไม่
  bool _obscureText = true;
  String _errorMessage = "";

  void _handleLogin(BuildContext context) async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    FocusScope.of(context).unfocus();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: SizedBox(
            height: 90.0, // กำหนดความสูง
            width: 90.0, // กำหนดความกว้าง
            child: CircularProgressIndicator(
              color: Color(0XFFE35205),
              strokeWidth: 12.0, // ปรับความหนาของวงกลม
              strokeCap: StrokeCap.round,
            ),
          ),
        );
      },
    );
    if (email.isEmpty || password.isEmpty) {
      if (mounted) {
        Navigator.pop(context);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกอีเมลและรหัสผ่าน')),
      );
      return;
    }

    final result = await _loginService.login(email, password);

    if (result['success']) {
      // เก็บ token หรือทำการ Redirect
      if (mounted) {
        Navigator.pop(context);
      }
      if (result['first']) {
        print("First Time");
        Navigator.pushReplacementNamed(context, '/infoform');
      } else {
        print("NOt First Time");
        Navigator.pushReplacementNamed(context, '/role');
      }

      // Navigator.pushNamed(context, '/role'); // แก้ไขตาม route ของคุณ
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
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
                    _handleLogin(context);
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
