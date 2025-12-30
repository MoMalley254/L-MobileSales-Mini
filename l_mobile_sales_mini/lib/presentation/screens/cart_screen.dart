import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:l_mobile_sales_mini/core/utils/cart/cart_utils.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/cart/cart_product_widget.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/cart/section_head.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/cart/selected_customer_widget.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/cart/selected_product_widget.dart';

import '../../core/navigation/route_names.dart';
import '../../core/utils/inventory/stock_utils.dart';
import '../../data/models/customers/customer_model.dart';
import '../../data/models/products/product_model.dart';
import '../../data/models/cart/cart_model.dart';
import '../controllers/cart_provider.dart';
import '../controllers/customers_provider.dart';
import '../controllers/products_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  final Product? product;
  final Customer? customer;
  final int? quantity;
  const CartScreen({super.key, this.product, this.customer, this.quantity});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  Customer? selectedCustomer;
  List<Product> selectedProducts = [];
  Map<String, dynamic> productTotals = {};
  Map<String, dynamic> productQuantities = {};

  double lineTotals = 0.0;
  double lineTotalsWithDiscounts = 0.0;
  double totalQuantities = 0;
  double totalDiscount = 0.0;

  DateTime deliveryDate = DateTime.now();

  void addProduct(Product product) {
    setState(() {
      if (!selectedProducts.any((p) => p.id == product.id)) {
        selectedProducts.add(product);
        productTotals[product.id] = {
          'totals': product.price,
          'discount': 0.0,
          'totalsWithDiscount': 0.0,
        };
        productQuantities[product.id] = {'quantity': 1};
      }
    });
  }

  void removeProduct(Product product) {
    setState(() {
      selectedProducts.remove(product);
      productTotals.removeWhere((productId, _) => productId == product.id);
      productQuantities.removeWhere((productId, _) => productId == product.id);
    });
  }

  void confirmProduct(
    Product product,
    int quantity,
    double totals,
    double discount,
    double totalsWithDiscount,
  ) {
    productTotals[product.id] = {
      'totals': totals,
      'discount': discount,
      'totalsWithDiscount': discount > 0 ? totalsWithDiscount : totals,
    };
    productQuantities[product.id] = {'quantity': quantity.toDouble()};

    getTotals();
  }

  double getLineTotals() {
    return productTotals.values.fold(0, (sum, item) => sum + item['totals']);
  }

  double getTotalDiscounts() {
    return productTotals.values.fold(0, (sum, item) => sum + item['discount']);
  }

  double getLineTotalsWithDiscounts() {
    return productTotals.values.fold(0, (sum, item) => sum + item['totalsWithDiscount']);
  }

  double getQuantityTotals() {
    return productQuantities.values.fold(0, (sum, item) => sum + item['quantity']);
  }

  void getTotals() {
    setState(() {
      lineTotals = getLineTotals();
      totalDiscount = getTotalDiscounts();
      lineTotalsWithDiscounts = getLineTotalsWithDiscounts();
      totalQuantities = getQuantityTotals();
    });
  }

  Future<void> updateDeliveryDate() async{
    DateTime? selectedDate = await getDateFromDialog();
    if (selectedDate != null) {
      setState(() {
        deliveryDate = selectedDate;
      });
    }
  }

  void doProceed() async {
    final Map<String, Map<String, dynamic>> productData = {};

    for (final id in productTotals.keys) {
      productData[id] = {
        ...productTotals[id]!,
        ...productQuantities[id]!,
      };
    }

    final cartItem = CartModel.create(
      products: selectedProducts,
      customer: selectedCustomer!,
      quantity: totalQuantities.toInt(),
      discount: totalDiscount,
      isDiscountPercentage: false,
      orderTime: DateTime.now(),
      deliveryDate: deliveryDate,
      productData: productData
    );

    await ref.read(cartProvider.notifier).addToCart(cartItem);
  }

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      selectedProducts.add(widget.product!);
      productTotals[widget.product!.id] = {
        'totals': widget.product!.price,
        'discount': 0.0,
        'totalsWithDiscount': 0.0,
      };
      productQuantities[widget.product!.id] = {
        'quantity': widget.quantity ?? 1,
      };
    }

    selectedCustomer = widget.customer;
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customersProvider);
    final productsAsync = ref.watch(productsProvider);

    return customersAsync.when(
      data: (customers) {
        return productsAsync.when(
          data: (products) {
            return buildCartBody(context, customersAsync, productsAsync);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error loading products: $e')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error loading customers: $e')),
    );
  }

  Widget buildCartBody(
    BuildContext context,
    AsyncValue<List<Customer>> customersAsync,
    AsyncValue<List<Product>> productsAsync,
  ) {
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      width: double.infinity,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(context),
            const SizedBox(height: 10),
            buildActions(context),
            buildCustomers(context, customersAsync),
            buildProducts(context, productsAsync),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Text(
      'Add To Cart',
      style: TextTheme.of(context).bodyLarge,
      textAlign: TextAlign.center,
    );
  }

  Widget buildActions(BuildContext context) {
    return lineTotals < 1 && totalQuantities < 1
        ? SizedBox.shrink()
        : Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(7),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[400]!,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                buildTotalsRow(context, 'SUB TOTAL', lineTotals),
                buildTotalsRow(context, 'Discount', totalDiscount),
                buildTotalsRow(context, 'Quantity', totalQuantities),
                lineTotalsWithDiscounts < 1
                    ? buildTotalsRow(context, 'TOTAL', lineTotalsWithDiscounts)
                    : SizedBox.shrink(),
                buildDeliveryDate(context),
                buildProceedButton(context)
              ],
            ),
          );
  }

  Widget buildTotalsRow(BuildContext context, String label, double value) {
    return RichText(
      text: TextSpan(
        style: TextTheme.of(context).labelMedium,
        children: [
          TextSpan(text: '$label: '),
          TextSpan(
            text: value.toStringAsFixed(2),
            style: TextTheme.of(context).bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget buildDeliveryDate(BuildContext context) {
    final String formattedDate = DateFormat('dd/MM/yyyy').format(deliveryDate);
    return TextButton.icon(
      onPressed: updateDeliveryDate,
      label: RichText(
        text: TextSpan(
            style: TextTheme.of(context).labelMedium,
            children: [
              TextSpan(text: 'Delivery Date: '),
              TextSpan(
                  text: formattedDate, style: TextTheme.of(context).bodyMedium)
            ]
        ),
      ),
      icon: Icon(
        Icons.edit,
        size: 20,
        color: Colors.redAccent,
      ),
    );
  }

  Widget buildProceedButton(BuildContext context) {
    return InkWell(
      onTap: () {
        doProceed();
        GoRouter.of(context).go(RouteNames.checkoutRoute);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.green[500],
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [
            Icon(Icons.add_shopping_cart, size: 20),
            const SizedBox(width: 5),
            Text(
              'Proceed',
              style: TextTheme.of(
                context,
              ).bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCustomers(
    BuildContext context,
    AsyncValue<List<Customer>> customersAsync,
  ) {
    return Container(
      // height: MediaQuery.of(context).size.height * .5,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400]!,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: selectedCustomer != null
          ? buildSelectedCustomer(context, customersAsync)
          : buildNoCustomersSelected(context, customersAsync),
    );
  }

  Widget buildSelectedCustomer(
    BuildContext context,
    AsyncValue<List<Customer>> customersAsync,
  ) {
    return Column(
      children: [
        SectionHead(title: 'Customer:'),
        const SizedBox(height: 5),
        SelectedCustomerWidget(customer: selectedCustomer!, showFullDetails: true,),
        buildSelectCustomerButton(context),
      ],
    );
  }

  Widget buildNoCustomersSelected(
    BuildContext context,
    AsyncValue<List<Customer>> customersAsync,
  ) {
    return Column(
      children: [
        Text(
          'No Customer selected, please select a customer by clicking the button below',
          style: TextTheme.of(context).labelMedium,
        ),
        const SizedBox(height: 5),
        buildSelectCustomerButton(context),
      ],
    );
  }

  Widget buildSelectCustomerButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final customer = await getCustomerFromDialog();
        if (customer != null) {
          setState(() => selectedCustomer = customer);
        }
      },
      icon: Icon(Icons.edit, size: 20, color: Colors.green),
      label: Text('Select Customer', style: TextTheme.of(context).bodyMedium),
    );
  }

  Widget buildProducts(
    BuildContext context,
    AsyncValue<List<Product>> productsAsync,
  ) {
    return Container(
      // height: MediaQuery.of(context).size.height * .5,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400]!,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: selectedProducts.isNotEmpty
          ? buildSelectedProduct(context, productsAsync)
          : buildNoProductsSelected(context, productsAsync),
    );
  }

  Widget buildSelectedProduct(
    BuildContext context,
    AsyncValue<List<Product>> productsAsync,
  ) {
    return Column(
      children: [
        buildSelectedProducts(context),
        buildSelectProductButton(context),
      ],
    );
  }

  Widget buildNoProductsSelected(
    BuildContext context,
    AsyncValue<List<Product>> productsAsync,
  ) {
    return Column(
      children: [
        Text(
          'No product selected, please select a product by clicking the button below',
          style: TextTheme.of(context).labelMedium,
        ),
        const SizedBox(height: 5),
        buildSelectProductButton(context),
      ],
    );
  }

  Widget buildSelectProductButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final product = await getProductFromDialog();
        if (product != null) {
          addProduct(product);
        }
      },
      icon: Icon(Icons.edit, size: 20, color: Colors.green),
      label: Text('Select Product', style: TextTheme.of(context).bodyMedium),
    );
  }

  Widget buildSelectedProducts(BuildContext context) {
    return Column(
      children: [
        ...selectedProducts.map(
          (product) => CartProductWidget(
            product: product,
            customer: selectedCustomer!,
            onRemove: removeProduct,
            onConfirm: confirmProduct,
          ),
        ),
      ],
    );
  }
}
