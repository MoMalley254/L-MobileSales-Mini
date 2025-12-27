import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l_mobile_sales_mini/data/models/products/product_model.dart';
import 'package:l_mobile_sales_mini/presentation/controllers/products_provider.dart';

import '../widgets/common/appbar_widget.dart';
import '../widgets/common/bottom_navigation_widget.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final String searchHint = "Search by name or SKU...";

  bool showAsList = true;
  bool shouldFilter = false;
  Map<String, dynamic> activeFilter = {};
  List<Product> items = [];
  List<Product> itemsToUse = [];
  List<Map<String, dynamic>> fixedFilters =[];

  void toggleShowAsList(bool isList) {
    setState(() {
      showAsList = isList;
    });
  }

  void showFilters() {
    print('Show filters');
  }

  void doFilter(Map<String, dynamic> filter) {
    setState(() {
      activeFilter = filter;
      shouldFilter = filter['name'] == 'All' ? false : true;
    });
  }

  void populateItems(List<Product> products) {
      items = products;
      itemsToUse = items;

    activeFilter = fixedFilters.first;
  }

  List<Product> getLowStockItems() {
    List<Product> generatedItems = [];
    for (var item in itemsToUse) {
      int totalStock = getItemStockTotals(item.stock);

      if (totalStock <= 10) {
        generatedItems.add(item);
      }
    }

    return generatedItems;
  }

  List<Product> getOutOfStockItems() {
    List<Product> generatedItems = [];
    for (var item in itemsToUse) {
      int totalStock = getItemStockTotals(item.stock);

      if (totalStock < 1) {
        generatedItems.add(item);
      }
    }

    return generatedItems;
  }

  int getItemStockTotals(List<Stock> stores) {
    int totalStock = 0;
    for (var store in stores) {
      int stock = store.quantity;
      totalStock += stock;
    }

    return totalStock;
  }

  Future<List<Product>> generateItems() async {
    List<Product> generatedItems = [];
    if (!shouldFilter || activeFilter['name'] == 'All') {
      return items;
    } else {
      for (var item in itemsToUse) {
        int totalStock = getItemStockTotals(item.stock);

        if (shouldFilter || activeFilter['name'] != 'All') {
          //Do filter
          if (activeFilter['name'] == 'Low Stock') {
            final List<Product> lowStockItems = getLowStockItems();
            generatedItems.addAll(lowStockItems);
          } else if (activeFilter['name'] == 'Out of Stock') {
            final List<Product> outOfStockItems = getOutOfStockItems();
            generatedItems.addAll(outOfStockItems);
          }
        }
      }
    }
    return generatedItems;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      items = ref.read(productsProvider).value ?? [];
      itemsToUse = items;
      fixedFilters = [
        {'name': 'All', 'count': itemsToUse.length},
        {'name': 'Out of Stock', 'count': getLowStockItems().length},
        {'name': 'Low Stock', 'count': getOutOfStockItems().length},
      ];
    });

    activeFilter = fixedFilters.first;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<Product>>>(productsProvider, (previous, next) {
      next.when(
        data: (products) {
          //
          if (products.isNotEmpty) {
            populateItems(products);
          }
        },
        error: (error, stack) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
        loading: () {},
      );
    });
    return buildInventoryBody(context);
  }

  Widget buildInventoryBody(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      width: double.infinity,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildSearch(context),
            const SizedBox(height: 10),
            buildLayoutSwitch(context),
            const SizedBox(height: 10),
            buildFixedFilters(context),
            const SizedBox(height: 20),
            buildAllItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildSearch(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextFormField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: searchHint,
          hintStyle: TextTheme.of(context).bodyMedium,
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          filled: true,
          fillColor: Theme.of(context).appBarTheme.backgroundColor,
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
      ),
    );
  }

  Widget buildLayoutSwitch(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(flex: 3, child: buildLayoutButtons(context)),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: showFilters,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Theme.of(context).appBarTheme.backgroundColor,
                ),
                child: Icon(Icons.tune),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLayoutButtons(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary,
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: buildLayoutBtn(context, true)),
          Expanded(child: buildLayoutBtn(context, false)),
        ],
      ),
    );
  }

  Widget buildLayoutBtn(BuildContext context, bool isList) {
    return InkWell(
      onTap: () => toggleShowAsList(isList),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: showAsList == isList
              ? Colors.green
              : Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [
            Icon(
              isList ? Icons.list : Icons.dashboard,
              size: 25,
              color: showAsList == isList ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 5),
            Text(
              isList ? 'List' : 'Grid',
              style: TextTheme.of(context).labelMedium?.copyWith(
                color: showAsList == isList ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFixedFilters(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: fixedFilters.length,
        itemBuilder: (context, index) {
          final filter = fixedFilters[index];
          return buildSingleFixedFilter(context, filter);
        },
      ),
    );
  }

  Widget buildSingleFixedFilter(
    BuildContext context,
    Map<String, dynamic> filter,
  ) {
    return InkWell(
      onTap: () => doFilter(filter),
      child: Container(
        width: MediaQuery.of(context).size.width * .35,
        height: 10,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: activeFilter == filter
              ? Colors.green
              : Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              filter['name'],
              style: TextTheme.of(context).labelMedium?.copyWith(
                color: activeFilter == filter ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.orange[200],
              ),
              child: Text(
                filter['count'].toString(),
                style: TextTheme.of(
                  context,
                ).labelMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAllItems(BuildContext context) {
    return FutureBuilder(
      future: generateItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: const CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error loading Error :: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text('No data');
        } else {
          final List<Product> generatedItems = snapshot.data!;
          return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 1,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: generatedItems.isEmpty
                ? buildNoItems(context)
                : buildItemsContainer(context, generatedItems),
          );
        }
      },
    );
  }

  Widget buildNoItems(BuildContext context) {
    return Center(
      child: Text(
        'No items available',
        style: TextTheme.of(context).bodyMedium,
      ),
    );
  }

  Widget buildItemsContainer(
    BuildContext context,
    List<Product> generatedItems,
  ) {
    if (showAsList) {
      return buildItemsList(context, items);
    } else {
      return buildItemsGrid(context, items);
    }
  }

  Widget buildItemsList(
    BuildContext context,
    List<Product> listItems,
  ) {
    return ListView.builder(
      itemCount: listItems.length,
      itemBuilder: (context, index) {
        final Product item = listItems[index];
        return buildItem(context, item, true);
      },
    );
  }

  Widget buildItemsGrid(
    BuildContext context,
    List<Product> gridItems,
  ) {
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
        return buildItem(context, item, false);
      },
    );
  }

  Widget buildItem(
    BuildContext context,
    Product item,
    bool isInListView,
  ) {
    return InkWell(
      onTap: () {
        // Handle item tap
        GoRouter.of(context).go('/products/:${item.id}');
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
