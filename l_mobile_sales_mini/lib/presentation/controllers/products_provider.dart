import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_mobile_sales_mini/data/models/products/product_model.dart';

import '../../core/providers/data_provider.dart';

final productsProvider = AsyncNotifierProvider<ProductsNotifier, List<Product>>(
    ProductsNotifier.new
);

class ProductsNotifier extends AsyncNotifier<List<Product>> {
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
}