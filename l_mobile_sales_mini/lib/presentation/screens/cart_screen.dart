import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  double discount = 0.0;
  bool isDiscountPercentage = false;

  @override
  void initState() {
    super.initState();
    selectedProduct = widget.product;
    selectedCustomer = widget.customer;
    quantity = widget.quantity!;
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customersProvider);
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add to Cart')),
      body: customersAsync.when(
        data: (customers) {
          return productsAsync.when(
            data: (products) {
              // Auto-select first available if nothing is passed
              selectedProduct ??= products.isNotEmpty ? products.first : null;
              selectedCustomer ??= customers.isNotEmpty ? customers.first : null;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (selectedProduct == null)
                      DropdownButton<Product>(
                        hint: const Text('Select Product'),
                        value: selectedProduct,
                        items: products
                            .map(
                              (p) => DropdownMenuItem(
                            value: p,
                            child: Text(p.name),
                          ),
                        )
                            .toList(),
                        onChanged: (p) => setState(() => selectedProduct = p),
                      )
                    else
                      Text('Product: ${selectedProduct!.name}'),

                    const SizedBox(height: 16),

                    if (selectedCustomer == null)
                      DropdownButton<Customer>(
                        hint: const Text('Select Customer'),
                        value: selectedCustomer,
                        items: customers
                            .map(
                              (c) => DropdownMenuItem(
                            value: c,
                            child: Text(c.name),
                          ),
                        )
                            .toList(),
                        onChanged: (c) => setState(() => selectedCustomer = c),
                      )
                    else
                      Text('Customer: ${selectedCustomer!.name}'),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        const Text('Quantity:'),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 60,
                          child: TextFormField(
                            initialValue: quantity.toString(),
                            keyboardType: TextInputType.number,
                            onChanged: (val) =>
                                setState(() => quantity = int.tryParse(val) ?? 1),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        const Text('Discount:'),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 80,
                          child: TextFormField(
                            initialValue: discount.toString(),
                            keyboardType: TextInputType.number,
                            onChanged: (val) =>
                                setState(() => discount = double.tryParse(val) ?? 0),
                          ),
                        ),
                        const SizedBox(width: 10),
                        DropdownButton<bool>(
                          value: isDiscountPercentage,
                          items: const [
                            DropdownMenuItem(value: false, child: Text('Amount')),
                            DropdownMenuItem(value: true, child: Text('%')),
                          ],
                          onChanged: (val) =>
                              setState(() => isDiscountPercentage = val ?? false),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedProduct != null && selectedCustomer != null) {
                            final cartItem = CartModel.create(
                              product: selectedProduct!,
                              customer: selectedCustomer!,
                              quantity: quantity,
                              discount: discount,
                              isDiscountPercentage: isDiscountPercentage,
                              orderTime: DateTime.now(),
                              deliveryDate:
                              DateTime.now().add(const Duration(days: 3)),
                            );

                            ref.read(cartProvider.notifier).addToCart(cartItem);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Added to cart!')),
                            );
                          }
                        },
                        child: const Text('Add to Cart'),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error loading products: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error loading customers: $e')),
      ),
    );
  }
}
