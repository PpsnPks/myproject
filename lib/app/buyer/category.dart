// lib/main/like.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myproject/Service/categoryservice.dart';
import 'package:myproject/app/buyer/buyerfooter.dart';
// import 'package:myproject/service/likeservice.dart';

class CategoryPage extends StatefulWidget {
  final String category;

  // รับค่าพารามิเตอร์ category ผ่านคอนสตรัคเตอร์
  const CategoryPage(this.category, {super.key});
  //const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late Future<List<Product>> likedProducts;
  List<Product> products = [];
  final scrollController = ScrollController();
  int page = 1;
  int perPage = 5;
  bool isLoadingMore = false;
  bool hasMore = true;
  _loadmore() async {
    List<Product> newPosts = [];
    Map<String, dynamic> response = await ProductService().getProduct(page, perPage);
    if (response['success'] == true) {
      newPosts = response['data'];
      print("11111111111 $newPosts");
      if (newPosts.isEmpty) {
        setState(() {
          hasMore = false;
        });
        return;
      } else {
        setState(() {
          products.addAll(newPosts);
        });
        return;
      }
    }
    print('lllllllllll  $response');
    return;
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scorollListener);
    _loadmore(); // ดึงข้อมูลจาก API
    // เรียก LikeService เพื่อดึงข้อมูลสินค้าที่ถูกใจ
    likedProducts = Categoryservice().getCategoryProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.category),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        actions: [
          IconButton(
            padding: const EdgeInsets.all(16.0),
            icon: const Icon(
              Icons.sort_rounded,
              color: Color(0xFFA5A9B6),
              size: 30,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    height: 460,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                            child: Text(
                          'ตัวกรอง',
                          style: TextStyle(fontSize: 24),
                        )),
                        Expanded(
                          child: ListView(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.all(0.0),
                                // leading: const Icon(Icons.edit, color: Colors.grey),
                                title: const Text(
                                  'เรียงตามราคา (สูงไปต่ำ)',
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                ),
                                onTap: () {
                                  Navigator.pop(context); // ปิด BottomSheet
                                },
                              ),
                              const Divider(height: 0),
                              ListTile(
                                contentPadding: const EdgeInsets.all(0.0),
                                title: const Text('เรียงตามราคา (ต่ำไปสูง)'),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const Divider(height: 0),
                              ListTile(
                                contentPadding: const EdgeInsets.all(0.0),
                                title: const Text('เรียงตามวันที่ลงสินค้า'),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const Divider(height: 0),
                              ListTile(
                                contentPadding: const EdgeInsets.all(0.0),
                                title: const Text('เรียงตามสภาพสินค้า (มือหนึ่ง)'),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const Divider(height: 0),
                              ListTile(
                                contentPadding: const EdgeInsets.all(0.0),
                                title: const Text('เรียงตามสภาพสินค้า (มือสอง)'),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const Divider(height: 0),
                              ListTile(
                                contentPadding: const EdgeInsets.all(0.0),
                                title: const Text('เรียงตามประเภทสินค้า (ขาย)'),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const Divider(height: 0),
                              ListTile(
                                contentPadding: const EdgeInsets.all(0.0),
                                title: const Text('เรียงตามประเภทสินค้า (แจก)'),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const Divider(height: 0),
                              ListTile(
                                contentPadding: const EdgeInsets.all(0.0),
                                title: const Text('เรียงตามประเภทสินค้า (พรีออเดอร์)'),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const Divider(height: 0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          // const SizedBox(
          //   width: 12,
          // )
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 66),
              controller: scrollController,
              itemCount: ((products.isEmpty && isLoadingMore) || !hasMore) ? 2 : 1,
              itemBuilder: (context, index) {
                if (products.isEmpty && isLoadingMore) {
                  return const Center(
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
                  );
                } else if (products.isEmpty) {
                  return const Center(child: Text('ไม่พบสินค้า'));
                } else if (products.isNotEmpty && index == 0) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            for (int i = 0; i < products.length; i += 2)
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: productCard(products[i]),
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
                                child: productCard(products[i]),
                              )
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (products.isNotEmpty && index == 1) {
                  if (isLoadingMore) {
                    return const Center(
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
                              'กำลังโหลดโพสต์เพิ่มเติม...',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 10.0),
                      child: Center(
                        child: Text(
                          'ไม่มีโพสต์ที่จะแสดงเพิ่มเติม',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                      ),
                    );
                  }
                }
              }),
          // FutureBuilder<List<Product>>(
          //   future: likedProducts,
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return const Center(child: CircularProgressIndicator());
          //     } else if (snapshot.hasError) {
          //       return const Center(child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล'));
          //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          //       return const Center(child: Text('ไม่มีสินค้าที่ถูกใจ'));
          //     } else {
          //       final products = snapshot.data!;

          //       return SingleChildScrollView(
          //         padding: const EdgeInsets.only(left: 12, right: 12, top: 66),
          //         child: Row(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Expanded(
          //               child: Column(
          //                 children: [
          //                   for (int i = 0; i < products.length; i += 2)
          //                     Padding(
          //                       padding: const EdgeInsets.all(4.0),
          //                       child: productCard(products[i]),
          //                     )
          //                 ],
          //               ),
          //             ),
          //             Expanded(
          //               child: Column(
          //                 children: [
          //                   for (int i = 1; i < products.length; i += 2)
          //                     Padding(
          //                       padding: const EdgeInsets.all(4.0),
          //                       child: productCard(products[i]),
          //                     )
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       );
          //     }
          //   },
          // ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: searchInputField(), // คงตำแหน่ง SearchInputField ไว้ด้านบน
          ),
        ],
      ),
      bottomNavigationBar: buyerFooter(context, 'home'),
    );
  }

  void _scorollListener() async {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      page += 1;
      setState(() {
        isLoadingMore = true;
      });
      await _loadmore();
      setState(() {
        isLoadingMore = false;
      });
      print('max');
    }
    print('scroll listener called');
  }

  Widget productCard(Product data) {
    return Card(
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
              child: Image.asset(
                data.imageUrl, //'assets/images/old_book.jpg',
                height: 120,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              data.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(height: 5),
            Text(
              data.detail,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFA5A9B6),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '${data.price} ฿',
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchInputField() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0, bottom: 10),
        child: TextField(
          onSubmitted: (value) {
            setState(() {});
          },
          decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 8.0), // Adjust the padding value as needed
                child: SvgPicture.asset(
                  'assets/icons/search-line.svg',
                  width: 10.0, // Icon width
                  height: 10.0, // Icon height
                ),
              ), // ไอคอนแว่นขยาย
              hintText: 'ค้นหาสิ่งที่คุณต้องการ',
              hintStyle: const TextStyle(
                color: Color(0xFFA5A9B6), // Set the hintText color
                fontSize: 16.0,
              ),
              //enabledBorder: const OutlineInputBorder(
              //  borderSide: BorderSide(width: 2, color: Color(0xFFDFE2EC)), //<-- SEE HERE
              //),
              filled: true, // เปิดใช้งานพื้นหลัง
              fillColor: Colors.white, // กำหนดสีพื้นหลังเป็นสีขาว
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)), // Set the border radius
                borderSide: BorderSide(
                  width: 2.0, // Set border width
                  color: Color(0xFFDFE2EC), // Set border color
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)), // Same radius for focused border
                borderSide: BorderSide(
                  width: 2.0,
                  color: Color.fromARGB(255, 174, 180, 192), // Border color when focused
                ),
              )),
        ),
      ),
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
