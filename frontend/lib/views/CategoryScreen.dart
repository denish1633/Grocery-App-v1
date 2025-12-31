import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groceryapp/controllers/ProductController.dart';
import 'package:groceryapp/widgets/product_card.dart';

class CategoryScreen extends StatelessWidget {
  final String category;

  const CategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: Obx(() {
        final products = controller.getProducts(category);

        if (products.isEmpty) {
          return const Center(child: Text("No products found"));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.7,
          ),
          itemCount: products.length,
          itemBuilder: (_, index) {
            return ProductCard(product: products[index]);
          },
        );
      }),
    );
  }
}
