import 'dart:math';

import 'package:flutter/material.dart';

import '../widgets/common/appbar_widget.dart';
import '../widgets/common/bottom_navigation_widget.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final String searchHint = "Search by name or SKU...";

  bool showAsList = true;
  bool shouldFilter = false;
  Map<String, dynamic> activeFilter = {};
  late List<Map<String, dynamic>> items;
  List<Map<String, dynamic>> itemsToUse = [];
  final List<Map<String, dynamic>> fixedFilters = [
    {
      'name': 'All',
      'count': 10,
    },
    {
      'name': 'Out of Stock',
      'count': 3,
    },
    {
      'name': 'Low Stock',
      'count': 6,
    },
    {
      'name': 'Sale',
      'count': 1,
    },
    {
      'name': 'New',
      'count': 4,
    },
    {
      'name': 'Archived',
      'count': 2,
    },
  ];

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

  final Random _random = Random();

  String _randomSku() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(8, (index) => chars[_random.nextInt(chars.length)]).join();
  }

  int _randomId() => _random.nextInt(900000) + 100000;

  double _randomPrice() =>
      double.parse((_random.nextDouble() * 500 + 10).toStringAsFixed(2));

  int _randomStock() => _random.nextInt(100);

  void populateItems() {
    setState(() {
      items = List.generate(10, (index) {
        return {
          'id': _randomId(),
          'name': 'Product ${index + 1}',
          'sku': _randomSku(),
          'image':
          'https://picsum.photos/seed/${index + 1}/300/300', // random network image
          'categories': [
            if (index.isEven) 'Electronics',
            if (index % 3 == 0) 'Featured',
            'General',
          ],
          'price': _randomPrice(),
          'stockCount': _randomStock(),
        };
      });
      itemsToUse = items;
    });
  }

  Future<List<Map<String, dynamic>>> generateItems() async {
    List<Map<String, dynamic>> generatedItems = [];
    if (shouldFilter || activeFilter['name'] != 'All') {
      //Do filter
      if (activeFilter['name'] == 'Low Stock') {
        for (var item in itemsToUse) {
          if (item['stockCount'] <= 10) {
            generatedItems.add(item);
          }
        }
      } else if (activeFilter['name'] == 'Out of Stock') {
        for (var item in itemsToUse) {
          if (item['stockCount'] < 1) {
            generatedItems.add(item);
          }
        }
      }
      return generatedItems;
    } else {
      return items;
    }
  }

  @override
  void initState() {
    super.initState();
    activeFilter = fixedFilters.first;
    populateItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(),
      body: buildInventoryBody(context),
      bottomNavigationBar: BottomNavigationWidget(),
    );
  }

  Widget buildInventoryBody(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildSearch(context),
            const SizedBox(height: 10,),
            buildLayoutSwitch(context),
            const SizedBox(height: 10,),
            buildFixedFilters(context),
            const SizedBox(height: 20,),
            buildAllItems(context)
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
          prefixIcon: Icon(
            Icons.search
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          filled: true,
          fillColor: Theme.of(context).appBarTheme.backgroundColor,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
        ),
      ),
    );
  }

  Widget buildLayoutSwitch(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: buildLayoutButtons(context)
          ),
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
                child: Icon(
                    Icons.tune
                ),
              ),
            ),
          )
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
            offset: Offset(0, 3)
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: buildLayoutBtn(context, true),
          ),
          Expanded(
            child: buildLayoutBtn(context, false),
          )
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
          color: showAsList == isList ? Colors.green : Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: BorderRadius.circular(7)
        ),
        child: Row(
          children: [
            Icon(
              isList ? Icons.list : Icons.dashboard,
              size: 25,
              color: showAsList == isList ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 5,),
            Text(
              isList ? 'List' : 'Grid',
              style: TextTheme.of(context).labelMedium?.copyWith(
                color: showAsList == isList ? Colors.white : Colors.black,
              ),
            )
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

  Widget buildSingleFixedFilter(BuildContext context, Map<String, dynamic> filter) {
    return InkWell(
        onTap: () => doFilter(filter),
        child: Container(
          width: MediaQuery.of(context).size.width * .35,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: activeFilter == filter ? Colors.green : Theme.of(context).appBarTheme.backgroundColor,
            borderRadius: BorderRadius.circular(30)
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
              const SizedBox(width: 5,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.orange[200]
                ),
                child: Text(
                  filter['count'].toString(),
                  style: TextTheme.of(context).labelMedium?.copyWith(
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            ],
          ),
        )
    );
  }

  Widget buildAllItems(BuildContext context) {
    return FutureBuilder(
      future: generateItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: const CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Text('Error loading date');
        } else if (!snapshot.hasData) {
          return const Text('No data');
        } else {
          final List<Map<String, dynamic>> generatedItems = snapshot.data!;
          return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 1,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: generatedItems.isEmpty ? buildNoItems(context) : buildItemsContainer(context, generatedItems)
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

  Widget buildItemsContainer(BuildContext context, List<Map<String, dynamic>> generatedItems) {
    if (showAsList) {
      return buildItemsList(context, items);
    } else {
      return buildItemsGrid(context, items);
    }
  }

  Widget buildItemsList(BuildContext context, List<Map<String, dynamic>> listItems) {
    return ListView.builder(
      itemCount: listItems.length,
      itemBuilder: (context, index) {
        final Map<String, dynamic> item = listItems[index];
        return buildItem(context, item, true);
      },
    );
  }

  Widget buildItemsGrid(BuildContext context, List<Map<String, dynamic>> gridItems) {
    return GridView.builder(
      itemCount: gridItems.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final Map<String, dynamic> item = gridItems[index];
        return buildItem(context, item, false);
      },
    );
  }

  Widget buildItem(BuildContext context, Map<String, dynamic> item, bool isInListView) {
    return InkWell(
      onTap: () {
        // Handle item tap
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
        child: isInListView ? buildItemDetailsRow(context, item) : buildItemDetailsColumn(context, item),
      ),
    );
  }

  Widget buildItemDetailsRow(BuildContext context, Map<String, dynamic> item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item['image'],
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.image_not_supported, size: 50),
            ),
          ),
        ),
        const SizedBox(width: 10,),
        buildItemInfoForList(context, item),
      ],
    );
  }

  Widget buildItemDetailsColumn(BuildContext context, Map<String, dynamic> item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item['image'],
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.image_not_supported, size: 50),
            ),
          ),
        ),
        const SizedBox(width: 10,),
        buildItemInfoForList(context, item),
      ],
    );
  }

  Widget buildItemInfoForList(BuildContext context, Map<String, dynamic> item) {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['name'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextTheme.of(context).bodyMedium
          ),
          Text(
            'SKU: ${item['sku']}',
            style: TextTheme.of(context).labelMedium,
          ),

          const SizedBox(height: 6),
          buildItemCategories(context, item['categories'] as List<String>),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${item['price']}',
                style: TextTheme.of(context).bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: item['stockCount'] > 10
                      ? Colors.green[200]
                      : Colors.red[200],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  item['stockCount'] > 0
                      ? 'Stock: ${item['stockCount']}'
                      : 'Out of stock',
                  style: TextTheme.of(context).labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildItemCategories(BuildContext context, List<String> categories) {
    return Container(
      height: 40,
      child: ListView.separated(
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final String category = categories[index];
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
      label: Text(
        category,
        style: TextTheme.of(context).labelMedium,
      ),
      visualDensity: VisualDensity.compact,
    );
  }
}
