import 'package:groceryapp/views/AccountScreen.dart';
import 'package:flutter/material.dart';
import 'package:groceryapp/views/CartScreen.dart';
import 'package:groceryapp/views/FavouriteScreen.dart';
import 'package:groceryapp/views/ExploreScreen.dart';
import 'package:groceryapp/views/ShopScreen.dart';
import 'package:groceryapp/widgets/bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of screens for bottom navigation
  final List<Widget> _screens = [
    Shopscreen(),
    const ExploreScreen(),
    const FavouriteScreen(),
    CartScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}
