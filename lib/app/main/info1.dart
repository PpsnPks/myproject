import 'package:flutter/material.dart';

class Info1Page extends StatefulWidget {
  const Info1Page({super.key});
  

  @override
  _Info1PageState createState() => _Info1PageState();
}

class _Info1PageState extends State<Info1Page> {
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
            // Image.asset(logo, height: 150)
            // Image.asset('assets/images/logo.png', height: 150), // รูปภาพต้อนรับ
            const SizedBox(height: 20),
            const Text(
              'ยินดีต้อนรับสู่',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'KMITL XChange',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'แอปนี้ช่วยให้นักศึกษาสามารถซื้อ ขาย หรือแจกของมือสองได้ง่ายๆ\n'
              'ผู้ซื้อสามารถค้นหาสินค้า หรือโพสต์ตามหาสินค้าที่ต้องการ\n'
              'ผู้ขายสามารถลงขายของได้ 3 รูปแบบ: ขาย, แจก, และพรีออร์เดอร์',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/info2'); // ไปยังหน้าถัดไป
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
