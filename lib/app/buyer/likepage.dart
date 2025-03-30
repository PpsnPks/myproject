import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myproject/app/buyer/buyerfooter.dart';
import 'package:myproject/Service/likeservice.dart';

class LikePage extends StatefulWidget {
  const LikePage({super.key});

  @override
  State<LikePage> createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  late Future<String> userIdFuture;
  List<Product> like = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchLikedProducts();
  }

  void fetchLikedProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      Map<String, dynamic> response = await LikeService().getLikedProducts();
      print("Response: $response");

      if (response['success'] == true && response['data'] is List) {
        var dataList = response['data'] as List;

        setState(() {
          like = dataList.every((item) => item is Product)
              ? List<Product>.from(dataList) // ถ้าเป็น Product อยู่แล้ว
              : dataList.map((item) => Product.fromJson(item as Map<String, dynamic>)).toList();
        });

        print("Loaded Products: ${like.length}");
        print(response['data']);
      } else {
        print("Error: Invalid response format");
        setState(() {
          like = [];
        });
      }
    } catch (e) {
      print("Error fetching liked products: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("ถูกใจ"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: SizedBox(
                      width: 10.0,
                      height: 10.0,
                      child: CircularProgressIndicator(
                        color: Color(0XFFE35205),
                        strokeWidth: 2.0,
                      ),
                    )),
                    SizedBox(width: 10),
                    Text(
                      'กำลังโหลดสินค้า',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                  ],
                ),
              ),
            )
          : like.isEmpty
              ? const Center(
                  child: Text(
                    'ไม่มีสินค้าที่ถูกใจ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: like.length,
                  itemBuilder: (context, index) {
                    final product = like[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/productdetail/${product.id}',
                          // ✅ ส่งข้อมูล product ไปที่หน้ารายละเอียด
                        );
                      },
                      child: Container(
                        height: 130,
                        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(0xFFDFE2EC), width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                // ClipRRect(
                                //   borderRadius: BorderRadius.circular(12),
                                //   child: CachedNetworkImage(
                                //     imageUrl: (product.product_images.isNotEmpty && product.product_images[0] != "")
                                //         ? product.product_images[0]
                                //         : 'https://t3.ftcdn.net/jpg/05/04/28/96/360_F_504289605_zehJiK0tCuZLP2MdfFBpcJdOVxKLnXg1.jpg',
                                //     placeholder: (context, url) => const SizedBox(
                                //       width: 80, // ✅ กำหนดขนาดรูป
                                //       height: 80, // ✅ กำหนดขนาดรูป
                                //       child: Center(
                                //         child: CircularProgressIndicator(
                                //           color: Color(0XFFE35205),
                                //           strokeCap: StrokeCap.round,
                                //         ),
                                //       ),
                                //     ),
                                //     imageBuilder: (context, imageProvider) => Container(
                                //       width: 80, // ✅ กำหนดขนาดรูป
                                //       height: 80, // ✅ กำหนดขนาดรูป
                                //       decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(8),
                                //         image: DecorationImage(
                                //           image: imageProvider,
                                //           fit: BoxFit.cover, // ✅ ปรับให้รูปพอดี
                                //         ),
                                //       ),
                                //     ),
                                //     errorWidget: (context, url, error) => Container(
                                //       width: 80, // ✅ กำหนดขนาดรูป
                                //       height: 80, // ✅ กำหนดขนาดรูป
                                //       decoration: const BoxDecoration(
                                //         image: DecorationImage(
                                //           image: AssetImage("assets/images/notfound.png"),
                                //           fit: BoxFit.cover, // ✅ ปรับให้รูปพอดี
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: product.product_images.isNotEmpty
                                        ? product.product_images[0]
                                        : 'https://t3.ftcdn.net/jpg/05/04/28/96/360_F_504289605_zehJiK0tCuZLP2MdfFBpcJdOVxKLnXg1.jpg',
                                    placeholder: (context, url) => LayoutBuilder(
                                      builder: (context, constraints) {
                                        double size = constraints.maxHeight;
                                        return SizedBox(
                                          width: size,
                                          height: size, // ให้สูงเท่ากับกว้าง
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              color: Color(0XFFE35205),
                                              strokeCap: StrokeCap.round,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    imageBuilder: (context, ImageProvider) {
                                      return LayoutBuilder(
                                        builder: (context, constraints) {
                                          double size = constraints.maxHeight; // ใช้ maxWidth เป็นขนาดของ width และ height
                                          return Container(
                                            width: size,
                                            height: size, // ให้ height เท่ากับ width
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: ImageProvider,
                                                fit: BoxFit.cover, // ปรับขนาดภาพให้เต็ม
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    errorWidget: (context, url, error) => LayoutBuilder(
                                      builder: (context, constraints) {
                                        double size = constraints.maxHeight;
                                        return Container(
                                          width: size,
                                          height: size,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage("assets/images/notfound.png"), // รูปจาก assets
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.product_name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        (product.product_price == '0' || product.product_price == '0.00') // ✅ เช็กเป็น `double` แทน String
                                            ? 'ฟรี'
                                            : '${product.product_price} ฿',
                                        style: const TextStyle(color: Color(0XFFE35205), fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        product.product_description,
                                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
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
      bottomNavigationBar: buyerFooter(context, 'like'),
    );
  }
}
