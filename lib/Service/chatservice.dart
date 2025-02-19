import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myproject/app/main/secureStorage.dart';
import 'package:myproject/auth_service.dart';
import 'package:myproject/environment.dart';

class Chatservice {
  Future<List<ProductChat>> getLikedProducts() async {
    // จำลองข้อมูล
    await Future.delayed(const Duration(seconds: 1)); // จำลองเวลาโหลดข้อมูล
    return [
      ProductChat(
        imageUrl: 'assets/images/a.jpg',
        title: '64010724',
        detail: 'พัดลม Xiaomi สภาพดี',
        types: 'เครื่องใช้ไฟฟ้า',
        price: '200',
        category: 'เครื่องใช้ไฟฟ้า',
      ),
      ProductChat(
        imageUrl: 'assets/images/image1.png',
        title: '64525879',
        detail: 'พัดลม Xiaomi สภาพดี',
        types: 'เครื่องใช้ไฟฟ้า',
        price: '150',
        category: 'หนังสือ',
      ),
    ];
  }
}

class ProductChat {
  final String imageUrl;
  final String title;
  final String detail;
  final String price;
  final String category;
  final String types;

  ProductChat({
    required this.imageUrl,
    required this.title,
    required this.detail,
    required this.price,
    required this.category,
    required this.types,
  });
}
