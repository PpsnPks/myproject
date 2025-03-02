import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
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

  Future<void> registerUser() async {
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

      final Uri url = Uri.parse('${Environment.baseUrl}/auth/register');
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(userData),
        );
        if (mounted) {
          Navigator.pop(context);
        }
        print('${response.statusCode}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          final int userId = responseData['user_id'];
          print(userId); // ดึงค่า user_id จากการตอบสนอง

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('เปลี่ยนรหัสผ่านสำเร็จ')),
          );
          print('Navigating to OTP page');
          Navigator.pushReplacementNamed(
            context,
            '/login',
            // arguments: {
            //   'email': widget.data,
            //   'user_id': userId, // ส่งค่า user_id ไปยังหน้า OTP
            // },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('การเปลี่ยนรหัสผ่านล้มเหลว')),
          );
        }
      } catch (error) {
        if (mounted) {
          Navigator.pop(context);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้: $error')),
        );
        print('เกิดข้อผิดพลาด: $error');
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
                      if (_formKey.currentState?.validate() ?? false) {
                        // เปลี่ยนรหัสผ่าน registerUser();
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
