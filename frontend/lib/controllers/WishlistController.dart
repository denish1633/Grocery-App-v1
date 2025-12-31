import 'package:get/get.dart';
import '../models/product.dart';

class WishlistController extends GetxController {
  var wishlist = <Product>[].obs;

  void toggleWishlist(Product product) {
    if (wishlist.any((p) => p.code == product.code)) {
      wishlist.removeWhere((p) => p.code == product.code);
    } else {
      wishlist.add(product);
    }
  }

  bool isWishlisted(Product product) {
    return wishlist.any((p) => p.code == product.code);
  }

  void removeFromWishlist(Product product) {
    wishlist.removeWhere((p) => p.code == product.code);
  }
}
