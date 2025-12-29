import 'package:l_mobile_sales_mini/core/utils/cart/cart_utils.dart';
import 'package:l_mobile_sales_mini/data/models/customers/customer_model.dart';
import 'package:l_mobile_sales_mini/data/models/products/product_model.dart';

class CartModel {
  String orderId;
  final List<Product> products;
  final Customer customer;
  final int quantity;
  final double discount;
  final bool isDiscountPercentage;
  final double totalPrice;
  final DateTime orderTime;
  final DateTime deliveryDate;

  CartModel({
    required this.orderId,
    required this.products,
    required this.customer,
    required this.quantity,
    required this.discount,
    this.isDiscountPercentage = false,
    required this.totalPrice,
    required this.orderTime,
    required this.deliveryDate,
  });

  factory CartModel.create({
    required List<Product> products,
    required Customer customer,
    required int quantity,
    required double discount,
    bool isDiscountPercentage = false,
    required DateTime orderTime,
    required DateTime deliveryDate,
  }) {
    final String id = generateOrderId();
    final double priceBeforeDiscount =
        products.fold(0.0, (sum, p) => sum + p.price) * quantity;

    final double totalPrice = isDiscountPercentage
        ? priceBeforeDiscount * (1 - discount / 100)
        : priceBeforeDiscount - discount;

    return CartModel(
      orderId: id,
      products: products,
      customer: customer,
      quantity: quantity,
      discount: discount,
      isDiscountPercentage: isDiscountPercentage,
      totalPrice: totalPrice,
      orderTime: orderTime,
      deliveryDate: deliveryDate,
    );
  }

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'products': products.map((p) => p.toJson()).toList(),
    'customer': customer.toJson(),
    'quantity': quantity,
    'discount': discount,
    'is_discount_percentage': isDiscountPercentage,
    'total_price': totalPrice,
    'order_time': orderTime.toIso8601String(),
    'delivery_date': deliveryDate.toIso8601String(),
  };

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    orderId: json['orderId'],
    products: (json['products'] as List)
        .map((e) => Product.fromJson(e))
        .toList(),
    customer: Customer.fromJson(json['customer']),
    quantity: json['quantity'],
    discount: (json['discount'] as num).toDouble(),
    isDiscountPercentage: json['is_discount_percentage'] ?? false,
    totalPrice: (json['total_price'] as num).toDouble(),
    orderTime: DateTime.parse(json['order_time']),
    deliveryDate: DateTime.parse(json['delivery_date']),
  );
}
