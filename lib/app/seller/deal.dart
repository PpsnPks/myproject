import 'package:flutter/material.dart';
// import 'package:myproject/Service/deal_buyerservice.dart';
import 'package:myproject/Service/deal_sellerservice.dart';
import 'package:myproject/app/buyer/buyerfooter.dart';

class DealsellerPage extends StatefulWidget {
  const DealsellerPage({super.key});

  @override
  State<DealsellerPage> createState() => _DealPageState();
}

class _DealPageState extends State<DealsellerPage> with SingleTickerProviderStateMixin {
  late Future<List<Product>> dealProducts;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    dealProducts = DealSellerservice().getdealProducts();
    _tabController = TabController(length: 4, vsync: this); // จำนวนแท็บที่คุณต้องการ
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายการนัดรับสินค้า"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'รออนุมัติ'), 
            Tab(text: 'รอนัดรับ'), 
            Tab(text: 'ยืนยันการส่ง'),
            Tab(text: 'ส่งสินค้า'), 
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // แสดงข้อมูลในแท็บแรก
          buildProductList(),
          // แสดงข้อมูลในแท็บที่สอง 
          buildProductList(), 
          // แสดงข้อมูลในแท็บที่สาม 
          buildProductList(), 
          // แสดงข้อมูลในแท็บที่สี่ 
          buildProductList(), 
        ],
      ),
      bottomNavigationBar: buyerFooter(context, 'like'),
    );
  }

  Widget buildProductList() {
    return FutureBuilder<List<Product>>(
      future: dealProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('ไม่มีสินค้าที่ถูกใจ'));
        } else {
          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/confirm');
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 7.0,
                  ),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
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
                                      color: Colors.orange,
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
            },
          );
        }
      },
    );
  }
}
