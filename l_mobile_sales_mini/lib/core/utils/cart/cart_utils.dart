import 'dart:math';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:l_mobile_sales_mini/data/models/cart/cart_model.dart';
import 'package:l_mobile_sales_mini/data/models/products/product_model.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/common/dialogs/cart_docs_dialog_widget.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/common/dialogs/select_customer_dialog_widget.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/common/dialogs/select_product_dialog_widget.dart';

import '../../../data/models/customers/customer_model.dart';
import '../../../presentation/widgets/common/dialogs/select_date_dialog_widget.dart';

Future<Customer?> getCustomerFromDialog() async {
  final Customer? selected = await SmartDialog.show(
    builder: (_) => SelectCustomerDialogWidget(),
  );

  return selected;
}

Future<Product?> getProductFromDialog() async {
  final Product? selected = await SmartDialog.show(
    builder: (_) => SelectProductDialogWidget(),
  );

  return selected;
}

String generateOrderId() {
  final random = Random();
  final timePart = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
  final randomPart = random
      .nextInt(36 * 36 * 36)
      .toRadixString(36)
      .padLeft(3, '0');

  final id = (timePart + randomPart).toUpperCase();
  return id.length > 7 ? id.substring(id.length - 7) : id;
}

Future<DateTime?> getDateFromDialog() async {
  final DateTime? selected = await SmartDialog.show(
    builder: (_) => SelectDateDialogWidget(),
  );

  return selected;
}

Future<void> showCartDoc(CartModel cart, bool isInvoice) async {
  await SmartDialog.show(
    builder: (_) => CartDocsDialogWidget(cart: cart, isInvoice: isInvoice)
  );
}
