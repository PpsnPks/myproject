// otp.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myproject/Service/otpservice.dart'; // Import OtpService

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final OtpService _otpService = OtpService();
  final TextEditingController _otpController1 = TextEditingController();
  final TextEditingController _otpController2 = TextEditingController();
  final TextEditingController _otpController3 = TextEditingController();
  final TextEditingController _otpController4 = TextEditingController();

  late String userId; // ใช้ late เนื่องจากจะรับค่าจาก arguments
  late String email; // ใช้ late เนื่องจากจะรับค่าจาก arguments
  bool enableButton = false;

  void check4digitOTP() {
    String otp = _otpController1.text.trim() + _otpController2.text.trim() + _otpController3.text.trim() + _otpController4.text.trim();
    if (otp.length == 4) {
      setState(() {
        enableButton = true;
      });
    } else {
      setState(() {
        enableButton = false;
      });
    }
  }

  void _verifyOtp() async {
    print('_verifyOtp');
    String otp = _otpController1.text.trim() + _otpController2.text.trim() + _otpController3.text.trim() + _otpController4.text.trim();

    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกรหัส OTP ให้ครบ')),
      );
      return;
    }

    final result = await _otpService.verifyemail(userId, email, otp);

    if (result['success']) {
      // OTP Verification successful
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ยืนยัน OTP สำเร็จ')),
      );
      Navigator.pushNamed(context, '/login'); // Navigate to next screen after success
    } else {
      // OTP Verification failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // การจัดการกับ arguments อย่างปลอดภัย
    final args = ModalRoute.of(context)?.settings.arguments as Map?; // ใช้ null-aware
    if (args != null) {
      email = args['email'];
      userId = args['user_id'].toString();
      // แสดงค่าใน console (log)
      print('Received email: $email');
      print('Received user_id: $userId');
    } else {
      // จัดการกับกรณีที่ arguments เป็น null (สามารถเพิ่มการแสดงผลหรือตัวจัดการตามต้องการ)
      print('Error: No arguments passed to the route!');
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
          child: SingleChildScrollView(
            // ทำให้สามารถเลื่อนหน้าจอได้
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // ตรงกลาง
              crossAxisAlignment: CrossAxisAlignment.center, // ตรงกลาง
              children: <Widget>[
                const Text(
                  'ยืนยันรหัส OTP',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                // OTP Input 4 ช่อง
                Form(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _otpInputField(_otpController1),
                      const SizedBox(width: 10),
                      _otpInputField(_otpController2),
                      const SizedBox(width: 10),
                      _otpInputField(_otpController3),
                      const SizedBox(width: 10),
                      _otpInputField(_otpController4),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Submit Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: enableButton ? const Color(0XFFE35205) : const Color.fromARGB(122, 227, 83, 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () => {enableButton ? _verifyOtp() : print('null')}, // Verify OTP when button is pressed
                  child: Text(
                    'ถัดไป',
                    style: TextStyle(
                      fontSize: 18,
                      color: enableButton ? const Color(0XFFFFFFFF) : const Color.fromARGB(129, 255, 255, 255),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันสำหรับสร้างช่องรับ OTP
  Widget _otpInputField(TextEditingController controller) {
    return SizedBox(
      width: 50,
      height: 70,
      child: TextFormField(
        controller: controller,
        onChanged: (value) {
          check4digitOTP();
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
