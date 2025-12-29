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
    return Container(

    );
  }
}
