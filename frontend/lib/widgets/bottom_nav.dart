import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<TabItem> items = [
    TabItem(icon: Icons.home, title: 'Home'),
    TabItem(icon: Icons.search, title: 'Shop'),
    TabItem(icon: Icons.favorite_border, title: 'Wishlist'),
    TabItem(icon: Icons.shopping_cart_outlined, title: 'Cart'),
    TabItem(icon: Icons.account_box, title: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomBarFloating(
      items: items,
      backgroundColor: Colors.white,
      color: Colors.black,
      colorSelected: Colors.green,
      indexSelected: currentIndex,
      paddingVertical: 20,
      onTap: onTap,
      borderRadius: BorderRadius.circular(65),
    );
  }
}
