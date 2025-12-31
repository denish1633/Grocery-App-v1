import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product.dart';
import '../controllers/CartController.dart';
import '../controllers/WishlistController.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ NEVER put controllers inside build
    final cartController = Get.find<CartController>();
    final wishlistController = Get.find<WishlistController>();

    final imageUrl = product.imageUrl ?? '';
    final name = product.name ?? 'Unnamed Product';
    final price = product.price ?? 0.0;

    return Stack(
      children: [
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// 🖼 IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image_not_supported, size: 60),
                        )
                      : const Icon(Icons.image_not_supported, size: 60),
                ),

                const SizedBox(height: 10),

                /// 🏷 NAME (constrained)
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                /// 📦 META
                const Text(
                  '1 pcs, Price',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),

                const Spacer(),

                /// 💰 PRICE + CART ACTIONS
                Row(
                  children: [
                    /// Price MUST be flexible
                    Expanded(
                      child: Text(
                        '\$${price.toStringAsFixed(2)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    /// Cart controls NEVER expand
                    Obx(() {
                      final qty =
                          cartController.quantityOf(product.code);

                      if (qty == 0) {
                        return _AddButton(
                          onTap: () => cartController.add(product),
                        );
                      }

                      return _QuantityControls(
                        quantity: qty,
                        onAdd: () => cartController.add(product),
                        onRemove: () =>
                            cartController.decrease(product.code),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),

        /// ❤️ WISHLIST
        Positioned(
          top: 8,
          right: 8,
          child: Obx(() {
            final isLiked =
                wishlistController.isWishlisted(product);

            return GestureDetector(
              onTap: () =>
                  wishlistController.toggleWishlist(product),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(1, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isLiked
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 20,
                  color: isLiked ? Colors.red : Colors.grey,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
class _AddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: onTap,
    );
  }
}

class _QuantityControls extends StatelessWidget {
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const _QuantityControls({
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: onRemove,
        ),

        SizedBox(
          width: 24,
          child: Center(
            child: Text(
              quantity.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),

        IconButton(
          icon: const Icon(Icons.add),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: onAdd,
        ),
      ],
    );
  }
}
