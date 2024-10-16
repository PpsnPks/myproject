class Homeservice {
  Future<List<Product>> getHomeProducts() async {
    // จำลองข้อมูล
    await Future.delayed(const Duration(seconds: 1)); // จำลองเวลาโหลดข้อมูล
    return [
      Product(
        imageUrl: 'assets/images/fan_example.png',
        title: 'พัดลม',
        detail: 'พัดลม Xiaomi สภาพดี ใช้งานมาไม่นาน สภาพปกติไม่มีส่วนไหนชำรุด',
        types: 'เครื่องใช้ไฟฟ้า',
        price: '200',
        category: 'เครื่องใช้ไฟฟ้า',
      ),
      Product(
        imageUrl: 'assets/images/tuyen.png',
        title: 'ตู้เย็น',
        detail: 'ตู้เย็นมือสอง ใช้งานมา 1 ปี',
        types: 'เครื่องใช้ไฟฟ้า',
        price: '150',
        category: 'เครื่องใช้ไฟฟ้า',
      ),
      Product(
        imageUrl: 'assets/images/sample_b1.jpg',
        title: 'หนังสือ',
        detail: 'หนังสือสภาพใหม่ ไม่มีตำหนิ',
        types: 'หนังสือ',
        price: '150',
        category: 'หนังสือ',
      ),
      Product(
        imageUrl: 'assets/images/sample_b1.jpg',
        title: 'หนังสือ',
        detail: 'หนังสือมือสอง',
        types: 'เครื่องใช้ไฟฟ้า',
        price: '150',
        category: 'หนังสือ',
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
