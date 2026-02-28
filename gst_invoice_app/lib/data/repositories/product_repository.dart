import 'package:hive/hive.dart';
import '../models/hive/product_model.dart';
import '../../core/constants/app_constants.dart';

class ProductRepository {
  final Box<ProductModel> _box = Hive.box<ProductModel>(AppConstants.productBox);

  List<ProductModel> getAllProducts() {
    return _box.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  ProductModel? getProductById(String id) {
    return _box.values.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Product not found'),
    );
  }

  Future<void> addProduct(ProductModel product) async {
    await _box.put(product.id, product);
  }

  Future<void> updateProduct(ProductModel product) async {
    await product.save();
  }

  Future<void> deleteProduct(String id) async {
    final key = _box.keys.firstWhere(
      (k) => _box.get(k)?.id == id,
      orElse: () => null,
    );
    if (key != null) await _box.delete(key);
  }

  List<ProductModel> searchProducts(String query) {
    final q = query.toLowerCase();
    return _box.values
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.hsnSac.contains(q))
        .toList();
  }
}
