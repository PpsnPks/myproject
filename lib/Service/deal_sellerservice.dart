
class DealSellerservice {
  Future<List<Product>> getdealProducts() async {
    // จำลองข้อมูล
    await Future.delayed(const Duration(seconds: 1)); // จำลองเวลาโหลดข้อมูล
    return [
      Product(
        imageUrl: 'assets/images/fan_example.png',
        title: 'พัดลม',
        detail: 'พัดลม Xiaomi สภาพดี',
        types: 'เครื่องใช้ไฟฟ้า',
        price: '200',
        category: 'เครื่องใช้ไฟฟ้า',
      ),
      Product(
        imageUrl: 'assets/images/fan_example.png',
        title: 'พัดลมเล็ก',
        detail: 'พัดลม Xiaoi สภาพดี',
        types: 'เครื่องใช้ไฟฟ้า',
        price: '150',
        category: 'เครื่องใช้ไฟฟ้า',
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

  Product({
    required this.imageUrl,
    required this.title,
    required this.detail,
    required this.price,
    required this.category,
    required this.types,
  });
}



