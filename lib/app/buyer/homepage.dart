import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:myproject/Service/postservice.dart';
import 'package:myproject/app/buyer/buyerfooter.dart';
import '../../Service/addservice.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loadingProduct = false;
  List<Product> homeProducts = []; // ประกาศตัวแปรให้ถูกต้อง

  void getProducts() async {
    try {
      setState(() {
        loadingProduct = true;
      });
      final response = await ProductService().getProduct(1, 10); // เรียก API
      if (response['success']) {
        setState(() {
          loadingProduct = false;
          homeProducts = response['data'];
        });
      } else {
        setState(() {
          loadingProduct = false;
        });
        throw Exception('Failed to load products');
      }
    } catch (e) {
      setState(() {
        loadingProduct = false;
      });
      print("Error loading products: $e");
      return; // ถ้ามีข้อผิดพลาดให้ส่งกลับเป็นลิสต์ว่าง
    }
  }

  bool loadingPost = false;
  List<Post> homePosts = [];
  void getPost() async {
    try {
      setState(() {
        loadingPost = true;
      });
      final response = await PostService().getPost(1, 3); // เรียก API
      if (response['success']) {
        setState(() {
          loadingPost = false;
          homePosts = response['data'];
        });
      } else {
        setState(() {
          loadingPost = false;
        });
        throw Exception('Failed to load products');
      }
    } catch (e) {
      setState(() {
        loadingPost = false;
      });
      print("Error loading products: $e");
      return; // ถ้ามีข้อผิดพลาดให้ส่งกลับเป็นลิสต์ว่าง
    }
  }

  @override
  void initState() {
    super.initState();
    getProducts(); // เรียกฟังก์ชันเพื่อโหลดข้อมูล
    getPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // ใช้ SingleChildScrollView รอบๆ Column
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // จัดตำแหน่งให้อยู่บน-ล่าง
                children: [
                  //const SearchInputField(), // เรียกใช้คลาส SearchInputField
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 100.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CatergoryButton(context, 'assets/icons/home_page/general-bag.svg', 'ของใช้ทั่วไป', '/general'),
                              CatergoryButton(context, 'assets/icons/home_page/electronic-computer.svg', 'อิเล็กทรอนิกส์', '/electronics'),
                              CatergoryButton(context, 'assets/icons/home_page/electrical-fan-light.svg', 'เครื่องใช้ไฟฟ้า', '/appliances'),
                              CatergoryButton(context, 'assets/icons/home_page/book-light.svg', 'หนังสือ', '/books'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CatergoryButton(context, 'assets/icons/home_page/education-ruler-pen.svg', 'การศึกษา', '/education'),
                              CatergoryButton(context, 'assets/icons/home_page/furniture-bed.svg', 'เฟอร์นิเจอร์', '/furniture'),
                              CatergoryButton(context, 'assets/icons/home_page/fashion-shirt.svg', 'แฟชั่น', '/fashion'),
                              CatergoryButton(context, 'assets/icons/home_page/other-3dots.svg', 'อื่นๆ', '/role'),
                            ],
                          ),
                        ),
                        CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            aspectRatio: 2.0,
                            enlargeCenterPage: true,
                          ),
                          items: imageSliders,
                        ),
                        const SizedBox(height: 24), // เพิ่มช่องว่างระหว่าง CarouselSlider กับ Row
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0), // กำหนด padding ซ้ายและขวา
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // จัดตำแหน่งให้ข้อความอยู่ห่างกัน
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'สินค้าเเนะนำ',
                                style: TextStyle(
                                  fontSize: 17, // ขนาดฟอนต์
                                  fontWeight: FontWeight.bold, // หนา
                                ),
                              ),
                              // Text(
                              //   'ทั้งหมด',
                              //   style: TextStyle(
                              //     fontSize: 12, // ขนาดฟอนต์
                              //     fontWeight: FontWeight.bold, // หนา
                              //     color: Color(0xFFFA5A2A),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10), // เพิ่มช่องว่างระหว่าง Row กับ FutureBuilder
                        loadingProduct
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
                            : homeProducts.isNotEmpty
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            for (int i = 0; i < homeProducts.length; i += 2)
                                              Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: productCard(homeProducts[i], context),
                                              )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            for (int i = 1; i < homeProducts.length; i += 2)
                                              Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: productCard(homeProducts[i], context),
                                              )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : const Center(child: Text('ไม่พบสินค้า')),
                        const SizedBox(height: 24),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 16.0, right: 16.0), // กำหนด padding ซ้ายและขวา
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween, // จัดตำแหน่งให้ข้อความอยู่ห่างกัน
                        //     crossAxisAlignment: CrossAxisAlignment.end,
                        //     children: [
                        //       const Text(
                        //         'โพสต์',
                        //         style: TextStyle(
                        //           fontSize: 17, // ขนาดฟอนต์
                        //           fontWeight: FontWeight.bold, // หนา
                        //         ),
                        //       ),
                        //       GestureDetector(
                        //         onTap: () {
                        //           Navigator.pushNamed(
                        //             context,
                        //             '/allpost',
                        //           );
                        //           print('click card');
                        //         },
                        //         child: const Text(
                        //           'ทั้งหมด',
                        //           style: TextStyle(
                        //             fontSize: 12, // ขนาดฟอนต์
                        //             fontWeight: FontWeight.bold, // หนา
                        //             color: Color(0xFFFA5A2A),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(height: 10),
                        // loadingPost
                        //     ? const Center(
                        //         child: Padding(
                        //           padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 10.0),
                        //           child: Row(
                        //             mainAxisSize: MainAxisSize.min, // ทำให้ column มีขนาดเท่ากับเนื้อหาภายใน
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               Center(
                        //                   child: SizedBox(
                        //                 width: 10.0,
                        //                 height: 10.0,
                        //                 child: CircularProgressIndicator(
                        //                   color: Color(0XFFE35205),
                        //                   strokeWidth: 2.0,
                        //                 ),
                        //               )),
                        //               SizedBox(width: 10), // เพิ่มระยะห่างระหว่าง progress กับข้อความ
                        //               Text(
                        //                 'กำลังโหลดโพสต์',
                        //                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       )
                        //     : homePosts.isNotEmpty
                        //         ? Column(children: [
                        //             for (int i = 0; i < homePosts.length; i += 1)
                        //               Column(
                        //                 children: [
                        //                   // Container(
                        //                   //   height: 2.0,
                        //                   //   width: double.infinity,
                        //                   //   color: Colors.grey[400],
                        //                   // ),
                        //                   postCard(homePosts[i], context),
                        //                   Container(
                        //                     height: 2.0,
                        //                     width: double.infinity,
                        //                     color: Colors.grey[400],
                        //                   ),
                        //                 ],
                        //               )
                        //           ])
                        //         : const Center(child: Text('ไม่พบรายการโพสต์')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: searchInputField(), // คงตำแหน่ง SearchInputField ไว้ด้านบน
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.pushNamed(context, '/addpost');
      //   },
      //   backgroundColor: const Color(0xFFFA5A2A),
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
      bottomNavigationBar: buyerFooter(context, 'home'),
    );
  }

  void printtext(String a) {
    print(a);
  }

  Widget productCard(Product data, BuildContext context) {
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
                        height: size,
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
                        double size = constraints.maxWidth;
                        return Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: ImageProvider,
                              fit: BoxFit.cover,
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
              data.product_type != 'preorder'
                  ? Text(
                      'จำนวน: ${data.product_qty}\nสภาพสินค้า : ${data.product_condition}\nถึงวันที่: ${data.date_exp}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFA5A9B6),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    )
                  : Text(
                      'ค่ามัดจำ: ${data.deposit}\nวันส่งสินค้า : ${data.date_send}\nถึงวันที่: ${data.date_exp}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFA5A9B6),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: data.product_type == 'preorder' ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
                  children: [
                    if (data.product_type == 'preorder')
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 1,
                            color: const Color(0XFFE35205),
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 3.0),
                        child: const Text(
                          'พรีออเดอร์',
                          style: TextStyle(color: Color(0XFFE35205), fontSize: 12, fontWeight: FontWeight.w600, height: 0),
                        ),
                      ),
                    Text(
                      data.product_price == '0' || data.product_price == '0.00' ? 'ฟรี' : '${data.product_price} ฿',
                      style: const TextStyle(
                        color: Color(0XFFE35205),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget postCard(Post data, BuildContext context) {
  //   return GestureDetector(
  //       onTap: () {
  //         Navigator.pop(context); // ปิด BottomSheet
  //         Navigator.pushNamed(
  //           context,
  //           '/postdetail/${data.id}',
  //         );
  //       },
  //       child: Card(
  //         elevation: 0,
  //         color: Colors.white,
  //         // margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(0.0),
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 9.0),
  //               child: Row(
  //                 children: [
  //                   CircleAvatar(
  //                     radius: 20,
  //                     backgroundImage: NetworkImage(data.profile),
  //                   ),
  //                   const SizedBox(width: 10),
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         data.name,
  //                         style: const TextStyle(
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                       const SizedBox(height: 1),
  //                       Text(
  //                         data.faculty,
  //                         style: const TextStyle(
  //                           fontSize: 11,
  //                           color: Colors.grey,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             // Section: Post Title
  //             Padding(
  //               padding: const EdgeInsets.only(left: 14.0, bottom: 8.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     data.detail,
  //                     maxLines: 3,
  //                     style:
  //                         const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black, overflow: TextOverflow.ellipsis),
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Text(
  //                     data.tags,
  //                     style: const TextStyle(
  //                       fontSize: 10,
  //                       color: Color(0xFFFA5A2A),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             // Section: Image
  //             if (data.imageUrl.isNotEmpty)
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 12.0),
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                     border: Border.all(
  //                       color: const Color.fromARGB(255, 224, 228, 244), // กำหนดสีขอบที่ต้องการ
  //                       width: 2.0, // กำหนดความหนาของขอบ
  //                     ),
  //                     borderRadius: BorderRadius.circular(22.0), // ใช้รัศมีเดียวกับ ClipRRect
  //                   ),
  //                   child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(22.0),
  //                     child: CachedNetworkImage(
  //                       imageUrl: data.imageUrl,
  //                       placeholder: (context, url) => const SizedBox(
  //                         width: double.infinity,
  //                         height: 360,
  //                         child: Center(
  //                           child: CircularProgressIndicator(
  //                             color: Color(0XFFE35205),
  //                             strokeCap: StrokeCap.round,
  //                             // strokeWidth: 12.0, // ปรับความหนาของวงกลม
  //                           ),
  //                         ),
  //                       ),
  //                       imageBuilder: (context, ImageProvider) {
  //                         return Container(
  //                           width: double.infinity,
  //                           height: 360,
  //                           decoration: BoxDecoration(image: DecorationImage(image: ImageProvider, fit: BoxFit.fill)),
  //                         );
  //                       },
  //                       errorWidget: (context, url, error) => LayoutBuilder(
  //                         builder: (context, constraints) {
  //                           double size = constraints.maxWidth;
  //                           return Container(
  //                             width: size,
  //                             height: size,
  //                             decoration: const BoxDecoration(
  //                               image: DecorationImage(
  //                                 image: AssetImage("assets/images/notfound.png"), // รูปจาก assets
  //                                 fit: BoxFit.fill,
  //                               ),
  //                             ),
  //                           );
  //                         },
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             Padding(
  //                 padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
  //                 child: IconButton(
  //                     onPressed: () => {},
  //                     icon: const Icon(
  //                       Icons.chat_outlined,
  //                       color: Color(0xFFA5A9B6),
  //                     ))),
  //           ],
  //         ),
  //       ));
  // }

  Widget searchInputField() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0, bottom: 10),
        child: GestureDetector(
          onTap: () {
            // เมื่อกดที่ Text แล้วจะเปลี่ยนหน้า
            Navigator.pushNamed(context, '/search'); // เปลี่ยน '/newPage' เป็นหน้าใหม่ที่คุณต้องการ
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(
                color: Color(0xFFDFE2EC),
                width: 2.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SvgPicture.asset(
                      'assets/icons/search-line.svg',
                      width: 28.0,
                      height: 28.0,
                    ),
                  ),
                  Text(
                    'ค้นหาสิ่งที่คุณต้องการ',
                    style: const TextStyle(
                      color: Color(0xFFA5A9B6),
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    // return Container(
    //   color: Colors.white,
    //   child: Padding(
    //     padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0, bottom: 10),
    //     child: TextField(
    //       onSubmitted: (value) {
    //         setState(() {});
    //       },
    //       decoration: InputDecoration(
    //           prefixIcon: Padding(
    //             padding: const EdgeInsets.only(left: 14.0, right: 8.0), // Adjust the padding value as needed
    //             child: SvgPicture.asset(
    //               'assets/icons/search-line.svg',
    //               width: 10.0, // Icon width
    //               height: 10.0, // Icon height
    //             ),
    //           ), // ไอคอนแว่นขยาย
    //           hintText: 'ค้นหาสิ่งที่คุณต้องการ',
    //           hintStyle: const TextStyle(
    //             color: Color(0xFFA5A9B6), // Set the hintText color
    //             fontSize: 16.0,
    //           ),
    //           //enabledBorder: const OutlineInputBorder(
    //           //  borderSide: BorderSide(width: 2, color: Color(0xFFDFE2EC)), //<-- SEE HERE
    //           //),
    //           filled: true, // เปิดใช้งานพื้นหลัง
    //           fillColor: Colors.white, // กำหนดสีพื้นหลังเป็นสีขาว
    //           enabledBorder: const OutlineInputBorder(
    //             borderRadius: BorderRadius.all(Radius.circular(10.0)), // Set the border radius
    //             borderSide: BorderSide(
    //               width: 2.0, // Set border width
    //               color: Color(0xFFDFE2EC), // Set border color
    //             ),
    //           ),
    //           focusedBorder: const OutlineInputBorder(
    //             borderRadius: BorderRadius.all(Radius.circular(10.0)), // Same radius for focused border
    //             borderSide: BorderSide(
    //               width: 2.0,
    //               color: Color.fromARGB(255, 174, 180, 192), // Border color when focused
    //             ),
    //           )),
    //     ),
    //   ),
    // );
  }
}

// ignore: non_constant_identifier_names
Column CatergoryButton(BuildContext context, String icon, String label, String route) {
  return Column(children: [
    OutlinedButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)), // ทำให้มุมเป็นเหลี่ยม
        ),
        padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
        side: const BorderSide(color: Color(0xFFDFE2EC), width: 2.0), // Add border color and thickness
        minimumSize: const Size(64, 64),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: 32.0, // Icon width
            height: 32.0, // Icon height
            // ignore: deprecated_member_use
            color: const Color(0xFFFA5A2A),
          ),
          //Icon(icon, size: 30, color: const Color(0xFFFA5A2A)),  // ไอคอนในปุ่ม
        ],
      ),
    ),
    const SizedBox(height: 8.0), // ระยะห่างระหว่างไอคอนและข้อความ
    Text(label, style: const TextStyle(fontSize: 12)),
  ]);
}

final List<String> imgList = [
  "assets/images/banner_home/pre-order.png",
  "assets/images/banner_home/free.png",
  "assets/images/banner_home/sale.png"
];
final List<Widget> imageSliders = imgList
    .map((item) => Container(
          margin: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFFA5A2A), // สีกรอบ
              width: 1.0, // ความหนาของกรอบ
            ),
            borderRadius: BorderRadius.circular(10.0), // มุมกรอบโค้ง
          ),
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              child: Stack(
                children: <Widget>[
                  Image.asset(item, fit: BoxFit.cover, width: 1000.0),
                ],
              )),
        ))
    .toList();

// class Product {
//   final String product_name;
//   final String product_category;
//   final String product_images;
//   final double product_price;

//   Product({
//     required this.product_name,
//     required this.product_category,
//     required this.product_images,
//     required this.product_price,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       product_name: json['product_name'],
//       product_category: json['product_category'],
//       product_images: json['product_images'],
//       product_price: json['product_price'],
//     );
//   }
// }
