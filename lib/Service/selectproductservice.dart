class Product {
  final String name;
  final String price;
  final String description;
  final String category;
  final String conditionProduct;
  final String durationUse;
  final String defect;
  final String timeForSell;
  // final String size;
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
    // required this.size,
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
        'assets/images/old_fan.png',
        'assets/images/fan2.png',
        'assets/images/fan3.jpg',
      ],
      name: 'พัดลม HATARI 16 นิ้ว',
      price: '359 ฿',
      description:
          'พัดลม HATARI ขนาด 16 นิ้ว พัดลมมือสองพร้อมใช้งาน สินค้าตามภาพครับ ทดสอบการใช้งานอย่างละเอียดแล้ว พัดแรงปกติครับ... ขนาด 16 นิ้ว สินค้ามือสองคุณภาพดี ยี่ห้อดี เช็คละเอียดทุกอุปกรณ์ หากสงสัยหรือ อยากขอรูปเพิ่มเติมทักแชทได้ครับ',
      category: 'เครื่องใช้ไฟฟ้า',
      conditionProduct: 'มือสอง',
      durationUse: '1-3 ปี',
      defect: 'ไม่มี',
      timeForSell: '10 ธันวาคม 2567',
      // size: '1000 มม. x 343 มม.',
      deliveryLocation: 'เกกีงาม 3',
      deliveryDate: '11 ธ.ค. 2567 10:00',
      seller: '64010724 รัชพล รุจิเวช ',
      stock: 1,
    );
  }
}
