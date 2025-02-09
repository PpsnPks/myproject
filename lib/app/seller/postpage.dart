import 'package:flutter/material.dart';
import 'package:myproject/Service/postservice.dart';
import 'package:myproject/app/seller/sellerfooter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List<Post> posts = [];
  final scrollController = ScrollController();
  int page = 1;
  int perPage = 5;
  bool isLoadingMore = false;
  bool hasMore = true;

  _loadmore() async {
    List<Post> newPosts = [];
    Map<String, dynamic> response = await PostService().getPost(page, perPage);
    if (response['success'] == true) {
      newPosts = response['data'];
      print("11111111111 $newPosts");
      if (newPosts.isEmpty) {
        setState(() {
          hasMore = false;
        });
        return;
      } else {
        setState(() {
          posts.addAll(newPosts);
        });
        return;
      }
    }
    print('lllllllllll  $response');
    return;
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scorollListener);
    _loadmore(); // ดึงข้อมูลจาก API
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
      backgroundColor: Colors.grey[400],
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
      body: ListView.builder(
        controller: scrollController,
        itemCount: (isLoadingMore || !hasMore) ? posts.length + 1 : posts.length,
        itemBuilder: (context, index) {
          if (index < posts.length) {
            final post = posts[index];
            return Card(
              elevation: 0,
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section: User Info
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 9.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(post.profile),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 0),
                            Text(
                              post.faculty,
                              style: const TextStyle(
                                fontSize: 11,
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
                    padding: const EdgeInsets.only(left: 14.0, bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.detail,
                          maxLines: 3,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black, overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          post.tags,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFFFA5A2A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Section: Image
                  if (post.imageUrl.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 224, 228, 244), // กำหนดสีขอบที่ต้องการ
                            width: 2.0, // กำหนดความหนาของขอบ
                          ),
                          borderRadius: BorderRadius.circular(22.0), // ใช้รัศมีเดียวกับ ClipRRect
                        ),
                        child: CachedNetworkImage(
                          imageUrl: post.imageUrl,
                          placeholder: (context, url) => const SizedBox(
                            width: double.infinity,
                            height: 360,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0XFFE35205),
                                strokeCap: StrokeCap.round,
                                // strokeWidth: 12.0, // ปรับความหนาของวงกลม
                              ),
                            ),
                          ),
                          imageBuilder: (context, ImageProvider) {
                            return Container(
                              width: double.infinity,
                              height: 360,
                              decoration: BoxDecoration(image: DecorationImage(image: ImageProvider, fit: BoxFit.fill)),
                            );
                          },
                        ),
                        // ClipRRect(
                        //   borderRadius: BorderRadius.circular(20.0),
                        //   child: Image.network(
                        //     post.imageUrl,
                        //     errorBuilder: (context, error, stackTrace) {
                        //       return const Text('กำลังโหลดรูป'); //ไม่ได้ ❌
                        //     },
                        //     width: double.infinity,
                        //     height: 360,
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                      ),
                    ),
                  // Section: Post Details
                  Padding(
                      padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                      child: IconButton(
                          onPressed: () => {},
                          icon: const Icon(
                            Icons.chat_outlined,
                            color: Color(0xFFA5A9B6),
                          ))),
                ],
              ),
            );
          } else {
            if (isLoadingMore) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // ทำให้ column มีขนาดเท่ากับเนื้อหาภายใน
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: SizedBox(
                        width: 10.0,
                        height: 10.0,
                        child: CircularProgressIndicator(
                          color: Color(0XFFE35205),
                          strokeWidth: 2.0,
                        ),
                      )),
                      SizedBox(width: 10), // เพิ่มระยะห่างระหว่าง progress กับข้อความ
                      Text(
                        'กำลังโหลดโพสต์เพิ่มเติม...',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            } else if (!hasMore) {
              return const Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 10.0),
                child: Center(
                  child: Text(
                    'ไม่มีโพสต์ที่จะแสดงเพิ่มเติม',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                ),
              );
            }
          }
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

  void _scorollListener() async {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      page += 1;
      setState(() {
        isLoadingMore = true;
      });
      await _loadmore();
      setState(() {
        isLoadingMore = false;
      });
      print('max');
    }
    print('scroll listener called');
  }
}
