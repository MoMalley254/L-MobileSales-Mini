import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_mobile_sales_mini/data/models/cart/cart_model.dart';

import '../controllers/cart_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  late String orderId;

  String generateOrderId() {
    return 'A9F3K2Q';
  }

  @override
  void initState() {
    super.initState();
    orderId = generateOrderId();
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

  Widget buildCheckoutBody(BuildContext context, AsyncValue<List<CartModel>> cartAsync) {
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
            cart.isEmpty ? buildEmptyCart(context) : buildCart(context, cart)

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
      child: Text(
        'No items in cart',
        style: TextTheme.of(context).bodyMedium,
      ),
    );
  }

  Widget buildCart(BuildContext context, List<CartModel> cart) {
    return Column(
      children: [
        buildOrderId(context),
        const SizedBox(height: 10,),
      ],
    );
  }

  Widget buildOrderId(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          style: TextTheme.of(context).labelMedium,
        children: [
          TextSpan(text: 'Order ID: '),
          TextSpan(
            text: orderId,
            style: TextTheme.of(context).bodyMedium,
          )
        ]
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
