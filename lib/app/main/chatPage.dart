import 'package:flutter/material.dart';
import 'package:myproject/app/buyer/buyerfooter.dart';
import 'package:myproject/service/Chatservice.dart';

class Chatpage extends StatefulWidget {
  const Chatpage({super.key});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  late Future<List<ProductChat>> likedProducts;
  bool isLoading = true;
  List<Chat> chats = [];

  void getAllChat() async {
    Map<String, dynamic> response = await Chatservice().getAllChat();
    print(response['success']);
    if (response['success'] == true) {
      List<Chat> data = response['data'];
      if (data.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      } else {
        setState(() {
          chats = data;
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

  @override
  void initState() {
    super.initState();
    // เรียก Chatservice เพื่อดึงข้อมูลสินค้าที่ถูกใจ
    getAllChat();
    // likedProducts = Chatservice().getLikedProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("แชท"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0XFFE35205),
                    strokeCap: StrokeCap.round,
                  ),
                ),
              ),
            )
          : ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return NotificationCard(
                  title: chat.name,
                  time: chat.time, // ใส่เวลาที่ต้องการ
                  imageUrl: chat.pic,
                  message: chat.latestMessage,
                  onTap: () {
                    Navigator.pushNamed(context, '/message/${chat.userId}', arguments: {'name': chat.name});
                  },
                );
              },
            ),
      bottomNavigationBar: buyerFooter(context, 'chat'),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String time;
  final String imageUrl;
  final String message;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.title,
    required this.time,
    required this.imageUrl,
    required this.message,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // ใช้ GestureDetector สำหรับการกด
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFDFE2EC), width: 2.0)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported, size: 50);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      message,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
