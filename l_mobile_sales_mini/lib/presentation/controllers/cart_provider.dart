import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_mobile_sales_mini/data/models/cart/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

      // Check if the same product for same customer already exists
      final index = currentCart.indexWhere(
        (item) =>
            item.product.id == cartItem.product.id &&
            item.customer.id == cartItem.customer.id,
      );

      if (index >= 0) {
        // If exists, update quantity and recalculate totalPrice
        final existingItem = currentCart[index];
        final updatedQuantity = existingItem.quantity + cartItem.quantity;

        final updatedItem = CartModel.create(
          product: existingItem.product,
          customer: existingItem.customer,
          quantity: updatedQuantity,
          discount: existingItem.discount,
          isDiscountPercentage: existingItem.isDiscountPercentage,
          orderTime: existingItem.orderTime,
          deliveryDate: existingItem.deliveryDate,
        );

        currentCart[index] = updatedItem;
      } else {
        // If not exists, just add new item
        currentCart.add(cartItem);
      }

      state = AsyncValue.data(currentCart);
      await _persistCart();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> removeFromCart(CartModel cartItem) async {
    try {
      final List<CartModel> currentCart = [...(state.value ?? [])];
      currentCart.removeWhere(
        (item) =>
            item.product.id == cartItem.product.id &&
            item.customer.id == cartItem.customer.id,
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
