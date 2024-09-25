import 'package:flutter/material.dart';
import 'package:myproject/homepage.dart';

class LikePage extends StatefulWidget {
  const LikePage({super.key});

  @override
  State<LikePage> createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(//appBar: AppBar(
        appBar: AppBar(
          title: const Text("ถูกใจ"),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.view_list_rounded, color: Color(0xFFA5A9B6),),  // ใช้ไอคอน view_list_rounded
            onPressed: () {
              // ทำบางอย่างเมื่อกดไอคอน
            },
          ),
        ],
          //centerTitle: true,
        ),
        body: itemCard(5),
        bottomNavigationBar: buyerFooter(context, 'like'),
      );
  }
}

GridView itemCard( int nCol ){
  return  GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 1,
    childAspectRatio: 0.75,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
  ),
  itemCount: 1,
  itemBuilder: (context, index) {
    return const ProductCard(
      imageUrl: 'assets/images/fan_example.png',
      title: 'พัดลม',
      price: '200 ฿',
      category: 'เครื่องใช้ไฟฟ้า',
    );
  },
);
}

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String category;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // เพิ่ม padding รอบ card
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Section without height restriction
            Padding(
              padding: const EdgeInsets.all(16.0), // เพิ่ม margin 16px รอบๆ รูปภาพ
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  imageUrl,
                  width: 100,  // กำหนดเฉพาะความกว้างของภาพ
                  height: 100,  // กำหนดเฉพาะความกว้างของภาพ
                  fit: BoxFit.contain, // ปรับขนาดให้พอดีโดยไม่ถูกตัด
                ),
              ),
            ),
            // Content Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: const TextStyle(color: Colors.orange, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Chip(
                    label: Text(category, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.grey[200],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
