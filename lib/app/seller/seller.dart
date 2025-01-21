// lib/main/like.dart
import 'package:flutter/material.dart';
import 'package:myproject/Service/categoryservice.dart';
import 'package:myproject/app/seller/sellerfooter.dart';

class SellerPage extends StatefulWidget {
  const SellerPage({super.key});

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
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
        title: const Text("คลัง"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined),
            onPressed: () {
              Navigator.of(context).pushNamed('/noti');
            },
          ),
        ],
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
                childAspectRatio: 0.67,
                crossAxisSpacing: 16,
                mainAxisSpacing: 8,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/selectproduct');
                  },
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // ignore: unused_local_variable
                      double aspectRatio =
                          (product.title.length > 20) ? 0.6 : 0.8;

                      return Stack(
                        children: [
                          Card(
                            color: const Color(0xFFFFFFFF),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Color(0xFFDFE2EC), width: 2.0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // จัดการจัดตำแหน่งเป็นแนวตั้ง
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      product
                                          .imageUrl, // ใช้ imageUrl จาก product
                                      height: constraints.maxWidth -
                                          28, // ปรับขนาดรูปภาพ
                                      width: constraints.maxWidth - 28,
                                      fit: BoxFit.contain,
                                      alignment: Alignment.topCenter,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
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
                                  const SizedBox(height: 36),
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
                                            vertical: 4, horizontal: 8),
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
                                          color: Color(0xFFFA5A2A),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // ปุ่มแก้ไขที่มุมขวาบน
                          Positioned(
                            top: 12,
                            right: 12,
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding: const EdgeInsets.all(16),
                                      height: 150,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            leading: const Icon(Icons.edit,
                                                color: Colors.grey),
                                            title: const Text('แก้ไข'),
                                            onTap: () {
                                              Navigator.pop(
                                                  context); // ปิด BottomSheet
                                              Navigator.pushNamed(
                                                context,
                                                '/editproduct',
                                                arguments: product,
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.delete,
                                                color: Colors.red),
                                            title: const Text('ลบ'),
                                            onTap: () {
                                              Navigator.pop(
                                                  context); // ปิด BottomSheet
                                              // เรียกฟังก์ชันสำหรับลบสินค้า
                                              _confirmDelete(context, product);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFA5A2A),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addproduct'); 
        },
        backgroundColor: const Color(0xFFFA5A2A),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: sellerFooter(context, 'seller'),
    );
  }
}

void _confirmDelete(BuildContext context, Product product) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: const Text('คุณแน่ใจหรือไม่ว่าต้องการลบสินค้านี้?'),
        actions: [
          TextButton(
            child: const Text('ยกเลิก'),
            onPressed: () {
              Navigator.pop(context); // ปิด dialog
            },
          ),
          TextButton(
            child: const Text('ลบ'),
            onPressed: () {
              // เรียกใช้ฟังก์ชันลบสินค้าที่นี่
              // ตัวอย่าง: productService.deleteProduct(product.id);
              Navigator.pop(context); // ปิด dialog
            },
          ),
        ],
      );
    },
  );
}
