import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart.dart';
import '../config/constants.dart';

class CartService {
  Future<void> saveCart(int userId, List<CartItem> items) async {
    final url = Uri.parse('${Constants.apiUrl}/api/v1/cart/$userId');

    await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "products": items.map((e) => e.toJson()).toList(),
      }),
    );
  }

  Future<void> checkout(int userId) async {
    final url =
        Uri.parse('${Constants.apiUrl}/api/v1/cart/$userId/checkout');

    await http.post(url);
  }
}
