import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myproject/auth_service.dart';
import 'package:myproject/environment.dart';

class PostService {
  Future<Post> getPostById(String id) async {
    try {
      String? accessToken = await AuthService().getAccessToken();
      String url = "${Environment.baseUrl}/posts/$id";

      if (accessToken == null) {
        throw Exception('กรุณาเข้าสู่ระบบก่อนทำรายการ');
      }

      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        "Accept": "application/json",
        'Content-Type': 'application/json',
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse != null) {
          return Post.fromJson(decodedResponse);
        } else {
          throw Exception('ไม่พบข้อมูลสินค้า');
        }
      } else {
        throw Exception('Error ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์: $e");
    }
  }
}

class Post {
  final String profilePic;
  final String name;
  final String faculty;
  final String detail;
  final String tag;
  final String postImage;
  final String category;
  final String price;
  final int userId;

  Post({
    required this.profilePic,
    required this.name,
    required this.faculty,
    required this.detail,
    required this.tag,
    required this.postImage,
    required this.category,
    required this.price,
    required this.userId,
  });

  factory Post.fromJson(Map<String, dynamic> data) {
    return Post(
      profilePic: "${Environment.imgUrl}/${data['user']['pic']}",
      name: data['user']?['name'] ?? 'ไม่ระบุ',
      faculty: data['user']?['faculty'] ?? 'ไม่ระบุ',
      detail: data['detail'] ?? '',
      tag: data['tag'] ?? '',
      postImage: '${Environment.imgUrl}/${data['image']}',
      category: data['category'] ?? '',
      price: data['price'] ?? '',
      userId: data['user']['id'] ?? '',
    );
  }

}
