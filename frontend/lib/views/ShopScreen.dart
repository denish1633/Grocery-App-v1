import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groceryapp/controllers/ProductController.dart';
import 'package:groceryapp/views/CategoryScreen.dart';
import 'package:groceryapp/widgets/banner_carousel.dart';
import 'package:groceryapp/widgets/product_card.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Shopscreen extends StatefulWidget {
  const Shopscreen({super.key});

  @override
  State<Shopscreen> createState() => _ShopscreenState();
}

class _ShopscreenState extends State<Shopscreen> {
  late final ProductController controller;

  final List<String> categories = const [
    "Beverages",
    "Snacks",
    "Fruits",
    "Vegetables",
  ];

  @override
  void initState() {
    super.initState();
    controller = Get.find<ProductController>();

    // Load first category eagerly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchCategoryProducts(categories.first);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return SafeArea(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        itemCount: categories.length + 3, // header widgets
        itemBuilder: (context, index) {
          if (index == 0) return _buildHeader();
          if (index == 1) return _buildSearchBar();
          if (index == 2) return const BannerCarousel();

          final category = categories[index - 3];
          return _buildProductRow(category);
        },
      ),
    );
  }

  // ───────── HEADER ─────────

  Widget _buildHeader() {
    return Column(
      children: const [
        Center(
          child: Image(
            image: AssetImage('/Users/denishshingala/GroceryApp/frontend/assets/logo.png'),
            height: 40,
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, size: 18),
            SizedBox(width: 4),
            Text('Dhaka, Banassre', style: TextStyle(fontSize: 16)),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search Store',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: const Color(0xFFF2F3F2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // ───────── PRODUCT ROW ─────────

  Widget _buildProductRow(String category) {
    return VisibilityDetector(
      key: Key('category-$category'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.2 &&
            !controller.hasLoadedCategory(category)) {
          controller.fetchCategoryProducts(category);
        }
      },
      child: Obx(() {
        if (controller.isLoading(category)) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final products = controller.getProducts(category);

        if (products.isEmpty) {
          return const SizedBox(height: 1);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(category,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () =>
                      Get.to(() => CategoryScreen(category: category)),
                  child: const Text('See all',
                      style: TextStyle(color: Color(0xFF53B175))),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 270,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, index) {
                  return SizedBox(
                    width: 160,
                    child: ProductCard(product: products[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        );
      }),
    );
  }
}
