import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
// import 'package:myproject/Service/chatservice.dart';
import 'package:myproject/Service/messageservice.dart';
import 'package:myproject/Service/productdetailservice.dart';
import 'package:myproject/Service/uploadimgservice.dart';
import 'package:myproject/environment.dart';
import 'package:url_launcher/url_launcher.dart';

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

  late GoogleMapController mapController;

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

  Future<void> _openGoogleMaps(double latitude, double longitude) async {
    final Uri googleMapUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");

    if (await canLaunchUrl(googleMapUrl)) {
      await launchUrl(googleMapUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  // Future<void> _openGoogleMaps(double latitude, double longitude) async {
  //   final Uri googleMapAndroid = Uri.parse("geo:$latitude,$longitude?q=$latitude,$longitude");

  //   if (await canLaunchUrl(googleMapAndroid)) {
  //     await launchUrl(googleMapAndroid);
  //   } else {
  //     throw 'Could not open Google Maps.';
  //   }
  // }

  late Timer _timer;
  String _dots = "";
  final FocusNode _focusNode = FocusNode(); // FocusNode ใช้จัดการการโฟกัส
  void addMessage() async {
    if (!mounted) return;
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
      _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
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
    PusherService().disconnectPusher(widget.receiverId);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/chat');
          },
        ),
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
                        if ((oldMessage.length - 2 - index) == -1) {
                          tempShowDate = oldMessage[oldMessage.length - 1].thaiDate;
                        } else {
                          tempShowDate = oldMessage[oldMessage.length - 1 - index].thaiDate;
                        }
                        tempShowDate = 'วันอังคาร';
                        print(
                            '${oldMessage.length} ${oldMessage.length - 1 - index} aaa ${message.message} ${message.thaiDate} $index ddd = $dateText $showDate $tempShowDate');
                        if (message.message.startsWith('\$\$Product : ')) {
                          String b = message.message.replaceFirst('\$\$Product : ', ''); // ตัด "qqqq : " ออก
                          print("ข้อความที่เหลือ: $b");

                          return Column(
                            children: [
                              if (oldMessage.length - 1 - index == 0 ||
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
                                padding: const EdgeInsets.all(4.0),
                                child: SizedBox(height: 130, width: double.infinity, child: buildProductCard(jsonDecode(b))),
                              ),
                            ],
                          );
                        } else if (message.message.startsWith('\$\$Image : ')) {
                          String b = message.message.replaceFirst('\$\$Image : ', ''); // ตัด "qqqq : " ออก
                          print("ข้อความที่เหลือ: $b");

                          return Column(
                            children: [
                              if ((oldMessage.length - 2 - (index)) == -1 ||
                                  ((oldMessage.length - 2 - (index)) >= 0 && message.thaiDate != old.thaiDate) ||
                                  index == oldMessage.length - 1)
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
                                            maxHeight: MediaQuery.of(context).size.width * 0.8, // กำหนด maxWidth 80% ของจอ
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              //DFE2EC
                                              color: const Color.fromARGB(255, 233, 234, 242),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                                            child: GestureDetector(
                                              onTap: () => {
                                                Navigator.pushNamed(context, '/fullimage', arguments: {'image': '${Environment.imgUrl}/$b'})
                                              },
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: CachedNetworkImage(
                                                  imageUrl: b.isNotEmpty
                                                      ? '${Environment.imgUrl}/$b'
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
                                                              fit: BoxFit.fitHeight, // ปรับขนาดภาพให้เต็ม
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
                                                            fit: BoxFit.fitHeight,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                      if (message.senderId == widget.receiverId && message.senderId != message.receiverId)
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 3.0),
                                          child: Column(
                                            children: [
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
                          // SizedBox(
                          //   height: 50,
                          //   width: 50,
                          //   child: ClipRRect(
                          //     borderRadius: BorderRadius.circular(8),
                          //     child: CachedNetworkImage(
                          //       imageUrl: b.isNotEmpty
                          //           ? '${Environment.imgUrl}/$b'
                          //           : 'https://t3.ftcdn.net/jpg/05/04/28/96/360_F_504289605_zehJiK0tCuZLP2MdfFBpcJdOVxKLnXg1.jpg',
                          //       placeholder: (context, url) => LayoutBuilder(
                          //         builder: (context, constraints) {
                          //           double size = constraints.maxHeight;
                          //           return SizedBox(
                          //             width: size,
                          //             height: size, // ให้สูงเท่ากับกว้าง
                          //             child: const Center(
                          //               child: CircularProgressIndicator(
                          //                 color: Color(0XFFE35205),
                          //                 strokeCap: StrokeCap.round,
                          //               ),
                          //             ),
                          //           );
                          //         },
                          //       ),
                          //       imageBuilder: (context, ImageProvider) {
                          //         return LayoutBuilder(
                          //           builder: (context, constraints) {
                          //             double size = constraints.maxHeight; // ใช้ maxWidth เป็นขนาดของ width และ height
                          //             return Container(
                          //               width: size,
                          //               height: size, // ให้ height เท่ากับ width
                          //               decoration: BoxDecoration(
                          //                 image: DecorationImage(
                          //                   image: ImageProvider,
                          //                   fit: BoxFit.fill, // ปรับขนาดภาพให้เต็ม
                          //                 ),
                          //               ),
                          //             );
                          //           },
                          //         );
                          //       },
                          //       errorWidget: (context, url, error) => LayoutBuilder(
                          //         builder: (context, constraints) {
                          //           double size = constraints.maxHeight;
                          //           return Container(
                          //             width: size,
                          //             height: size,
                          //             decoration: const BoxDecoration(
                          //               image: DecorationImage(
                          //                 image: AssetImage("assets/images/notfound.png"), // รูปจาก assets
                          //                 fit: BoxFit.fill,
                          //               ),
                          //             ),
                          //           );
                          //         },
                          //       ),
                          //     ),
                          //   ),
                          // );
                        } else if (message.message.startsWith('\$\$Location : ')) {
                          String b = message.message.replaceFirst('\$\$Location : ', ''); // ตัด "qqqq : " ออก
                          print("Aข้อความที่เหลือ: $b");
                          dynamic location = jsonDecode(b);
                          location['la'] = double.parse(location['la']);
                          location['long'] = double.parse(location['long']);
                          return Column(
                            children: [
                              if ((oldMessage.length - 2 - (index)) == -1 ||
                                  ((oldMessage.length - 2 - (index)) >= 0 && message.thaiDate != old.thaiDate) ||
                                  index == oldMessage.length - 1)
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
                                            maxHeight: MediaQuery.of(context).size.width * 0.8 + 60.0, // กำหนด maxWidth 80% ของจอ
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              //DFE2EC
                                              color: const Color.fromARGB(255, 233, 234, 242),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width * 0.8, // กำหนด maxWidth 80% ของจอ
                                                  height: MediaQuery.of(context).size.width * 0.8,
                                                  child: GoogleMap(
                                                    initialCameraPosition: CameraPosition(
                                                      target: LatLng(location['la'], location['long']), //const LatLng(13.7563, 100.5018),
                                                      zoom: 15,
                                                    ),
                                                    markers: {
                                                      Marker(
                                                        markerId: const MarkerId('marker_1'),
                                                        position: LatLng(location['la'], location['long']),
                                                        infoWindow: const InfoWindow(title: 'หมุดที่นี่', snippet: 'รายละเอียดเพิ่มเติม'),
                                                      ),
                                                    },
                                                    onMapCreated: (GoogleMapController controller) {
                                                      setState(() {
                                                        mapController = controller;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(4.0, 10.0, 4.0, 0.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Location : ${location['name']}',
                                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () => {_openGoogleMaps(location['la'], location['long'])},
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: const Color.fromARGB(255, 247, 223, 210),
                                                            borderRadius: BorderRadius.circular(20),
                                                            border: Border.all(
                                                              width: 1,
                                                              color: const Color(0XFFE35205),
                                                            ),
                                                          ),
                                                          padding: const EdgeInsets.fromLTRB(15.0, 3.0, 15.0, 6.0),
                                                          child: const Text(
                                                            'ไปที่ google map',
                                                            style: TextStyle(
                                                                color: Color(0XFFE35205),
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w600,
                                                                height: 0),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                      if (message.senderId == widget.receiverId && message.senderId != message.receiverId)
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 3.0),
                                          child: Column(
                                            children: [
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
                          // SizedBox(
                          //   height: 50,
                          //   width: 50,
                          //   child: ClipRRect(
                          //     borderRadius: BorderRadius.circular(8),
                          //     child: CachedNetworkImage(
                          //       imageUrl: b.isNotEmpty
                          //           ? '${Environment.imgUrl}/$b'
                          //           : 'https://t3.ftcdn.net/jpg/05/04/28/96/360_F_504289605_zehJiK0tCuZLP2MdfFBpcJdOVxKLnXg1.jpg',
                          //       placeholder: (context, url) => LayoutBuilder(
                          //         builder: (context, constraints) {
                          //           double size = constraints.maxHeight;
                          //           return SizedBox(
                          //             width: size,
                          //             height: size, // ให้สูงเท่ากับกว้าง
                          //             child: const Center(
                          //               child: CircularProgressIndicator(
                          //                 color: Color(0XFFE35205),
                          //                 strokeCap: StrokeCap.round,
                          //               ),
                          //             ),
                          //           );
                          //         },
                          //       ),
                          //       imageBuilder: (context, ImageProvider) {
                          //         return LayoutBuilder(
                          //           builder: (context, constraints) {
                          //             double size = constraints.maxHeight; // ใช้ maxWidth เป็นขนาดของ width และ height
                          //             return Container(
                          //               width: size,
                          //               height: size, // ให้ height เท่ากับ width
                          //               decoration: BoxDecoration(
                          //                 image: DecorationImage(
                          //                   image: ImageProvider,
                          //                   fit: BoxFit.fill, // ปรับขนาดภาพให้เต็ม
                          //                 ),
                          //               ),
                          //             );
                          //           },
                          //         );
                          //       },
                          //       errorWidget: (context, url, error) => LayoutBuilder(
                          //         builder: (context, constraints) {
                          //           double size = constraints.maxHeight;
                          //           return Container(
                          //             width: size,
                          //             height: size,
                          //             decoration: const BoxDecoration(
                          //               image: DecorationImage(
                          //                 image: AssetImage("assets/images/notfound.png"), // รูปจาก assets
                          //                 fit: BoxFit.fill,
                          //               ),
                          //             ),
                          //           );
                          //         },
                          //       ),
                          //     ),
                          //   ),
                          // );
                        }
                        return Column(
                          children: [
                            if (oldMessage.length - 1 - index == 0 ||
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
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    width: 40.0, // you can adjust the width as you need
                    child: IconButton(
                        padding: EdgeInsets.zero, // No padding
                        icon: const Icon(
                          Icons.photo,
                          size: 30,
                        ),
                        onPressed: () {
                          _pickimg();
                        },
                        constraints: const BoxConstraints()),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                    width: 40.0,
                    child: IconButton(
                      padding: EdgeInsets.zero, // No padding
                      icon: const Icon(
                        Icons.location_on,
                        size: 30,
                      ),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              padding: const EdgeInsets.all(20),
                              height: 460,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Center(
                                      child: Text(
                                    'สถานที่นัดรับของ',
                                    style: TextStyle(fontSize: 24),
                                  )),
                                  Expanded(
                                    child: ListView(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            'โซนหอพัก',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              height: 1.0,
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          contentPadding: const EdgeInsets.all(0.0),
                                          // leading: const Icon(Icons.edit, color: Colors.grey),
                                          title: const Text(
                                            'เกกี',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              height: 1.0,
                                            ),
                                          ),
                                          onTap: () {
                                            const temp = '{"name" : "เกกี", "la" : "13.72781386554174", "long" : "100.77059800722523"}';
                                            _sendMessage('\$\$Location : $temp');
                                            Navigator.pop(context); // ปิด BottomSheet
                                          },
                                        ),
                                        const Divider(height: 0),
                                        ListTile(
                                          contentPadding: const EdgeInsets.all(0.0),
                                          title: const Text('RNP'),
                                          onTap: () {
                                            const temp = '{"name" : "RNP", "la" : "13.727609463500029", "long" : "100.76481852468011"}';
                                            _sendMessage('\$\$Location : $temp');
                                            Navigator.pop(context);
                                          },
                                        ),
                                        const Divider(height: 0),
                                        ListTile(
                                          contentPadding: const EdgeInsets.all(0.0),
                                          title: const Text('FBT'),
                                          onTap: () {
                                            const temp = '{"name" : "FBT", "la" : "13.723076519199177", "long" : "100.78029566320657"}';
                                            _sendMessage('\$\$Location : $temp');
                                            Navigator.pop(context);
                                          },
                                        ),
                                        const Divider(height: 0),
                                        ListTile(
                                          contentPadding: const EdgeInsets.all(0.0),
                                          title: const Text('จินดา'),
                                          onTap: () {
                                            const temp = '{"name" : "จินดา", "la" : "13.721739050966804", "long" : "100.78384553916294"}';
                                            _sendMessage('\$\$Location : $temp');
                                            Navigator.pop(context);
                                          },
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            'คณะวิศวะ',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              height: 1.0,
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          contentPadding: const EdgeInsets.all(0.0),
                                          title: const Text('ตึกโหล'),
                                          onTap: () {
                                            const temp = '{"name" : "ตึกโหล", "la" : "13.727324226294408", "long" : "100.7724138310083"}';
                                            _sendMessage('\$\$Location : $temp');
                                            Navigator.pop(context);
                                          },
                                        ),
                                        const Divider(height: 0),
                                        ListTile(
                                          contentPadding: const EdgeInsets.all(0.0),
                                          title: const Text('ตึก HM'),
                                          onTap: () {
                                            const temp = '{"name" : "ตึก HM", "la" : "13.726577885378601", "long" : "100.77517672662191"}';
                                            _sendMessage('\$\$Location : $temp');
                                            Navigator.pop(context);
                                          },
                                        ),
                                        const Divider(height: 0),
                                        ListTile(
                                          contentPadding: const EdgeInsets.all(0.0),
                                          title: const Text('ร้าน นางคาเฟ่'),
                                          onTap: () {
                                            const temp =
                                                '{"name" : "ร้าน นางคาเฟ่", "la" : "13.72491156246569", "long" : "100.77358915914414"}';
                                            _sendMessage('\$\$Location : $temp');
                                            Navigator.pop(context);
                                          },
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            'พระเทพ',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              height: 1.0,
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          contentPadding: const EdgeInsets.all(0.0),
                                          title: const Text('โรงอาหารพระเทพ'),
                                          onTap: () {
                                            const temp =
                                                '{"name" : "โรงอาหารพระเทพ", "la" : "13.730071712511561", "long" : "100.77590728681582"}';
                                            _sendMessage('\$\$Location : $temp');
                                            Navigator.pop(context);
                                          },
                                        ),
                                        const Divider(height: 0),
                                        ListTile(
                                          contentPadding: const EdgeInsets.all(0.0),
                                          title: const Text('คลินิคสจล.'),
                                          onTap: () {
                                            const temp =
                                                '{"name" : "คลินิคสจล.", "la" : "13.729577917786296", "long" : "100.77741439301415"}';
                                            _sendMessage('\$\$Location : $temp');
                                            Navigator.pop(context);
                                          },
                                        ),
                                        const Divider(height: 0),
                                        ListTile(
                                          contentPadding: const EdgeInsets.all(0.0),
                                          title: const Text('สนามกีฬา'),
                                          onTap: () {
                                            const temp =
                                                '{"name" : "สนามกีฬา", "la" : "13.730297726354788", "long" : "100.77230996713159"}';
                                            _sendMessage('\$\$Location : $temp');
                                            Navigator.pop(context);
                                          },
                                        ),
                                        const Divider(height: 0),
                                        ListTile(
                                          contentPadding: const EdgeInsets.all(0.0),
                                          title: const Text('หอใน'),
                                          onTap: () {
                                            const temp = '{"name" : "หอใน", "la" : "13.730297726354788", "long" : "100.77230996713159"}';
                                            _sendMessage('\$\$Location : $temp');
                                            Navigator.pop(context);
                                          },
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            'คณะวิทย์',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              height: 1.0,
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          contentPadding: const EdgeInsets.all(0.0),
                                          title: const Text('โรงอาหารคณะวิทย์'),
                                          onTap: () {
                                            const temp =
                                                '{"name" : "โรงอาหารคณะวิทย์", "la" : "13.729088318545317", "long" : "100.7795365474223"}';
                                            _sendMessage('\$\$Location : $temp');
                                            Navigator.pop(context);
                                          },
                                        ),
                                        const Divider(height: 0),
                                        ListTile(
                                          contentPadding: const EdgeInsets.all(0.0),
                                          title: const Text('โรงอาหารคณะครุ'),
                                          onTap: () {
                                            const temp =
                                                '{"name" : "โรงอาหารคณะครุ", "la" : "13.729235827442663", "long" : "100.78061248163122"}';
                                            _sendMessage('\$\$Location : $temp');
                                            Navigator.pop(context);
                                          },
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            'บริเวณหอสมุด',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              height: 1.0,
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          contentPadding: const EdgeInsets.all(0.0),
                                          title: const Text('หอสมุดกลาง'),
                                          onTap: () {
                                            const temp =
                                                '{"name" : "หอสมุดกลาง", "la" : "13.727527264041003", "long" : "100.77844227530247"}';
                                            _sendMessage('\$\$Location : $temp');
                                            Navigator.pop(context);
                                          },
                                        ),
                                        const Divider(height: 0),
                                        ListTile(
                                          contentPadding: const EdgeInsets.all(0.0),
                                          title: const Text('หอประชุม (วร บุนนาค)'),
                                          onTap: () {
                                            const temp =
                                                '{"name" : "หอประชุม (วร บุนนาค)", "la" : "13.72661051606565", "long" : "100.77926648009303"}';
                                            _sendMessage('\$\$Location : $temp');
                                            Navigator.pop(context);
                                          },
                                        ),
                                        const Divider(height: 1),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
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
    // print(product['imageUrl']);
    // print('AAA ${product['imageUrl']}');
    // print('AAAA ${Environment.imgUrl}${product['imageUrl']}');
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
                      ? '${Environment.imgUrl}${product['imageUrl']}'
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
                    product['type'] != 'preorder'
                        ? Text(
                            'จำนวน: ${product['stock']}\nสภาพสินค้า : ${product['condition']}\nถึงวันที่: ${product['timeForSell']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFA5A9B6),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          )
                        : Text(
                            'ค่ามัดจำ: ${product['deposit']}\nวันส่งสินค้า : ${product['date_send']}\nถึงวันที่: ${product['timeForSell']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFA5A9B6),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisAlignment: product['type'] == 'preorder' ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
                        children: [
                          if (product['type'] == 'preorder')
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  width: 1,
                                  color: const Color(0XFFE35205),
                                ),
                              ),
                              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 3.0),
                              child: const Text(
                                'พรีออเดอร์',
                                style: TextStyle(color: Color(0XFFE35205), fontSize: 12, fontWeight: FontWeight.w600, height: 0),
                              ),
                            ),
                          Text(
                            product['price'] == '0' || product['price'] == '0.00' ? 'ฟรี' : '${product['price']} ฿',
                            style: const TextStyle(
                              color: Color(0XFFE35205),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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

  final List<Uint8List> _imageBytesList = [];
  void _pickimg() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery); // เลือกเพียง 1 รูป

    if (pickedFile != null) {
      var response = await UploadImgService().uploadImg(pickedFile);
      if (response['success']) {
        _sendMessage('\$\$Image : ${response['image']}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('อัปโหลดรูปไม่ได้ โปรดลองอีกครั้ง'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
