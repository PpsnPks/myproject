import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Service/confirmservice.dart';
import 'package:myproject/Service/productdetailservice.dart';
import 'package:myproject/app/buyer/buyerfooter.dart';
import 'package:myproject/app/main/secureStorage.dart';
import 'package:myproject/service/likeservice.dart';

class ConfirmSellerPage extends StatefulWidget {
  final String data;

  const ConfirmSellerPage({super.key, required this.data});
  State<ConfirmSellerPage> createState() => _ConfirmState();
}

class _ConfirmState extends State<ConfirmSellerPage> {
  late Future<List<ProductLike>> likedProducts;
  final userId = Securestorage().readSecureData('userId');
  bool isLoading = false;
  // String b =
  //     '{"id" : "1", "imageUrl" : "/images/Es9fkHJpdfEcXGnzLvDMHMrmPKQL9ohhwSAplFo3.png", "name" : "รองเท้า air jordan 1 low", "condition" : "มือหนึ่ง", "stock": "1", "timeForSell": "2025-12-12", "price": "25000"}';
  // String stock = '3';
  // String name = 'Pipusana Pingkasan';
  // String faculty = 'วิศวะ';
  // String sellerPic = 'aaa';
  dynamic data = '';
  int qty = 1;
  final TextEditingController _productQtyController = TextEditingController();

//  final Confirm confirmData = Confirmservice.getConfirm();
  confirmDeal(String dealId, String buyerId, String productId, int qty) async {
    bool response = await ProductService().putDeal(dealId, buyerId, productId, qty);
    if (response) {
      Navigator.pushReplacementNamed(context, '/cart-seller/2');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.data != '') {
      setState(() {
        data = jsonDecode(widget.data);
      });
    }
    // เรียก LikeService เพื่อดึงข้อมูลสินค้าที่ถูกใจ
    // likedProducts = LikeService().getLikedProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("รอยืนยัน"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/cart-seller/1');
          },
        ),
      ),
      body: isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // ทำให้ column มีขนาดเท่ากับเนื้อหาภายใน
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
                    SizedBox(width: 10), // เพิ่มระยะห่างระหว่าง progress กับข้อความ
                    Text(
                      'กำลังโหลดสินค้า',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: SizedBox(height: 130, width: double.infinity, child: buildProductCard(data)),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Text('คลัง   :  ${data['stock']}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('จำนวน', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.white, // สีพื้นหลังของปุ่ม (เปลี่ยนได้)
                                  border: Border.all(color: const Color(0xFFE35205), width: 2), // กรอบสีส้ม
                                  borderRadius: BorderRadius.circular(10), // ทำให้ขอบมน
                                ),
                                alignment: Alignment.center,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (qty > 1) {
                                        qty--;
                                        _productQtyController.text = qty.toString(); // อัปเดตค่าของ controller
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.remove, color: Color(0xFFE35205)),
                                  iconSize: 24, // ลดขนาดไอคอนให้พอดีกับ Container
                                  padding: EdgeInsets.zero, // ลบ Padding ออกเพื่อให้อยู่ตรงกลางจริง ๆ
                                  constraints: const BoxConstraints(),
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Text(qty.toString(), style: const TextStyle(fontSize: 18)),
                              const SizedBox(width: 12.0),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.white, // สีพื้นหลังของปุ่ม (เปลี่ยนได้)
                                  border: Border.all(color: const Color(0xFFE35205), width: 2), // กรอบสีส้ม
                                  borderRadius: BorderRadius.circular(10), // ทำให้ขอบมน
                                ),
                                alignment: Alignment.center,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (qty < int.parse(data['stock'])) {
                                        qty++;
                                      }
                                      _productQtyController.text = qty.toString(); // อัปเดตค่าของ controller
                                    });
                                  },
                                  icon: const Icon(Icons.add, color: Color(0xFFE35205)),
                                  iconSize: 24, // ลดขนาดไอคอนให้พอดีกับ Container
                                  padding: EdgeInsets.zero, // ลบ Padding ออกเพื่อให้อยู่ตรงกลางจริง ๆ
                                  constraints: const BoxConstraints(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      const Text('โพสต์โดย', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 6.0,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(data['seller_pic']),
                            radius: 20,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['seller_name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(data['seller_faculty']),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await confirmDeal(data['deal_id'], data['buyer_user_id'], data['product_id'], qty);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: const Color(0XFFE35205),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('ยืนยัน', style: TextStyle(fontSize: 18, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
      // bottomNavigationBar: buyerFooter(context, 'cart-seller'),
    );
  }

  Widget buildProductCard(dynamic data) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/productdetail/${data['product_id']}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          border: Border.all(color: Colors.grey.shade300, width: 2), // Gray border
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: data['product_images'].isNotEmpty
                      ? data['product_images']
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
                              fit: BoxFit.fill, // ปรับขนาดภาพให้เต็ม
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
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Flexible(
                fit: FlexFit.loose,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      data['product_name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      'จำนวน: ${data['stock']}\nสภาพสินค้า : ${data['product_condition']}\nถึงวันที่: ${data['timeForSell']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFA5A9B6),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        data['price'] == '0' || data['price'] == '0.00' ? 'ฟรี' : '${data['price']} ฿',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                // child: Text(
                //   product.product_description,
                //   style: const TextStyle(color: Colors.grey, fontSize: 10),
                //   overflow: TextOverflow.ellipsis,
                //   maxLines: 3,
                // ),
              ),
              // const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
