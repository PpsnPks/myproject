// lib/main/like.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myproject/Service/addservice.dart';
import 'package:myproject/app/buyer/buyerfooter.dart';

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
  int perPage = 6;
  bool isLoadingMore = false;
  bool hasMore = true;
  bool hasError = false;
  String searchText = "";
  String sortPrice = "asc";
  String sortDate = "desc";
  String productCondition = '';
  String productType = '';

  int filterIndex = 0;

  resetFilter() {
    sortPrice = "asc";
    sortDate = "desc";
    productCondition = '';
    productType = '';
  }

  _loadnew() async {
    List<Product> newPosts = [];
    setState(() {
      products = [];
      isLoadingMore = true;
    });
    Map<String, dynamic> response = await ProductService()
        .getProductCategory(page, perPage, widget.category, searchText, sortPrice, sortDate, productCondition, productType);
    if (response['success'] == true) {
      newPosts = response['data'];
      print('$page, $perPage, ${widget.category}, $searchText, $sortPrice, $sortDate, $productCondition, $productType');
      print("11111111111 $newPosts");
      if (newPosts.isEmpty) {
        setState(() {
          isLoadingMore = false;
          hasMore = false;
        });
        return;
      } else {
        setState(() {
          isLoadingMore = false;
          products = newPosts;
        });
        return;
      }
    }
    setState(() {
      isLoadingMore = false;
      hasMore = false;
    });
    print('lllllllllll  $response');
    return;
  }

  _loadmore() async {
    List<Product> newPosts = [];
    setState(() {
      isLoadingMore = true;
    });
    Map<String, dynamic> response = await ProductService()
        .getProductCategory(page, perPage, widget.category, searchText, sortPrice, sortDate, productCondition, productType);
    if (response['success'] == true) {
      newPosts = response['data'];
      print("11111111111 $newPosts");
      if (newPosts.isEmpty) {
        setState(() {
          isLoadingMore = false;
          hasMore = false;
        });
        return;
      } else {
        setState(() {
          isLoadingMore = false;
          products.addAll(newPosts);
        });
        return;
      }
    }
    setState(() {
      isLoadingMore = false;
      hasMore = false;
    });
    print('lllllllllll  $response');
    return;
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scorollListener);
    _loadmore(); // ดึงข้อมูลจาก API
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
              Icons.sort,
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
                                trailing: filterIndex == 1 ? const Icon(Icons.check_circle, color: Colors.green) : const Text(''),
                                onTap: () {
                                  if (filterIndex != 1) {
                                    filterIndex = 1;
                                    print('aaa 1');
                                  } else {
                                    filterIndex = 0;
                                    print('aaa 0');
                                  }
                                  resetFilter();
                                  sortPrice = "desc";
                                  _loadnew();
                                  Navigator.pop(context); // ปิด BottomSheet
                                },
                              ),
                              const Divider(height: 0),
                              ListTile(
                                contentPadding: const EdgeInsets.all(0.0),
                                title: const Text('เรียงตามราคา (ต่ำไปสูง)'),
                                trailing: filterIndex == 2 ? const Icon(Icons.check_circle, color: Colors.green) : const Text(''),
                                onTap: () {
                                  if (filterIndex != 2) {
                                    filterIndex = 2;
                                    print('aaa 2');
                                  } else {
                                    filterIndex = 0;
                                    print('aaa 0');
                                  }
                                  resetFilter();
                                  sortPrice = "asc";
                                  _loadnew();
                                  Navigator.pop(context);
                                },
                              ),
                              const Divider(height: 0),
                              ListTile(
                                contentPadding: const EdgeInsets.all(0.0),
                                title: const Text('เรียงตามวันที่ลงสินค้า (เก่าสุด)'),
                                trailing: filterIndex == 3 ? const Icon(Icons.check_circle, color: Colors.green) : const Text(''),
                                onTap: () {
                                  if (filterIndex != 3) {
                                    filterIndex = 3;
                                    print('aaa 3');
                                  } else {
                                    filterIndex = 0;
                                    print('aaa 0');
                                  }
                                  resetFilter();
                                  sortDate = "asc"; //เก่าสุด
                                  _loadnew();
                                  Navigator.pop(context);
                                },
                              ),
                              const Divider(height: 0),
                              ListTile(
                                contentPadding: const EdgeInsets.all(0.0),
                                title: const Text('เรียงตามวันที่ลงสินค้า (ล่าสุด)'),
                                trailing: filterIndex == 4 ? const Icon(Icons.check_circle, color: Colors.green) : const Text(''),
                                onTap: () {
                                  if (filterIndex != 4) {
                                    filterIndex = 4;
                                    print('aaa 4');
                                  } else {
                                    filterIndex = 0;
                                    print('aaa 0');
                                  }
                                  resetFilter();
                                  sortDate = "desc"; //ล่าสุด
                                  _loadnew();
                                  Navigator.pop(context);
                                },
                              ),
                              const Divider(height: 0),
                              ListTile(
                                contentPadding: const EdgeInsets.all(0.0),
                                title: const Text('เรียงตามสภาพสินค้า (มือหนึ่ง)'),
                                trailing: filterIndex == 5 ? const Icon(Icons.check_circle, color: Colors.green) : const Text(''),
                                onTap: () {
                                  if (filterIndex != 5) {
                                    filterIndex = 5;
                                    print('aaa 5');
                                  } else {
                                    filterIndex = 0;
                                    print('aaa 0');
                                  }
                                  resetFilter();
                                  productCondition = 'มือหนึ่ง';
                                  _loadnew();
                                  Navigator.pop(context);
                                },
                              ),
                              const Divider(height: 0),
                              ListTile(
                                contentPadding: const EdgeInsets.all(0.0),
                                title: const Text('เรียงตามสภาพสินค้า (มือสอง)'),
                                trailing: filterIndex == 6 ? const Icon(Icons.check_circle, color: Colors.green) : const Text(''),
                                onTap: () {
                                  if (filterIndex != 6) {
                                    filterIndex = 6;
                                    print('aaa 6');
                                  } else {
                                    filterIndex = 0;
                                    print('aaa 0');
                                  }
                                  resetFilter();
                                  productCondition = 'มือสอง';
                                  _loadnew();
                                  Navigator.pop(context);
                                },
                              ),
                              const Divider(height: 0),
                              ListTile(
                                contentPadding: const EdgeInsets.all(0.0),
                                title: const Text('เรียงตามประเภทสินค้า (ขาย)'),
                                trailing: filterIndex == 7 ? const Icon(Icons.check_circle, color: Colors.green) : const Text(''),
                                onTap: () {
                                  if (filterIndex != 7) {
                                    filterIndex = 7;
                                    print('aaa 7');
                                  } else {
                                    filterIndex = 0;
                                    print('aaa 0');
                                  }
                                  resetFilter();
                                  productType = 'sell';
                                  _loadnew();
                                  Navigator.pop(context);
                                },
                              ),
                              const Divider(height: 0),
                              ListTile(
                                contentPadding: const EdgeInsets.all(0.0),
                                title: const Text('เรียงตามประเภทสินค้า (แจก)'),
                                trailing: filterIndex == 8 ? const Icon(Icons.check_circle, color: Colors.green) : const Text(''),
                                onTap: () {
                                  if (filterIndex != 8) {
                                    filterIndex = 8;
                                    print('aaa 8');
                                  } else {
                                    filterIndex = 0;
                                    print('aaa 0');
                                  }
                                  resetFilter();
                                  productType = 'free';
                                  _loadnew();
                                  Navigator.pop(context);
                                },
                              ),
                              const Divider(height: 0),
                              ListTile(
                                contentPadding: const EdgeInsets.all(0.0),
                                title: const Text('เรียงตามประเภทสินค้า (พรีออเดอร์)'),
                                trailing: filterIndex == 9 ? const Icon(Icons.check_circle, color: Colors.green) : const Text(''),
                                onTap: () {
                                  if (filterIndex != 9) {
                                    filterIndex = 9;
                                    print('aaa 9');
                                  } else {
                                    filterIndex = 0;
                                    print('aaa 0');
                                  }
                                  resetFilter();
                                  productType = 'preorder';
                                  _loadnew();
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
              itemCount: ((products.isNotEmpty && isLoadingMore) || (products.isNotEmpty && !hasMore)) ? 2 : 1,
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
                      color: Color(0XFFE35205),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget searchInputField() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0, bottom: 10),
        child: TextField(
          onSubmitted: (value) {
            setState(() {
              searchText = value;
              _loadnew();
            });
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
