import 'package:get/get.dart';
import 'package:groceryapp/models/product.dart';
import '../services/ProductService.dart';

class ProductController extends GetxController {
  final ProductService _service = ProductService();

  /// category → full product list
  final productsByCategory = <String, List<Product>>{}.obs;

  /// category → loading state
  final loadingByCategory = <String, bool>{}.obs;

  /// categories that have already been fetched
  final Set<String> _loadedCategories = <String>{};

  // ───────── FETCH PRODUCTS ─────────

  Future<void> fetchCategoryProducts(String category) async {
    // 🔒 HARD GUARD: prevent duplicate calls
    if (_loadedCategories.contains(category)) return;

    // 🔒 Prevent concurrent fetch
    if (loadingByCategory[category] == true) return;

    loadingByCategory[category] = true;

    try {
      final products = await _service.fetchProducts(category);

      productsByCategory[category] = products;
      _loadedCategories.add(category);
    } catch (e) {
      print('❌ Error fetching $category: $e');
    } finally {
      loadingByCategory[category] = false;
    }
  }

  // ───────── READ HELPERS ─────────

  List<Product> getProducts(String category, {int limit = 5}) {
    final list = productsByCategory[category] ?? [];
    return list.take(limit).toList();
  }

  bool isLoading(String category) {
    return loadingByCategory[category] ?? false;
  }

  bool hasLoadedCategory(String category) {
    return _loadedCategories.contains(category);
  }

  // ───────── OPTIONAL: REFRESH SUPPORT ─────────

  Future<void> refreshCategory(String category) async {
    _loadedCategories.remove(category);
    productsByCategory.remove(category);
    await fetchCategoryProducts(category);
  }

  void clearAll() {
    productsByCategory.clear();
    loadingByCategory.clear();
    _loadedCategories.clear();
  }
}
