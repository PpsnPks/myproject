import 'package:flutter/material.dart';
import 'package:myproject/Service/productdetailservice.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    // รับข้อมูล product จาก arguments
    final product = ModalRoute.of(context)!.settings.arguments as Product?;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("รายละเอียดสินค้า")),
        body: const Center(child: Text("ไม่พบข้อมูลสินค้า")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Center(child: Text("รายละเอียดสินค้า")),
      ),
      body: SingleChildScrollView(
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
                  return Image.network(product.imageUrl[index]);
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
                    isFavorited ? Icons.favorite : Icons.favorite_border,
                    size: 30,
                    color: isFavorited ? Colors.red : Colors.black,
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
            // Other product details
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
            // Buy button
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
