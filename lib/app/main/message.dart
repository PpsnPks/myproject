import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // สำหรับจัดรูปแบบเวลา
import 'package:image_picker/image_picker.dart'; // สำหรับเลือกรูป
import 'dart:io'; // สำหรับใช้ File class

class Messagepage extends StatefulWidget {
  const Messagepage({super.key});

  @override
  State<Messagepage> createState() => _MessagepageState();
}

class _MessagepageState extends State<Messagepage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = []; // เก็บข้อความพร้อมเวลา
  final ImagePicker _picker = ImagePicker(); // ตัวเลือกภาพ

  // ฟังก์ชันส่งข้อความ
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _controller.text,
          'time': DateFormat('HH:mm').format(DateTime.now()), // บันทึกเวลา
          'image': null, // ไม่มีรูป
        });
      });
      _controller.clear();
    }
  }

  // ฟังก์ชันส่งรูป
  Future<void> _sendImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery); // เลือกรูปจากแกลเลอรี
    if (image != null) {
      setState(() {
        _messages.add({
          'text': null, // ไม่มีข้อความ
          'time': DateFormat('HH:mm').format(DateTime.now()), // บันทึกเวลา
          'image': image.path, // เก็บพาธรูป
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          // พื้นที่แสดงข้อความ
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerRight, // ข้อความอยู่ด้านขวา
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // เวลา
                        Text(
                          message['time'],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // ข้อความหรือรูป
                        if (message['text'] != null)
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFE35205), // พื้นหลังสีส้ม
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            child: Text(
                              message['text'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          )
                        else if (message['image'] != null)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: File(message['image']).existsSync() // ตรวจสอบว่าไฟล์มีอยู่จริง
                                ? Image(
                                    image: FileImage(File(message['image'])), // ใช้ FileImage แทน Image.file
                                    width: 150, // กำหนดความกว้าง
                                    height: 200, // กำหนดความสูง
                                    fit: BoxFit.cover, // ปรับการแสดงผลรูปให้เต็มขนาดที่กำหนด
                                  )
                                : Container(
                                    child: Icon(Icons.error, color: Colors.red), // แสดงไอคอนถ้าผิดพลาด
                                  ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // แถบส่งข้อความและรูป
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: _sendImage, // ฟังก์ชันส่งรูป
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
