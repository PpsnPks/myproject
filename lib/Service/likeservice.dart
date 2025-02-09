import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myproject/environment.dart';

class LikeService {

  Future<List<Product>> getLikedProducts() async {
    final url = Uri.parse('$Environment.baseUrl/getlikes');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load liked products');
      }
    } catch (e) {
      throw Exception('Error fetching liked products: $e');
    }
  }

  Future<bool> likeProduct(Product product) async {
    final url = Uri.parse('$Environment.baseUrl/likes');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error liking product: $e');
    }
  }
}

class Product {
  final String imageUrl;
  final String title;
  final String detail;
  final String price;

  Product({
    required this.imageUrl,
    required this.title,
    required this.detail,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      imageUrl: json['imageUrl'] ?? '',
      title: json['title'] ?? '',
      detail: json['detail'] ?? '',
      price: json['price'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'detail': detail,
      'price': price,
    };
  }
}
