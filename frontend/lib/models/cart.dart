import 'package:groceryapp/models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  Map<String, dynamic> toJson() => {
        "product_id": product.code,
        "name": product.name,
        "price": product.price,
        "image_url": product.imageUrl,
        "quantity": quantity,
      };
}
