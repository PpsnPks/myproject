import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// import 'package:myproject/Service/registerservice.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureText = true;
  bool _obscureText2 = true;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกอีเมล';
    }
    // ใช้ RegEx เพื่อตรวจสอบรูปแบบอีเมล
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    final kmitlRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@kmitl\.ac\.th$'); // รูปแบบอีเมล
    if (!emailRegExp.hasMatch(value)) {
      return 'รูปแบบอีเมลไม่ถูกต้อง';
    } else if (!kmitlRegExp.hasMatch(value)) {
      return 'กรุณาลงทะเบียนด้วยอีเมลของสถาบัน';
    }
    return null; // ถ้าผ่าน validation
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกอีเมล';
    }
    // ใช้ RegEx เพื่อตรวจสอบรูปแบบอีเมล
    final passRegExp = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    if (value.length < 8) {
      return 'รหัสผ่านต้องมีความยาวอย่างน้อย 8 ตัว';
    }
    if (!passRegExp.hasMatch(value)) {
      return 'รหัสผ่านต้องประกอบด้วย A-Z, a-z, 0-9 และอักขระพิเศษอย่างน้อย 1 ตัว';
    }
    return null; // ถ้าผ่าน validation
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณายืนยันรหัสผ่าน';
    }

    if (value != _passwordController.text) {
      return 'รหัสผ่านไม่ตรงกัน';
    }

    return null; // ถ้าผ่าน validation
  }

  Future<void> registerUser() async {
    if (_emailController.text != '' &&
        _emailController.text != '' &&
        _passwordController.text != '' &&
        _confirmPasswordController.text != '') {
      // สร้างข้อมูลที่จะส่งไปยัง API
      Map<String, dynamic> userData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'password_confirmation': _confirmPasswordController.text,
      };

      final Uri url = Uri.parse('http://localhost:8000/api/auth/register');
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(userData),
        );

        // ตรวจสอบสถานะของ response
        if (response.statusCode == 200) {
          // หากการลงทะเบียนสำเร็จ
          print('ลงทะเบียนสำเร็จ');
          // แสดงข้อความแจ้ง หรือนำผู้ใช้ไปหน้าอื่น
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ลงทะเบียนสำเร็จ')),
          );
        } else {
          // หากการลงทะเบียนล้มเหลว
          print('การลงทะเบียนล้มเหลว: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('การลงทะเบียนล้มเหลว')),
          );
          // แสดงข้อความแจ้ง error
          // setState(() {
          //   _errorMessage = 'การลงทะเบียนล้มเหลว: ${response.body}';
          // });
        }
      } catch (error) {
        // Handle network or other errors
        print('เกิดข้อผิดพลาด: $error');
        // setState(() {
        //   _errorMessage = 'เกิดข้อผิดพลาด: $error';
        // });
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey, // ผูกฟอร์มกับ _formKey
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'ลงทะเบียน',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                // Name Input
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'ชื่อ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Email Input
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'อีเมล',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: validateEmail, // ใช้ฟังก์ชัน validate
                ),
                const SizedBox(height: 20),
                // Password Input
                TextFormField(
                  obscureText: _obscureText,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'รหัสผ่าน',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility
                            : Icons.visibility_off, // เปลี่ยนไอคอนตามสถานะ
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
                  validator: validatePassword,
                ),
                const SizedBox(height: 20),
                // Confirm Password Input
                TextFormField(
                  obscureText: _obscureText2,
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'ยืนยันรหัสผ่าน',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText2
                            ? Icons.visibility
                            : Icons.visibility_off, // เปลี่ยนไอคอนตามสถานะ
                      ),
                      onPressed: () => {
                        setState(() {
                          _obscureText2 =
                              !_obscureText2; // สลับค่า _obscureText
                        })
                      }, // คลิกไอคอนเพื่อสลับสถานะ
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: validateConfirmPassword,
                ),
                const SizedBox(height: 30),
                // Register Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color(0XFFE35205),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    print(_nameController.text);
                    print(_emailController.text);
                    print(_passwordController.text);
                    print(_confirmPasswordController.text);
                    // ตรวจสอบว่า form ทั้งหมดผ่าน validation หรือไม่
                    if (_formKey.currentState?.validate() ?? false) {
                      // ถ้าผ่าน validation
                      print('อีเมลถูกต้อง: ${_emailController.text}');
                      registerUser();
                    } else {
                      print('ข้อมูลไม่ถูกต้อง');
                    }
                  },
                  child: const Text(
                    'ลงทะเบียน',
                    style: TextStyle(fontSize: 18, color: Color(0XFFFFFFFF)),
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
