import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class OrderService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/v1';

  /// Create order from cart
    Future<void> createOrder({
  required List<Map<String, dynamic>> items,
  required double totalAmount,
  required String token,
}) async {

  print(jsonEncode({
      'total_amount': totalAmount,
      'items': items,
    }));
    
  final response = await http.post(
    Uri.parse('$baseUrl/orders'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'total_amount': totalAmount,
      'items': items,
    }),
  );

  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception(
      'Order failed: ${response.statusCode} ${response.body}',
    );
  }
}
  
  
  
  /// Get user orders
  static Future<List<Order>> fetchOrders(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print('🟡 Fetch orders response: ${response.body}');
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      
      return data.map((e) => Order.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  /// Track single order
  static Future<Order> getOrderById(int orderId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders/$orderId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Order.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Order not found');
    }
  }
}
