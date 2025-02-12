import 'package:flutter/material.dart';
import 'package:myproject/Service/productdetailservice.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool isFavorited = false; 
  int selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
        title: const Center(child: Text("รายละเอียดสินค้า")),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_outlined),
            onPressed: () {
              // More options action
            },
          ),
        ],
      ),
      body: FutureBuilder<Product>(
        future: ProductService.getProduct(), // เรียก API สำหรับดึงข้อมูล
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final product = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image slider
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
                  // Product Title and Favorite Icon
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
                              : Icons.favorite_border,
                          size: 30,
                          color: isFavorited
                              ? Colors.red
                              : Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            isFavorited = !isFavorited;
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
                  // Other product details like category, condition, etc.
                  _buildDetailText('ประเภท', product.category),
                  _buildDetailText('สภาพสินค้า', product.conditionProduct),
                  _buildDetailText('ระยะเวลาการใช้งาน', product.durationUse),
                  _buildDetailText('ตำหนิสินค้า', product.defect),
                  _buildDetailText('สถานที่นัดรับ', product.deliveryLocation),
                  _buildDetailText('ระยะเวลา', product.timeForSell),
                  const SizedBox(height: 10),
                  // Seller Info
                  const Text(
                    'โพสต์โดย:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/profile.jpg'),
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(product.seller),
                    ],
                  ),
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
                          'แชท',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text("No product found"));
          }
        },
      ),
    );
  }

  Widget _buildDetailText(String title, String detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(detail),
        const SizedBox(height: 10),
      ],
    );
  }
}
