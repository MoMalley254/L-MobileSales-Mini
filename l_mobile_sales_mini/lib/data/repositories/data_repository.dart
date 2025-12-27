import 'package:l_mobile_sales_mini/data/services/json_loader.dart';

import '../models/user/user_model.dart';

class DataRepository {
  final JsonLoader _service = JsonLoader();
  List<User>? _users;

  List<User> get users => _users?.toList() ?? [];

  bool get isLoaded =>_users != null;

  Future<void> loadData() async {
    if (isLoaded) return;

    final futures = [
      _service.loadJsonList('assets/data/user_data.json'),
    ];

    final results = await Future.wait(futures);

    _users = (results[0]).map((j) => User.fromJson(j)).toList();
  }

  Future<void> refresh() async {
    _users = null;

    await loadData();
  }
}