import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:myproject/app/buyer/buyerfooter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Service/addservice.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Product>> getProducts() async {
    try {
      final response = await AddService().getProduct(1, 10); // เรียก API
      print('ss1 ${response['data'].toString()}');
      if (response['success']) {
        return response['data'];
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print("Error loading products: $e");
      return []; // ถ้ามีข้อผิดพลาดให้ส่งกลับเป็นลิสต์ว่าง
    }
  }

  late Future<List<Product>> homeProducts; // ประกาศตัวแปรให้ถูกต้อง

  @override
  void initState() {
    super.initState();
    homeProducts = getProducts(); // เรียกฟังก์ชันเพื่อโหลดข้อมูล
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
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
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
                            children: [
                              Text(
                                'สินค้าเเนะนำ',
                                style: TextStyle(
                                  fontSize: 17, // ขนาดฟอนต์
                                  fontWeight: FontWeight.bold, // หนา
                                ),
                              ),
                              Text(
                                'ทั้งหมด',
                                style: TextStyle(
                                  fontSize: 12, // ขนาดฟอนต์
                                  fontWeight: FontWeight.bold, // หนา
                                  color: Color(0xFFFA5A2A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10), // เพิ่มช่องว่างระหว่าง Row กับ FutureBuilder

                        // FutureBuilder เพื่อโหลดข้อมูลสินค้า
                        FutureBuilder<List<Product>>(
                          future: homeProducts, // ใช้ homeProducts ที่ประกาศแล้ว
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text('ไม่มีสินค้า'));
                            } else {
                              final products = snapshot.data!;
                              print("Products loaded: ${products.length}");
                              return GridView.builder(
                                padding: const EdgeInsets.only(left: 12, right: 12),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.67,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 8,
                                ),
                                itemCount: products.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/selectproduct');
                                    },
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        double aspectRatio = (product.product_name.length > 20) ? 0.6 : 0.8;
                                        return Card(
                                          color: const Color(0xFFFFFFFF),
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(color: Color(0xFFDFE2EC), width: 2.0),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          elevation: 0,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: Image.network(
                                                    product.product_images[0], // Use [0] for the first image
                                                    height: constraints.maxWidth - 28,
                                                    width: constraints.maxWidth - 28,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Flexible(
                                                  child: Text(
                                                    product.product_name,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.grey),
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                                      child: Text(
                                                        product.product_category,
                                                        style: TextStyle(
                                                          color: Colors.blueGrey[400],
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      '${product.product_price} ฿',
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

                        const SizedBox(height: 24),
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0), // กำหนด padding ซ้ายและขวา
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // จัดตำแหน่งให้ข้อความอยู่ห่างกัน
                            children: [
                              Text(
                                'โพสต์',
                                style: TextStyle(
                                  fontSize: 17, // ขนาดฟอนต์
                                  fontWeight: FontWeight.bold, // หนา
                                ),
                              ),
                              Text(
                                'ทั้งหมด',
                                style: TextStyle(
                                  fontSize: 12, // ขนาดฟอนต์
                                  fontWeight: FontWeight.bold, // หนา
                                  color: Color(0xFFFA5A2A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
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
      bottomNavigationBar: buyerFooter(context, 'home'),
    );
  }

  void printtext(String a) {
    print(a);
  }

  Widget searchInputField() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0, bottom: 10),
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

class Product {
  final String product_name;
  final String product_category;
  final String product_images;
  final double product_price;

  Product({
    required this.product_name,
    required this.product_category,
    required this.product_images,
    required this.product_price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      product_name: json['product_name'],
      product_category: json['product_category'],
      product_images: json['product_images'],
      product_price: json['product_price'],
    );
  }
}
