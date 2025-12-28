import 'package:flutter/material.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/inventory/item_widget.dart';

import '../../../../data/models/products/product_model.dart';

class ItemsGridWidget extends StatelessWidget {
  final List<Product> gridItems;
  const ItemsGridWidget({super.key, required this.gridItems});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: gridItems.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final Product item = gridItems[index];
        return ItemWidget(item:item, isInListView: false);
      },
    );
  }
}
