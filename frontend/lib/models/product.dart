import 'package:flutter/foundation.dart';
import 'dart:math';

class Product {
  final String code;
  final String name;
  final String? brand;
  final String? imageUrl;
  final double price;

  Product({
    required this.code,
    required this.name,
    this.brand,
    this.imageUrl,
    this.price = 0.0,
  });

  /// Factory to create a Product from backend or OpenFoodFacts JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      code: json['code']?.toString() ?? UniqueKey().toString(),
      name: (json['name']?.toString().trim().isNotEmpty ?? false)
          ? json['name']
          : (json['product_name'] ?? 'Unknown Product'),
      brand: json['brand'] ?? json['brands'],
      imageUrl: json['image_url'] ?? json['image_front_url'],
      price: (json['price'] != null)
          ? double.tryParse(json['price'].toString()) ?? _generateRandomPrice()
          : _generateRandomPrice(),
    );
  }

  /// Convert Product to JSON (for local caching or storage)
  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
        'brand': brand,
        'image_url': imageUrl,
        'price': price,
      };

  /// Clone with optional overrides
  Product copyWith({
    String? code,
    String? name,
    String? brand,
    String? imageUrl,
    double? price,
  }) {
    return Product(
      code: code ?? this.code,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
    );
  }

  /// Generates a pseudo-random price for products without one
  static double _generateRandomPrice() {
    final random = Random();
    final price = 2 + random.nextInt(150) / 10; // range: 2.0–17.0
    return double.parse(price.toStringAsFixed(2));
  }
}
