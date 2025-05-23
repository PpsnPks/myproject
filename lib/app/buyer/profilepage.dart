import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Service/addservice.dart';
import 'package:myproject/Service/postservice.dart';
import 'package:myproject/app/buyer/buyerfooter.dart';
import 'package:myproject/app/seller/sellerfooter.dart';
import 'package:myproject/Service/formservice.dart';
import 'package:myproject/app/main/secureStorage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isBuyerSelected = false; // Default to Buyer tab
  bool isSellerSelected = false; // Default to Buyer tab
  bool isGridSelected = true; // Default to Grid view

  String role = '';

  String pic = '';
  String hideEmail = '';
  String hidePhone = '';
  String studentID = '';
  String name = '';
  String faculty = '';
  String department = '';
  String classyear = '';
  String address = '';


  Future<void> getDataUser() async {
    final id = await Securestorage().readSecureData('userId');
    final response = await UserService().getUserById(int.parse(id));

    if (response['success']) {
      final customer = response['data'];

      if (customer != null) {
        setState(() {
          pic = customer['pic'] ?? ''; // ถ้า pic เป็น null ให้ใช้ค่าเริ่มต้น
          var phoneNumber = customer['mobile'] ?? '0000000000';
          var email = customer['email'] ?? 'unknown@example.com';

          // เช็คความยาวของเบอร์โทรและอีเมลก่อน substring
          if (phoneNumber.length >= 10) {
            hidePhone = '${phoneNumber.substring(0, 3)}-***-${phoneNumber.substring(6)}';
          } else {
            hidePhone = phoneNumber; // กรณีเบอร์ไม่ครบ 10 ตัว
          }

          if (email.length >= 8) {
            hideEmail = '${email.substring(0, 3)}***${email.substring(6)}';
          } else {
            hideEmail = email; // กรณีอีเมลไม่ครบ 8 ตัว
          }

          studentID = email.length >= 8 ? '${email.substring(0, 8)}' : email;
          name = customer['name'] ?? 'ไม่ระบุชื่อ';
          faculty = customer['faculty'] ?? 'ไม่ระบุคณะ';
          department = customer['department'] ?? 'ไม่ระบุภาควิชา';
          classyear = customer['classyear'] ?? 'ไม่ระบุชั้นปี';
          address = customer['address'] ?? 'ไม่ระบุที่อยู่';
        });
      }
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

  void getRole() async {
    role = await Securestorage().readSecureData('role');
    if (role == 'buy') {
      setState(() {
        isBuyerSelected = true;
        isSellerSelected = false;
      });
    } else if (role == 'sell') {
      setState(() {
        isBuyerSelected = false;
        isSellerSelected = true;
      });
    }
  }

  bool isLoading = true;
  List<Deal> cartSProducts = [];
  List<Deal> pendingApproval = [];
  List<Deal> pendingCollection = [];
  List<Deal> filterByStep(List<Deal> deals, String step) {
    return deals.where((deals) => deals.deal_status == step).toList();
  }

  getSell() async {
    Map<String, dynamic> response = await CartService().getCartSeller();
    print(response['success']);
    if (response['success'] == true) {
      List<Deal> data = response['data'];
      print("11111111111 ${data.length}");
      if (data.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      } else {
        cartSProducts = data;
        setState(() {
          pendingApproval = filterByStep(cartSProducts, 'waiting');
          pendingCollection = filterByStep(cartSProducts, 'success');
          isLoading = false;
        });
        return;
      }
    }
    setState(() {
      isLoading = false;
    });
    print('lllllllllll  $response');
    return;
  }

  List<Product> cartBProducts = [];
  List<Seller> cartSeller = [];

  getBuy() async {
    Map<String, dynamic> response = await CartService().getCartBuyer();
    print(response['success']);
    if (response['success'] == true) {
      List<Product> data = response['data'];
      List<Seller> dataS = response['dataS'];
      print("11111111111 ${data.length}");
      if (data.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      } else {
        setState(() {
          cartBProducts = data;
          cartSeller = dataS;
          isLoading = false;
        });
        return;
      }
    }
    setState(() {
      isLoading = false;
    });
    print('lllllllllll  $response');
    return;
  }

  
  Future<void> deletePost(String postId) async {
  var result = await PostService().deletePostById(postId);
  if (result['success']) {
    print(result['message']);
  } else {
    print('Error: ${result['message']}');
  }
}

  @override
  void initState() {
    super.initState();
    initData();
    getSell();
    getBuy();
  }

  Future<void> initData() async {
    try {
      // ดึงค่า userId จาก SecureStorage
      final id = await Securestorage().readSecureData('userId');

      if (id != null) {
        getPost(int.parse(id)); // ส่ง userId ไปใน getPost
        getRole();
        getDataUser();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("โปรไฟล์"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show options for logout, personal info
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.person_outline_rounded),
                        title: const Text('ข้อมูลส่วนตัว'),
                        onTap: () {
                          // Handle personal info action
                          Navigator.pop(context); // Close the bottom sheet
                          Navigator.pushNamed(context, '/infoprofile');
                          // Navigate to personal information page if needed
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.info_outline_rounded),
                        title: const Text('เกี่ยวกับ'),
                        onTap: () {
                          // Handle personal info action
                          Navigator.pop(context); // Close the bottom sheet
                          Navigator.pushNamed(context, '/info1');
                          // Navigate to personal information page if needed
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.exit_to_app_outlined, color: Colors.red),
                        title: const Text(
                          'ออกจากระบบ',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () {
                          // Handle logout action
                          Navigator.pop(context); // Close the bottom sheet
                          Securestorage().deleteAllSecureData();
                          Navigator.pushReplacementNamed(context, '/login');
                          // Add your logout logic here
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
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
          // Tab Buttons
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
            child: Row(
              children: [
                // Buyer Tab
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: isBuyerSelected ? const Color(0xFFE35205) : const Color(0xFFFCEEEA),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        await Securestorage().writeSecureData('role', 'buy');
                        setState(() {
                          isBuyerSelected = true;
                          isSellerSelected = false;
                        });
                      },
                      child: Text(
                        'คนซื้อ',
                        style: TextStyle(
                          fontSize: 16,
                          color: isBuyerSelected ? Colors.white : const Color(0xFFE35205),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Seller Tab
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: isSellerSelected ? const Color(0xFFE35205) : const Color(0xFFFCEEEA),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        await Securestorage().writeSecureData('role', 'sell');
                        setState(() {
                          isBuyerSelected = false;
                          isSellerSelected = true;
                        });
                      },
                      child: Text(
                        'คนขาย',
                        style: TextStyle(
                          fontSize: 16,
                          color: isSellerSelected ? Colors.white : const Color(0xFFE35205),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Grid and History Buttons
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          //   child: Row(
          //     children: [
          //       // ถ้าเป็นผู้ซื้อ (isBuyerSelected == true) จะแสดงไอคอน Grid View
          //       if (isBuyerSelected)
          //         Expanded(
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               IconButton(
          //                 onPressed: () {
          //                   setState(() {
          //                     isGridSelected = true;
          //                   });
          //                 },
          //                 icon: Icon(
          //                   Icons.grid_view,
          //                   color: isGridSelected ? const Color(0xFFE35205) : Colors.grey,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       // ถ้าเป็นผู้ขาย (isBuyerSelected == false) แสดงคำว่า "ประวัติการขาย" แทนไอคอน
          //       Expanded(
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: [
          //             if (!isBuyerSelected)
          //               Text(
          //                 'ประวัติการขาย',
          //                 style: TextStyle(
          //                   color: Colors.grey, // สีสำหรับข้อความ
          //                   fontSize: 16.0, // ขนาดตัวอักษร
          //                   fontWeight: FontWeight.w400, // ตัวหนา
          //                 ),
          //               )
          //             else
          //               IconButton(
          //                 onPressed: () {
          //                   setState(() {
          //                     isGridSelected = false;
          //                   });
          //                 },
          //                 icon: Icon(
          //                   Icons.history,
          //                   color: isGridSelected ? Colors.grey : const Color(0xFFE35205),
          //                 ),
          //               ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Content Area
          Expanded(
            child: buildBuyerGridView(),
          ),
        ],
      ),
      // Footer changes based on role
      bottomNavigationBar: isBuyerSelected ? buyerFooter(context, 'profile') : sellerFooter(context, 'profile'),
    );
  }

  // Buyer Grid View
  Widget buildBuyerGridView() {
    if (homePosts.isEmpty) {
      return const Center(
        child: Text(
          'ยังไม่มีโพสต์',
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // จัดให้อยู่ซ้าย-ขวา
                          children: [
                            Row(
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
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.grey),
                              onPressed: () => confirmDelete(context, post.id),
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

  // Buyer History View
 
  void confirmDelete(BuildContext context, String postId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("ยืนยันการลบ"),
        content: Text("คุณต้องการลบโพสต์นี้หรือไม่?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("ยกเลิก"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await deletePost(postId); // รอให้ลบเสร็จก่อน
              Navigator.pushReplacementNamed(context, '/profile'); // อัปเดต UI หลังลบโพสต์
            },
            child: Text("ลบ", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}
}
