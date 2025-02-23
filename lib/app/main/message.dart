import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:myproject/Service/chatservice.dart';
import 'package:myproject/Service/messageservice.dart';
import 'package:myproject/Service/productdetailservice.dart';

class Messagepage extends StatefulWidget {
  final String receiverId;
  final String name;
  const Messagepage({super.key, required this.receiverId, required this.name});

  @override
  State<Messagepage> createState() => _MessagepageState();
}

class _MessagepageState extends State<Messagepage> {
  String name = '';
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final MessageService _messageService = MessageService();

  // เพิ่มข้อมูลจำลอง buyer และ seller
  final String buyerId = "buyer_001";
  final String sellerId = "seller_001";
  // final List<NewMessage> messages = [];
  List<OldMessage> oldMessage = [];
  late NewMessage newMessage;
  bool isLoading = true;
  bool showDate = false;
  bool isSending = false;

  void getOldMessage() async {
    setState(() {
      isLoading = true;
    });
    oldMessage = await MessageService().getoldMessage(widget.receiverId);
    setState(() {
      isLoading = false;
    });
    for (OldMessage item in oldMessage) {
      print(
          '${item.message}, sendid: ${item.senderId}, receiverId: ${item.receiverId}, statusread: ${item.statusread}, timeStamp: ${item.timeStamp}, date: ${item.thaiDate}, time: ${item.time}');
    }
  }

  late Timer _timer;
  String _dots = "";
  final FocusNode _focusNode = FocusNode(); // FocusNode ใช้จัดการการโฟกัส
  void addMessage() async {
    print('qqqqqqqqqqqqqqqqqqqqqqqqqqqq');
    var response = await MessageService().getoldMessage(widget.receiverId);
    print('ssssssssssssssssssssssssssss');
    if (isSending) {
      setState(() {
        _timer.cancel(); // ยกเลิก timer เมื่อ widget ถูกทิ้ง
        isSending = false;
      });
    }
    setState(() {
      oldMessage = response;
    });
    // var a = jsonDecode(data);
    // final messageTime = DateFormat('HH:mm').format(DateTime.now());
    // print('2222');

    // setState(() {
    //   messages.add(data);
    //   // messages.add({
    //   //   'text': data.message,
    //   //   'senderId': data.senderId,
    //   //   'receiverId': data.receiverId,
    //   //   'time': data.time,
    //   //   'image': 'aaa',
    //   // });
    // });
    // print('3333');
  }

  void _sendMessage(String mess) async {
    _controller.clear();
    isSending = true;
    _focusNode.unfocus();
    setState(() {
      _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
        if (_dots.length < 6) {
          setState(() {
            _dots += " .";
          });
        } else {
          setState(() {
            _dots = "";
          });
        }
      });
    });
    if (mess.isNotEmpty) {
      newMessage = await MessageService().sendChat(widget.receiverId, mess);
      print(newMessage.message);
      // อัปเดต UI ก่อนส่งข้อมูล
      // setState(() {
      //   messages.add({
      //     'text': messageText,
      //     'time': messageTime,
      //     'image': null,
      //   });
      // });
      // ส่งข้อมูลไปยัง API
      // await _messageService.sendMessage(
      //   buyerId: buyerId,
      //   sellerId: sellerId,
      //   message: messageText,
      // );
    }
  }

  dynamic getProduct(String id) async {
    setState(() {
      isLoading = true;
    });

    var response = await ProductService().getProductById(id);
    return response;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    PusherService().initPusher(widget.receiverId, addMessage);
    getOldMessage();
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: isLoading
                  ? const Center(
                      child: SizedBox(
                        height: 60.0, // กำหนดความสูง
                        width: 60.0, // กำหนดความกว้าง
                        child: CircularProgressIndicator(
                          color: Color(0XFFE35205),
                          strokeWidth: 5.0, // ปรับความหนาของวงกลม
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                    )
                  : ListView.builder(
                      reverse: true,
                      itemCount: oldMessage.length,
                      itemBuilder: (context, index) {
                        var message;
                        var old;
                        var dateText = 'a';
                        var tempShowDate = '';

                        print('222A2');
                        message = oldMessage[oldMessage.length - 1 - index];
                        old = (oldMessage.length - 2 - index) == -1
                            ? {'thaiDate': 'aaa', 'message': 'eeeee'}
                            : oldMessage[oldMessage.length - 2 - index];
                        tempShowDate = message.thaiDate;
                        print('$index aaa ${message.message} ${message.thaiDate} $index ddd = $dateText $showDate $tempShowDate');
                        if (message.message.startsWith('\$\$Product : ')) {
                          String b = message.message.replaceFirst('\$\$Product : ', ''); // ตัด "qqqq : " ออก
                          print("ข้อความที่เหลือ: $b");

                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SizedBox(height: 130, width: double.infinity, child: buildProductCard(jsonDecode(b))),
                          );
                        }
                        return Column(
                          children: [
                            if ((oldMessage.length - 2 - (index)) == -1 ||
                                ((oldMessage.length - 2 - (index)) >= 0 && message.thaiDate != old.thaiDate))
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(69, 80, 80, 81),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                                    child: Text(
                                      tempShowDate,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: (message.senderId == widget.receiverId && message.senderId != message.receiverId)
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (message.senderId != widget.receiverId || message.senderId == message.receiverId)
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 3.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              message.statusread == '1' ? 'อ่านแล้ว' : '',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10,
                                              ),
                                            ),
                                            Text(
                                              message.time,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context).size.width * 0.8, // กำหนด maxWidth 80% ของจอ
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            //DFE2EC
                                            color: (message.senderId == widget.receiverId && message.senderId != message.receiverId)
                                                ? const Color(0xFFDFE2EC)
                                                : const Color(0xFFE35205),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                          child: Text(
                                            message.message,
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                            style: TextStyle(
                                              color: (message.senderId == widget.receiverId && message.senderId != message.receiverId)
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        )),
                                    if (message.senderId == widget.receiverId && message.senderId != message.receiverId)
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 3.0),
                                        child: Column(
                                          children: [
                                            // Text(
                                            //   message.statusread == '1' ? 'อ่านแล้ว' : '',
                                            //   style: const TextStyle(
                                            //     color: Colors.grey,
                                            //     fontSize: 10,
                                            //   ),
                                            // ),
                                            Text(
                                              message.time,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
                      focusNode: _focusNode,
                      readOnly: isSending,
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: isSending ? 'กำลังส่งข้อความ$_dots' : 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => {_sendMessage(_controller.text)},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductCard(dynamic product) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/productdetail/${product['id']}');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          border: Border.all(color: Colors.grey.shade300, width: 2), // Gray border
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: product['imageUrl'].isNotEmpty
                      ? product['imageUrl'][0]
                      : 'https://t3.ftcdn.net/jpg/05/04/28/96/360_F_504289605_zehJiK0tCuZLP2MdfFBpcJdOVxKLnXg1.jpg',
                  placeholder: (context, url) => LayoutBuilder(
                    builder: (context, constraints) {
                      double size = constraints.maxHeight;
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
                        double size = constraints.maxHeight; // ใช้ maxWidth เป็นขนาดของ width และ height
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
                      double size = constraints.maxHeight;
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
              const SizedBox(width: 20),
              Flexible(
                fit: FlexFit.loose,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      'จำนวน: ${product['stock']}\nสภาพสินค้า : ${product['condition']}\nถึงวันที่: ${product['timeForSell']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFA5A9B6),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '${product['price']} ฿',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                // child: Text(
                //   product.product_description,
                //   style: const TextStyle(color: Colors.grey, fontSize: 10),
                //   overflow: TextOverflow.ellipsis,
                //   maxLines: 3,
                // ),
              ),
              // const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
// if (index < messages.length) {
//   message = messages[messages.length - 1 - (index)]; //new
//   if (index == 0) {
//     dateText = message['thaiDate'];
//   } else if (dateText != message['thaiDate']) {
//     showDate = true;
//     tempShowDate = dateText;
//     dateText = message['thaiDate'];
//   } else {
//     showDate = false;
//   }
//   return showDate
//       ? Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 color: const Color(0xFFDFE2EC),
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//               child: Text(
//                 tempShowDate,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ],
//         )
//       : null;
// } else {
//   message = oldMessage[oldMessage.length - 1 - (index - messages.length)];
//   if (index == 0) {
//     dateText = message.thaiDate;
//   } else if (dateText != message.thaiDate) {
//     showDate = true;
//     tempShowDate = dateText;
//     dateText = message.thaiDate;
//   } else {
//     showDate = false;
//   }
//   return showDate
//       ? Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 color: const Color(0xFFDFE2EC),
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//               child: Text(
//                 tempShowDate,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ],
//         )
//       : null;
// }
