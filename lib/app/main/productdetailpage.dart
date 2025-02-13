import 'package:flutter/material.dart';
import 'package:myproject/Service/productdetailservice.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int selectedQuantity = 1;
  bool isLiked = false;  // ตัวแปรสำหรับติดตามการกดถูกใจ

  // จำลอง userId สำหรับตัวอย่างนี้
  final String userId = "";  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายละเอียดสินค้า"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<Product>(
        future: ProductService().getProductById(widget.productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('เกิดข้อผิดพลาดในการโหลดสินค้า'),
                  Text(snapshot.error.toString(), style: const TextStyle(color: Colors.red)),
                ],
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text("ไม่พบสินค้า"));
          }

          final product = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // รูปสินค้า
                if (product.imageUrl.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      itemCount: product.imageUrl.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          product.imageUrl[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 10),

                // ชื่อสินค้า
                Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                // ราคา
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('฿${product.price}', style: const TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? const Color(0XFFE35205) : Colors.grey,
                      ),
                      onPressed: () async {
                        setState(() {
                          isLiked = !isLiked;  // เปลี่ยนสถานะการกดถูกใจ
                        });

                        // ส่งข้อมูลการถูกใจไปยังเซิร์ฟเวอร์
                        final response = await http.post(
                          Uri.parse('{{base_url}}/likes'),
                          body: json.encode({
                            'userId': userId,
                            'productId': widget.productId,
                          }),
                          headers: {'Content-Type': 'application/json'},
                        );

                        if (response.statusCode == 200) {
                          // การกดถูกใจสำเร็จ
                          print('Product liked!');
                        } else {
                          // หากการกดถูกใจไม่สำเร็จ
                          print('Failed to like product');
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // รายละเอียดสินค้า
                _buildDetailText('หมวดหมู่', product.category),
                _buildDetailText('สภาพสินค้า', product.condition),
                if (product.condition == 'มือสอง') ...[
                  _buildDetailText('ระยะเวลาการใช้งาน', product.durationUse),
                  _buildDetailText('ตำหนิสินค้า', product.defect),
                ],
                _buildDetailText('สถานที่นัดรับ', product.deliveryLocation),
                _buildDetailText('ระยะเวลาที่ลงขาย', product.timeForSell),
                const SizedBox(height: 10),

                // ข้อมูลผู้ขาย
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(product.sellerPic),
                      radius: 20,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.sellerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('${product.sellerFaculty}'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // จำนวนสินค้าและปุ่มแชท
                Text('จำนวนที่เหลือ: ${product.stock}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.pushNamed(context, '/chat', arguments: {'sellerId': product.sellerName});
                //   },
                //   style: ElevatedButton.styleFrom(
                //     padding: const EdgeInsets.symmetric(vertical: 15),
                //     backgroundColor: const Color(0XFFE35205),
                //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                //   ),
                //   child: const Text('แชท', style: TextStyle(fontSize: 18, color: Colors.white)),
                // ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/chat', arguments: {'sellerId': product.sellerName});
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: const Color(0XFFE35205),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('แชท', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailText(String title, String detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(detail),
        const SizedBox(height: 10),
      ],
    );
  }
}
