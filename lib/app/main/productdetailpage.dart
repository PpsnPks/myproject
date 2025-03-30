import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Service/messageservice.dart';
import 'package:myproject/Service/productdetailservice.dart';
import 'package:myproject/environment.dart';
import 'package:myproject/app/main/secureStorage.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int selectedQuantity = 1;
  bool isLiked = false; // ตัวแปรสำหรับติดตามการกดถูกใจ
  int currentIndex = 0;
  bool isLoading = true;
  late ProductDetail data;

  String userId = "";

  void toggleLike() async {
    isLiked = !isLiked;
    if (isLiked == true) {
      await ProductService().likeProduct(int.parse(widget.productId));
    } else {
      await ProductService().unlikeProduct(widget.productId);
    }
  }

  void getProductDetail() async {
    setState(() {
      isLoading = true;
    });
    userId = await Securestorage().readSecureData('userId');
    ProductDetail response = await ProductService().getProductById(widget.productId);
    setState(() {
      isLiked = response.isLiked;
      data = response;
      isLoading = false;
    });
  }

  sendProductToMessage(String recieveId, String mess) async {
    await MessageService().sendChat(recieveId, mess);
  }

  createDeal(String productId) async {
    bool response = await ProductService().createDeal(productId);
    if (response) {
      Navigator.pushNamed(context, '/message/${data.sellerId}', arguments: {'name': data.sellerName});
    }
  }

  @override
  void initState() {
    super.initState();
    getProductDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("รายละเอียดสินค้า"),
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
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // รูปสินค้า
                    if (data.imageUrl.isNotEmpty)
                      Stack(
                        children: [
                          SizedBox(
                            height: 300,
                            child: PageView.builder(
                              itemCount: data.imageUrl.length,
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: data.imageUrl[index].isNotEmpty
                                        ? data.imageUrl[index]
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
                                                fit: BoxFit.cover, // ปรับขนาดภาพให้เต็ม
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
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                                // Image.network(
                                //   data.imageUrl[index],
                                //   fit: BoxFit.cover,
                                //   errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                                // );
                              },
                              onPageChanged: (index) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                data.imageUrl.length,
                                (index) => Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: index == currentIndex ? const Color(0XFFE35205) : Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 16,
                            child: Text(
                              '${currentIndex + 1}/${data.imageUrl.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),

                    // ชื่อสินค้า
                    Text(data.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),

                    // ราคา
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data.price == '0' || data.price == '0.00' ? 'ฟรี' : '฿${data.price}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? const Color(0XFFE35205) : Colors.grey,
                          ),
                          onPressed: () async {
                            setState(() {
                              toggleLike();
                              // isLiked = !isLiked; // เปลี่ยนสถานะการกดถูกใจ
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // รายละเอียดสินค้า
                    _buildDetailText('รายละเอียดสินค้า', data.description),
                    _buildDetailText('หมวดหมู่', data.category),
                    if (data.type == 'preorder') _buildDetailText('ค่ามัดจำ', "${data.deposit} ฿"),
                    _buildDetailText('สภาพสินค้า', data.condition),
                    if (data.condition == 'มือสอง') ...[
                      _buildDetailText('ระยะเวลาการใช้งาน', data.durationUse),
                      _buildDetailText('ตำหนิสินค้า', data.defect),
                    ],
                    _buildDetailText('สถานที่นัดรับ', data.deliveryLocation),
                    if (data.type == 'preorder') _buildDetailText('วันส่งสินค้า', data.date_send),
                    _buildDetailText('ระยะเวลาที่ลงขาย', data.timeForSell),
                    const SizedBox(height: 10),

                    // ข้อมูลผู้ขาย
                    Text('โพสต์โดย', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/viewprofile',
                              arguments: {'userId': data.sellerId}, // ส่ง userId ไปด้วย
                            );
                          },
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(data.sellerPic),
                            radius: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.sellerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('${data.sellerFaculty}'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // จำนวนสินค้าและปุ่มแชท
                    Text('จำนวนที่เหลือ: ${data.stock}', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 20),

                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.pushNamed(context, '/chat', arguments: {'sellerId': product.sellerName});
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     padding: const EdgeInsets.symmetric(vertical: 15),
                    //     backgroundColor: const Color(0XFFE35205),
                    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    //   ),
                    //   child: const Text('แชท', style: TextStyle(fontSize: 18, color: Colors.white)),
                    // ),
                    if (userId != data.sellerId)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                String temp =
                                    '\$\$Product : {"id" : "${data.id}", "imageUrl" : "${data.imageUrl[0].replaceFirst(Environment.imgUrl, '')}", "name" : "${data.name}", "condition" : "${data.condition}", "stock": "${data.stock}", "timeForSell": "${data.timeForSell}", "price": "${data.price}", "deposit": "${data.deposit}", "date_send": "${data.date_send}", "type": "${data.type}"}';
                                await createDeal(data.id);
                                await sendProductToMessage(data.sellerId, temp);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                backgroundColor: const Color(0XFFE35205),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text('แชท', style: TextStyle(fontSize: 18, color: Colors.white)),
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              )

        // FutureBuilder<ProductDetail>(
        //   future: ProductService().getProductById(widget.productId),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const Center(child: CircularProgressIndicator());
        //     } else if (snapshot.hasError) {
        //       return Center(
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             const Text('เกิดข้อผิดพลาดในการโหลดสินค้า'),
        //             Text(snapshot.error.toString(), style: const TextStyle(color: Colors.red)),
        //           ],
        //         ),
        //       );
        //     } else if (!snapshot.hasData) {
        //       return const Center(child: Text("ไม่พบสินค้า"));
        //     }

        //     final product = snapshot.data!;

        //     return
        //   },
        // ),
        );
  }

  Widget _buildDetailText(String title, String detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(detail),
        const SizedBox(height: 10),
      ],
    );
  }
}
