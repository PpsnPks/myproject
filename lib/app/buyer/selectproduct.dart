import 'package:flutter/material.dart';
import 'package:myproject/Service/selectproductservice.dart';

class SelectProductPage extends StatefulWidget {
  const SelectProductPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SelectProductPageState createState() => _SelectProductPageState();
}

class _SelectProductPageState extends State<SelectProductPage> {
  bool isFavorited = false; // ย้ายตัวแปรออกมาที่นี่
  int selectedQuantity = 1;
  @override
  Widget build(BuildContext context) {
    // เรียกใช้ข้อมูลสินค้า
    final product = ProductService.getProduct();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Back action
          },
        ),
        // ignore: sized_box_for_whitespace
        title: Container(
          width: double.infinity, // ใช้ความกว้างทั้งหมด
          child: const Center(
            child: Text("รายละเอียดสินค้า"), // ข้อความตรงกลาง
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_outlined),
            onPressed: () {
              // More options action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        // ใช้ SingleChildScrollView เพื่อให้เลื่อนได้
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image slider (placeholder for now)
            Container(
              height: 200,
              color: Colors.grey[300],
              child: PageView.builder(
                itemCount: product.imageUrl.length,
                itemBuilder: (context, index) {
                  return Image.asset(product.imageUrl[index]);
                },
              ),
            ),

            const SizedBox(height: 10),
            // Product Title
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFavorited
                        ? Icons.favorite
                        : Icons.favorite_border, // เปลี่ยนไอคอนตามสถานะ
                    size: 30,
                    color: isFavorited
                        ? Colors.red
                        : Colors.black, // เปลี่ยนสีตามสถานะ
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorited = !isFavorited; // เปลี่ยนสถานะเมื่อกด
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Product Price
            Text(
              product.price,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Product Description
            const Text(
              'รายละเอียด',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(product.description),
            const SizedBox(height: 10),

            const Text(
              'ประเภท',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(product.category),
            const SizedBox(height: 10),

            const Text(
              'ขนาด',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(product.size),
            const SizedBox(height: 10),

            const Text(
              'สถานที่จัดส่ง',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(product.deliveryLocation),
            const SizedBox(height: 10),

            const Text(
              'ระยะเวลาจัดส่ง',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(product.deliveryDate),
            const SizedBox(height: 10),
            const Text(
              'โพสต์โดย:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Post Owner Information
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/profile.jpg'), // Replace with network image if needed
                  radius: 20,
                ),
                const SizedBox(width: 10),
                Text(product.seller),
              ],
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            // Quantity selector and Buy button
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('คลัง : ${product.stock}',
                        style: const TextStyle(fontSize: 18)),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (selectedQuantity > 1) {
                                selectedQuantity--; // ลดจำนวนเมื่อมากกว่า 1
                              }
                            });
                          },
                          icon: const Icon(Icons.remove, color: Colors.orange),
                        ),
                        Text('$selectedQuantity',
                            style: const TextStyle(fontSize: 18)),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (selectedQuantity < product.stock) {
                                selectedQuantity++; // เพิ่มจำนวนเมื่อไม่เกิน stock
                              }
                            });
                          },
                          icon: const Icon(Icons.add, color: Colors.orange),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/confirm');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: const Color(0xFFFA5A2A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'ซื้อสินค้า',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
