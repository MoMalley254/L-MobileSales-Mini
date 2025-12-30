import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/inventory/stock_utils.dart';
import '../../../../data/models/products/product_model.dart';

class ItemWidget extends StatelessWidget {
  final Product item;
   final   bool isInListView;
  const ItemWidget({
    super.key,
    required this.item,
    required this.isInListView
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle item tap
        GoRouter.of(context).go('/products/${item.id}');
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isInListView
            ? buildItemDetailsRow(context, item)
            : buildItemDetailsColumn(context, item),
      ),
    );
  }

  Widget buildItemDetailsRow(BuildContext context, Product item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              //Use online link instead
              'https://picsum.photos/400/300?1',
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.image_not_supported, size: 50),
            ),

            //Use Image.asset(item.images.first)
          ),
        ),
        const SizedBox(width: 10),
        buildItemInfoForList(context, item),
      ],
    );
  }

  Widget buildItemDetailsColumn(
      BuildContext context,
      Product item,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              //Use online link instead
              'https://picsum.photos/400/300?1',
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.image_not_supported, size: 50),
            ),

            //Use Image.asset(item.images.first)
          ),
        ),
        const SizedBox(width: 10),
        buildItemInfoForList(context, item),
      ],
    );
  }


  Widget buildItemInfoForList(BuildContext context, Product item) {
    int totalStock = getItemStockTotals(item.stock);

    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextTheme.of(context).bodyMedium,
          ),
          Text('SKU: ${item.sku}', style: TextTheme.of(context).labelMedium),

          const SizedBox(height: 6),
          buildItemCategories(context, item.category, item.subcategory),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              Text(
                '\$${item.price}',
                style: TextTheme.of(
                  context,
                ).bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: totalStock > 10
                      ? Colors.green[200]
                      : Colors.red[200],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  totalStock > 0
                      ? 'Stock: $totalStock'
                      : 'Out of stock',
                  style: TextTheme.of(
                    context,
                  ).labelMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildItemCategories(BuildContext context, String category, String subCategory) {
    List<String> combinedList = [category, subCategory];
    return Container(
      height: 40,
      child: ListView.separated(
        itemCount: combinedList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final String category = combinedList[index];
          return buildItemCategory(context, category);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 5);
        },
      ),
    );
  }

  Widget buildItemCategory(BuildContext context, String category) {
    return Chip(
      label: Text(category, style: TextTheme.of(context).labelMedium),
      visualDensity: VisualDensity.compact,
    );
  }
}
