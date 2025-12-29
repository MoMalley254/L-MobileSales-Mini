import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:l_mobile_sales_mini/data/models/products/product_model.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/common/dialogs/select_customer_dialog_widget.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/common/dialogs/select_product_dialog_widget.dart';

import '../../../data/models/customers/customer_model.dart';

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