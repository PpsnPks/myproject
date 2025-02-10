import 'dart:convert'; // เพิ่มการนำเข้า dart:convert
import 'package:myproject/app/main/secureStorage.dart';
import 'package:myproject/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:myproject/environment.dart';

class AddService {
  // URL ของ API
  final String postUrl = "${Environment.baseUrl}/products";

  // ฟังก์ชันสำหรับ post
  Future<Map<String, dynamic>> addProduct(
      String productName,
      List productImages,
      int productQty,
      String productPrice,
      String productDescription,
      String productCategory,
      String productType,
      String dateExp,
      String productLocation,
      String productCondition,
      String productDefect,
      String productYears,
      String tag) async {
    try {
      // ดึง accessToken จาก AuthService
      AuthService authService = AuthService();
      String? accessToken = await authService.getAccessToken();
      String userId = await Securestorage().readSecureData('userId') ?? '99999';
      String? productConditionValue = productType == 'preorder' ? 'มือหนึ่ง' : productCondition;
      // print(productName);
      // print(productConditionValue);
      print(
          'productName = $productName \n productImages = $productImages \n productQty = $productQty \n productPrice = $productPrice \n productDescription = $productDescription \n productCategory = $productCategory \n productType = $productType \n dateExp = $dateExp \n productLocation = $productLocation \n productCondition = $productCondition \n productDefect = $productDefect \n productYears = $productYears \n tag = $tag');
      if (accessToken == null) {
        return {
          "success": false,
          "message": "กรุณาเข้าสู่ระบบก่อนทำรายการ",
        };
      }

      // Header
      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

      // Body (แปลงข้อมูลให้เป็น JSON string)
      Map<String, dynamic> body = {
        "product_name": productName.isEmpty ? "N/A" : productName,
        "product_images": productImages,
        "product_qty": productQty,
        "product_price": int.parse(productPrice),
        "product_description": productDescription,
        "product_category": productCategory,
        "product_type": productType,
        "seller_id": int.tryParse(userId) ?? 0,
        "date_exp": dateExp,
        "product_location": productLocation,
        "product_condition": productConditionValue,
        "product_defect": productDefect,
        "product_years": productYears,
        "tag": tag,
      };

      // แปลง Map เป็น JSON string ก่อนส่ง
      String jsonBody = json.encode(body);
      // POST Request
      final response = await http.post(
        Uri.parse(postUrl),
        headers: headers,
        body: jsonBody,
      );

      // ตรวจสอบสถานะของ Response
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "data": response.body,
        };
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

  Future<Map<String, dynamic>> getProduct(int page, int length) async {
    const url = "${Environment.baseUrl}/getproducts";
    try {
      // ดึง accessToken จาก AuthService
      AuthService authService = AuthService();
      String? accessToken = await authService.getAccessToken();

      if (accessToken == null) {
        return {
          "success": false,
          "message": "กรุณาเข้าสู่ระบบก่อนทำรายการ",
        };
      }

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
        "product_type": "",
        "product_category": "",
        "product_condition": "",
        "price_order": "desc",
        "status": ""
      };

      // แปลง Map เป็น JSON string ก่อนส่ง
      String jsonBody = json.encode(body);
      // Get Request
      final response = await http.post(Uri.parse(url), headers: headers, body: jsonBody);
      print('qqq ${response.statusCode} \n ${response.body}');

      // ตรวจสอบสถานะของ Response
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        print('qqq $decodedResponse');
        if (decodedResponse != null && decodedResponse['data'] != null) {
          List<Product> data = (decodedResponse['data']['data'] as List).map((postJson) => Product.fromJson(postJson)).toList();

          return {"success": true, "data": data};
        } else {
          return {"success": false, "message": "รูปแบบข้อมูลไม่ถูกต้อง"};
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
}

class Product {
  final String product_name;
  final String product_images;
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
        'name: $product_name, '
        'images: $product_images, ' //${product_images.join(", ")}
        'qty: $product_qty, '
        'price: $product_price, '
        'description: $product_description, '
        'category: $product_category, '
        'type: $product_type, '
        'seller: $seller_id, '
        'exp: $date_exp, '
        'location: $product_location, '
        'condition: $product_condition, '
        'defect: $product_defect, '
        'years: $product_years, '
        'tags: $tag'
        ')';
  }

  factory Product.fromJson(Map<String, dynamic> data) {
    print('qqq2 $data');
    return Product(
      product_name: data['product_name'] ?? "",
      product_images:
          data['user'] != null && data['user']['product_images'] != null ? "${Environment.imgUrl}/${data['user']['product_images']}" : "",
      product_qty: data['product_qty'].toString(),
      product_price: data['product_price'] ?? "",
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
