import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:myproject/app/buyer/buyerfooter.dart';

import '../../Service/homeservice.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  late Future<List<Product>> homeProducts;

    @override
  void initState() {
    super.initState();
    // เรียก LikeService เพื่อดึงข้อมูลสินค้าที่ถูกใจ
    homeProducts = Homeservice().getHomeProducts();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: SingleChildScrollView( // ใช้ SingleChildScrollView รอบๆ Column
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // จัดตำแหน่งให้อยู่บน-ล่าง
          children: [
            const SearchInputField(), // เรียกใช้คลาส SearchInputField
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(right: 24.0, left: 24.0, top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/icons/home_page/pin.svg',
                    width: 24.0,  // Icon width
                    height: 24.0,  // Icon height
                    // ignore: deprecated_member_use
                    color: const Color(0xFFFA5A2A),
                  ),
                  const SizedBox(width: 4.0,),
                  const Text('ที่อยู่ :',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Roboto',
                      color: Color(0xFFA5A9B6),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  const Flexible(
                    child: Text(
                          '701 ซอย ฉลองกรุง 1 แขวงลาดกระบัง เขตลาดกระบัง',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Roboto',
                            color: Color(0xFF000000),
                            //fontWeight: FontWeight.bold,
                          )
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0),
              child: Column(
                children: [
                  GridView.count(
                    crossAxisCount: 4, // สร้าง 4 คอลัมน์
                    crossAxisSpacing: 8.0, // ระยะห่างระหว่างคอลัมน์
                    mainAxisSpacing: 8.0, // ระยะห่างระหว่างแถว
                    shrinkWrap: true, // ให้ GridView ย่อขนาดตามเนื้อหาที่มีอยู่
                    physics: const NeverScrollableScrollPhysics(), // ปิดการเลื่อน
                    children: [
                      CatergoryButton(context, 'assets/icons/home_page/general-bag.svg', 'ของใช้ทั่วไป', '/category'),
                      CatergoryButton(context, 'assets/icons/home_page/electronic-computer.svg', 'อิเล็กทรอนิกส์', '/category'),
                      CatergoryButton(context, 'assets/icons/home_page/electrical-fan-light.svg', 'เครื่องใช้ไฟฟ้า', '/category'),
                      CatergoryButton(context, 'assets/icons/home_page/book-light.svg', 'หนังสือ', '/category'),
                      CatergoryButton(context, 'assets/icons/home_page/education-ruler-pen.svg', 'การศึกษา', '/category'),
                      CatergoryButton(context, 'assets/icons/home_page/furniture-bed.svg', 'เฟอร์นิเจอร์', '/category'),
                      CatergoryButton(context, 'assets/icons/home_page/fashion-shirt.svg', 'แฟชั่น', '/category'),
                      CatergoryButton(context, 'assets/icons/home_page/other-3dots.svg', 'อื่นๆ', '/role'),
                    ],
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                    ),
                    items: imageSliders,
                  ),
                  const SizedBox(height: 20), // เพิ่มช่องว่างระหว่าง CarouselSlider กับ Row
<<<<<<< HEAD
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0), // กำหนด padding ซ้ายและขวา
=======
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0), // กำหนด padding ซ้ายและขวา
>>>>>>> a6d3778855b315143ed9b788ceaa3ff1c52b2287
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // จัดตำแหน่งให้ข้อความอยู่ห่างกัน
                      children: [
                        const Text(
                          'สินค้าเเนะนำ',
                          style: TextStyle(
                            fontSize: 17, // ขนาดฟอนต์
                            fontWeight: FontWeight.bold, // หนา
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/category');
                          },
                          child: const Text(
                            'ทั้งหมด',
                            style: TextStyle(
                              fontSize: 12, // ขนาดฟอนต์
                              fontWeight: FontWeight.bold, // หนา
                              color: Color(0xFFFA5A2A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20), // เพิ่มช่องว่างระหว่าง Row กับ FutureBuilder
                  
                  // FutureBuilder เพื่อโหลดข้อมูลสินค้า
                  FutureBuilder<List<Product>>(
                    future: homeProducts,
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
                          padding: const EdgeInsets.all(14), // เพิ่ม padding ให้ดูสมส่วน
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 คอลัมน์
                            childAspectRatio: 0.67,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: products.length,
                          shrinkWrap: true, // ย่อ GridView ตามเนื้อหา
                          physics: const NeverScrollableScrollPhysics(), // ปิดการเลื่อน
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/selectproduct'); // เปลี่ยนหน้าไปที่ '/selectproduct' เมื่อกดคาร์ด
                              },
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  // ignore: unused_local_variable
                                  double aspectRatio = (product.title.length > 20) ? 0.6 : 0.8; // ปรับค่า childAspectRatio ตามความยาว

                                  return Card(
                                    color: const Color(0xFFFFFFFF),
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(color: Color(0xFFDFE2EC), width: 1.0),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(8,8,8,8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start, // จัดการจัดตำแหน่งเป็นแนวตั้ง
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.asset(
                                              product.imageUrl, // ใช้ imageUrl จาก product
                                              height: 140, // ปรับขนาดรูปภาพ
                                              width: double.infinity,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Flexible(
                                            child: Text(
                                              product.title, // ใช้ title จาก product
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              overflow: TextOverflow.ellipsis, // ใช้ ellipsis เพื่อแสดงจุดไข่ปลาเมื่อยาวเกินไป
                                              maxLines: 2, // จำกัดจำนวนบรรทัดที่จะแสดง
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // จัดตำแหน่งให้ห่างกัน
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey), // กำหนดสีขอบ
                                                  borderRadius: BorderRadius.circular(12), // กำหนดมุมโค้งมนของกรอบ
                                                ),
                                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    bottomNavigationBar: buyerFooter(context, 'home'),
  );
}


}

// BottomAppBar buyerFooter(BuildContext context, String selected){
//   return  BottomAppBar(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: <Widget>[
//                 IconButton(
//                   icon: Icon(Icons.home_rounded,  // ใช้ไอคอน home outline
//                     color: selected == 'home'? const Color(0xFFFA5A2A): const Color(0xFFA5A9B6),  // กำหนดสีเป็น #FA5A2A
//                     size: 38,  // ขนาดไอคอน
//                   ),
//                   onPressed: () {
//                     // Handle home button press
//                     Navigator.pushNamed(context, '/home');
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.favorite_border,  // ใช้ไอคอน home outline
//                     //color: Color(0xFFFA5A2A),  // กำหนดสีเป็น #FA5A2A
//                     color: selected == 'like'? const Color(0xFFFA5A2A): const Color(0xFFA5A9B6),
//                     size: 34,  // ขนาดไอคอน
//                   ),
//                   onPressed: () {
//                     Navigator.pushNamed(context, '/like');
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.chat_outlined,size: 30),
//                   onPressed: () {
//                     // Handle notifications button press
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.person_outline_rounded,
//                   color: selected == 'profile'? const 
//                   Color(0xFFFA5A2A): const Color(0xFFA5A9B6),
//                     size: 34,  // ขนาดไอคอน
//                   ),
//                   onPressed: () {
//                     Navigator.pushNamed(context, '/profile');
//                   },
//                 ),
//               ],
//             ),
//           );
// }

// ignore: non_constant_identifier_names
Column CatergoryButton(BuildContext context, String icon, String label, String route) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: () {
            Navigator.pushNamed(context, route);
          },
          style: OutlinedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),  // ทำให้มุมเป็นเหลี่ยม
            ),
            padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
            side: const BorderSide(color: Color(0xFFDFE2EC), width: 2.0),  // Add border color and thickness
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                width: 32.0,  // Icon width
                height: 32.0,  // Icon height
                // ignore: deprecated_member_use
                color: const Color(0xFFFA5A2A),
              ),
              //Icon(icon, size: 30, color: const Color(0xFFFA5A2A)),  // ไอคอนในปุ่ม
            ],
          ),
        ),
        const SizedBox(height: 8.0),  // ระยะห่างระหว่างไอคอนและข้อความ
        Text(label, style: const TextStyle(fontSize: 12)),
      ]
    );
}

class SearchInputField extends StatelessWidget {
  const SearchInputField({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      
      padding: const EdgeInsets.only(left: 20.0, right: 20.0 ,top: 30.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 14.0, right: 8.0),  // Adjust the padding value as needed
            child: SvgPicture.asset(
              'assets/icons/search-line.svg',
              width: 10.0,  // Icon width
              height: 10.0,  // Icon height
            ),
          ),  // ไอคอนแว่นขยาย
          hintText: 'ค้นหาสิ่งที่คุณต้องการ',
          hintStyle: const TextStyle(
            color: Color(0xFFA5A9B6),  // Set the hintText color
            fontSize: 16.0,
          ),
          //enabledBorder: const OutlineInputBorder(
          //  borderSide: BorderSide(width: 2, color: Color(0xFFDFE2EC)), //<-- SEE HERE
          //),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),  // Set the border radius
            borderSide: BorderSide(
              width: 2.0,  // Set border width
              color: Color(0xFFDFE2EC),  // Set border color
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),  // Same radius for focused border
            borderSide: BorderSide(
              width: 2.0,
              color: Color.fromARGB(255, 174, 180, 192),  // Border color when focused
            ),
          ),
          // border: const OutlineInputBorder(
          //  borderRadius: BorderRadius.all(Radius.circular(10)),
          //  borderSide: BorderSide(
          //    color: Color.fromARGB(255, 255, 255, 255),  // Set the border color
          //    width: 4.0,  // Set the border width
          //  ),
          // ),
          
        ),
      ),
      
    );
  }
}
final List<String> imgList = ["assets/images/banner_home/pre-order.png", "assets/images/banner_home/free.png", "assets/images/banner_home/sale.png"];
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

