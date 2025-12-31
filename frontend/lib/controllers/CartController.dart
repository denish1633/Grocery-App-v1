import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:groceryapp/controllers/OrderController.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../services/CartService.dart';
import 'AuthController.dart';

class CartController extends GetxController {
  final _storage = GetStorage();
  final _service = CartService();
  final auth = Get.find<AuthController>();

  /// product_code → CartItem
  final items = <String, CartItem>{}.obs;

  Timer? _syncTimer;

  int get userId => auth.user.value?.id ?? 0;
  String get token => auth.user.value?.accessToken ?? '';

  double get total =>
      items.values.fold(0, (sum, i) => sum + (i.product.price * i.quantity));

  @override
  void onInit() {
    super.onInit();
    _loadLocal();
    ever(items, (_) => _saveLocal());
  }

  // ---------------- CART ACTIONS ----------------

  void add(Product product) {
    items.update(
      product.code,
      (existing) {
        existing.quantity++;
        return existing;
      },
      ifAbsent: () => CartItem(product: product),
    );
    _scheduleSync();
  }

  void decrease(String code) {
    final item = items[code];
    if (item == null) return;

    if (item.quantity > 1) {
      item.quantity--;
    } else {
      items.remove(code);
    }
    _scheduleSync();
  }

  int quantityOf(String code) => items[code]?.quantity ?? 0;
  bool isInCart(String code) => items.containsKey(code);

  // ---------------- LOCAL STORAGE ----------------

  void _saveLocal() {
    _storage.write(
      'cart',
      items.values.map((e) => e.toJson()).toList(),
    );
  }

  void _loadLocal() {
    final data = _storage.read('cart');
    if (data == null) return;

    for (final e in data) {
      items[e['product_id']] = CartItem(
        product: Product(
          code: e['product_id'],
          name: e['name'],
          price: (e['price'] ?? 0).toDouble(),
          imageUrl: e['image_url'],
        ),
        quantity: e['quantity'],
      );
    }
  }

  // ---------------- BACKEND SYNC ----------------

  void _scheduleSync() {
    if (userId == 0) return;

    _syncTimer?.cancel();
    _syncTimer = Timer(
      const Duration(seconds: 1),
      syncWithBackend,
    );
  }

  Future<void> syncWithBackend() async {
    if (userId == 0) return;

    await _service.saveCart(
      userId,
      items.values.toList(),
    );
  }

  // ---------------- CHECKOUT ----------------

  Future<void> checkout() async {
    if (items.isEmpty) return;

    // 1️⃣ Ensure user is logged in
    if (token.isEmpty) {
      throw Exception('User not authenticated');
    }

    // 2️⃣ Sync cart first (optional but good)
    await syncWithBackend();

    // 3️⃣ Place order (JWT handles user)
    await Get.find<OrderController>().placeOrder(
      items: items.values.toList(),
    );

    // 4️⃣ Clear cart only after success
    items.clear();
    _storage.remove('cart');
  }
}
