import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Service/addservice.dart';
import 'package:myproject/app/seller/sellerfooter.dart';

class CartSPage extends StatefulWidget {
  final int tab;
  const CartSPage({super.key, required this.tab});

  @override
  State<CartSPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartSPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Deal> cartProducts = [];
  // List<Seller> cartSeller = [];
  bool isLoading = true;

  List<Deal> pendingApproval = [];
  List<Deal> pendingCollection = [];

  loadall() async {
    Map<String, dynamic> response = await CartService().getCartSeller();
    print(response['success']);
    if (response['success'] == true) {
      List<Deal> data = response['data'];
      print("11111111111 ${data.length}");
      if (data.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      } else {
        cartProducts = data;
        setState(() {
          pendingApproval = filterByStep(cartProducts, 'waiting');
          pendingCollection = filterByStep(cartProducts, 'success');
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
    loadall();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.tab);
  }

  // Helper method to filter products by step
  List<Deal> filterByStep(List<Deal> deals, String step) {
    return deals.where((deals) => deals.deal_status == step).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text("รายการ"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0XFFE35205),
          tabs: const [
            Tab(text: 'รอดำเนินการ'),
            Tab(text: 'ดำเนินการสำเร็จ'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              // Container(
              //   height: 2.0,
              //   width: double.infinity,
              //   color: Colors.grey[300],
              // ),
              const SizedBox(
                height: 1.0,
              ),
              SingleChildScrollView(
                child: isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min, // ทำให้ column มีขนาดเท่ากับเนื้อหาภายใน
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
                              SizedBox(width: 10), // เพิ่มระยะห่างระหว่าง progress กับข้อความ
                              Text(
                                'กำลังโหลดสินค้า',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      )
                    : pendingApproval.isNotEmpty
                        ? Column(
                            children: [
                              for (int i = 0; i < pendingApproval.length; i += 1)
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SizedBox(height: 130, width: double.infinity, child: buildProductCard(pendingApproval[i], 1)),
                                )
                            ],
                          )
                        : const Center(child: Text('ไม่พบสินค้า')),
              ),
            ],
          ),
          Column(
            children: [
              // Container(
              //   height: 2.0,
              //   width: double.infinity,
              //   color: Colors.grey[300],
              // ),
              const SizedBox(
                height: 1.0,
              ),
              SingleChildScrollView(
                child: isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min, // ทำให้ column มีขนาดเท่ากับเนื้อหาภายใน
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
                              SizedBox(width: 10), // เพิ่มระยะห่างระหว่าง progress กับข้อความ
                              Text(
                                'กำลังโหลดสินค้า',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      )
                    : pendingCollection.isNotEmpty
                        ? Column(
                            children: [
                              for (int i = 0; i < pendingCollection.length; i += 1)
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SizedBox(height: 130, width: double.infinity, child: buildProductCard(pendingCollection[i], 2)),
                                )
                            ],
                          )
                        : const Center(child: Text('ไม่พบสินค้า')),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: sellerFooter(context, 'cart-seller'),
    );
  }

  // Helper method to build content for each step
  // Widget buildStepContent(List<Product> products, String emptyMessage) {
  //   if (products.isEmpty) {
  //     return Center(child: Text(emptyMessage));
  //   }

  //   return ListView.builder(
  //     itemCount: products.length,
  //     itemBuilder: (context, index) {
  //       final product = products[index];
  //       return buildProductCard(product);
  //     },
  //   );
  // }

  // Helper method to build individual product cards
  Widget buildProductCard(Deal deal, int tab) {
    return GestureDetector(
      onTap: () {
        if (tab == 1) {
          String temp =
              '{"deal_id" : "${deal.deal_id}", "product_images" : "${deal.product_images[0]}", "product_name" : "${deal.product_name}", "product_condition" : "${deal.product_condition}", "stock": "${deal.product_qty}", "timeForSell": "${deal.product_date_exp}", "price": "${deal.product_price}", "seller_name": "${deal.seller_name}", "seller_faculty": "${deal.seller_faculty}", "seller_pic": "${deal.seller_pic}", "buyer_user_id": "${deal.buyer_user_id}", "product_id": "${deal.product_id}"}';
          Navigator.pushReplacementNamed(context, '/confirm', arguments: {
            'data': temp,
          });
        }
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
                  imageUrl: deal.product_images.isNotEmpty
                      ? deal.product_images[0]
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
                    Text(
                      deal.product_name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, height: 1.6),
                      maxLines: 1,
                    ),
                    Text(
                      deal.product_price == '0' || deal.product_price == '0.00' ? 'ฟรี' : '${deal.product_price} ฿',
                      style: const TextStyle(color: Color(0XFFE35205), fontSize: 18, fontWeight: FontWeight.w500, height: 1.0),
                    ),
                    SizedBox(
                      // constraints: const BoxConstraints(minHeight: 57.0),
                      height: 44,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 17,
                            backgroundImage: NetworkImage(deal.buyer_pic),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                deal.buyer_name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                deal.buyer_faculty,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (tab == 1)
                const SizedBox(
                  width: 30,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFFA5A9B6),
                    size: 24,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
