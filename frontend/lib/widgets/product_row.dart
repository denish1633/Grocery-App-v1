import 'package:flutter/material.dart';
import 'package:groceryapp/models/product.dart';
import 'package:groceryapp/widgets/product_card.dart';

class ProductRow extends StatelessWidget {
  final String title;
  final List<Product> products;

  const ProductRow({
    super.key,
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🏷 Section Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),

        // 🛒 Horizontal Product List
        
      ],
    );
  }
}
