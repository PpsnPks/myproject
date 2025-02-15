import 'package:flutter/material.dart';
import 'package:myproject/Service/postdetailservice.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostDetailPage extends StatefulWidget {
  final String postId;

  const PostDetailPage({super.key, required this.postId});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  int selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายละเอียดโพสต์"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<Post>(
        future: PostService().getPostById(widget.postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('เกิดข้อผิดพลาดในการโหลดสินค้า'),
                  Text(snapshot.error.toString(), style: const TextStyle(color: Colors.red)),
                ],
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text("ไม่พบสินค้า"));
          }

          final post = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Images
                if (post.postImage.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      itemCount: 1,  // Assuming there's only one image per post
                      itemBuilder: (context, index) {
                        return Image.network(
                          post.postImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 10),

                // Product Name
                Text(post.detail, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                // Product Price
                Text('฿${post.price}', style: const TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                // Product Details
                _buildDetailText('หมวดหมู่', post.category),
                const SizedBox(height: 10),

                // Seller Info
                Text('โพสต์โดย',style: const TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(post.profilePic),
                      radius: 20,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('${post.faculty}'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Stock & Buttons
                // You can add stock info or other relevant fields as necessary
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/chat', arguments: {'sellerId': post.name});
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: const Color(0XFFE35205),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('แชท', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailText(String title, String detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(detail),
        const SizedBox(height: 10),
      ],
    );
  }
}

