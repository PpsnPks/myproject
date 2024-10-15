import 'package:flutter/material.dart';
import 'package:myproject/Service/cartservice.dart';
import 'package:myproject/app/buyer/buyerfooter.dart';

class CartBPage extends StatefulWidget {
  const CartBPage({super.key});

  @override
  State<CartBPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartBPage> with SingleTickerProviderStateMixin {
  late Future<List<Product>> cartProducts;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    cartProducts = CartService().getCartProducts();
    _tabController = TabController(length: 4, vsync: this);
  }

  // Helper method to filter products by step
  List<Product> filterByStep(List<Product> products, String step) {
    return products.where((product) => product.step == step).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Tab(text: 'รออนุมัติ'),
            Tab(text: 'รอนัดรับ'),
            Tab(text: 'ยืนยัน'),
            Tab(text: 'ได้รับสินค้า'),
          ],
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: cartProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('ไม่มีสินค้าที่อยู่ในรถเข็น'));
          } else {
            final products = snapshot.data!;

            // Filter products by steps
            final pendingApproval = filterByStep(products, 'รออนุมัติ');
            final pendingCollection = filterByStep(products, 'รอนัดรับ');
            final confirmReceipt = filterByStep(products, 'ยืนยัน');
            final received = filterByStep(products, 'ได้รับสินค้า');

            return TabBarView(
              controller: _tabController,
              children: [
                buildStepContent(pendingApproval, 'ไม่มีสินค้ารออนุมัติ'),
                buildStepContent(pendingCollection, 'ไม่มีสินค้ารอนัดรับ'),
                buildStepContent(confirmReceipt, 'ไม่มีสินค้ายืนยันการรับ'),
                buildStepContent(received, 'ไม่มีสินค้าที่ได้รับ'),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: buyerFooter(context, 'cart-buyer'),
    );
  }

  // Helper method to build content for each step
  Widget buildStepContent(List<Product> products, String emptyMessage) {
    if (products.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return buildProductCard(product);
      },
    );
  }

  // Helper method to build individual product cards
  Widget buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/confirm', arguments: product);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0),
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          border: Border.all(color: Colors.grey.shade300, width: 2), // Gray border
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  product.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.detail,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            product.category,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          '${product.price} ฿',
                          style: const TextStyle(
                            color: const Color(0XFFE35205),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }

}