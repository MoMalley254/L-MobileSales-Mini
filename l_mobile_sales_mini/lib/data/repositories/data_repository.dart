import 'package:l_mobile_sales_mini/data/models/products/product_model.dart';
import 'package:l_mobile_sales_mini/data/services/json_loader.dart';

import '../models/customers/customer_model.dart';
import '../models/user/user_model.dart';

class DataRepository {
  final JsonLoader _service = JsonLoader();
  List<User>? _users;
  List<Product>? _products;
  List<Customer>? _customers;

  List<User> get users => _users?.toList() ?? [];
  List<Product> get products => _products?.toList() ?? [];
  List<Customer> get customers => _customers?.toList() ?? [];

  bool get isLoaded =>_users != null && _products != null && _customers != null;

  Future<void> loadData() async {
    if (isLoaded) return;

    final futures = [
      _service.loadJsonList('assets/data/user_data.json'),
      _service.loadJsonList('assets/data/products_data.json'),
      _service.loadJsonList('assets/data/customers_data.json'),
    ];

    final results = await Future.wait(futures);

    _users = (results[0]).map((j) => User.fromJson(j)).toList();
    _products = (results[1]).map((p) => Product.fromJson(p)).toList();
    _customers = (results[2]).map((c) => Customer.fromJson(c)).toList();
  }

  Future<void> refresh() async {
    _users = null;
    _products = null;
    _customers = null;

    await loadData();
  }
}