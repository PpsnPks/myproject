// import 'dart:convert';
// import 'package:http/http.dart' as http;

class Homeservice {
  Future<List<Product>> getHomeProducts() async {
    // try {
    //   final Uri apiUrl = Uri.parse('http://localhost:8000/products');

    //   // ส่งข้อมูล login (username, password) ผ่าน HTTP POST
    //   final response = await http.post(
    //     apiUrl,
    //     headers: {"Content-Type": "application/json"},
    //     body: jsonEncode({
    //       "status": null,
    //       "draw": 1,
    //       "columns": [],
    //       "order": [
    //         {"column": 0, "dir": "asc"}
    //       ],
    //       "start": 0,
    //       "length": 20,
    //       "search": {"value": "", "regex": false}
    //     }),
    //   );
    //   print(response.body);

    //   // ตรวจสอบสถานะการตอบกลับ
    //   if (response.statusCode == 200) {
    //     // หากสำเร็จ ให้แปลง JSON ที่ได้กลับมาเป็นข้อมูล
    //     // var data = jsonDecode(response.body);
    //     // ตัวอย่างการใช้งานข้อมูลจาก API (เช่น token)
    //     // String token = data['access_token'];
    //     // Navigator.pushNamed(context, '/role');
    //   } else {}
    // } catch (e) {

    // }

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
        imageUrl: 'assets/images/tuyen.png',
        title: 'ตู้เย็น',
        detail: 'ตู้เย็นมือสอง ใช้งานมา 1 ปี ใหม่มากๆ',
        types: 'เครื่องใช้ไฟฟ้า',
        price: '1500',
        category: 'เครื่องใช้ไฟฟ้า',
      ),
      Product(
        imageUrl: 'assets/images/sample_b1.jpg',
        title: 'หนังสือ ความลับคนอ่านเท่านั้นจะรู้',
        detail: 'หนังสือสภาพใหม่ ไม่มีตำหนิ',
        types: 'หนังสือ',
        price: '150',
        category: 'หนังสือ',
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
