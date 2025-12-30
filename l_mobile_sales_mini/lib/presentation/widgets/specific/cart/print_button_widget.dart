import 'package:flutter/material.dart';
import 'package:l_mobile_sales_mini/data/models/cart/cart_model.dart';

class PrintButtonWidget extends StatefulWidget {
  final CartModel cart;
  final bool isInvoice;
  const PrintButtonWidget({super.key, required this.cart, required this.isInvoice});

  @override
  State<PrintButtonWidget> createState() => _PrintButtonWidgetState();
}

class _PrintButtonWidgetState extends State<PrintButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .8,
      child: Center(
        child: ElevatedButton.icon(
            onPressed: () {
              //Do print
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white
            ),
            label: Text(
              'Print ${widget.isInvoice ? 'Invoice' : 'Receipt'}',
              style: TextTheme.of(context).bodyMedium?.copyWith(
                  color: Colors.white
              ),
            ),
            icon: Icon(
              Icons.print,
              size: 25,
            )
        ),
      ),
    );
  }
}
