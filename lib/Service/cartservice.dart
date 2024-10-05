class CartService {
  Future<List<Product>> getCartProducts() async {
    // Simulate a delay for fetching data
    await Future.delayed(const Duration(seconds: 1));

    // Simulated product data with steps
    return [
      Product(
        imageUrl: 'assets/images/fan_example.png',
        title: 'พัดลม',
        detail: 'พัดลม Xiaomi สภาพดี',
        types: 'เครื่องใช้ไฟฟ้า',
        price: '200',
        category: 'เครื่องใช้ไฟฟ้า',
        step: 'รออนุมัติ', // Pending Approval
      ),
      Product(
        imageUrl: 'assets/images/fan_example.png',
        title: 'หนังสือ',
        detail: 'หนังสือมือสอง สภาพดี',
        types: 'หนังสือ',
        price: '150',
        category: 'หนังสือ',
        step: 'รอนัดรับ', // Pending Collection
      ),
      Product(
        imageUrl: 'assets/images/fan_example.png',
        title: 'เก้าอี้',
        detail: 'เก้าอี้ไม้ แข็งแรงทนทาน',
        types: 'เฟอร์นิเจอร์',
        price: '500',
        category: 'เฟอร์นิเจอร์',
        step: 'รอนัดรับ', // Confirm Receipt
      ),
      Product(
        imageUrl: 'assets/images/fan_example.png',
        title: 'โต๊ะทำงาน',
        detail: 'โต๊ะทำงานปรับระดับได้',
        types: 'เฟอร์นิเจอร์',
        price: '1200',
        category: 'เฟอร์นิเจอร์',
        step: 'ได้รับสินค้า', // Received
      ),
    ];
  }
}

class Product {
  final String imageUrl;
  final String title;
  final String detail;
  final String price;
  final String category;
  final String types;
  final String step; // Add this to track the step status

  Product({
    required this.imageUrl,
    required this.title,
    required this.detail,
    required this.price,
    required this.category,
    required this.types,
    required this.step,
  });
}
