import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:groceryapp/controllers/ProductController.dart';
import 'package:groceryapp/views/CategoryScreen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ProductController controller = Get.find<ProductController>();

  final List<Map<String, dynamic>> categories = [
    {"name": "Produce", "color": const Color(0xFFDFFFD8)},
    {"name": "Oil", "color": const Color(0xFFFFF6BD)},
    {"name": "Meat", "color": const Color(0xFFFFD9C0)},
    {"name": "Bakery", "color": const Color(0xFFE7D1FF)},
    {"name": "Dairy", "color": const Color(0xFFFFE6E6)},
    {"name": "Beverages", "color": const Color(0xFFC5E3FF)},
  ];

  final String unsplashKey = "KKbmPU7Sp9eW9Bzeb4IDQk0jueve2pM1GkYjRZJh2Gg";

  /// Fetch Unsplash image
  Future<String> fetchImage(String query) async {
    try {
      final url =
          "https://api.unsplash.com/search/photos?page=1&per_page=1&query=$query&client_id=$unsplashKey";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'].isNotEmpty) {
          return data['results'][0]['urls']['regular'];
        }
      }
      return "https://via.placeholder.com/150";
    } catch (_) {
      return "https://via.placeholder.com/150";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Find Products',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            // 🔍 Search bar
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF2F3F2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search Store",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🧱 Category Grid
            Expanded(
              child: GridView.builder(
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (_, index) {
                  final category = categories[index];

                  return FutureBuilder<String>(
                    future: fetchImage(category["name"]),
                    builder: (_, snapshot) {
                      if (!snapshot.hasData) {
                        return _buildLoadingTile(category);
                      }

                      return _buildCategoryTile(
                        category,
                        snapshot.data!,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🧩 Category card
  Widget _buildCategoryTile(
      Map<String, dynamic> category, String imageUrl) {
    final String categoryName = category["name"];

    return GestureDetector(
      onTap: () {
        // 🔥 fetch once (cached in controller)
        controller.fetchCategoryProducts(categoryName);

        // 👉 navigate to see all
        Get.to(() => CategoryScreen(category: categoryName));
      },
      child: Container(
        decoration: BoxDecoration(
          color: category["color"],
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: category["color"], width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 70,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                categoryName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ⏳ Loading placeholder
  Widget _buildLoadingTile(Map<String, dynamic> category) {
    return Container(
      decoration: BoxDecoration(
        color: category["color"],
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}
