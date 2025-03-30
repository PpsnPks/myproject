import 'package:flutter/material.dart';
import 'package:myproject/Service/customerservice.dart';
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
  if (response['success']) {
    final userData = response['customer'];
    setState(() {
      pic = userData.pic;
      var phoneNumber = userData.mobile;
      var email = userData.email;
      hidePhone = '${phoneNumber.substring(0, 3)}-***-${phoneNumber.substring(6)}';
      hideEmail = '${email.substring(0, 3)}***${email.substring(6)}';
      studentID = '${email.substring(0, 8)}';
      name = userData.name;
      faculty = userData.faculty;
      department = userData.department;
      classyear = userData.classyear;
      address = userData.address;

      if (response.containsKey('userpost')) {
        buyerItems = response['userpost'].map<Map<String, String>>((post) {
          return {
            'title': post['title'] ?? '',
            'image': post['image_url'] ?? '',
          };
        }).toList();
      }
    });
  }
}

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      viewedUserId = args['userId'].toString();
      currentUserId = await Securestorage().readSecureData('userId');
      getDataUser(viewedUserId);
    });
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
                  child: Image.network(
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
}
