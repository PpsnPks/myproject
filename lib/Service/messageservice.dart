import 'package:http/http.dart' as http;
import 'dart:convert';

class MessageService {
  final String baseUrl = '{{base_url}}/chat';

  Future<void> sendMessage({
    required String buyerId,
    required String sellerId,
    required String message,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'buyer_id': buyerId,
          'seller_id': sellerId,
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        print('Message sent successfully');
      } else {
        print('Failed to send message: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
