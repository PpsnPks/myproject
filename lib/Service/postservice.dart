import 'dart:convert'; // เพิ่มการนำเข้า dart:convert
import 'package:myproject/auth_service.dart'; 
import 'package:http/http.dart' as http;
import 'package:myproject/environment.dart'; 

class PostService {
  // URL ของ API
  final String postUrl = "${Environment.baseUrl}/posts";
  
  // ฟังก์ชันสำหรับ post
  Future<Map<String, dynamic>> addpost(String image, String detail, String category, String tag, String price, String userpost_id) async {
    try {
      // ดึง accessToken จาก AuthService
      AuthService authService = AuthService();
      String? accessToken = await authService.getAccessToken();

      if (accessToken == null) {
        return {
          "success": false,
          "message": "ไม่พบ access token",
        };
      }

      // Header
      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

      // Body (แปลงข้อมูลให้เป็น JSON string)
      Map<String, String> body = {
        "image": "image1.png",
        "detail": detail,
        "category": category,
        "tag": tag,
        "price": price,
        "userpost_id": userpost_id,
      };

      // แปลง Map เป็น JSON string ก่อนส่ง
      String jsonBody = json.encode(body);

      // POST Request
      final response = await http.post(
        Uri.parse(postUrl),
        headers: headers,
        body: jsonBody, // ส่งข้อมูลในรูปแบบ JSON
      );

      // ตรวจสอบสถานะของ Response
      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": response.body,
        };
      } else {
        return {
          "success": false,
          "message": response.body ?? "เกิดข้อผิดพลาดในการเข้าสู่ระบบ",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้นะจ๊ะ",
      };
    }
  }
}



class Postservice {
  Future<List<Post>> getCategoryProducts() async {
    // จำลองข้อมูล
    await Future.delayed(const Duration(seconds: 1)); // จำลองเวลาโหลดข้อมูล
    return [
      Post(
        profile:'',
        name: 'ภูมิ ไพรศรี',
        faculty: 'วิศวะกรรมศาสตร์',
        id: '100.0',
        imageUrl: 'assets/images/fan_example.png',
        title: 'ตามหาพัดลม',
        detail: 'พัดลม Xiaomi สภาพดี ใช้งานมาไม่นาน สภาพปกติไม่มีส่วนไหนชำรุด',
        tags: 'เครื่องใช้ไฟฟ้า',
      ),
      Post(
        profile:'',
        name: 'รัชพล รุจิเวช',
        faculty: 'วิศวะกรรมศาสตร์',
        id: '100.0',
        imageUrl: 'assets/images/tuyen.png',
        title: 'ต้องการ ตู้เย็น',
        detail: 'ตู้เย็นมือสอง ใช้งานมา 1 ปี',
        tags: 'เครื่องใช้ไฟฟ้า',
      ),
      Post(
        profile:'',
        name: 'สมหวัง ใจดี',
        faculty: 'วิศวะกรรมศาสตร์',
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
  final String faculty;
  final String id;
  final String imageUrl;
  final String title;
  final String detail;
  final String tags;

  Post({
    required this.profile,
    required this.name,
    required this.faculty,
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.detail,
    required this.tags,
  });
}