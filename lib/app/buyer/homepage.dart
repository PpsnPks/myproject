import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  title: const Text("My App"),
      //  backgroundColor: const Color.fromARGB(255, 174, 220, 255),
        
      //  //centerTitle: true,
      //),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,  // จัดตำแหน่งให้อยู่บน-ล่าง
          children: [
            const SearchInputField(),  // เรียกใช้คลาส SearchInputField
            //const Padding(
            //  padding: EdgeInsets.all(16.0),
            //  child: Text(
            //    "Hello Feature",
            //    style: TextStyle(fontSize: 24),
            //  ),
            //),
            Flexible (
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0),
                child: GridView.count(
                  crossAxisCount: 4,  // สร้าง 4 คอลัมน์
                  crossAxisSpacing: 8.0,  // ระยะห่างระหว่างคอลัมน์
                  mainAxisSpacing: 8.0,  // ระยะห่างระหว่างแถว
                  children: [
                    CatergoryButton(context, 'assets/icons/home_page/general-bag.svg', 'ของใช้ทั่วไป', '/general'),
                    CatergoryButton(context, 'assets/icons/home_page/electronic-computer.svg', 'อิเล็กทรอนิกส์', '/electronics'),
                    CatergoryButton(context, 'assets/icons/home_page/electrical-fan-light.svg', 'เครื่องใช้ไฟฟ้า', '/appliances'),
                    CatergoryButton(context, 'assets/icons/home_page/book-light.svg', 'หนังสือ', '/books'),
                    CatergoryButton(context, 'assets/icons/home_page/education-ruler-pen.svg', 'การศึกษา', '/education'),
                    CatergoryButton(context, 'assets/icons/home_page/furniture-bed.svg', 'เฟอร์นิเจอร์', '/furniture'),
                    CatergoryButton(context, 'assets/icons/home_page/fashion-shirt.svg', 'แฟชั่น', '/fashion'),
                    CatergoryButton(context, 'assets/icons/home_page/other-3dots.svg', 'Bอื่นๆ', '/others'),
                  ],
                ),
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
              ),
              items: imageSliders,
            )
          ],
        ),
      ),
      bottomNavigationBar: buyerFooter(context,  'home'),
    );
  }
}

BottomAppBar buyerFooter(BuildContext context, String selected){
  return  BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home_rounded,  // ใช้ไอคอน home outline
                    color: selected == 'home'? const Color(0xFFFA5A2A): const Color(0xFFA5A9B6),  // กำหนดสีเป็น #FA5A2A
                    size: 38,  // ขนาดไอคอน
                  ),
                  onPressed: () {
                    // Handle home button press
                    Navigator.pushNamed(context, '/home');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.favorite_border,  // ใช้ไอคอน home outline
                    //color: Color(0xFFFA5A2A),  // กำหนดสีเป็น #FA5A2A
                    color: selected == 'like'? const Color(0xFFFA5A2A): const Color(0xFFA5A9B6),
                    size: 34,  // ขนาดไอคอน
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/like');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chat_outlined,size: 30),
                  onPressed: () {
                    // Handle notifications button press
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person_outline_rounded,size: 34),
                  onPressed: () {
                    // Handle profile button press
                  },
                ),
              ],
            ),
          );
}

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
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
          //border: const OutlineInputBorder(
          //  borderRadius: BorderRadius.all(Radius.circular(10)),
          //  borderSide: BorderSide(
          //    color: Color.fromARGB(255, 255, 255, 255),  // Set the border color
          //    width: 4.0,  // Set the border width
          //  ),
          //),
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
              color: Colors.blue, // สีกรอบ
              width: 2.0, // ความหนาของกรอบ
            ),
            borderRadius: BorderRadius.circular(10.0), // มุมกรอบโค้ง
      ),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          child: Stack(
            children: <Widget>[
              Image.network(item, fit: BoxFit.cover, width: 1000.0),
            ],
          )),
    ))
    .toList();
