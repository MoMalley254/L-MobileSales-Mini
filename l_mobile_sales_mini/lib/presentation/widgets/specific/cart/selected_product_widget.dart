import 'package:flutter/material.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/inventory/item_widget.dart';

import '../../../../core/utils/inventory/stock_utils.dart';
import '../../../../data/models/products/product_model.dart';

class SelectedProductWidget extends StatelessWidget {
  final Product product;
  const SelectedProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 5, bottom: 20),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: buildProductInfo(context, product),
      ),
    );
  }

  Widget buildProductInfo(BuildContext context, Product product) {
    return Container(
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
      child: buildItemDetailsRow(context, product)
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
          buildItemStores(context, item.stock),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  Widget buildItemStores(BuildContext context, List<Stock> stores) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        itemCount: stores.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final Stock store = stores[index];
          return buildItemStore(context, store);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 5);
        },
      ),
    );
  }

  Widget buildItemStore(BuildContext context, Stock store) {
    return Chip(
      label: Text('${store.warehouseId} : ${store.quantity}', style: TextTheme.of(context).labelMedium),
      visualDensity: VisualDensity.compact,
    );
  }
}
