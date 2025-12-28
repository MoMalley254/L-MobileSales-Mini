import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/inventory/items_list_widget.dart';

import '../../../../data/models/products/product_model.dart';
import '../../../controllers/products_provider.dart';
import '../inventory/item_widget.dart';

class RelatedProductsWidget extends ConsumerWidget {
  final List<String> relatedProductsIds;
  const RelatedProductsWidget({super.key, required this.relatedProductsIds});

  List<Product> getRelatedProducts(List<Product> allProducts) {
    return allProducts.where((p) => relatedProductsIds.contains(p.id)).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    ref.listen<AsyncValue<List<Product>>>(productsProvider, (_, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error.toString())));
      }
    });

    final allProducts = productsAsync.value ?? [];
    final List<Product> related = getRelatedProducts(allProducts);

    return related.isEmpty ? SizedBox.shrink() : Container(
      height: MediaQuery.of(context).size.height * .5,
      child: buildList(context, related),
    );
  }

  Widget buildList(BuildContext context, List<Product> related) {
    return ListView.builder(
      itemCount: related.length,
      itemBuilder: (context, index) {
        final Product item = related[index];
        return ItemWidget(item:item, isInListView: true);
      },
    );
  }
}
