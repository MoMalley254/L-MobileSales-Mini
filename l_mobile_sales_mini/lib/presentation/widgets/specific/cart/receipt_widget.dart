import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:l_mobile_sales_mini/data/models/cart/cart_model.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/cart/letter_head_widget.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/cart/print_button_widget.dart';

class ReceiptWidget extends StatefulWidget {
  final CartModel cart;
  const ReceiptWidget({super.key, required this.cart});

  @override
  State<ReceiptWidget> createState() => _ReceiptWidgetState();
}

class _ReceiptWidgetState extends State<ReceiptWidget> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> productData = widget.cart.productData;
    return Center(
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LetterHeadWidget(),

            const SizedBox(height: 20),
            _dashedDivider(),

            const SizedBox(height: 20),

            Center(
              child: Column(
                children: [
                  Chip(
                    label: Text(
                      '#${widget.cart.orderId}',
                      style: TextTheme.of(context).bodyMedium,
                    ),
                    backgroundColor: Color(0xFFF1F3F5),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Issued: ${DateFormat('dd/MM/yyyy').format(widget.cart.orderTime)}',
                    style: TextTheme.of(context).labelMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            _dashedDivider(),

            const SizedBox(height: 20),

            ...widget.cart.products.map((product) {
              return _itemRow(
                title: product.name,
                subtitle:
                    'Qty: ${productData[product.id]['quantity']} x \$${product.price} ',
                price: '\$${productData[product.id]['totalsWithDiscount']} ',
              );
            }),
            const SizedBox(height: 16),

            const SizedBox(height: 20),
            _dashedDivider(),

            const SizedBox(height: 16),

            _totalRow('Discount', '\$${widget.cart.discount}'),
            const SizedBox(height: 10),

            const SizedBox(height: 16),
            const Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: TextTheme.of(context).labelMedium),
                Text(
                  '\$${widget.cart.totalPrice}',
                  style: TextTheme.of(context).bodyMedium,
                ),
              ],
            ),

            PrintButtonWidget(cart: widget.cart, isInvoice: false)
          ],
        ),
      ),
    );
  }

  Widget _itemRow({
    required String title,
    required String subtitle,
    required String price,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextTheme.of(context).bodyMedium),
              const SizedBox(height: 4),
              Text(subtitle, style: TextTheme.of(context).labelMedium),
            ],
          ),
        ),
        Text(price, style: TextTheme.of(context).bodyMedium),
      ],
    );
  }

  Widget _totalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextTheme.of(context).labelMedium),
        Text(value, style: TextTheme.of(context).bodyMedium),
      ],
    );
  }

  static Widget _dashedDivider() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: List.generate(
            (constraints.maxWidth / 10).floor(),
            (_) => Expanded(
              child: Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                color: const Color(0xFFE0E6ED),
              ),
            ),
          ),
        );
      },
    );
  }
}
