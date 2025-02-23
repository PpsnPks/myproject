import 'dart:convert';
import 'package:http/http.dart' as http;
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
        List<ProductLike> data = responseBody.map((likeJson) {
          // แปลงข้อมูลจาก likeJson ที่เป็น Product
          return ProductLike.fromJson(likeJson['product']);
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



  Future<bool> likeProduct(ProductLike product) async {
    final url = Uri.parse('${Environment.baseUrl}/likes');
    try {
      String userId = Securestorage().readSecureData('userId');

      Map<String, dynamic> body = {
        "userlike_id": userId,
        "product_id": product.id
      };
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

class ProductLike {
  final String id;
  final String productName;
  final List<String> productImages;
  final String productPrice;
  final String productDescription;
  final String productCategory;
  final String productType;
  final String sellerId;
  final String dateExp;
  final String productLocation;
  final String productCondition;
  final String productDefect;
  final String productYears;
  final List<String> tags;

  ProductLike({
    required this.id,
    required this.productName,
    required this.productImages,
    required this.productPrice,
    required this.productDescription,
    required this.productCategory,
    required this.productType,
    required this.sellerId,
    required this.dateExp,
    required this.productLocation,
    required this.productCondition,
    required this.productDefect,
    required this.productYears,
    required this.tags,
  });

  factory ProductLike.fromJson(Map<String, dynamic> data) {
  return ProductLike(
    id: data['id']?.toString() ?? "", // ใช้ "" หาก id เป็น null
    productName: data['product_name'] ?? "", // ใช้ "" หาก product_name เป็น null
    productImages: List<String>.from(data['product_images'] ?? []), // ใช้ [] หาก product_images เป็น null
    productPrice: data['product_price'] ?? "", // ใช้ "" หาก product_price เป็น null
    productDescription: data['product_description'] ?? "", // ใช้ "" หาก product_description เป็น null
    productCategory: data['product_category'] ?? "", // ใช้ "" หาก product_category เป็น null
    productType: data['product_type'] ?? "", // ใช้ "" หาก product_type เป็น null
    sellerId: data['seller_id'] ?? "", // ใช้ "" หาก seller_id เป็น null
    dateExp: data['date_exp'] ?? "", // ใช้ "" หาก date_exp เป็น null
    productLocation: data['product_location'] ?? "", // ใช้ "" หาก product_location เป็น null
    productCondition: data['product_condition'] ?? "", // ใช้ "" หาก product_condition เป็น null
    productDefect: data['product_defect'] ?? "", // ใช้ "" หาก product_defect เป็น null
    productYears: data['product_years'] ?? "", // ใช้ "" หาก product_years เป็น null
    tags: List<String>.from(data['tags'] ?? []), // ใช้ [] หาก tags เป็น null
  );
}

}
