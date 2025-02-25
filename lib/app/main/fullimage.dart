import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myproject/environment.dart';

class FullScreenImageView extends StatefulWidget {
  final String image;

  const FullScreenImageView({super.key, required this.image});

  @override
  _FullScreenImageViewState createState() => _FullScreenImageViewState();
}

class _FullScreenImageViewState extends State<FullScreenImageView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // ตั้งค่าพื้นหลังเป็นสีดำ
      body: Stack(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: widget.image.isNotEmpty
                    ? widget.image
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
                            image: ImageProvider, fit: BoxFit.contain, // ปรับขนาดภาพให้เต็ม
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
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 10,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
              iconSize: 32, // ลดขนาดไอคอนให้พอดีกับ Container
              padding: EdgeInsets.zero, // ลบ Padding ออกเพื่อให้อยู่ตรงกลางจริง ๆ
              constraints: const BoxConstraints(),
            ),
          ),
          // Positioned(top: 40, right: 30, child: Text(widget.image, style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}
