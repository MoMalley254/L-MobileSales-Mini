import 'package:l_mobile_sales_mini/data/models/user/user_model.dart';

class AppDataState {
  final List<User> users;
  final bool isRefreshing;

  AppDataState({required this.users, this.isRefreshing = false});

  factory AppDataState.initial() => AppDataState(users: []);

  AppDataState copyWith({List<User>? users, bool? isRefreshing}) {
    return AppDataState(users: users ?? this.users, isRefreshing: isRefreshing ?? this.isRefreshing);
  }
}
