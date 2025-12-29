import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_mobile_sales_mini/core/utils/cart/cart_utils.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/cart/selected_customer_widget.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/cart/selected_product_widget.dart';

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
  Product? selectedProduct;
  int quantity = 1;
  int maxQty = 99;
  double discount = 0.0;
  bool isDiscountPercentage = false;
  double lineTotals = 0.00;
  double lineTotalsWithDiscount = 0.00;
  final TextEditingController _cartQtyController = TextEditingController();

  void updateCartQty(bool increase) {
    setState(() {
      quantity = increase ? quantity + 1 : quantity - 1;
      quantity = quantity.clamp(0, maxQty);

      _cartQtyController.text = quantity.toString();
    });

    doTotals();
  }

  void setCartQty() {
    setState(() {
      quantity = int.tryParse(_cartQtyController.text) ?? 0;
      quantity = quantity.clamp(0, maxQty);

      _cartQtyController.text = quantity.toString();
    });

    doTotals();
  }

  void doTotals() {
    double newLineTotals = selectedProduct!.price * quantity;
    double newLineTotalsWithDiscount = getTotalsAfterDiscount(newLineTotals);

    setState(() {
      lineTotals = newLineTotals;
      lineTotalsWithDiscount = newLineTotalsWithDiscount;
    });
  }

  double getTotalsAfterDiscount(double newLineTotals) {
    if (isDiscountPercentage) {
      double discounted = selectedProduct!.price * (discount / 100);
      setState(() {
        discount = discounted;
      });
      return newLineTotals - discounted;
    } else {
      return newLineTotals - discount;
    }
  }

  void doProceed() async {
    final CartModel cartItem = CartModel.create(
        product: selectedProduct!,
        customer: selectedCustomer!,
        quantity: quantity,
        discount: discount,
        orderTime: DateTime.now(),
        deliveryDate: DateTime.now(),
    );

    final cartNotifier = ref.read(cartProvider.notifier);
    await cartNotifier.addToCart(cartItem);
  }

  @override
  void initState() {
    super.initState();
    selectedProduct = widget.product;
    selectedCustomer = widget.customer;
    quantity = (widget.quantity ?? 1);
    _cartQtyController.text = quantity.toString();
    maxQty = (widget.product != null
        ? getItemStockTotals(widget.product!.stock)
        : 99);
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customersProvider);
    final productsAsync = ref.watch(productsProvider);
    final cartAsync = ref.watch(cartProvider);

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

  Widget buildActions(BuildContext context) {
    return selectedCustomer == null || selectedProduct == null
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
                buildQuantitySelection(context),
                const SizedBox(height: 5),
                buildDiscountSelection(context),
                const SizedBox(height: 5),
                buildTotals(context),
              ],
            ),
          );
  }

  Widget buildQuantitySelection(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 2, child: buildQuantitySection(context)),
        const SizedBox(width: 10),
        Expanded(flex: 2, child: buildProceedButton(context)),
      ],
    );
  }

  Widget buildQuantitySection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        children: [
          buildMaxQtyLabel(context),
          Row(
            children: [
              buildQuantityButton(context, false),
              buildQuantityInput(context),
              buildQuantityButton(context, true),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildMaxQtyLabel(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextTheme.of(context).labelMedium,
        children: [
          TextSpan(text: 'Available : '),
          TextSpan(
            text: maxQty.toString(),
            style: TextTheme.of(
              context,
            ).labelMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildQuantityButton(BuildContext context, bool increase) {
    return IconButton(
      onPressed: () => updateCartQty(increase),
      icon: Icon(
        increase ? Icons.add : Icons.remove,
        size: 20,
        color: Colors.black,
      ),
    );
  }

  Widget buildQuantityInput(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Center(
        child: TextFormField(
          controller: _cartQtyController,
          onChanged: (String? value) {
            setCartQty();
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintStyle: TextTheme.of(context).bodyMedium,
            filled: true,
            fillColor: Theme.of(context).appBarTheme.backgroundColor,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          ),
        ),
      ),
    );
  }

  Widget buildProceedButton(BuildContext context) {
    return InkWell(
      onTap: doProceed,
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

  Widget buildTotals(BuildContext context) {
    return Column(
      children: [buildTotalsRow(context), buildTotalsWithDiscount(context)],
    );
  }

  Widget buildTotalsRow(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextTheme.of(context).labelMedium,
        children: [
          TextSpan(text: 'TOTAL: '),
          TextSpan(
            text: lineTotals.toStringAsFixed(2),
            style: TextTheme.of(context).bodyMedium,
          ),
          TextSpan(
            text: ' TAX: (${selectedProduct!.taxRate.toStringAsFixed(1)})',
            style: TextTheme.of(
              context,
            ).labelMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildDiscountSelection(BuildContext context) {
    return Row(
      children: [
        const Text('Discount:'),
        const SizedBox(width: 10),
        SizedBox(
          width: 80,
          child: TextFormField(
            initialValue: discount.toString(),
            keyboardType: TextInputType.number,
            onChanged: (val) {
              setState(() => discount = double.tryParse(val) ?? 0);
              doTotals();
            },
          ),
        ),
        const SizedBox(width: 10),
        DropdownButton<bool>(
          value: isDiscountPercentage,
          items: const [
            DropdownMenuItem(value: false, child: Text('Amount')),
            DropdownMenuItem(value: true, child: Text('%')),
          ],
          onChanged: (val) {
            setState(() => isDiscountPercentage = val ?? false);
            doTotals();
          },
        ),
      ],
    );
  }

  Widget buildTotalsWithDiscount(BuildContext context) {
    String symbol = isDiscountPercentage ? '%' : '';
    return lineTotalsWithDiscount < 1
        ? SizedBox.shrink()
        : RichText(
            text: TextSpan(
              style: TextTheme.of(context).labelMedium,
              children: [
                TextSpan(text: 'TOTAL AFTER DISCOUNT: '),
                TextSpan(
                  text: lineTotalsWithDiscount.toStringAsFixed(2),
                  style: TextTheme.of(context).bodyMedium,
                ),
                TextSpan(
                  text: '(Discount: $discount$symbol)',
                  style: TextTheme.of(
                    context,
                  ).labelMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
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

  Widget buildSectionHead(BuildContext context, String title) {
    return Text(
      title,
      style: TextTheme.of(context).labelMedium,
      textAlign: TextAlign.center,
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
        buildSectionHead(context, 'Customer:'),
        const SizedBox(height: 5),
        SelectedCustomerWidget(customer: selectedCustomer!),
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
      child: selectedProduct != null
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
        buildSectionHead(context, 'Product:'),
        SelectedProductWidget(product: selectedProduct!),
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
          setState(() {
            selectedProduct = product;
            maxQty = getItemStockTotals(product.stock);
          });
        }
      },
      icon: Icon(Icons.edit, size: 20, color: Colors.green),
      label: Text('Select Product', style: TextTheme.of(context).bodyMedium),
    );
  }
}
