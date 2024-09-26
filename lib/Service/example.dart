import 'dart:convert';  // สำหรับการแปลง JSON
import 'package:http/http.dart' as http;
class LikeService {
  Future<List<Product>> getLikedProducts() async {
    // URL ของ API ที่จะเรียก
    // ignore: prefer_const_declarations
    final url = 'https://your-api-url.com/liked-products'; // เปลี่ยนเป็น URL ที่แท้จริง

    // ทำการเรียก API
    final response = await http.get(Uri.parse(url));

    // ตรวจสอบสถานะของการตอบกลับ
    if (response.statusCode == 200) {
      // แปลงข้อมูล JSON เป็น List
      final List<dynamic> data = json.decode(response.body);
      return data.map((productData) => Product(
        imageUrl: productData['imageUrl'],
        title: productData['title'],
        detail: productData['detail'],
        price: productData['price'],
        category: productData['category'],
      )).toList();
    } else {
      throw Exception('Failed to load liked products');
    }
  }
}

class Product {
  final String imageUrl;
  final String title;
  final String detail;
  final String price;
  final String category;

  Product({
    required this.imageUrl,
    required this.title,
    required this.detail,
    required this.price,
    required this.category,
  });
}
