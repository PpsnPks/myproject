import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("แชท"), centerTitle: true, backgroundColor: Colors.white),
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
          : chats.isEmpty
              ? const Center(
                  child: Text(
                    'ยังไม่มีประวัติการแชท',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                )
              : ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    print('chat.pic ${chat.pic}');
                    return NotificationCard(
                      title: chat.name,
                      time: chat.time, // ใส่เวลาที่ต้องการ
                      imageUrl: chat.pic,
                      unread: chat.unread.toString(),
                      message: chat.latestMessage.startsWith('\$\$Product : ')
                          ? '[ สินค้า : ${jsonDecode(chat.latestMessage.replaceFirst('\$\$Product : ', ''))['name']} ]' //'สินค้า : ${jsonDecode(chat.latestMessage.replaceFirst('\$\$Product : ', ''))['name']}'
                          : chat.latestMessage.startsWith('\$\$Image : ')
                              ? '[ รูปภาพ ]'
                              : chat.latestMessage,
                      type: chat.latestMessage.startsWith('\$\$Product : ') || chat.latestMessage.startsWith('\$\$Image : ')
                          ? 'product'
                          : 'message',
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/message/${chat.userId}', arguments: {'name': chat.name});
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
  final String type;
  final String unread;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.title,
    required this.time,
    required this.imageUrl,
    required this.message,
    required this.type,
    required this.unread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // ใช้ GestureDetector สำหรับการกด
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFDFE2EC), width: 2.0)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(100),
              //   child: Image.asset(
              //     imageUrl,
              //     width: 50,
              //     height: 50,
              //     fit: BoxFit.cover,
              //     errorBuilder: (context, error, stackTrace) {
              //       return const Icon(Icons.image_not_supported, size: 50);
              //     },
              //   ),
              // ),
              SizedBox(
                width: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl.isNotEmpty
                        ? imageUrl
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
                                fit: BoxFit.fill, // ปรับขนาดภาพให้เต็ม
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
                    // const SizedBox(height: 5),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    // const SizedBox(height: 5),
                    // type == 'product'
                    // ? Container(
                    //     padding: const EdgeInsets.fromLTRB(8, 2, 8, 6), // กำหนดระยะห่างข้อความจากขอบ
                    //     decoration: BoxDecoration(
                    //       border: Border.all(color: const Color(0xFFA5A9B6), width: 2), // เส้นกรอบ
                    //       borderRadius: BorderRadius.circular(14), // มุมโค้ง
                    //       // color: const Color(0xFFA5A9B6), // พื้นหลัง
                    //     ),
                    //     child: Text(
                    //       message,
                    //       style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 0, 0, 0)),
                    //     ),
                    //   )
                    Text(
                      message,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              if (int.parse(unread) > 0)
                Container(
                  width: 30,
                  height: 30,
                  padding: const EdgeInsets.fromLTRB(8, 2, 8, 6), // กำหนดระยะห่างข้อความจากขอบ
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE35205), width: 2), // เส้นกรอบ
                    borderRadius: BorderRadius.circular(100), // มุมโค้ง
                    color: const Color(0xFFE35205), // พื้นหลัง
                  ),
                  child: Center(
                    child: Text(
                      unread,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
