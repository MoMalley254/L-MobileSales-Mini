import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:l_mobile_sales_mini/data/models/cart/cart_model.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/cart/invoice_widget.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/cart/receipt_widget.dart';

class CartDocsDialogWidget extends StatelessWidget {
  final CartModel cart;
  final bool isInvoice;
  const CartDocsDialogWidget({super.key, required this.cart, required this.isInvoice});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height  * .9,
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        // color: Colors.white60,
          borderRadius: BorderRadius.circular(7)
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildHead(context),
            const SizedBox(height: 10,),
            isInvoice ? InvoiceWidget(cart: cart) : ReceiptWidget(cart: cart)
          ],
        ),
      )
    );
  }

  Widget buildHead(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Preview ${isInvoice ? 'Invoice' : 'Receipt'}',
          style: TextTheme.of(context).bodyMedium,
        ),
        TextButton(
          onPressed: () => SmartDialog.dismiss(force: true),
          child: Text('Close', style: TextTheme.of(context).bodyMedium),
        )
      ],
    );
  }
}
