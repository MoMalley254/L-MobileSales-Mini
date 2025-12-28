import 'package:flutter/material.dart';

import '../../../../data/models/products/product_model.dart';
import 'item_widget.dart';

class ItemsListWidget extends StatelessWidget {
  final List<Product> listItems;
  const ItemsListWidget({super.key, required this.listItems});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listItems.length,
      itemBuilder: (context, index) {
        final Product item = listItems[index];
        return ItemWidget(item:item, isInListView: true);
      },
    );
  }
}
