class LikeService {
  Future<List<Product>> getLikedProducts() async {
    // จำลองข้อมูล
    await Future.delayed(const Duration(seconds: 1)); // จำลองเวลาโหลดข้อมูล
    return [
      Product(
        imageUrl: 'assets/images/old_fan.png',
        title: 'พัดลม HATARI 16 นิ้ว',
        detail:
            'พัดลม HATARI ขนาด 16 นิ้ว พัดลมมือสองพร้อมใช้งาน สินค้าตามภาพครับ ทดสอบการใช้งานอย่างละเอียดแล้ว พัดแรงปกติครับ... ขนาด 16 นิ้ว สินค้ามือสองคุณภาพดี ยี่ห้อดี เช็คละเอียดทุกอุปกรณ์ หากสงสัยหรือ อยากขอรูปเพิ่มเติมทักแชทได้ครับ',
        types: 'เครื่องใช้ไฟฟ้า',
        price: '359',
        category: 'เครื่องใช้ไฟฟ้า',
      ),
      Product(
        imageUrl: 'assets/images/old_book.jpg',
        title: 'หนังสือเริ่มต้นธุรกิจส่วนตัว',
        detail: 'หนังสือมือสอง ไม่มีตำหนิ',
        types: 'หนังสือ',
        price: '120',
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
