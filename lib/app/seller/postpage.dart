import 'package:flutter/material.dart';
import 'package:myproject/Service/postservice.dart';
import 'package:myproject/app/seller/sellerfooter.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Future<List<Post>> posts = Future.value([]);

  _loadmore(int page, int length) async {
    Map<String, dynamic> response = await PostService().getPost(1, 10);
    print('11111111111 $response');
    if (response['status'] == true) {
      final newPosts = response['data'];
      setState(() {
        posts = newPosts;
        // page++;  // เพิ่มเลขหน้าเพื่อโหลดข้อมูลหน้าถัดไป
      });
      print('22222222222');
    }
    print('lllllllllll  $response');
    return;
  }

  @override
  void initState() {
    super.initState();
    _loadmore(1, 10); // ดึงข้อมูลจาก API
    //   _loadData();

    //   // ตั้งค่า ScrollController เพื่อจับการเลื่อน
    //   _scrollController.addListener(() {
    //     if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
    //       // เลื่อนถึงจุดสุดท้ายแล้ว ให้โหลดข้อมูลเพิ่ม
    //       if (!isLoading) {
    //         setState(() {
    //           isLoading = true;
    //         });
    //         _loadData();
    //       }
    //     }
    //   });
  }
  // Future<void> _loadData(int nowPage, int lenght) async {
  //   // สมมติว่า `fetchPosts` คือฟังก์ชันที่ดึงข้อมูลจาก API หรือฐานข้อมูล
  //   Map<String, dynamic> response = await PostService().getPost(nowPage, lenght);

  //   if(response['success']){
  //     List<Post> newPosts = response['data'].
  //   }
  //   // List<Post> newPosts

  //   setState(() {
  //     posts.addAll(newPosts);
  //     page++;  // เพิ่มเลขหน้าเพื่อโหลดข้อมูลหน้าถัดไป
  //     isLoading = false;
  //   });
  // }

  // final ScrollController _scrollController = ScrollController();
  // bool isLoading = false;
  // int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("โพสต์"),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: FutureBuilder<List<Post>>(
        future: posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("เกิดข้อผิดพลาดในการโหลดข้อมูล"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("ไม่มีข้อมูลโพสต์"));
          }

          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section: User Info
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(product.profile),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product.faculty,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Section: Post Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.tags,
                            style: const TextStyle(
                              fontSize: 8,
                              color: Color(0xFFFA5A2A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Section: Image
                    if (product.imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Image.network(
                          product.imageUrl,
                          width: double.infinity,
                          height: 360,
                          fit: BoxFit.cover,
                        ),
                      ),
                    // Section: Post Details
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        product.detail,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addpost');
        },
        backgroundColor: const Color(0xFFFA5A2A),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: sellerFooter(context, 'post'),
    );
  }
}
