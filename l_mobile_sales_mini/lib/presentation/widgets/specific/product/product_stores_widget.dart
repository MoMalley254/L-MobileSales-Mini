import 'package:flutter/material.dart';

import '../../../../data/models/products/product_model.dart';

class ProductStoresWidget extends StatelessWidget {
  final List<Stock> stores;
  const ProductStoresWidget({super.key, required this.stores});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Stores', style: TextTheme.of(context).labelMedium),
        const SizedBox(height: 5),
        SizedBox(
          height: MediaQuery.of(context).size.height * .1,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: stores.length,
            separatorBuilder: (context, index) {
              return const SizedBox(width: 10);
            },
            itemBuilder: (context, index) {
              final store = stores[index];
              return StoreWidget(store: store);
            },
          ),
        ),
      ],
    );
  }
}

class StoreWidget extends StatelessWidget {
  final Stock store;
  const StoreWidget({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width * .8,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(14),
            bottomRight: Radius.circular(14),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 5),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.warehouseId,
                    style: TextTheme.of(context).bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Reserved : ${store.reserved}',
                    style: TextTheme.of(context).labelMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    store.quantity.toString(),
                    style: TextTheme.of(context).bodyMedium,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 15,
                        color: store.quantity >= 10
                            ? Colors.green[500]!
                            : store.quantity < 1
                            ? Colors.red[500]!
                            : Colors.deepOrange[500]!,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        store.quantity >= 10
                            ? 'In Stock'
                            : store.quantity < 1
                            ? 'Out'
                            : 'Low Stock',
                        style: TextTheme.of(context).labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: store.quantity >= 10
                              ? Colors.green[500]!
                              : store.quantity < 1
                              ? Colors.red[500]!
                              : Colors.deepOrange[500]!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

