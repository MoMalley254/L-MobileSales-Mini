import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:l_mobile_sales_mini/data/models/customers/customer_model.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/customers/customer_widget.dart';

import '../../../controllers/customers_provider.dart';

class SelectCustomerDialogWidget extends ConsumerStatefulWidget {
  const SelectCustomerDialogWidget({super.key});

  @override
  ConsumerState<SelectCustomerDialogWidget> createState() => _SelectCustomerDialogState();
}

class _SelectCustomerDialogState extends ConsumerState<SelectCustomerDialogWidget> {
  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customersProvider);
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height  * .75,
        decoration: BoxDecoration(
          // color: Colors.white60,
            borderRadius: BorderRadius.circular(7)
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => SmartDialog.dismiss(force: true),
                  child: Text('Close', style: TextTheme.of(context).bodyMedium),
                )
              ],
            ),
            const SizedBox(height: 15),
            buildCustomersList(context, customersAsync),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }

  Widget buildCustomersList(
      BuildContext context,
      AsyncValue<List<Customer>> customersAsync,
      ) {
    return customersAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text(
          'Error loading customers',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      data: (customers) {
        if (customers.isEmpty) {
          return Center(
            child: Text('No customers found', style: TextTheme.of(context).bodyMedium,),
          );
        }

        return SizedBox(
          height: MediaQuery.of(context).size.height  * .65,
          child: ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final Customer customer = customers[index];

              return InkWell(
                onTap: () {
                  SmartDialog.dismiss(force: true, result: customer);
                },
                child: CustomerWidget(customer: customer),
              );
            },
          ),
        );
      },
    );
  }

}
