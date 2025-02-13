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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['product_name'] ?? 'ไม่มีชื่อสินค้า',
      price: json['product_price'] ?? '',
      imageUrl: List<String>.from(json['product_images'] ?? []),
      description: json['product_description'] ?? '',
      category: json['product_category'] ?? '',
      condition: json['product_condition'] ?? '',
      durationUse: json['product_condition'] == "มือสอง" ? (json['product_years'] ?? '-') : '',
      defect: json['product_condition'] == "มือสอง" ? (json['product_defect'] ?? '-') : '',
      deliveryLocation: json['product_location'] ?? '',
      timeForSell: json['date_exp'] ?? '',
      sellerPic: json['seller']?['pic'] ?? '',
      sellerName: json['seller']?['name'] ?? 'ไม่ระบุ',
      sellerFaculty: json['seller']?['faculty'] ?? 'ไม่ระบุ',
      createdAt: json['created_at'] ?? '',
      stock: json['product_qty'] ?? 1,
    );
  }
}
