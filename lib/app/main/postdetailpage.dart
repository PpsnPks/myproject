import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Service/postdetailservice.dart';

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

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Images
                          if (post.postImage.isNotEmpty)
                            GestureDetector(
                              onTap: () => {
                                Navigator.pushNamed(context, '/fullimage', arguments: {'image': post.postImage})
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12), // ปรับให้กรอบมีมุมมน
                                child: SizedBox(
                                  height: 300,
                                  child: PageView.builder(
                                    itemCount: 1, // Assuming there's only one image per post
                                    itemBuilder: (context, index) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl: post.postImage.isNotEmpty
                                              ? post.postImage
                                              : 'https://t3.ftcdn.net/jpg/05/04/28/96/360_F_504289605_zehJiK0tCuZLP2MdfFBpcJdOVxKLnXg1.jpg',
                                          placeholder: (context, url) => LayoutBuilder(
                                            builder: (context, constraints) {
                                              double size = constraints.maxWidth;
                                              return SizedBox(
                                                width: size,
                                                height: size, // ให้สูงเท่ากับกว้าง
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
                                                double size = constraints.maxWidth; // ใช้ maxWidth เป็นขนาดของ width และ height
                                                return Container(
                                                  width: size,
                                                  height: size, // ให้ height เท่ากับ width
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: ImageProvider,
                                                      fit: BoxFit.cover, // ปรับขนาดภาพให้เต็ม
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
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 10),
                          // Product Name
                          Text(post.detail, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),

                          // Product Price
                          Text('฿${post.price}', style: const TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),

                          // Product Details
                          _buildDetailText('หมวดหมู่', post.category),
                          const SizedBox(height: 10),

                          // Seller Info
                          const Text('โพสต์โดย', style: TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/viewprofile',
                                    arguments: {'userId': post.userId}, // ส่ง userId ไปด้วย
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(post.profilePic),
                                  radius: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(post.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(post.faculty),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/message/${post.userId}', arguments: {'name': post.name});
                          // Navigator.pushNamed(context, '/chat', arguments: {'sellerId': post.name});
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
                ),
              )
            ],
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
