import 'package:flutter/material.dart';

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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 4,  // สร้าง 4 คอลัมน์
                  crossAxisSpacing: 8.0,  // ระยะห่างระหว่างคอลัมน์
                  mainAxisSpacing: 8.0,  // ระยะห่างระหว่างแถว
                  children: [
                    CatergoryButton(context, Icons.home, 'ของใช้ทั่วไป', '/general'),
                    CatergoryButton(context, Icons.electric_bolt, 'อิเล็กทรอนิกส์', '/electronics'),
                    CatergoryButton(context, Icons.kitchen, 'เครื่องใช้', '/appliances'),
                    CatergoryButton(context, Icons.book, 'หนังสือ', '/books'),
                    CatergoryButton(context, Icons.school, 'การศึกษา', '/education'),
                    CatergoryButton(context, Icons.chair, 'เฟอร์นิเจอร์', '/furniture'),
                    CatergoryButton(context, Icons.checkroom, 'แฟชั่น', '/fashion'),
                    CatergoryButton(context, Icons.more_horiz, 'อื่นๆ', '/others'),
                  ],
                ),
              ),
            ),
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
Column CatergoryButton(BuildContext context, IconData icon, String label, String route) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, route);
          },
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),  // ทำให้มุมเป็นเหลี่ยม
            ),
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: const Color(0xFFFA5A2A)),  // ไอคอนในปุ่ม
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
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),  // ไอคอนแว่นขยาย
          hintText: 'ค้นหาสิ่งที่คุณต้องการ',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }
}
