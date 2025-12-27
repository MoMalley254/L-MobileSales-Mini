import 'package:l_mobile_sales_mini/data/models/products/product_model.dart';
import 'package:l_mobile_sales_mini/data/models/user/user_model.dart';

class AppDataState {
  final List<User> users;
  final List<Product> products;
  final bool isRefreshing;

  AppDataState({
    required this.users,
    required this.products,
    this.isRefreshing = false,
  });

  factory AppDataState.initial() => AppDataState(users: [], products: []);

  AppDataState copyWith({
    List<User>? users,
    List<Product>? products,
    bool? isRefreshing,
  }) {
    return AppDataState(
      users: users ?? this.users,
      products: products ?? this.products,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}
