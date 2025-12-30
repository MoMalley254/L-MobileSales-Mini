import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:l_mobile_sales_mini/data/models/cart/cart_model.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/cart/letter_head_widget.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/cart/print_button_widget.dart';

class InvoiceWidget extends StatefulWidget {
  final CartModel cart;
  const InvoiceWidget({super.key, required this.cart});

  @override
  State<InvoiceWidget> createState() => _InvoiceWidgetState();
}

class _InvoiceWidgetState extends State<InvoiceWidget> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> productData = widget.cart.productData;

    return Center(
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LetterHeadWidget(),

              const SizedBox(height: 12),

              Center(
                child: Column(
                  children: [
                    Chip(
                      label: Text('#${widget.cart.orderId}', style: TextTheme.of(context).bodyMedium,),
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
              const Divider(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BILL TO',
                        style: TextTheme.of(context).labelMedium,
                      ),
                      SizedBox(height: 6),
                      Text(
                        widget.cart.customer.name,
                        style: TextTheme.of(context).bodyMedium,
                      ),
                      Text(
                        widget.cart.customer.id,
                        style: TextTheme.of(context).labelMedium,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.green, size: 18),
                      SizedBox(width: 4),
                      Text(
                        widget.cart.customer.category,
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                'ITEMS PURCHASED',
                style: TextTheme.of(context).labelMedium,
              ),

              const SizedBox(height: 12),

              ...widget.cart.products.map((product) {
                return _itemRow(
                    title: product.name,
                    subtitle: product.sku,
                    price: productData[product.id]['totalsWithDiscount'],
                    quantity: productData[product.id]['quantity'],
                    image: product.images.first
                );
              }),

              const SizedBox(height: 12),

              const SizedBox(height: 20),
              const Divider(),

              _totalRow('Subtotal', '\$${widget.cart.totalPrice}'),
              const SizedBox(height: 8),
              _totalRow(
                'Discount',
                '-\$${widget.cart.discount}',
                valueColor: Colors.green,
              ),

              const SizedBox(height: 16),
              const Divider(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Grand Total',
                    style: TextTheme.of(context).labelMedium,
                  ),
                  Text(
                    '\$${widget.cart.totalPrice}',
                    style: TextTheme.of(context).bodyMedium,
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(),

              PrintButtonWidget(cart: widget.cart, isInvoice: true,)
            ],
          ),
        )
      ),
    );
  }

  Widget _itemRow({
    required String title,
    required String subtitle,
    required double price,
    required double quantity,
    required String image,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFFF1F3F5),
          child: Image.network(
            // image,
            'https://picsum.photos/400/300?1',  //Sample image
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          )
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextTheme.of(context).bodyMedium
              ),
              const SizedBox(height: 4),
              Text(
                'SKU: $subtitle',
                style: TextTheme.of(context).labelMedium
              ),

              Text(
                  '\$ ${price.toStringAsFixed(2)}',
                  style: TextTheme.of(context).bodyMedium
              ),

              Text(
                  'Qty: ${quantity.toStringAsFixed(0)}',
                  style: TextTheme.of(context).labelMedium
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _totalRow(
      String label,
      String value, {
        Color valueColor = Colors.black,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}