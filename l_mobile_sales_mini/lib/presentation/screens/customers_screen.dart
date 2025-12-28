import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_mobile_sales_mini/data/models/customers/customer_model.dart';
import 'package:l_mobile_sales_mini/presentation/controllers/customers_provider.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/customers/customer_widget.dart';

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  final TextEditingController _searchController = TextEditingController();
  final String searchHint = "Search by name ...";

  bool shouldFilter = false;
  Map<String, dynamic> activeFilter = {};
  List<Map<String, dynamic>> fixedFilters = [];

  List<String> getAvailableCategories(List<Customer> customers) {
    final Set<String> categories = {};
    for (final customer in customers) {
      categories.add(customer.category);
    }
    return categories.toList();
  }

  List<String> getAvailableTypes(List<Customer> customers) {
    final Set<String> types = {};
    for (final customer in customers) {
      types.add(customer.type);
    }
    return types.toList();
  }

  List<String> getAvailableFrequencies(List<Customer> customers) {
    final Set<String> frequencies = {};
    for (final customer in customers) {
      frequencies.add(customer.orderFrequency);
    }

    return frequencies.toList();
  }

  List<Customer> _getFilteredCustomers(List<Customer> allCustomers) {
    // 1. Filter by search text
    final String searchText = _searchController.text.toLowerCase();
    final List<Customer> searchedCustomers = searchText.isEmpty
        ? allCustomers
        : allCustomers.where((p) {
      return p.name.toLowerCase().contains(searchText);
    }).toList();

    // 2. Filter by active filter
    final filterName = activeFilter['name'];
    if (filterName == 'All') {
      return searchedCustomers;
    } else if (filterName == 'Category') {
      return searchedCustomers
          .where((p) => p.category == activeFilter['name'])
          .toList();
    } else if (filterName == 'Type') {
      return searchedCustomers
          .where((p) => p.type == activeFilter['name'])
          .toList();
    } else if (filterName == 'Frequency') {
      return searchedCustomers
          .where((p) => p.orderFrequency == activeFilter['name'])
          .toList();
    }

    return searchedCustomers;
  }

  @override
  void initState() {
    super.initState();
    activeFilter = {'name': 'All', 'filters': []};
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customersProvider);
    ref.listen<AsyncValue<List<Customer>>>(customersProvider, (_, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error.toString())));
      }

      final allCustomers = customersAsync.value ?? [];

      fixedFilters = [
        {'name': 'All',},
        {'name': 'Category', 'filters': getAvailableCategories(allCustomers)},
        {'name': 'Type', 'filters': getAvailableTypes(allCustomers)},
        {'name': 'Frequency', 'filters': getAvailableFrequencies(allCustomers)}
      ];
    });

    return buildCustomersBody(context, customersAsync);
  }

  Widget buildCustomersBody(BuildContext context, AsyncValue<List<Customer>> customersAsync) {
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      width: double.infinity,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildSearch(context),
            const SizedBox(height: 10),
            buildFixedFilters(context),
            const SizedBox(height: 20),
            buildAllCustomers(context, customersAsync),
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
      // onTap: () => doFilter(filter),
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
          ],
        ),
      ),
    );
  }

  Widget buildAllCustomers(
      BuildContext context,
      AsyncValue<List<Customer>> buildAllCustomers,
      ) {
    return buildAllCustomers.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (customers) {
        final filteredItems = _getFilteredCustomers(customers);

        if (filteredItems.isEmpty) {
          return buildNoItems(context);
        }
        return buildCustomersContainer(context, filteredItems);
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

  Widget buildCustomersContainer(BuildContext context, List<Customer> customers) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 1,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: buildCustomersList(context, customers),
    );
  }

  Widget buildCustomersList(BuildContext context, List<Customer> customers) {
    return ListView.builder(
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final Customer customer = customers[index];
        return CustomerWidget(customer: customer);
      },
    );
  }
}
