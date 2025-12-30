import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/common/dialogs/confirm_delete_dialog_widget.dart';

Future<bool?> confirmDelete(String title, String description) async {
  final bool? selected = await SmartDialog.show(
    builder: (_) => ConfirmDeleteDialogWidget(title: title, description: description),
  );

  return selected;
}