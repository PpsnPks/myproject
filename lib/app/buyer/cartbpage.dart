import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Service/addservice.dart';
// import 'package:myproject/Service/cartservice.dart';
import 'package:myproject/app/buyer/buyerfooter.dart';

class CartBPage extends StatefulWidget {
  const CartBPage({super.key});

  @override
  State<CartBPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartBPage> with SingleTickerProviderStateMixin {
  late Future<List<Product>> cartProductsAAA;
  // late TabController _tabController;
  List<Product> cartProducts = [];
  List<Seller> cartSeller = [];
  bool isLoading = true;

  loadall() async {
    Map<String, dynamic> response = await CartService().getCartBuyer();
    print(response['success']);
    if (response['success'] == true) {
      List<Product> data = response['data'];
      List<Seller> dataS = response['dataS'];
      print("11111111111 ${data.length}");
      if (data.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      } else {
        setState(() {
          cartProducts = data;
          cartSeller = dataS;
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
    // _tabController = TabController(length: 2, vsync: this);
  }

  // Helper method to filter products by step
  // List<Product> filterByStep(List<Product> products, String step) {
  //   return products.where((product) => product.step == step).toList();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text("รายการ"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0), // กำหนดความสูงของเส้น
          child: Container(
            height: 2.0,
            width: double.infinity,
            color: Colors.grey[300],
          ),
        ),
        // bottom: TabBar(
        //   controller: _tabController,
        //   labelColor: Colors.black,
        //   unselectedLabelColor: Colors.grey,
        //   indicatorColor: const Color(0XFFE35205),
        //   tabs: const [
        //     Tab(text: ''),
        //     Tab(text: ''),
        //   ],
        // ),
      ),
      body: Column(
        children: [
          // Container(
          //   height: 2.0,
          //   width: double.infinity,
          //   color: Colors.grey[300],
          // ),
          const SizedBox(
            height: 1.0,
          ),
          isLoading
              ? const Expanded(
                  child: Center(
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
                  ),
                )
              : cartProducts.isEmpty
                  ? const Expanded(child: Center(child: Text('ไม่พบสินค้า')))
                  : SingleChildScrollView(
                      child: Column(
                      children: [
                        for (int i = 0; i < cartProducts.length; i += 1)
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SizedBox(height: 130, width: double.infinity, child: buildProductCard(cartProducts[i], cartSeller[i])),
                          )
                      ],
                    )),
        ],
      ),
      bottomNavigationBar: buyerFooter(context, 'cart-buyer'),
    );
  }

  // Helper method to build individual product cards
  Widget buildProductCard(Product product, Seller seller) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/productdetail');
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
                  imageUrl: product.product_images.isNotEmpty
                      ? product.product_images[0]
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
                              fit: BoxFit.cover, // ปรับขนาดภาพให้เต็ม
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
                      product.product_name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, height: 1.6),
                      maxLines: 1,
                    ),
                    Text(
                      product.product_price == '0' || product.product_price == '0.00' ? 'ฟรี' : '${product.product_price} ฿',
                      style: const TextStyle(color: Color(0XFFE35205), fontSize: 18, fontWeight: FontWeight.w500, height: 1.0),
                    ),
                    SizedBox(
                      // constraints: const BoxConstraints(minHeight: 57.0),
                      height: 44,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 17,
                            backgroundImage: NetworkImage(seller.pic),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                seller.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                seller.faculty,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
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
              // const SizedBox(
              //   width: 30,
              //   child: Icon(
              //     Icons.arrow_forward_ios_rounded,
              //     color: Color(0xFFA5A9B6),
              //     size: 24,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build content for each step
  // Widget buildStepContent(List<Product> products, String emptyMessage) {
  //   if (products.isEmpty) {
  //     return Center(child: Text(emptyMessage));
  //   }

  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       const SizedBox(height: 7.0),
  //       Expanded(
  //         child: ListView.builder(
  //           itemCount: products.length,
  //           itemBuilder: (context, index) {
  //             final product = products[index];
  //             return buildProductCard(product);
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
