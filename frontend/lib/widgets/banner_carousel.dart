import 'package:flutter/material.dart';
import 'package:scroll_page_view/pager/page_controller.dart';
import 'package:scroll_page_view/pager/scroll_page_view.dart';

class BannerCarousel extends StatelessWidget {
  const BannerCarousel({super.key});

  final List<String> images = const [
    '/Users/denishshingala/GroceryApp/frontend/assets/images/banner1.jpg',
    '/Users/denishshingala/GroceryApp/frontend/assets/images/banner2.png',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ScrollPageView(
        controller: ScrollPageController(),
        delay: const Duration(seconds: 3),
        indicatorAlign: Alignment.bottomCenter,
        indicatorColor: Colors.grey.shade300,
        checkedIndicatorColor: Colors.green,
        children: images.map((img) => _buildImage(img)).toList(),
      ),
    );
  }

  Widget _buildImage(String img) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(img, fit: BoxFit.cover),
      ),
    );
  }
}
