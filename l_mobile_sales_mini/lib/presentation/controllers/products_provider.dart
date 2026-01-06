import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_mobile_sales_mini/data/models/products/product_model.dart';

import '../../core/providers/data_provider.dart';
import '../../data/services/database_service.dart';

final productsProvider = AsyncNotifierProvider<ProductsNotifier, List<Product>>(
    ProductsNotifier.new
);

class ProductsNotifier extends AsyncNotifier<List<Product>> {
  final DatabaseService _dbService = DatabaseService();

  @override
  Future<List<Product>> build() async {
    final data = await ref.read(appDataAsyncProvider.future);
    final products = data.products;

    if (products.isNotEmpty) {
      return products;
    } else {
      return [];
    }
  }

  Product? getProductFromId(String id) {
    return state.value?.firstWhere((product) => product.id == id);
  }

  Future<bool> insertProduct(Product product) async {
    bool insertResult = await _dbService.insertProduct(product);
    if (insertResult) {
      state.value?.add(product);
      return true;
    } else {
      return false;
    }
  }
}