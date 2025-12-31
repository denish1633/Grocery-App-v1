import 'package:get/get.dart';
import 'package:groceryapp/controllers/AuthController.dart';
import 'package:groceryapp/models/cart.dart';
import 'package:groceryapp/models/order.dart';
import 'package:groceryapp/services/OrderService.dart';

class OrderController extends GetxController {
  final orders = <Order>[].obs;
  final isLoading = false.obs;

  final _service = OrderService();
  final AuthController auth = Get.find<AuthController>();

   @override
  void onInit() {
    super.onInit();

    // 🔥 Reactively listen for login / token availability
    ever(auth.user, (user) {
      final token = user?.accessToken;
      print('🟣 Auth changed → token: $token');

      if (token != null && token.isNotEmpty) {
        fetchOrders(token);
      }
    });
  }
 

 
  // ---------------- FETCH ORDERS ----------------

    Future<void> fetchOrders(String token) async {
    try {
      isLoading.value = true;
      print('🟡 Fetching orders...');
      orders.value = await OrderService.fetchOrders(token);
      print('🟢 Orders fetched: ${orders.length}');
    } catch (e) {
      print('❌ Fetch orders error: $e');
      Get.snackbar('Error', 'Could not load orders');
    } finally {
      isLoading.value = false;
    }
    }
   
   
   // ---------------- PLACE ORDER ----------------

  Future<void> placeOrder({
    required List<CartItem> items,
  }) async {
    if (items.isEmpty) {
      throw Exception('Cart is empty');
    }

    final token = auth.user.value?.accessToken;
    if (token == null || token.isEmpty) {
      throw Exception('User not authenticated');
    }

    final totalAmount = items.fold<double>(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );

    double total = double.parse(totalAmount.toStringAsFixed(2));


    await _service.createOrder(
      token: token,
      totalAmount: total,
      items: items
          .map(
            (item) => {
              'product_id': int.parse(item.product.code),// ✅ MUST be product_id
              'quantity': item.quantity,
              'price': item.product.price,
            },
          )
          .toList(),
    );

    // Refresh order list after placing order
    await fetchOrders(token);
  }
// ---------------- TRACK ORDER ----------------

  Future<Order?> trackOrder(int orderId) async {
    final token = auth.user.value?.accessToken;
    if (token == null || token.isEmpty) return null;

    try {
      isLoading.value = true;
      return await OrderService.getOrderById(orderId, token);
    } catch (e) {
      Get.snackbar('Error', 'Order not found');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

}