// lib/main/like.dart
import 'package:flutter/material.dart';
import 'package:myproject/app/buyer/buyerfooter.dart';
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
      body: Padding(
        padding: const EdgeInsets.only(top: 7.0),
        child: FutureBuilder<List<Product>>(
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
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/selectproduct');
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 7.0),
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color
                        border: Border.all(
                            color: Colors.grey.shade300,
                            width: 2), // Gray border
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                product.imageUrl,
                                width: 105,
                                height: 105,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    product.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        height: 1.6),
                                    maxLines: 1,
                                  ),
                                  // const SizedBox(height: 4),
                                  Container(
                                    constraints:
                                        const BoxConstraints(minHeight: 57.0),
                                    child: Text(
                                      product.detail,
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                          height: 1.3),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ),
                                  // const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        // decoration: BoxDecoration(
                                        //   color: Colors.grey[200],
                                        //   borderRadius: BorderRadius.circular(4),
                                        // ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        child: const Text(
                                          '', // product.category
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              height: 1.2),
                                        ),
                                      ),
                                      Text(
                                        '${product.price} ฿',
                                        style: const TextStyle(
                                            color: Color(0XFFE35205),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            height: 1.0),
                                      ),
                                    ],
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
  final String types;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.detail,
    required this.price,
    required this.category,
    required this.types,
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
                    types,
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
