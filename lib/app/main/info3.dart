import 'package:flutter/material.dart';

class Info3Page extends StatefulWidget {
  const Info3Page({super.key});

  @override
  _Info3PageState createState() => _Info3PageState();
}

class _Info3PageState extends State<Info3Page> {
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
            // Image.asset('assets/selling_guide.png', height: 150), // รูปภาพสื่อถึงการขายสินค้า
            const SizedBox(height: 20),
            const Text(
              'วิธีการใช้งานสำหรับผู้ขาย',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. ลงประกาศขายสินค้าที่ต้องการ\n'
              '2. เลือกประเภทสินค้า: ขาย, แจก, หรือพรีออร์เดอร์\n'
              '3. รอผู้ซื้อทักมาผ่านระบบแชท\n'
              '4. ตกลงรายละเอียดการรับส่งสินค้า',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile'); // ไปยังหน้าเริ่มใช้งาน
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFFE35205),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: const Text(
                'เริ่มใช้งาน',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
