import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:myproject/Service/loginservice.dart';
import 'package:myproject/environment.dart';

class NewPasswordPage extends StatefulWidget {
  final String data;
  const NewPasswordPage({super.key, required this.data});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _obscureText = true;
  bool _obscureText2 = true;

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกรหัสผ่าน';
    }
    final passRegExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    if (value.length < 8) {
      return 'รหัสผ่านต้องมีความยาวอย่างน้อย 8 ตัว';
    }
    if (!passRegExp.hasMatch(value)) {
      return 'รหัสผ่านต้องประกอบด้วย A-Z, a-z, 0-9 และอักขระพิเศษอย่างน้อย 1 ตัว';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณายืนยันรหัสผ่าน';
    }

    if (value != _passwordController.text) {
      return 'รหัสผ่านไม่ตรงกัน';
    }

    return null;
  }

  Future<void> _handleNewpassword() async {
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
    if (_otpController.text.isNotEmpty && _passwordController.text.isNotEmpty && _confirmPasswordController.text.isNotEmpty) {
      Map<String, dynamic> userData = {
        "email": widget.data,
        'reset_code': _otpController.text,
        'password': _passwordController.text,
        'password_confirmation': _confirmPasswordController.text,
      };

      final result = await LoginService().newpassword(userData);

      if (result['success']) {
        // เก็บ token หรือทำการ Redirect
        if (mounted) {
          Navigator.pop(context);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เปลี่ยนรหัสผ่านสำเร็จ')),
        );
        Navigator.pushNamed(context, '/login');
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'รหัสผ่านใหม่',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    obscureText: _obscureText,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'รหัสผ่าน',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      errorStyle: TextStyle(
                        fontSize: 10,
                        // กำหนดขนาดฟอนต์ของข้อความผิดพลาด
                      ),
                      errorMaxLines: 2,
                    ),
                    validator: validatePassword,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    obscureText: _obscureText2,
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'ยืนยันรหัสผ่าน',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText2 ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText2 = !_obscureText2;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      errorStyle: TextStyle(
                        fontSize: 10,
                        // กำหนดขนาดฟอนต์ของข้อความผิดพลาด
                      ),
                    ),
                    validator: validateConfirmPassword,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _otpController,
                    decoration: InputDecoration(
                      labelText: 'OTP',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      errorStyle: TextStyle(
                        fontSize: 10,
                        // กำหนดขนาดฟอนต์ของข้อความผิดพลาด
                      ),
                    ),
                    validator: (value) => (value == null || value.isEmpty) ? "กรุณากรอกรหัส OTP" : null,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color(0XFFE35205),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (_formKey.currentState?.validate() ?? false) {
                        // เปลี่ยนรหัสผ่าน Newpassword();
                        _handleNewpassword();
                      }
                    },
                    child: const Text(
                      'สร้างรหัสผ่านใหม่',
                      style: TextStyle(fontSize: 18, color: Color(0XFFFFFFFF)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
