import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l_mobile_sales_mini/data/models/products/product_model.dart';
import 'package:l_mobile_sales_mini/presentation/controllers/products_provider.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/inventory/items_grid_widget.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/inventory/items_list_widget.dart';

import '../../core/utils/inventory/stock_utils.dart';
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
  List<Map<String, dynamic>> fixedFilters = [];

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

  List<Product> _getFilteredItems(List<Product> allProducts) {
    // 1. Filter by search text
    final String searchText = _searchController.text.toLowerCase();
    final List<Product> searchedProducts = searchText.isEmpty
        ? allProducts
        : allProducts.where((p) {
            return p.name.toLowerCase().contains(searchText) ||
                p.sku.toLowerCase().contains(searchText);
          }).toList();

    // 2. Filter by active filter
    final filterName = activeFilter['name'];
    if (filterName == 'All') {
      return searchedProducts;
    } else if (filterName == 'Out of Stock') {
      return searchedProducts
          .where((p) => getItemStockTotals(p.stock) == 0)
          .toList();
    } else if (filterName == 'Low Stock') {
      return searchedProducts
          .where(
            (p) =>
                getItemStockTotals(p.stock) > 0 &&
                getItemStockTotals(p.stock) <= 10,
          )
          .toList();
    }

    return searchedProducts;
  }

  @override
  void initState() {
    super.initState();
    activeFilter = {'name': 'All', 'count': 0};
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    ref.listen<AsyncValue<List<Product>>>(productsProvider, (_, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error.toString())));
      }
    });

    final allProducts = productsAsync.value ?? [];
    final outOfStockCount = allProducts
        .where((p) => getItemStockTotals(p.stock) == 0)
        .length;
    final lowStockCount = allProducts
        .where((p) => getItemStockTotals(p.stock) <= 10)
        .length;

    fixedFilters = [
      {'name': 'All', 'count': allProducts.length},
      {'name': 'Out of Stock', 'count': outOfStockCount},
      {'name': 'Low Stock', 'count': lowStockCount},
    ];

    return buildInventoryBody(context, productsAsync);
  }

  Widget buildInventoryBody(
    BuildContext context,
    AsyncValue<List<Product>> productsAsync,
  ) {
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
            buildAllItems(context, productsAsync),
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

  Widget buildAllItems(
    BuildContext context,
    AsyncValue<List<Product>> productsAsync,
  ) {
    return productsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (products) {
        final filteredItems = _getFilteredItems(products);

        if (filteredItems.isEmpty) {
          return buildNoItems(context);
        }
        return buildItemsContainer(context, filteredItems);
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
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 1,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: showAsList
          ? ItemsListWidget(listItems: generatedItems)
          : ItemsGridWidget(gridItems: generatedItems),
    );
  }
}
