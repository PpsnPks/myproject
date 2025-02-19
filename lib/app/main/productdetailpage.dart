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
  bool isLiked = false; // ตัวแปรสำหรับติดตามการกดถูกใจ
  int currentIndex = 0;
  bool isLoading = true;
  late ProductDetail data;

  // จำลอง userId สำหรับตัวอย่างนี้
  final String userId = "";

  void toggleLike() async {
    isLiked = !isLiked;
    if (isLiked == true) {
      await ProductService().likeProduct(int.parse(widget.productId));
    } else {
      await ProductService().unlikeProduct(widget.productId);
    }
  }

  void getProductDetail() async {
    setState(() {
      isLoading = true;
    });
    ProductDetail response = await ProductService().getProductById(widget.productId);
    setState(() {
      isLiked = response.isLiked;
      data = response;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getProductDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("รายละเอียดสินค้า"),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: isLoading
            ? const Center(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0XFFE35205),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // รูปสินค้า
                    if (data.imageUrl.isNotEmpty)
                      Stack(
                        children: [
                          SizedBox(
                            height: 300,
                            child: PageView.builder(
                              itemCount: data.imageUrl.length,
                              itemBuilder: (context, index) {
                                return Image.network(
                                  data.imageUrl[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                                );
                              },
                              onPageChanged: (index) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                data.imageUrl.length,
                                (index) => Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: index == currentIndex ? const Color(0XFFE35205) : Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 16,
                            child: Text(
                              '${currentIndex + 1}/${data.imageUrl.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),

                    // ชื่อสินค้า
                    Text(data.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),

                    // ราคา
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('฿${data.price}', style: const TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? const Color(0XFFE35205) : Colors.grey,
                          ),
                          onPressed: () async {
                            setState(() {
                              toggleLike();
                              // isLiked = !isLiked; // เปลี่ยนสถานะการกดถูกใจ
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // รายละเอียดสินค้า
                    _buildDetailText('รายละเอียดสินค้า', data.description),
                    _buildDetailText('หมวดหมู่', data.category),
                    _buildDetailText('สภาพสินค้า', data.condition),
                    if (data.condition == 'มือสอง') ...[
                      _buildDetailText('ระยะเวลาการใช้งาน', data.durationUse),
                      _buildDetailText('ตำหนิสินค้า', data.defect),
                    ],
                    _buildDetailText('สถานที่นัดรับ', data.deliveryLocation),
                    _buildDetailText('ระยะเวลาที่ลงขาย', data.timeForSell),
                    const SizedBox(height: 10),

                    // ข้อมูลผู้ขาย
                    Text('โพสต์โดย', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(data.sellerPic),
                          radius: 20,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.sellerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('${data.sellerFaculty}'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // จำนวนสินค้าและปุ่มแชท
                    Text('จำนวนที่เหลือ: ${data.stock}', style: const TextStyle(fontSize: 18)),
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
                              Navigator.pushNamed(context, '/chat', arguments: {'sellerId': data.sellerName});
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
              )

        // FutureBuilder<ProductDetail>(
        //   future: ProductService().getProductById(widget.productId),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const Center(child: CircularProgressIndicator());
        //     } else if (snapshot.hasError) {
        //       return Center(
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             const Text('เกิดข้อผิดพลาดในการโหลดสินค้า'),
        //             Text(snapshot.error.toString(), style: const TextStyle(color: Colors.red)),
        //           ],
        //         ),
        //       );
        //     } else if (!snapshot.hasData) {
        //       return const Center(child: Text("ไม่พบสินค้า"));
        //     }

        //     final product = snapshot.data!;

        //     return
        //   },
        // ),
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
