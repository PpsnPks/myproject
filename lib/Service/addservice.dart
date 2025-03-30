// ignore_for_file: non_constant_identifier_names

import 'dart:convert'; // เพิ่มการนำเข้า dart:convert
import 'package:intl/intl.dart';
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
        "product_price": int.tryParse(productPrice) ?? 0,
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
}

class ProductService {
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
        "product_category": "", //category
        "product_condition": "",
        "price_order": "asc",
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

  Future<Map<String, dynamic>> getRecommendedProducts() async {
    const url = "https://recommend-880011621471.asia-southeast1.run.app/recommend";

    try {
      // ดึง accessToken และ user_id จาก AuthService
      AuthService authService = AuthService();
      String? accessToken = await authService.getAccessToken();
      String? userId = await authService.getUserId();

      if (accessToken == null || userId == null) {
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

      // Body
      Map<String, dynamic> body = {"user_id": userId};

      // ส่ง Request
      final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(body));

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);

        if (decodedResponse != null && decodedResponse['recommendations'] != null) {
          List<Product> data = (decodedResponse['recommendations'] as List).map((postJson) => Product.fromJson(postJson)).toList();

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

  Future<Map<String, dynamic>> getRecommendedProductsfromPost() async {
    const url = "https://recommend-product-form-post-880011621471.asia-southeast1.run.app/recommend";

    try {
      // ดึง accessToken และ user_id จาก AuthService
      AuthService authService = AuthService();
      String? accessToken = await authService.getAccessToken();
      String? userId = await authService.getUserId();

      if (accessToken == null || userId == null) {
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

      // Body
      Map<String, dynamic> body = {"user_id": userId};

      // ส่ง Request
      final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(body));

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);

        if (decodedResponse != null && decodedResponse['recommendations'] != null) {
          List<Product> data = (decodedResponse['recommendations'] as List).map((postJson) => Product.fromJson(postJson)).toList();

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

  Future<Map<String, dynamic>> getProductCategory(int page, int length, String category, String search, String sortPrice, String sortDate,
      String productCondition, String productType) async {
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
          {"column": 0, "dir": sortDate}
        ],
        "start": (page - 1) * length,
        "length": length,
        "search": {"value": search, "regex": false},
        "product_type": productType,
        "product_category": category, //category
        "product_condition": productCondition,
        "price_order": sortPrice, // "asc"  "desc"
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

  Future<Map<String, dynamic>> getProductSeller() async {
    try {
      // ดึง accessToken จาก AuthService
      String? accessToken = await AuthService().getAccessToken();
      String userId = await Securestorage().readSecureData('userId');
      String url = "${Environment.baseUrl}/productsid/$userId";

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

      // Get Request
      final response = await http.get(Uri.parse(url), headers: headers);
      print('qqq ${response.statusCode}');

      // ตรวจสอบสถานะของ Response
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        print('qqq1 $decodedResponse');
        if (decodedResponse != null) {
          print('qqq2.1');
          List<Product> data = (decodedResponse as List).map((postJson) => Product.fromJson(postJson)).toList();
          return {"success": true, "data": data};
        } else {
          print('qqq2.2');

          return {"success": false, "message": "status code: ${response.statusCode}"};
        }
      } else {
        print('qqq2.3');

        return {
          "success": false,
          "message": 'Error ${response.statusCode} ${response.body}',
        };
      }
    } catch (e) {
      print('qqq2.4');

      return {
        "success": false,
        "message": "เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์: $e",
      };
    }
  }

  Future<Map<String, dynamic>> getProductById(String id) async {
    try {
      // ดึง accessToken จาก AuthService
      String? accessToken = await AuthService().getAccessToken();
      String userId = await Securestorage().readSecureData('userId');
      String url = "${Environment.baseUrl}/products/$id/$userId";

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

      // Get Request
      final response = await http.get(Uri.parse(url), headers: headers);
      print('qqq ${response.statusCode}');

      // ตรวจสอบสถานะของ Response
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        print('qqq1 $decodedResponse');
        if (decodedResponse != null) {
          print('qqq2.1');
          Product data = Product.fromJson(decodedResponse['product']);
          return {"success": true, "data": data};
        } else {
          print('qqq2.2');

          return {"success": false, "message": "status code: ${response.statusCode}"};
        }
      } else {
        print('qqq2.3');

        return {
          "success": false,
          "message": 'Error ${response.statusCode} ${response.body}',
        };
      }
    } catch (e) {
      print('qqq2.4');

      return {
        "success": false,
        "message": "เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์: $e",
      };
    }
  }

  Future<Map<String, dynamic>> deleteProductById(String product_id) async {
    try {
      // ดึง accessToken จาก AuthService
      String? accessToken = await AuthService().getAccessToken();
      String url = "${Environment.baseUrl}/products/$product_id";

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

      final response = await http.delete(Uri.parse(url), headers: headers);
      print('qqq ${response.statusCode} \n ${response.body}');

      // ตรวจสอบสถานะของ Response
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        print('qqq $decodedResponse');
        if (decodedResponse != null && decodedResponse['data'] != null) {
          List<Product> data = (decodedResponse['data']['data'] as List).map((postJson) => Product.fromJson(postJson)).toList();
          return {"success": true, "data": data};
        } else {
          return {"success": false, "message": "status code: ${response.statusCode}"};
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

  Future<Map<String, dynamic>> updateProduct(
      String id,
      String productName,
      List<dynamic> productImages,
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
    String url = "${Environment.baseUrl}/products/$id";
    try {
      // ดึง accessToken จาก AuthService
      String? accessToken = await AuthService().getAccessToken();
      String userId = await Securestorage().readSecureData('userId') ?? '99999';
      // String? productConditionValue = productType == 'preorder' ? 'มือหนึ่ง' : productCondition;
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
        "product_price": int.tryParse(productPrice) ?? 0,
        "product_description": productDescription,
        "product_category": productCategory,
        "product_type": productType,
        "seller_id": int.tryParse(userId) ?? 0,
        "date_exp": dateExp,
        "product_location": productLocation,
        "product_condition": productCondition,
        "product_defect": productDefect,
        "product_years": productYears,
        "tag": tag,
        "status": "ok"
      };

      // แปลง Map เป็น JSON string ก่อนส่ง
      String jsonBody = json.encode(body);
      // POST Request
      final response = await http.put(
        Uri.parse(url),
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
}

class CartService {
  Future<Map<String, dynamic>> getCartBuyer() async {
    try {
      // ดึง accessToken จาก AuthService
      String? accessToken = await AuthService().getAccessToken();
      String userId = await Securestorage().readSecureData('userId');
      String url = "${Environment.baseUrl}/dealsid/$userId";

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

      // Get Request
      final response = await http.get(Uri.parse(url), headers: headers);
      print('qqq ${response.statusCode}');

      // ตรวจสอบสถานะของ Response
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        print('qqq1 $decodedResponse');
        if (decodedResponse != null) {
          print('qqq2.1');
          List<Product> data = (decodedResponse as List)
              .where((postJson) => postJson['status'] == 'success')
              .map((postJson) => Product.fromJson(postJson['product']))
              .toList();
          List<Seller> dataS = (decodedResponse).map((postJson) => Seller.fromJson(postJson['product']['seller'])).toList();
          return {"success": true, "data": data, "dataS": dataS};
        } else {
          print('qqq2.2');

          return {"success": false, "message": "status code: ${response.statusCode}"};
        }
      } else {
        print('qqq2.3');

        return {
          "success": false,
          "message": 'Error ${response.statusCode} ${response.body}',
        };
      }
    } catch (e) {
      print('qqq2.4');

      return {
        "success": false,
        "message": "เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์: $e",
      };
    }
  }

  Future<Map<String, dynamic>> getCartSeller() async {
    try {
      // ดึง accessToken จาก AuthService
      String? accessToken = await AuthService().getAccessToken();
      String userId = await Securestorage().readSecureData('userId');
      String url = "${Environment.baseUrl}/dealsellerid/$userId";

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

      // Get Request
      final response = await http.get(Uri.parse(url), headers: headers);
      print('qqq ${response.statusCode}');

      // ตรวจสอบสถานะของ Response
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        print('qqq1 $decodedResponse');
        if (decodedResponse != null) {
          print('qqq2.1');
          List<Deal> data = (decodedResponse as List).map((postJson) => Deal.fromJson(postJson)).toList();
          return {"success": true, "data": data};
        } else {
          print('qqq2.2');

          return {"success": false, "message": "status code: ${response.statusCode}"};
        }
      } else {
        print('qqq2.3');

        return {
          "success": false,
          "message": 'Error ${response.statusCode} ${response.body}',
        };
      }
    } catch (e) {
      print('qqq2.4');

      return {
        "success": false,
        "message": "เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์: $e",
      };
    }
  }
}

class SearchService {
  Future<Map<String, dynamic>> searchProduct(int page, int length, String category, String search, String sortPrice, String sortDate,
      String productCondition, String productType) async {
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
          {"column": 0, "dir": sortDate}
        ],
        "start": (page - 1) * length,
        "length": length,
        "search": {"value": search, "regex": false},
        "product_type": productType,
        "product_category": category, //category
        "product_condition": productCondition,
        "price_order": sortPrice, // "asc"  "desc"
        "status": ""
      };
      print(body);

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
  final String deposit;
  final String date_send;

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
    required this.deposit,
    required this.date_send,
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
        'deposit: $deposit'
        'date_send: $date_send'
        ')';
  }

  factory Product.fromJson(Map<String, dynamic> data) {
    print('qqq2 $data');
    String defect = '';
    String deposit = '';
    String dateSend = '';

    if (data['product_type'] == 'preorder') {
      final temp = data['product_defect'].split(', ');
      deposit = temp[0];
      dateSend = temp[1];
    } else {
      defect = data['product_defect'] ?? '';
    }
    print('data : ${double.parse(data['product_price'])}');
    return Product(
      id: data['id']?.toString() ?? "",
      product_name: data['product_name'] ?? "",
      product_images: (data['product_images'] as List).map((image) => '${Environment.imgUrl}/$image').toList(),
      product_qty: data['product_qty'].toString(),
      product_price: NumberFormat("#,###").format(double.parse(data['product_price'])),
      product_description: data['product_description'] ?? "", //data['product_description'],
      product_category: data['product_category'] ?? "",
      product_type: data['product_type'] ?? "",
      seller_id: data['seller_id'].toString(),
      date_exp: data['date_exp'] ?? "",
      product_location: data['product_location'] ?? "",
      product_condition: data['product_condition'] ?? "",
      product_defect: defect,
      product_years: data['product_years'] ?? "",
      tag: data['tag'] ?? "",
      deposit: deposit,
      date_send: dateSend,
    );
  }
}

class Deal {
  final String deal_id;
  final String deal_qty;
  final String deal_date;
  final String deal_status;
  // final String deal_bill;

  final String product_id;
  final String product_name;
  final List<dynamic> product_images;
  final String product_qty;
  final String product_price;
  final String product_description;
  final String product_category;
  final String product_type;
  final String product_seller_id;
  final String product_date_exp;
  final String product_location;
  final String product_condition;
  final String product_defect;
  final String product_years;
  final String product_tag;

  final String seller_user_id;
  final String seller_name;
  final String seller_pic;
  final String seller_email;
  final String seller_mobile;
  final String seller_address;
  final String seller_faculty;
  final String seller_department;
  final String seller_classyear;
  final String seller_status;

  final String buyer_user_id;
  final String buyer_name;
  final String buyer_pic;
  final String buyer_email;
  final String buyer_mobile;
  final String buyer_address;
  final String buyer_faculty;
  final String buyer_department;
  final String buyer_classyear;
  final String buyer_status;

  Deal({
    required this.deal_id,
    required this.deal_qty,
    required this.deal_date,
    required this.deal_status,
    // required this.deal_bill,
    required this.buyer_user_id,
    required this.buyer_name,
    required this.buyer_pic,
    required this.buyer_email,
    required this.buyer_mobile,
    required this.buyer_address,
    required this.buyer_faculty,
    required this.buyer_department,
    required this.buyer_classyear,
    required this.buyer_status,
    required this.seller_user_id,
    required this.seller_name,
    required this.seller_pic,
    required this.seller_email,
    required this.seller_mobile,
    required this.seller_address,
    required this.seller_faculty,
    required this.seller_department,
    required this.seller_classyear,
    required this.seller_status,
    required this.product_id,
    required this.product_name,
    required this.product_images,
    required this.product_qty,
    required this.product_price,
    required this.product_description,
    required this.product_category,
    required this.product_type,
    required this.product_seller_id,
    required this.product_date_exp,
    required this.product_location,
    required this.product_condition,
    required this.product_defect,
    required this.product_years,
    required this.product_tag,
  });

  factory Deal.fromJson(Map<String, dynamic> data) {
    return Deal(
      deal_id: data['id']?.toString() ?? "",
      deal_qty: data['qty']?.toString() ?? "",
      deal_date: data['deal_date'],
      deal_status: data['status'],
      // deal_bill: data['id'],

      buyer_user_id: data['buyer']['user_id']?.toString() ?? "",
      buyer_name: data['buyer']['name'],
      buyer_pic: '${Environment.imgUrl}/${data['buyer']['pic']}',
      buyer_email: data['buyer']['email'],
      buyer_mobile: data['buyer']['mobile'],
      buyer_address: data['buyer']['address'],
      buyer_faculty: data['buyer']['faculty'],
      buyer_department: data['buyer']['department'],
      buyer_classyear: data['buyer']['classyear'],
      buyer_status: data['buyer']['status'] ?? 'qqq',

      product_id: data['product']['id']?.toString() ?? "",
      product_name: data['product']['product_name'] ?? "",
      product_images: (data['product']['product_images'] as List).map((image) => '${Environment.imgUrl}/$image').toList(),
      product_qty: data['product']['product_qty'].toString(),
      product_price: NumberFormat("#,###").format(double.parse(data['product']['product_price'])),
      product_description: data['product']['product_description'] ?? "",
      product_category: data['product']['product_category'] ?? "",
      product_type: data['product']['product_type'] ?? "",
      product_seller_id: data['product']['seller_id'].toString(),
      product_date_exp: data['product']['date_exp'] ?? "",
      product_location: data['product']['product_location'] ?? "",
      product_condition: data['product']['product_condition'] ?? "",
      product_defect: data['product']['product_defect'] ?? "",
      product_years: data['product']['product_years'] ?? "",
      product_tag: data['product']['tag'] ?? "",
      seller_user_id: data['product']['seller']['user_id']?.toString() ?? "",
      seller_name: data['product']['seller']['name'],
      seller_pic: '${Environment.imgUrl}/${data['product']['seller']['pic']}',
      seller_email: data['product']['seller']['email'],
      seller_mobile: data['product']['seller']['mobile'],
      seller_address: data['product']['seller']['address'],
      seller_faculty: data['product']['seller']['faculty'],
      seller_department: data['product']['seller']['department'],
      seller_classyear: data['product']['seller']['classyear'],
      seller_status: data['product']['seller']['status'] ?? 'qqq',
    );
  }
}

class Buyer {
  final String user_id;
  final String name;
  final String pic;
  final String email;
  final String mobile;
  final String address;
  final String faculty;
  final String department;
  final String classyear;
  final String status;

  Buyer({
    required this.user_id,
    required this.name,
    required this.pic,
    required this.email,
    required this.mobile,
    required this.address,
    required this.faculty,
    required this.department,
    required this.classyear,
    required this.status,
  });

  factory Buyer.fromJson(Map<String, dynamic> data) {
    return Buyer(
      user_id: data['user_id']?.toString() ?? "",
      name: data['name'],
      pic: '${Environment.imgUrl}/${data['pic']}',
      email: data['email'],
      mobile: data['mobile'],
      address: data['address'],
      faculty: data['faculty'],
      department: data['department'],
      classyear: data['classyear'],
      status: data['status'] ?? 'qqq',
    );
  }
}

class Seller {
  final String user_id;
  final String name;
  final String pic;
  final String email;
  final String mobile;
  final String address;
  final String faculty;
  final String department;
  final String classyear;
  final String status;

  Seller({
    required this.user_id,
    required this.name,
    required this.pic,
    required this.email,
    required this.mobile,
    required this.address,
    required this.faculty,
    required this.department,
    required this.classyear,
    required this.status,
  });

  factory Seller.fromJson(Map<String, dynamic> data) {
    print('qqq2 $data');
    return Seller(
      user_id: data['user_id']?.toString() ?? "",
      name: data['name'],
      pic: '${Environment.imgUrl}/${data['pic']}',
      email: data['email'],
      mobile: data['mobile'],
      address: data['address'],
      faculty: data['faculty'],
      department: data['department'],
      classyear: data['classyear'],
      status: data['status'] ?? 'qqq',
    );
  }
}
