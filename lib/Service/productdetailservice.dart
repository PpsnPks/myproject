import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myproject/app/main/secureStorage.dart';
import 'package:myproject/auth_service.dart';
import 'package:myproject/environment.dart';

class ProductService {
  Future<ProductDetail> getProductById(String id) async {
    try {
      String? accessToken = await AuthService().getAccessToken();
      String userId = await Securestorage().readSecureData('userId');
      String url = "${Environment.baseUrl}/products/$id/$userId";

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
          return ProductDetail.fromJson(decodedResponse);
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

  Future<void> likeProduct(int id) async {
    try {
      int userId = int.parse(await Securestorage().readSecureData('userId'));
      String? accessToken = await AuthService().getAccessToken();
      String url = "${Environment.baseUrl}/likes";
      print('aaa $userId kub');

      if (accessToken == null) {
        throw Exception('กรุณาเข้าสู่ระบบก่อนทำรายการ');
      }

      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        "Accept": "application/json",
        'Content-Type': 'application/json',
      };

      Map<String, dynamic> body = {"userlike_id": userId, "product_id": id};
      String jsonBody = json.encode(body);

      final response = await http.post(Uri.parse(url), headers: headers, body: jsonBody);

      if (response.statusCode == 201) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse != null) {
          print(decodedResponse);
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

  Future<void> unlikeProduct(String id) async {
    try {
      String? accessToken = await AuthService().getAccessToken();
      String userId = await Securestorage().readSecureData('userId');
      String url = "${Environment.baseUrl}/likes/$userId/$id";

      if (accessToken == null) {
        throw Exception('กรุณาเข้าสู่ระบบก่อนทำรายการ');
      }

      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        "Accept": "application/json",
        'Content-Type': 'application/json',
      };

      final response = await http.delete(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse != null) {
          print(decodedResponse);
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

class ProductDetail {
  final String id;
  final String name;
  final String price;
  final List<String> imageUrl;
  final String description;
  final String category;
  final String condition;
  final String durationUse;
  final String defect;
  final String deliveryLocation;
  final String timeForSell;
  final String sellerPic;
  final String sellerName;
  final String sellerFaculty;
  final String sellerId;
  final String createdAt;
  final int stock;
  final bool isLiked;

  ProductDetail({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.category,
    required this.condition,
    required this.durationUse,
    required this.defect,
    required this.deliveryLocation,
    required this.timeForSell,
    required this.sellerPic,
    required this.sellerName,
    required this.sellerFaculty,
    required this.sellerId,
    required this.createdAt,
    required this.stock,
    required this.isLiked,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> data) {
    return ProductDetail(
      id: data['product']['id']?.toString() ?? '',
      name: data['product']['product_name'] ?? 'ไม่มีชื่อสินค้า',
      price: data['product']['product_price'] ?? '',
      imageUrl: (data['product']['product_images'] as List).map((image) => '${Environment.imgUrl}/$image').toList(),
      description: data['product']['product_description'] ?? '',
      category: data['product']['product_category'] ?? '',
      condition: data['product']['product_condition'] ?? '',
      durationUse: data['product']['product_condition'] == "มือสอง" ? (data['product']['product_years'] ?? '-') : '',
      defect: data['product']['product_condition'] == "มือสอง" ? (data['product']['product_defect'] ?? '-') : '',
      deliveryLocation: data['product']['product_location'] ?? '',
      timeForSell: data['product']['date_exp'] ?? '',
      sellerPic: "${Environment.imgUrl}/${data['product']['seller']['pic']}",
      sellerName: data['product']['seller']?['name'] ?? 'ไม่ระบุ',
      sellerFaculty: data['product']['seller']?['faculty'] ?? 'ไม่ระบุ',
      sellerId: data['product']['seller']!['user_id'].toString(),
      createdAt: data['product']['created_at'] ?? '',
      stock: data['product']['product_qty'] ?? 1,
      isLiked: data['is_liked'],
    );
  }
}
