import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Service/customerservice.dart';
import 'package:myproject/Service/postservice.dart';
import 'package:myproject/app/main/secureStorage.dart';

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key});

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  String pic = '-';
  String hideEmail = '-';
  String hidePhone = '-';
  String studentID = '-';
  String name = '-';
  String faculty = '-';
  String department = '-';
  String classyear = '-';
  String address = '-';
  String currentUserId = '';
  String viewedUserId = '';
  List<Map<String, String>> buyerItems = [];

  Future<void> getDataUser(String userId) async {
  final response = await CustomerService().getUserByID(userId);
  print("🛠 Raw API Response: $response"); // 🔴 Debug

  if (response['success'] == true) {
    final userData = response['customer'];
    print("👤 User Data: $userData");
  } // 🔴 Debug: ดูข้อมูลที่ API ส่งมา

  if (response['success']) {
    final userData = response['customer'];
    setState(() {
      pic = userData.pic ?? '-';
      var phoneNumber = userData.mobile ?? '';
      var email = userData.email ?? '';

      if (phoneNumber.length >= 10) {
        hidePhone = '${phoneNumber.substring(0, 3)}-***-${phoneNumber.substring(6)}';
      }

      if (email.length >= 8) {
        hideEmail = '${email.substring(0, 3)}***${email.substring(6)}';
        studentID = email.substring(0, 8);
      }

      name = userData.name ?? '-';
      faculty = userData.faculty ?? '-';
      department = userData.department ?? '-';
      classyear = userData.classyear ?? '-';
      address = userData.address ?? '-';

      if (response.containsKey('userpost') && response['userpost'] is List) {
        buyerItems = (response['userpost'] as List<dynamic>)
            .map<Map<String, String>>((post) {
          return {
            'title': post['title']?.toString() ?? 'ไม่มีชื่อสินค้า',
            'image': post['image_url']?.toString() ?? '',
          };
        }).toList();
      }
    });
  } else {
    print("🔴 ไม่สามารถดึงข้อมูลผู้ใช้ได้");
  }
}

  bool loadingPost = false;
  List<Post> homePosts = [];

  void getPost(int userId) async {
    try {
      setState(() {
        loadingPost = true;
      });

      // เรียก API โดยส่ง userId ที่สามารถปรับเปลี่ยนได้
      final response = await PostService().getPostUser(userId); // ส่ง userId ที่รับมา

      if (response['success']) {
        setState(() {
          loadingPost = false;
          homePosts = response['data']; // ดึงข้อมูลโพสต์มาเก็บใน homePosts
        });
      } else {
        setState(() {
          loadingPost = false;
        });
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      setState(() {
        loadingPost = false;
      });
      print("Error loading posts: $e");
      return; // ถ้ามีข้อผิดพลาดให้ส่งกลับเป็นลิสต์ว่าง
    }
  }

  @override
void initState() {
  super.initState();
  Future.delayed(Duration.zero, () async {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    print("📌 Arguments received: $args"); // ✅ Debug
    viewedUserId = args?['userId']?.toString() ?? '';
    currentUserId = await Securestorage().readSecureData('userId');

    if (viewedUserId.isNotEmpty) {
      getDataUser(viewedUserId);
      getPost(int.parse(viewedUserId)); // ✅ ใช้ `viewedUserId` กับ `getPost`
    }
  });
}

  Future<void> initData() async {
    try {
      // ดึงค่า userId จาก SecureStorage
      final id = await Securestorage().readSecureData('userId');

      if (id != null) {
        getPost(int.parse(id)); // ส่ง userId ไปใน getPost
      } else {
        print('User ID not found');
      }
    } catch (e) {
      print("Error initializing data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("โปรไฟล์"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(pic),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hideEmail,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hidePhone,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: buildBuyerGridView(),
          ),
        ],
      ),
    );
  }

  Widget buildBuyerGridView() {
    if (homePosts.isEmpty) {
      return const Center(
        child: Text(
          'ยังไม่มีรายการโพสต์',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: homePosts.length,
        itemBuilder: (context, index) {
          final post = homePosts[index]; // ดึงโพสต์จาก homePosts
          return Column(
            children: [
              // Container(
              //   height: 2.0,
              //   width: double.infinity,
              //   color: Colors.grey[400],
              // ),
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
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis,
                              ),
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
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: ImageProvider,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
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
                    ],
                  ),
                ),
              ),
              // Container(
              //   height: 4.0,
              //   width: double.infinity,
              //   color: Colors.grey[400],
              // ),
            ],
          );
        },
      ),
    );
  }
}
