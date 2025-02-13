import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myproject/auth_service.dart';
import 'package:myproject/environment.dart';

class ProductService {
  Future<Product> getProductById(String id) async {
    try {
      String? accessToken = await AuthService().getAccessToken();
      String url = "${Environment.baseUrl}/products/$id";

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
          return Product.fromJson(decodedResponse);
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

class Product {
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
  final String createdAt;
  final int stock;

  Product({
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
    required this.createdAt,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> data) {
    return Product(
      id: data['id']?.toString() ?? '',
      name: data['product_name'] ?? 'ไม่มีชื่อสินค้า',
      price: data['product_price'] ?? '',
      imageUrl: (data['product_images'] as List).map((image) => '${Environment.imgUrl}/$image').toList(),
      description: data['product_description'] ?? '',
      category: data['product_category'] ?? '',
      condition: data['product_condition'] ?? '',
      durationUse: data['product_condition'] == "มือสอง" ? (data['product_years'] ?? '-') : '',
      defect: data['product_condition'] == "มือสอง" ? (data['product_defect'] ?? '-') : '',
      deliveryLocation: data['product_location'] ?? '',
      timeForSell: data['date_exp'] ?? '',
      sellerPic: "${Environment.imgUrl}/${data['seller']['pic']}",
      sellerName: data['seller']?['name'] ?? 'ไม่ระบุ',
      sellerFaculty: data['seller']?['faculty'] ?? 'ไม่ระบุ',
      createdAt: data['created_at'] ?? '',
      stock: data['product_qty'] ?? 1,
    );
  }
}
