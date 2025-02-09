import 'package:flutter/material.dart';
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
  bool isBuyerSelected = true; // Default to Buyer tab
  bool isGridSelected = true; // Default to Grid view

  String pic = '-';
  String hideEmail = '-';
  String hidePhone = '-';
  String studentID = '-';
  String name = '-';
  String faculty = '-';
  String department = '-';
  String classyear = '-';
  String address = '-';
  Future<void> getDataUser() async {
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) {
    //     return const Center(
    //       child: SizedBox(
    //         height: 90.0, // กำหนดความสูง
    //         width: 90.0, // กำหนดความกว้าง
    //         child: CircularProgressIndicator(
    //           color: Color(0XFFE35205),
    //           strokeWidth: 12.0, // ปรับความหนาของวงกลม
    //           strokeCap: StrokeCap.round,
    //         ),
    //       ),
    //     );
    //   },
    // );
    final id = await Securestorage().readSecureData('userId');
    final response = await UserService().getUserById(int.parse(id));
    if (response['success']) {
      final userData = response['data'];
      setState(() {
        pic = userData['pic'];
        var phoneNumber = userData['mobile'];
        var email = userData['email'];
        hidePhone = '${phoneNumber.substring(0, 3)}-***-${phoneNumber.substring(6)}';
        hideEmail = '${email.substring(0, 3)}***${email.substring(6)}';
        studentID = '${email.substring(0, 8)}';
        name = userData['name'];
        faculty = userData['faculty'];
        department = userData['department'];
        classyear = userData['classyear'];
        address = userData['address'];
      });
    }
    // if (mounted) {
    //     Navigator.pop(context);
    //   }
  }

  @override
  void initState() {
    super.initState(); // กำหนดค่าเริ่มต้นให้ userData เป็น Future ที่ว่าง
    getDataUser();
  }

  // รายการสินค้า (คนซื้อ)
  final List<Map<String, String>> buyerItems = [
    {'image': 'assets/images/sample_item.png', 'title': 'สินค้า A'},
    {'image': 'assets/images/sample_item.png', 'title': 'สินค้า B'},
    {'image': 'assets/images/sample_item.png', 'title': 'สินค้า C'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ฉัน"),
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
                        leading: const Icon(Icons.person),
                        title: const Text('ข้อมูลส่วนตัว'),
                        onTap: () {
                          // Handle personal info action
                          Navigator.pop(context); // Close the bottom sheet
                          Navigator.pushNamed(context, '/infoprofile');
                          // Navigate to personal information page if needed
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.exit_to_app),
                        title: const Text('ออกจากระบบ'),
                        onTap: () {
                          // Handle logout action
                          Navigator.pop(context, '/login'); // Close the bottom sheet
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
                      onPressed: () {
                        setState(() {
                          isBuyerSelected = true;
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
                      color: isBuyerSelected ? const Color(0xFFFCEEEA) : const Color(0xFFE35205),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isBuyerSelected = false;
                        });
                      },
                      child: Text(
                        'คนขาย',
                        style: TextStyle(
                          fontSize: 16,
                          color: isBuyerSelected ? const Color(0xFFE35205) : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Grid and History Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                // Column สำหรับไอคอน Grid View
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isGridSelected = true;
                          });
                        },
                        icon: Icon(
                          Icons.grid_view,
                          color: isGridSelected ? const Color(0xFFE35205) : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Column สำหรับไอคอน History View
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isGridSelected = false;
                          });
                        },
                        icon: Icon(
                          Icons.history,
                          color: isGridSelected ? Colors.grey : const Color(0xFFE35205),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Content Area
          Expanded(
            child: isBuyerSelected
                ? (isGridSelected ? buildBuyerGridView() : buildBuyerHistoryView())
                : (isGridSelected ? buildSellerGridView() : buildSellerHistoryView()),
          ),
        ],
      ),
      // Footer changes based on role
      bottomNavigationBar: isBuyerSelected ? buyerFooter(context, 'profile') : sellerFooter(context, 'profile'),
    );
  }

  // Buyer Grid View
  Widget buildBuyerGridView() {
    if (buyerItems.isEmpty) {
      return const Center(
        child: Text(
          'ยังไม่มีรายการสินค้า',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        itemCount: buyerItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          final item = buyerItems[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.asset(
                    item['image']!,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item['title']!,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Buyer History View
  Widget buildBuyerHistoryView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'ยังไม่มีประวัติการซื้อ',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Seller Grid View
  Widget buildSellerGridView() {
    return const Center(
      child: Text(
        'ยังไม่มีรายการที่คุณขาย',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  // Seller History View
  Widget buildSellerHistoryView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sell_outlined, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'ยังไม่มีประวัติการขาย',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
