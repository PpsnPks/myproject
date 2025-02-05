import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:image_picker/image_picker.dart'; 
import 'dart:io';
import 'package:myproject/Service/messageservice.dart'; 

class Messagepage extends StatefulWidget {
  const Messagepage({super.key});

  @override
  State<Messagepage> createState() => _MessagepageState();
}

class _MessagepageState extends State<Messagepage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ImagePicker _picker = ImagePicker();
  final MessageService _messageService = MessageService();

  // เพิ่มข้อมูลจำลอง buyer และ seller
  final String buyerId = "buyer_001";
  final String sellerId = "seller_001";

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final messageText = _controller.text;
      final messageTime = DateFormat('HH:mm').format(DateTime.now());

      // อัปเดต UI ก่อนส่งข้อมูล
      setState(() {
        _messages.add({
          'text': messageText,
          'time': messageTime,
          'image': null,
        });
      });

      _controller.clear();

      // ส่งข้อมูลไปยัง API
      await _messageService.sendMessage(
        buyerId: buyerId,
        sellerId: sellerId,
        message: messageText,
      );
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
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          message['time'],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (message['text'] != null)
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFE35205),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: Text(
                              message['text'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: () {}, 
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
