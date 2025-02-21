import 'package:flutter/material.dart';

class Info2Page extends StatefulWidget {
  const Info2Page({super.key});

  @override
  _Info2PageState createState() => _Info2PageState();
}

class _Info2PageState extends State<Info2Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image.asset('assets/buying_guide.png', height: 150), // รูปภาพสื่อถึงการซื้อสินค้า
            const SizedBox(height: 20),
            const Text(
              'วิธีการใช้งานสำหรับผู้ซื้อ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. ค้นหาสินค้าที่คุณต้องการผ่านระบบค้นหา\n'
              '2. หากไม่พบสินค้าสามารถโพสต์ตามหาได้\n'
              '3. ติดต่อผู้ขายผ่านระบบแชท\n'
              '4. นัดรับสินค้าหรือตกลงการส่งสินค้า',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/info3'); // ไปยังหน้าถัดไป (สำหรับผู้ขาย)
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFFE35205),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: const Text(
                'ถัดไป',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
