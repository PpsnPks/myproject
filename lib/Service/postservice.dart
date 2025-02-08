import 'dart:convert'; // เพิ่มการนำเข้า dart:convert
import 'package:myproject/app/main/secureStorage.dart';
import 'package:myproject/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:myproject/environment.dart';

class PostService {
  // URL ของ API
  final String postUrl = "${Environment.baseUrl}/posts";

  // ฟังก์ชันสำหรับ post
  Future<Map<String, dynamic>> addPost(String image, String detail, String category, String tag, String price) async {
    try {
      // ดึง accessToken จาก AuthService
      AuthService authService = AuthService();
      String? accessToken = await authService.getAccessToken();
      String userId = await Securestorage().readSecureData('userId');

      // Header
      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

      // Body (แปลงข้อมูลให้เป็น JSON string)
      Map<String, String> body = {
        "image": image,
        "detail": detail,
        "category": category,
        "tag": tag,
        "price": price,
        "userpost_id": userId,
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
      if (response.statusCode == 201) {
        return {
          "success": true,
          "data": response.body,
        };
      } else {
        return {
          "success": false,
          "message": 'error ${response.statusCode} ${response.body}',
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้นะจ๊ะ",
      };
    }
  }

  Future<Map<String, dynamic>> getPost(int page, int length) async {
    const url = "${Environment.baseUrl}/getposts";
    try {
      // ดึง accessToken จาก AuthService
      AuthService authService = AuthService();
      String? accessToken = await authService.getAccessToken();
      // Header
      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        "Accept": "application/json",
        'Content-Type': 'application/json',
      };

      // Body (แปลงข้อมูลให้เป็น JSON string)
      Map<String, dynamic> body = {
        "draw": 1,
        "columns": [],
        "order": [
          {"column": 0, "dir": "desc"}
        ],
        "start": (page - 1) * length,
        "length": length,
        "search": {"value": "", "regex": false},
        "tag": "",
        "category": "",
        "status": "ok"
      };

      // แปลง Map เป็น JSON string ก่อนส่ง
      String jsonBody = json.encode(body);
      // Get Request
      final response = await http.post(Uri.parse(url), headers: headers, body: jsonBody);

      // ตรวจสอบสถานะของ Response
      if (response.statusCode == 200) {
        print('888888 ${response.statusCode} $accessToken');
        List<Post> data = (jsonDecode(response.body)['data']['data'] as List).map((postJson) => Post.fromJson(postJson)).toList();
        print('888888 $data');
        return {
          "success": true,
          "data": data //data,
        };
      } else {
        print('888888 ${response.statusCode}');
        return {
          "success": false,
          "message": 'error ${response.statusCode} ${response.body}',
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้นะจ๊ะ $e",
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
        profile: '',
        name: 'ภูมิ ไพรศรี',
        faculty: 'วิศวะกรรมศาสตร์',
        id: '100.0',
        imageUrl: 'assets/images/fan_example.png',
        // title: 'ตามหาพัดลม',
        detail: 'พัดลม Xiaomi สภาพดี ใช้งานมาไม่นาน สภาพปกติไม่มีส่วนไหนชำรุด',
        tags: 'เครื่องใช้ไฟฟ้า',
      ),
      Post(
        profile: '',
        name: 'รัชพล รุจิเวช',
        faculty: 'วิศวะกรรมศาสตร์',
        id: '100.0',
        imageUrl: 'assets/images/tuyen.png',
        // title: 'ต้องการ ตู้เย็น',
        detail: 'ตู้เย็นมือสอง ใช้งานมา 1 ปี',
        tags: 'เครื่องใช้ไฟฟ้า',
      ),
      Post(
        profile: '',
        name: 'สมหวัง ใจดี',
        faculty: 'วิศวะกรรมศาสตร์',
        id: '100.0',
        imageUrl: 'assets/images/tuyen.png',
        // title: 'ตู้เย็น',
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
  // final String title;
  final String detail;
  final String tags;

  Post({
    required this.profile,
    required this.name,
    required this.faculty,
    required this.id,
    required this.imageUrl,
    // required this.title,
    required this.detail,
    required this.tags,
  });

  factory Post.fromJson(Map<String, dynamic> data) {
    print('aaa ${data['image']}');
    return Post(
      profile: "${Environment.imgUrl}/${data['user']['pic']}", // ไม่มีข้อมูลใน JSON, คุณสามารถใส่ข้อมูล default หรือ null
      name: data['user']['name'], // ไม่มีข้อมูลใน JSON, คุณสามารถใส่ข้อมูล default หรือ null
      faculty: data['user']['faculty'], // ไม่มีข้อมูลใน JSON, คุณสามารถใส่ข้อมูล default หรือ null
      id: data['id'].toString(),
      imageUrl: '${Environment.imgUrl}/${data['image']}',
      // title: data['category'], // หรือเปลี่ยนให้ตรงกับ field ที่คุณต้องการ
      detail: data['detail'],
      tags: data['tag'],
    );
  }
}
