import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:myproject/environment.dart';

class ProductService {
  static Future<Product> getProduct() async {
    final String baseUrl = "${Environment.baseUrl}/product/";// ใส่ URL ของ API ที่ต้องการดึงข้อมูล
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      // แปลงข้อมูล JSON ที่ได้รับจาก API เป็น Product
      final data = json.decode(response.body);
      return Product(
        name: data['name'],
        price: data['price'],
        description: data['description'],
        category: data['category'],
        conditionProduct: data['conditionProduct'],
        durationUse: data['durationUse'],
        defect: data['defect'],
        timeForSell: data['timeForSell'],
        deliveryLocation: data['deliveryLocation'],
        deliveryDate: data['deliveryDate'],
        seller: data['seller'],
        stock: data['stock'],
        imageUrl: List<String>.from(data['imageUrl']),
      );
    } else {
      throw Exception('Failed to load product');
    }
  }
}

class Product {
  final String name;
  final String price;
  final String description;
  final String category;
  final String conditionProduct;
  final String durationUse;
  final String defect;
  final String timeForSell;
  final String deliveryLocation;
  final String deliveryDate;
  final String seller;
  final num stock;
  final List<String> imageUrl;

  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.conditionProduct,
    required this.durationUse,
    required this.defect,
    required this.timeForSell,
    required this.deliveryLocation,
    required this.deliveryDate,
    required this.seller,
    required this.stock,
    required this.imageUrl,
  });
}
