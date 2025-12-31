import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:groceryapp/controllers/AuthController.dart';
import 'package:groceryapp/controllers/OrderController.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});

  final AuthController authController = Get.find<AuthController>();
  final OrderController orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    final user = authController.user.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('Please login'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserInfo(user.email),
                  const SizedBox(height: 24),

                  // 🧾 Orders
                  const Text(
                    'My Orders',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildOrdersSection(),

                  const SizedBox(height: 24),

                  // ⚙ Settings
                  const Text(
                    'Settings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingsTile(Icons.edit, 'Edit Profile', () {}),
                  _buildSettingsTile(Icons.location_on, 'Manage Addresses', () {}),
                  _buildSettingsTile(Icons.notifications, 'Notifications', () {}),
                  _buildSettingsTile(Icons.security, 'Privacy & Security', () {}),
                ],
              ),
            ),
    );
  }

  // ---------------- UI SECTIONS ----------------

  Widget _buildUserInfo(String email) {
    return Center(
      child: Column(
        children: [
          const CircleAvatar(
            radius: 45,
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/150?img=47',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            email,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            'Member since 2025',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

Widget _buildOrdersSection() {
  return Obx(() {
    print('🟡 isLoading: ${orderController.isLoading.value}');
    print('🟢 orders length: ${orderController.orders.length}');
    print('🟢 orders data: ${orderController.orders}');

    if (orderController.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (orderController.orders.isEmpty) {
      return const Text('No orders found.');
    }

    return Column(
      children: orderController.orders.map((order) {
        print('🔵 Rendering order id: ${order.id}');
        return ListTile(
          leading: const Icon(Icons.receipt_long, color: Colors.green),
          title: Text('Order #${order.id}'),
          subtitle: Text('Total: \$${order.totalAmount}'),
        );
      }).toList(),
    );
  });
}

// Widget _buildOrderCard(Order order) {
//   final status = order.status.toLowerCase();

//   final Color statusColor = switch (status) {
//     'delivered' => Colors.green,
//     'in transit' => Colors.orange,
//     _ => Colors.red,
//   };

//   return Card(
//     margin: const EdgeInsets.symmetric(vertical: 6),
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     elevation: 2,
//     child: ExpansionTile(
//       leading: const Icon(Icons.receipt_long, color: Colors.green),
//       title: Text('Order #${order.id}'),
//       subtitle: Text(
//         'Total: \$${order.totalAmount.toStringAsFixed(2)}'
//         '\nPlaced on: ${order.createdAt.toLocal().toString().split(' ')[0]}',
//       ),
//       trailing: Text(
//         order.status.toUpperCase(),
//         style: TextStyle(
//           fontWeight: FontWeight.bold,
//           color: statusColor,
//         ),
//       ),
//       children: order.items.map((item) {
//         return ListTile(
//           title: Text('Product ID: ${item.productId}'),
//           subtitle: Text('Quantity: ${item.quantity}'),
//           trailing: Text('\$${item.price.toStringAsFixed(2)}'),
//         );
//       }).toList(),
//     ),
//   );
// }

  Widget _buildSettingsTile(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.green),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  // ---------------- LOGOUT ----------------

  void _showLogoutDialog(BuildContext context) {
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Are you sure you want to log out?',
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        onPressed: () {
          authController.logout();
          Get.offAllNamed('/login');
        },
        child: const Text('Logout'),
      ),
      cancel: TextButton(
        onPressed: Get.back,
        child: const Text('Cancel'),
      ),
    );
  }
}
