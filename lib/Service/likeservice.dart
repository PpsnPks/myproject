import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:myproject/app/main/secureStorage.dart';
import 'package:myproject/auth_service.dart';
import 'package:myproject/environment.dart';

class LikeService {
  Future<Map<String, dynamic>> getLikedProducts() async {
    try {
      String? accessToken = await AuthService().getAccessToken();
      String userId = await Securestorage().readSecureData('userId');
      String url = "${Environment.baseUrl}/userslikes/$userId";

      if (accessToken == null) {
        return {
          "success": false,
          "message": "กรุณาเข้าสู่ระบบก่อนทำรายการ",
        };
      }

      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        "Accept": "application/json",
        'Content-Type': 'application/json',
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);

        if (responseBody == null) {
          return {"success": false, "message": "No liked products found."};
        }

        if (responseBody is List) {
          List<Product> data = responseBody.map((likeJson) {
            // แปลงข้อมูลจาก likeJson ที่เป็น Product
            return Product.fromJson(likeJson['product']);
          }).toList();

          return {"success": true, "data": data};
        } else {
          return {"success": false, "message": "Invalid response format"};
        }
      } else {
        return {
          "success": false,
          "message": 'Error ${response.statusCode} ${response.body}',
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์: $e",
      };
    }
  }

  Future<bool> likeProduct(Product product) async {
    final url = Uri.parse('${Environment.baseUrl}/likes');
    try {
      String userId = Securestorage().readSecureData('userId');

      Map<String, dynamic> body = {"userlike_id": userId, "product_id": product.id};
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to like product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error liking product: $e');
    }
  }

  Future<bool> unlikeProduct(String productId) async {
    final url = Uri.parse('${Environment.baseUrl}/likes/$productId');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to unlike product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error unliking product: $e');
    }
  }
}

class Product {
  final String id;
  final String product_name;
  final List<dynamic> product_images;
  final String product_qty;
  final String product_price;
  final String product_description;
  final String product_category;
  final String product_type;
  final String seller_id;
  final String date_exp;
  final String product_location;
  final String product_condition;
  final String product_defect;
  final String product_years;
  final String tag;

  Product({
    required this.id,
    required this.product_name,
    required this.product_images,
    required this.product_qty,
    required this.product_price,
    required this.product_description,
    required this.product_category,
    required this.product_type,
    required this.seller_id,
    required this.date_exp,
    required this.product_location,
    required this.product_condition,
    required this.product_defect,
    required this.product_years,
    required this.tag,
  });

  @override
  String toString() {
    return 'Product('
        'id: $id, '
        'product_name: $product_name, '
        'product_images: $product_images, ' //${product_images.join(", ")}
        'product_qty: $product_qty, '
        'product_price: $product_price, '
        'product_description: $product_description, '
        'product_category: $product_category, '
        'product_type: $product_type, '
        'seller_id: $seller_id, '
        'date_exp: $date_exp, '
        'product_location: $product_location, '
        'product_condition: $product_condition, '
        'product_defect: $product_defect, '
        'product_years: $product_years, '
        'tags: $tag'
        ')';
  }

  factory Product.fromJson(Map<String, dynamic> data) {
    print('qqq2 $data');
    return Product(
      id: data['id']?.toString() ?? "",
      product_name: data['product_name'] ?? "",
      product_images: (data['product_images'] as List).map((image) => '${Environment.imgUrl}/$image').toList(),
      product_qty: data['product_qty'].toString(),
      product_price: NumberFormat("#,###").format(double.parse(data['product_price'])),
      product_description: data['product_description'] ?? "",
      product_category: data['product_category'] ?? "",
      product_type: data['product_type'] ?? "",
      seller_id: data['seller_id'].toString(),
      date_exp: data['date_exp'] ?? "",
      product_location: data['product_location'] ?? "",
      product_condition: data['product_condition'] ?? "",
      product_defect: data['product_defect'] ?? "",
      product_years: data['product_years'] ?? "",
      tag: data['tag'] ?? "",
    );
  }
}
