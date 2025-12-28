import 'package:l_mobile_sales_mini/data/models/customers/customer_model.dart';
import 'package:l_mobile_sales_mini/data/models/products/product_model.dart';

class CartModel {
  final Product product;
  final Customer customer;
  final int quantity;
  final double discount;
  final bool isDiscountPercentage;
  final double totalPrice;
  final DateTime orderTime;
  final DateTime deliveryDate;

  CartModel({
    required this.product,
    required this.customer,
    required this.quantity,
    required this.discount,
    this.isDiscountPercentage = false,
    required this.totalPrice,
    required this.orderTime,
    required this.deliveryDate,
  });

  factory CartModel.create({
    required Product product,
    required Customer customer,
    required int quantity,
    required double discount,
    bool isDiscountPercentage = false,
    required DateTime orderTime,
    required DateTime deliveryDate,
  }) {
    double priceBeforeDiscount = product.price * quantity;
    double totalPrice;

    if (isDiscountPercentage) {
      totalPrice = priceBeforeDiscount * (1 - discount / 100);
    } else {
      totalPrice = priceBeforeDiscount - discount;
    }

    return CartModel(
      product: product,
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
    'product': product.toJson(),
    'customer': customer.toJson(),
    'quantity': quantity,
    'discount': discount,
    'is_discount_percentage': isDiscountPercentage,
    'total_price': totalPrice,
    'order_time': orderTime.toIso8601String(),
    'delivery_date': deliveryDate.toIso8601String(),
  };

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    product: Product.fromJson(json['product']),
    customer: Customer.fromJson(json['customer']),
    quantity: json['quantity'],
    discount: (json['discount'] as num).toDouble(),
    isDiscountPercentage: json['is_discount_percentage'] ?? false,
    totalPrice: (json['total_price'] as num).toDouble(),
    orderTime: DateTime.parse(json['order_time']),
    deliveryDate: DateTime.parse(json['delivery_date']),
  );
}
