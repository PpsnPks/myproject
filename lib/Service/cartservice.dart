class CartService {
  Future<List<Product>> getCartProducts() async {
    // Simulate a delay for fetching data
    await Future.delayed(const Duration(seconds: 1));

    // Simulated product data with steps
    return [
      Product(
        imageUrl: 'assets/images/old_fan.png',
        title: 'พัดลม HATARI 16 นิ้ว',
        detail:
            'พัดลม Xiaomi Mi Smart Standing Fan 2 Lite เป็นพัดลมที่ผสมผสานดีไซน์อันเรียบหรูเข้ากับฟังก์ชันการใช้งานที่ครบครัน เหมาะสำหรับทั้งบ้านและสำนักงาน ด้วยคุณสมบัติที่โดดเด่น',
        types: 'เครื่องใช้ไฟฟ้า',
        price: '200',
        category: 'เครื่องใช้ไฟฟ้า',
        step: 'รอดำเนินการ', // Pending Approval
      ),
      Product(
        imageUrl: 'assets/images/old_fan.png',
        title: 'หนังสือ',
        detail: 'หนังสือมือสอง สภาพดี',
        types: 'หนังสือ',
        price: '150',
        category: 'หนังสือ',
        step: 'รอดำเนินการ', // Pending Collection
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
