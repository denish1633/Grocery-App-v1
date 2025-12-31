import 'package:groceryapp/controllers/OrderController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groceryapp/controllers/WishlistController.dart';
import 'controllers/AuthController.dart';
import 'controllers/ProductController.dart';
import 'controllers/CartController.dart'; // ✅ Import
import 'utils/storage.dart';
import 'views/LoginScreen.dart';
import 'views/RegisterScreen.dart';
import 'views/HomeScreen.dart';
import 'views/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Storage.init();

  // ✅ Register all controllers BEFORE runApp
  Get.put<AuthController>(AuthController(), permanent: true);
  Get.put<ProductController>(ProductController(), permanent: true);
  Get.put<CartController>(CartController(), permanent: true); // ✅ Important
  Get.put<OrderController>(OrderController(), permanent: true); // ✅ Important
  Get.put<WishlistController>(WishlistController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Indian Grocery Store',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const WelcomeScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
      ],
      home: Obx(() {
        final auth = Get.find<AuthController>();
        return auth.user.value == null ? LoginScreen() : const HomeScreen();
      }),
    );
  }
}
