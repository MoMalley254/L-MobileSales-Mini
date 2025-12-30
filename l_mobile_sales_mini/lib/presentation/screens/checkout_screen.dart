import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:l_mobile_sales_mini/data/models/cart/cart_model.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/cart/selected_customer_widget.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/cart/selected_product_widget.dart';

import '../controllers/cart_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {

  Future<void> deleteCartItem(CartModel cart) async {
    await ref.read(cartProvider.notifier).removeFromCart(cart);

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartAsync = ref.watch(cartProvider);

    return cartAsync.when(
      data: (cart) {
        return buildCheckoutBody(context, cartAsync);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error loading cart: $e')),
    );
  }

  Widget buildCheckoutBody(
    BuildContext context,
    AsyncValue<List<CartModel>> cartAsync,
  ) {
    final List<CartModel> cart = cartAsync.value ?? [];

    return Container(
      height: MediaQuery.of(context).size.height * 1,
      width: double.infinity,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(context),
            const SizedBox(height: 10),
            cart.isEmpty ? buildEmptyCart(context) : buildCart(context, cart),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Text(
      'Checkout',
      style: TextTheme.of(context).bodyLarge,
      textAlign: TextAlign.center,
    );
  }

  Widget buildEmptyCart(BuildContext context) {
    return Center(
      child: Text('No items in cart', style: TextTheme.of(context).bodyMedium),
    );
  }

  Widget buildCart(BuildContext context, List<CartModel> cartList) {
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: ListView.builder(
        itemCount: cartList.length,
        itemBuilder: (context, index) {
          final CartModel cart = cartList[index];
          return buildSingleCart(context, cart);
        },
      ),
    );
  }

  Widget buildSingleCart(BuildContext context, CartModel cart) {
    final Map<String, dynamic> productData = cart.productData;

    print('Product data $productData');
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400]!,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          buildCartHead(context, cart),
          const SizedBox(height: 10),
          buildPricing(
            context,
            cart.totalPrice,
            cart.discount,
            cart.quantity,
            cart.deliveryDate,
            cart.orderTime,
          ),
          const SizedBox(height: 5),
          SelectedCustomerWidget(customer: cart.customer, showFullDetails: false),
          const SizedBox(height: 5),
          ...cart.products.map(
            (product) => SelectedProductWidget(
                product: product,
              showFullDetails: false,
              productData: productData[product.id],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCartHead(BuildContext context, CartModel cart) {
    return Row(
      children: [
        buildOrderId(context, cart.orderId),
        buildDeleteCartButton(context, cart)
      ],
    );
  }

  Widget buildDeleteCartButton(BuildContext context, CartModel cart) {
    return IconButton.filled(
        onPressed: () => deleteCartItem(cart),
        icon: Icon(
          Icons.delete,
          size: 25,
          color: Colors.red,
        )
    );
  }

  Widget buildOrderId(BuildContext context, String orderId) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextTheme.of(context).labelMedium,
        children: [
          TextSpan(text: 'Order #: '),
          TextSpan(text: orderId, style: TextTheme.of(context).bodyMedium),
        ],
      ),
    );
  }

  Widget buildPricing(
    BuildContext context,
    double totalPrice,
    double discount,
    int quantity,
    DateTime deliveryDate,
    DateTime orderDate,
  ) {
    return Column(
      children: [
        buildPricingText(context, 'TOTAL', totalPrice),
        buildPricingText(context, 'Discount', discount),
        buildPricingText(context, 'Quantity', quantity.toDouble()),
        buildDate(context, 'DELIVERY DATE', deliveryDate),
        buildDate(context, 'ORDER DATE', orderDate),
      ],
    );
  }

  Widget buildPricingText(BuildContext context, String label, double value) {
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

  Widget buildDate(BuildContext context, String label, DateTime date) {
    final String formattedDate = DateFormat('dd/MM/yyyy').format(date);
    return RichText(
      text: TextSpan(
        style: TextTheme.of(context).labelMedium,
        children: [
          TextSpan(text: '$label: '),
          TextSpan(
            text: formattedDate,
            style: TextTheme.of(context).bodyMedium,
          ),
        ],
      ),
    );
  }


  // Widget buildActions(BuildContext context) {
  //   return selectedCustomer == null || selectedProduct == null
  //       ? SizedBox.shrink()
  //       : Container(
  //     width: double.infinity,
  //     margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  //     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).colorScheme.primary,
  //       borderRadius: BorderRadius.circular(7),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey[400]!,
  //           blurRadius: 4,
  //           offset: Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         buildQuantitySelection(context),
  //         const SizedBox(height: 5),
  //         buildDiscountSelection(context),
  //         const SizedBox(height: 5),
  //         buildTotals(context),
  //       ],
  //     ),
  //   );
  // }
}
