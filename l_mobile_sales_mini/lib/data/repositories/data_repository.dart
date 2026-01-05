import 'package:l_mobile_sales_mini/data/models/products/product_model.dart';
import 'package:l_mobile_sales_mini/data/services/database_service.dart';
import 'package:l_mobile_sales_mini/data/services/json_loader.dart';

import '../models/customers/customer_model.dart';
import '../models/user/user_model.dart';

class DataRepository {
  final JsonLoader _service = JsonLoader();
  final DatabaseService _dbService = DatabaseService();

  List<User>? _users;
  List<Product>? _products;
  List<Customer>? _customers;

  List<User> get users => _users?.toList() ?? [];
  List<Product> get products => _products?.toList() ?? [];
  List<Customer> get customers => _customers?.toList() ?? [];

  bool get isLoaded =>_users != null && _products != null && _customers != null;

  Future<void> loadData() async {
    if (isLoaded) return;

    _products = await getProducts();

    final futures = [
      _service.loadJsonList('assets/data/user_data.json'),
      _service.loadJsonList('assets/data/customers_data.json'),
    ];

    final results = await Future.wait(futures);

    _users = (results[0]).map((j) => User.fromJson(j)).toList();
    _customers = (results[1]).map((c) => Customer.fromJson(c)).toList();
  }

  Future<List<Product>> getProducts() async {
    List<Product> dbProducts = await _dbService.getProductsFromDb();
    if (dbProducts.isNotEmpty) {
      return dbProducts;
    } else {
      //If DB is empty, load from JSON
      final productData = await _service.loadJsonList('assets/data/products_data.json');
      List<Product> products = productData.map((p) => Product.fromJson(p)).toList();

      //Save to DB for next time
      await _dbService.insertAllProducts(products);
      return products;
    }
  }

  Future<void> refresh() async {
    _users = null;
    _products = null;
    _customers = null;

    await loadData();
  }
}