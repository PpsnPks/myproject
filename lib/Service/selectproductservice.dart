class Product {
  final String name;
  final String price;
  final String description;
  final String category;
  final String conditionProduct;
  final String durationUse;
  final String defect;
  final String timeForSell;
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
    required this.conditionProduct,
    required this.durationUse,
    required this.defect,
    required this.timeForSell,
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
      description:
          'พัดลม Xiaomi Mi Smart Standing Fan 2 Lite เป็นพัดลมที่ผสมผสานดีไซน์อันเรียบหรูเข้ากับฟังก์ชันการใช้งานที่ครบครัน เหมาะสำหรับทั้งบ้านและสำนักงาน ด้วยคุณสมบัติที่โดดเด่น',
      category: 'เครื่องใช้ไฟฟ้า',
      conditionProduct: 'มือสอง',
      durationUse: '1-3 ปี',
      defect: 'มีฝุ่นเกาะเยอะ',
      timeForSell: '25 ธันวาคม 2567',
      size: '1000 มม. x 343 มม.',
      deliveryLocation: 'วิศวกรรมศาสตร์ ECC ',
      deliveryDate: '25 ธ.ค. 2567 10:00',
      seller: '64010724 รัชพล รุจิเวช ',
      stock: 3,
    );
  }
}
