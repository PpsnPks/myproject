import 'package:flutter/material.dart';
import 'package:myproject/Service/loginservice.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกอีเมล';
    }
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    final kmitlRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@kmitl\.ac\.th$');
    if (!emailRegExp.hasMatch(value)) {
      return 'รูปแบบอีเมลไม่ถูกต้อง';
    } else if (!kmitlRegExp.hasMatch(value)) {
      return 'กรุณาลงทะเบียนด้วยอีเมลของสถาบัน';
    }
    return null;
  }

  void _handleForgotpassword() async {
    final String email = _emailController.text.trim();
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
    if (email.isEmpty) {
      if (mounted) {
        Navigator.pop(context);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกอีเมล')),
      );
      return;
    }

    final result = await LoginService().forgotpassword(email);

    if (result['success']) {
      // เก็บ token หรือทำการ Redirect
      if (mounted) {
        Navigator.pop(context);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('รหัส OTP ถูกส่งไปยังอีเมล กรุณาตรวจสอบ')),
      );
      Navigator.pushNamed(
        context,
        '/newpassword',
        arguments: {
          'data': _emailController.text,
        },
      );
      // Future.delayed(const Duration(seconds: 2), () {
      // });

      // Navigator.pushNamed(context, '/role'); // แก้ไขตาม route ของคุณ
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
      print(result['message']);
      // แสดงข้อความผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'ลืมรหัสผ่าน',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                // Email Input
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'อีเมล',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: validateEmail,
                ),
                const SizedBox(height: 30),
                // Submit Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color(0XFFE35205),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    // Add forgot password functionality
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (_formKey.currentState?.validate() ?? false) {
                      // เปลี่ยนรหัสผ่าน registerUser();
                      _handleForgotpassword();
                    }
                  },
                  child: const Text(
                    'ถัดไป',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0XFFFFFFFF),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
