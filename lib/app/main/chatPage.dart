import 'package:flutter/material.dart';
import 'package:myproject/app/buyer/buyerfooter.dart';
import 'package:myproject/service/Chatservice.dart';

class Chatpage extends StatefulWidget {
  const Chatpage({super.key});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  late Future<List<ProductChat>> likedProducts;

  @override
  void initState() {
    super.initState();
    // เรียก Chatservice เพื่อดึงข้อมูลสินค้าที่ถูกใจ
    likedProducts = Chatservice().getLikedProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("แชท"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<List<ProductChat>>(
        future: likedProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('ไม่มีสินค้าที่ถูกใจ'));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return NotificationCard(
                  title: product.title,
                  time: '17:30 น.', // ใส่เวลาที่ต้องการ
                  imageUrl: product.imageUrl,
                  detail: product.detail,
                  onTap: () {
                    Navigator.pushNamed(context, '/message');
                  },
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: buyerFooter(context, 'chat'),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String time;
  final String imageUrl;
  final String detail;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.title,
    required this.time,
    required this.imageUrl,
    required this.detail,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // ใช้ GestureDetector สำหรับการกด
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFDFE2EC), width: 2.0)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported, size: 50);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      detail,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
