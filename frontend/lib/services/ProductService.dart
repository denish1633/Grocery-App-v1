import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:groceryapp/models/product.dart';

class ProductService {
  final String baseUrl = "http://127.0.0.1:8000/api/v1/external-products";

  Future<List<Product>> fetchProducts(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/$category'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch $category products');
    }
  }
}
