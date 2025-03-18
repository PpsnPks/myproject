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
  int perPage = 3;
  bool isLoadingMore = false;
  bool hasMore = true;

  _loadmore() async {
    List<Post> newPosts = [];
    setState(() {
      isLoadingMore = true;
    });
    Map<String, dynamic> response = await PostService().getPost(page, perPage);
    if (response['success'] == true) {
      newPosts = response['data'];
      print("11111111111 ${newPosts.length}");
      if (newPosts.isEmpty) {
        setState(() {
          isLoadingMore = false;
          hasMore = false;
        });
        return;
      } else {
        setState(() {
          isLoadingMore = false;
          posts.addAll(newPosts);
        });
        return;
      }
    }
    setState(() {
      isLoadingMore = false;
    });
    print('lllllllllll  $response');
    return;
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scorollListener);
    _loadmore(); // ดึงข้อมูลจาก API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          controller: scrollController,
          itemCount: (isLoadingMore || !hasMore) ? posts.length + 1 : posts.length,
          itemBuilder: (context, index) {
            if (posts.isEmpty && isLoadingMore) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
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
                      SizedBox(width: 10),
                      Text(
                        'กำลังโหลดโพสต์เพิ่มเติม...',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            } else if (posts.isEmpty) {
              return Center(
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - kBottomNavigationBarHeight,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 2.0, color: Colors.grey),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'ไม่พบรายการโพสต์',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                  ),
                ),
              );
            } else if (index < posts.length) {
              final post = posts[index];
              return Column(
                children: [
                  Container(
                    height: 2.0,
                    width: double.infinity,
                    color: Colors.grey[400],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/postdetail/${post.id}', // Navigate to post detail page
                      );
                    },
                    child: Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 9.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 40,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      imageUrl: post.profile.isNotEmpty
                                          ? post.profile
                                          : 'https://t3.ftcdn.net/jpg/05/04/28/96/360_F_504289605_zehJiK0tCuZLP2MdfFBpcJdOVxKLnXg1.jpg',
                                      placeholder: (context, url) => LayoutBuilder(
                                        builder: (context, constraints) {
                                          double size = 10;
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
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                // CircleAvatar(
                                //   radius: 20,
                                //   backgroundImage: NetworkImage(post.profile),
                                // ),
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
                                    const SizedBox(height: 1),
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
                          if (post.imageUrl.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromARGB(255, 224, 228, 244),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(22.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(22.0),
                                  child: CachedNetworkImage(
                                    imageUrl: post.imageUrl,
                                    placeholder: (context, url) => const SizedBox(
                                      width: double.infinity,
                                      height: 360,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0XFFE35205),
                                          strokeCap: StrokeCap.round,
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
                                    errorWidget: (context, url, error) => LayoutBuilder(
                                      builder: (context, constraints) {
                                        double size = constraints.maxWidth;
                                        return Container(
                                          width: size,
                                          height: 360,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage("assets/images/notfound.png"),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                            child: IconButton(
                              onPressed: () => {},
                              icon: const Icon(
                                Icons.chat_outlined,
                                color: Color(0xFFA5A9B6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 2.0,
                    width: double.infinity,
                    color: Colors.grey[400],
                  ),
                ],
              );
            } else {
              if (isLoadingMore) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
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
                        SizedBox(width: 10),
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
            return null;
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.pushNamed(context, '/addpost');
      //   },
      //   backgroundColor: const Color(0xFFFA5A2A),
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
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
