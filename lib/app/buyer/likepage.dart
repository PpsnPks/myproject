import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myproject/app/buyer/buyerfooter.dart';
import 'package:myproject/service/likeservice.dart';

class LikePage extends StatefulWidget {
  const LikePage({super.key});

  @override
  State<LikePage> createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  late Future<String> userIdFuture;
  List<ProductLike> like = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchLikedProducts();
  }

  void fetchLikedProducts() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> response = await LikeService().getLikedProducts();
    print(response);  // ตรวจสอบ response ที่ได้รับ
    if (response['success'] && response['data'] is List) {
      setState(() {
        like = List<ProductLike>.from(
            response['data'].map((item) => ProductLike.fromJson(item)));
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ถูกใจ"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: SizedBox(
                      width: 10.0,
                      height: 10.0,
                      child: CircularProgressIndicator(
                        color: Color(0XFFE35205),
                        strokeWidth: 2.0,
                      ),
                    )),
                    SizedBox(width: 10),
                    Text(
                      'กำลังโหลดสินค้า',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: like.length,
              itemBuilder: (context, index) {
                final product = like[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/productdetail');
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 7.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: product.product_images.isNotEmpty
                                    ? product.product_images[0]
                                    : 'https://t3.ftcdn.net/jpg/05/04/28/96/360_F_504289605_zehJiK0tCuZLP2MdfFBpcJdOVxKLnXg1.jpg',
                                placeholder: (context, url) =>
                                    LayoutBuilder(
                                  builder: (context, constraints) {
                                    double size = constraints.maxHeight;
                                    return SizedBox(
                                      width: size,
                                      height: size,
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
                                      double size = constraints.maxHeight;
                                      return Container(
                                        width: size,
                                        height: size,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: ImageProvider,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                errorWidget: (context, url, error) =>
                                    LayoutBuilder(
                                  builder: (context, constraints) {
                                    double size = constraints.maxHeight;
                                    return Container(
                                      width: size,
                                      height: size,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/notfound.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.product_name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${product.product_price} ฿',
                                    style: const TextStyle(
                                        color: Color(0XFFE35205),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    product.product_description,
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 13),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.favorite, color: Colors.orange),
                            onPressed: () async {
                              await LikeService().unlikeProduct(product.id);
                              fetchLikedProducts();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: buyerFooter(context, 'like'),
    );
  }
}

