// lib/main/like.dart
import 'package:flutter/material.dart';
import 'package:myproject/Service/categoryservice.dart';
import 'package:myproject/app/buyer/buyerfooter.dart';
// import 'package:myproject/service/likeservice.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late Future<List<Product>> likedProducts;

  @override
  void initState() {
    super.initState();
    // เรียก LikeService เพื่อดึงข้อมูลสินค้าที่ถูกใจ
    likedProducts = Categoryservice().getCategoryProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("หมวดหมู่"),
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
              padding: const EdgeInsets.all(16), // เพิ่ม padding ให้ดูสมส่วน
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 คอลัมน์
                // เริ่มต้นด้วย childAspectRatio = 0.7
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context,
                        '/selectproduct'); // เปลี่ยนหน้าไปที่ '/confirm' เมื่อกดคาร์ด
                  },
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // ตรวจสอบความยาวของ title
                      // ignore: unused_local_variable
                      double aspectRatio = (product.title.length > 20)
                          ? 0.6
                          : 0.8; // ปรับค่า childAspectRatio ตามความยาว

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // จัดการจัดตำแหน่งเป็นแนวตั้ง
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  product.imageUrl, // ใช้ imageUrl จาก product
                                  height: 120, // ปรับขนาดรูปภาพ
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 20),
                              // ใช้ Flexible เพื่อให้ข้อความสามารถขยายได้
                              Flexible(
                                child: Text(
                                  product.title, // ใช้ title จาก product
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow
                                      .ellipsis, // ใช้ ellipsis เพื่อแสดงจุดไข่ปลาเมื่อยาวเกินไป
                                  maxLines: 2, // จำกัดจำนวนบรรทัดที่จะแสดง
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, // จัดตำแหน่งให้ห่างกัน
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey), // กำหนดสีขอบ
                                      borderRadius: BorderRadius.circular(
                                          12), // กำหนดมุมโค้งมนของกรอบ
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      product.category, // หมวดหมู่ของสินค้า
                                      style: TextStyle(
                                        color: Colors.blueGrey[400],
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${product.price} ฿', // ใช้ price จาก product พร้อมแสดงหน่วยเงิน
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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

// class ProductCard extends StatelessWidget {
//   final String imageUrl;
//   final String title;
//   final String detail;
//   final String price;
//   final String category;

//   const ProductCard({
//     super.key,
//     required this.imageUrl,
//     required this.title,
//     required this.detail,
//     required this.price,
//     required this.category,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.asset(
//                 imageUrl,
//                 width: 80,
//                 height: 80,
//                 fit: BoxFit.contain,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     detail,
//                     style: const TextStyle(
//                         color: Color.fromARGB(255, 24, 52, 177), fontSize: 16),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     price,
//                     style: const TextStyle(color: Colors.orange, fontSize: 16),
//                   ),
//                   const SizedBox(height: 8),
//                   Chip(
//                     label: Text(category, style: const TextStyle(fontSize: 12)),
//                     backgroundColor: Colors.grey[200],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
