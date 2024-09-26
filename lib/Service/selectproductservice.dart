class Product {
  final String name;
  final String price;
  final String description;
  final String category;
  final String size;
  final String deliveryLocation;
  final String deliveryDate;
  final String seller;
  final num stock;
  final List<String> imageUrl;

  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.size,
    required this.deliveryLocation,
    required this.deliveryDate,
    required this.seller,
    required this.stock, 
    required this.imageUrl,
  });
}

// สร้างข้อมูลสินค้า
class ProductService {
  static Product getProduct() {
    return Product(
      imageUrl: [
        'assets/images/fan1.png',
        'assets/images/fan2.png',
        'assets/images/fan3.jpg',
      ],
      name: 'พัดลม Xiaomi',
      price: '600 ฿',
      description:'Xiaomi Mi Smart Standing Fan 2 Lite พัดลมที่มาพร้อมดีไซน์อันเรียบหรู',
      category: 'เครื่องใช้ไฟฟ้า',
      size: '1000 มม. x 343 มม.',
      deliveryLocation: 'วิศวกรรมศาสตร์ ECC ',
      deliveryDate: '25 ธ.ค. 2567 10:00',
      seller: '64010724 รัชพล รุจิเวช ',
      stock: 3,
    );
  }
}
