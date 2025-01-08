class Postservice {
  Future<List<Post>> getCategoryProducts() async {
    // จำลองข้อมูล
    await Future.delayed(const Duration(seconds: 1)); // จำลองเวลาโหลดข้อมูล
    return [
      Post(
        profile:'',
        name: 'Product 1',
        id: '100.0',
        imageUrl: 'assets/images/fan_example.png',
        title: 'พัดลม',
        detail: 'พัดลม Xiaomi สภาพดี ใช้งานมาไม่นาน สภาพปกติไม่มีส่วนไหนชำรุด',
        tags: 'เครื่องใช้ไฟฟ้า',
      ),
      Post(
        profile:'',
        name: 'Product 1',
        id: '100.0',
        imageUrl: 'assets/images/tuyen.png',
        title: 'ตู้เย็น',
        detail: 'ตู้เย็นมือสอง ใช้งานมา 1 ปี',
        tags: 'เครื่องใช้ไฟฟ้า',
      ),
    ];
  }
}
class Post {
  final String profile;
  final String name;
  final String id;
  final String imageUrl;
  final String title;
  final String detail;
  final String tags;

  Post({
    required this.profile,
    required this.name,
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.detail,
    required this.tags,
  });
}