import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_mobile_sales_mini/data/models/customers/customer_model.dart';

import '../../core/providers/data_provider.dart';

final customersProvider = AsyncNotifierProvider<CustomersNotifier, List<Customer>>(
  CustomersNotifier.new
);

class CustomersNotifier extends AsyncNotifier<List<Customer>> {
  @override
  Future<List<Customer>> build() async {
    final data = await ref.read(appDataAsyncProvider.future);
    final customers = data.customers;

    if (customers.isNotEmpty) {
      return customers;
    } else {
      return [];
    }
  }


  Customer? getCustomerFromId(String customerId) {
    return state.value?.firstWhere((c) => c.id == customerId);
  }
}