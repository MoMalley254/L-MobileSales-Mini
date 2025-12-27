import 'package:l_mobile_sales_mini/data/models/products/product_model.dart';
import 'package:l_mobile_sales_mini/data/services/json_loader.dart';

import '../models/user/user_model.dart';

class DataRepository {
  final JsonLoader _service = JsonLoader();
  List<User>? _users;
  List<Product>? _products;

  List<User> get users => _users?.toList() ?? [];
  List<Product> get products => _products?.toList() ?? [];

  bool get isLoaded =>_users != null && _products != null;

  Future<void> loadData() async {
    if (isLoaded) return;

    final futures = [
      _service.loadJsonList('assets/data/user_data.json'),
      _service.loadJsonList('assets/data/products_data.json'),
    ];

    final results = await Future.wait(futures);

    _users = (results[0]).map((j) => User.fromJson(j)).toList();
    _products = (results[1]).map((p) => Product.fromJson(p)).toList();
  }

  Future<void> refresh() async {
    _users = null;
    _products = null;

    await loadData();
  }
}