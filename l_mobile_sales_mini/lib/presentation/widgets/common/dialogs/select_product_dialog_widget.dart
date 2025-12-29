import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:l_mobile_sales_mini/data/models/products/product_model.dart';
import 'package:l_mobile_sales_mini/presentation/controllers/products_provider.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/cart/selected_product_widget.dart';

import '../../specific/inventory/item_widget.dart';

class SelectProductDialogWidget extends ConsumerStatefulWidget {
  const SelectProductDialogWidget({super.key});

  @override
  ConsumerState<SelectProductDialogWidget> createState() =>
      _SelectProductDialogWidgetState();
}

class _SelectProductDialogWidgetState
    extends ConsumerState<SelectProductDialogWidget> {
  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * .75,
        decoration: BoxDecoration(
          // color: Colors.white60,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => SmartDialog.dismiss(force: true),
                  child: Text('Close', style: TextTheme.of(context).bodyMedium),
                ),
              ],
            ),
            const SizedBox(height: 15),
            buildProductsList(context, productsAsync),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildProductsList(
    BuildContext context,
    AsyncValue<List<Product>> productsAsync,
  ) {
    return productsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Error loading products',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      data: (products) {
        if (products.isEmpty) {
          return Center(
            child: Text(
              'No products found',
              style: TextTheme.of(context).bodyMedium,
            ),
          );
        }

        return SizedBox(
          height: MediaQuery.of(context).size.height * .65,
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final Product product = products[index];

              return InkWell(
                onTap: () {
                  SmartDialog.dismiss(force: true, result: product);
                },
                child: SelectedProductWidget(product: product),
              );
            },
          ),
        );
      },
    );
  }
}
