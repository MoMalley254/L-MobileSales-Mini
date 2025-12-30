import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_mobile_sales_mini/data/models/cart/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/products/product_model.dart';

final cartProvider = AsyncNotifierProvider<CartNotifier, List<CartModel>>(
  CartNotifier.new,
);

class CartNotifier extends AsyncNotifier<List<CartModel>> {
  @override
  Future<List<CartModel>> build() async {
    return await getCartFromStored();
  }

  Future<List<CartModel>> getCartFromStored() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String savedJson = prefs.getString('cart_key') ?? '';
      if (savedJson.isNotEmpty) {
        final List<dynamic> jsonList = json.decode(savedJson);
        return jsonList.map((json) => CartModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return [];
    }
  }

  Future<void> addToCart(CartModel cartItem) async {
    try {
      final List<CartModel> currentCart = [...(state.value ?? [])];

      // Find existing cart item with same customer & same products
      final index = currentCart.indexWhere(
        (item) =>
            item.customer.id == cartItem.customer.id &&
            _sameProducts(item.products, cartItem.products),
      );

      if (index >= 0) {
        final existingItem = currentCart[index];
        final updatedQuantity = existingItem.quantity + cartItem.quantity;

        final updatedItem = CartModel.create(
          products: existingItem.products,
          customer: existingItem.customer,
          quantity: updatedQuantity,
          discount: existingItem.discount,
          isDiscountPercentage: existingItem.isDiscountPercentage,
          orderTime: existingItem.orderTime,
          deliveryDate: existingItem.deliveryDate,
          productData: existingItem.productData
        );

        currentCart[index] = updatedItem;
      } else {
        currentCart.add(cartItem);
      }

      state = AsyncValue.data(currentCart);
      await _persistCart();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  bool _sameProducts(List<Product> a, List<Product> b) {
    if (a.length != b.length) return false;

    final aIds = a.map((p) => p.id).toList()..sort();
    final bIds = b.map((p) => p.id).toList()..sort();

    for (int i = 0; i < aIds.length; i++) {
      if (aIds[i] != bIds[i]) return false;
    }
    return true;
  }

  Future<void> removeFromCart(CartModel cartItem) async {
    try {
      final List<CartModel> currentCart = [...(state.value ?? [])];

      currentCart.removeWhere(
        (item) =>
            item.customer.id == cartItem.customer.id &&
            _sameProducts(item.products, cartItem.products),
      );

      state = AsyncValue.data(currentCart);
      await _persistCart();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> clearCart() async {
    try {
      state = const AsyncValue.data([]);
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cart_key');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> _persistCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<dynamic> jsonList = state.value!
          .map((item) => item.toJson())
          .toList();
      await prefs.setString('cart_key', json.encode(jsonList));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
