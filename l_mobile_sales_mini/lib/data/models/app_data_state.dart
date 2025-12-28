import 'package:l_mobile_sales_mini/data/models/customers/customer_model.dart';
import 'package:l_mobile_sales_mini/data/models/products/product_model.dart';
import 'package:l_mobile_sales_mini/data/models/user/user_model.dart';

class AppDataState {
  final List<User> users;
  final List<Product> products;
  final List<Customer> customers;
  final bool isRefreshing;

  AppDataState({
    required this.users,
    required this.products,
    required this.customers,
    this.isRefreshing = false,
  });

  factory AppDataState.initial() => AppDataState(users: [], products: [], customers: []);

  AppDataState copyWith({
    List<User>? users,
    List<Product>? products,
    List<Customer>? customers,
    bool? isRefreshing,
  }) {
    return AppDataState(
      users: users ?? this.users,
      products: products ?? this.products,
      customers: customers ?? this.customers,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}
