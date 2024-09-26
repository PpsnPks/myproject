// lib/main/like.dart
import 'package:flutter/material.dart';
import 'package:myproject/app/buyer/homepage.dart';
import 'package:myproject/service/likeservice.dart';

class LikePage extends StatefulWidget {
  const LikePage({super.key});

  @override
  State<LikePage> createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  late Future<List<Product>> likedProducts;

  @override
  void initState() {
    super.initState();
    // เรียก LikeService เพื่อดึงข้อมูลสินค้าที่ถูกใจ
    likedProducts = LikeService().getLikedProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ถูกใจ"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      
      body: FutureBuilder<List<Product>>(
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
            
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 2.5, // คงไว้เพื่อให้มีสัดส่วนที่เหมาะสม
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context,'/selectproduct'); // เปลี่ยนหน้าไปที่ '/confirm' เมื่อกดคาร์ด
                  },
                  child: Card(
                    margin: const EdgeInsets.only(
                      left: 20.0, // มาร์จินซ้าย
                      right: 20.0, // มาร์จินขวา
                      top: 7.0, // มาร์จินด้านบน
                      bottom: 7.0, // มาร์จินด้านล่าง
                    ),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              product.imageUrl, // ใช้ imageUrl จาก product
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title, // ใช้ title จาก product
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  product.detail, // ใช้ detail จาก product
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  product.price, // ใช้ price จาก product
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: buyerFooter(context, 'like'),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String detail;
  final String price;
  final String category;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.detail,
    required this.price,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    detail,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 24, 52, 177), fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: const TextStyle(color: Colors.orange, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(category, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.grey[200],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
