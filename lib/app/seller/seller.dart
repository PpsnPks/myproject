// lib/main/like.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Service/addservice.dart';
import 'package:myproject/app/seller/sellerfooter.dart';

class SellerPage extends StatefulWidget {
  const SellerPage({super.key});

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  bool isLoading = true;
  List<Product> products = [];

  loadall() async {
    Map<String, dynamic> response = await ProductService().getProductSeller();
    print(response['success']);
    if (response['success'] == true) {
      List<Product> data = response['data'];
      print("11111111111 ${data.length}");
      if (data.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      } else {
        setState(() {
          products = data;
          isLoading = false;
        });
        return;
      }
    }
    setState(() {
      isLoading = false;
    });
    print('lllllllllll  $response');
    return;
  }

  @override
  void initState() {
    super.initState();
    loadall();
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
      body: SingleChildScrollView(
        child: isLoading
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
            : products.isNotEmpty
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            for (int i = 0; i < products.length; i += 2)
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Stack(
                                  children: [
                                    productCardSeller(products[i],context),
                                    editButton(context, products[i]),
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            for (int i = 1; i < products.length; i += 2)
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Stack(
                                  children: [
                                    productCardSeller(products[i],context),
                                    editButton(context, products[i]),
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                    ],
                  )
                : const Center(child: Text('ไม่พบสินค้า')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addproduct');
        },
        backgroundColor: const Color(0XFFE35205),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: sellerFooter(context, 'seller'),
    );
  }
}

Widget editButton(BuildContext context, Product product) {
  return Positioned(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit, color: Colors.grey),
                    title: const Text('แก้ไข'),
                    onTap: () {
                      Navigator.pop(context); // ปิด BottomSheet
                      Navigator.pushNamed(
                        context,
                        '/editproduct/${product.id}',
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text('ลบ'),
                    onTap: () {
                      Navigator.pop(context); // ปิด BottomSheet
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
          color: Color(0XFFE35205),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.edit,
          color: Colors.white,
          size: 16,
        ),
      ),
    ),
  );
}

Widget productCardSeller(Product data, BuildContext context) {
  return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/productdetail/${data.id}',
        );
        print('click card');
      },
      child: Card(
    color: const Color(0xFFFFFFFF),
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: Color(0xFFDFE2EC), width: 2.0),
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: data.product_images.isNotEmpty
                  ? data.product_images[0]
                  : 'https://t3.ftcdn.net/jpg/05/04/28/96/360_F_504289605_zehJiK0tCuZLP2MdfFBpcJdOVxKLnXg1.jpg',
              placeholder: (context, url) => LayoutBuilder(
                builder: (context, constraints) {
                  double size = constraints.maxWidth;
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
                    double size = constraints.maxWidth; // ใช้ maxWidth เป็นขนาดของ width และ height
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
                  double size = constraints.maxWidth;
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
          const SizedBox(height: 10),
          Text(
            data.product_name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 5),
          Text(
            'จำนวน: ${data.product_qty}\nสภาพสินค้า : ${data.product_condition}\nถึงวันที่: ${data.date_exp}',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFFA5A9B6),
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              data.product_price == '0.00' ? 'ฟรี' : '${data.product_price} ฿',
              style: const TextStyle(
                color: const Color(0XFFE35205),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  )
  );
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
              ProductService().deleteProductById(product.id);
              Navigator.pop(context); // ปิด dialog
            },
          ),
        ],
      );
    },
  );
}
