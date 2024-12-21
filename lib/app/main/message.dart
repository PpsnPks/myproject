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
        title: Text('Chat'),
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
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 8),
                        // ข้อความหรือรูป
                        if (message['text'] != null)
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFE35205), // พื้นหลังสีส้ม
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            child: Text(
                              message['text'],
                              style: TextStyle(
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
                            child: Image.file(
                              File(message['image']), // แสดงรูป
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
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
                  icon: Icon(Icons.photo),
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
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
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
