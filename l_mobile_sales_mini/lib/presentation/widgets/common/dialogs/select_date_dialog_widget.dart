import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SelectDateDialogWidget extends StatelessWidget {
  const SelectDateDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height  * .5,
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        // color: Colors.white60,
          borderRadius: BorderRadius.circular(7)
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pick Date',
                style: TextTheme.of(context).bodyMedium,
              ),
              TextButton(
                onPressed: () => SmartDialog.dismiss(force: true),
                child: Text('Close', style: TextTheme.of(context).bodyMedium),
              )
            ],
          ),
          const SizedBox(height: 15),
          SfDateRangePicker(
            backgroundColor: Colors.grey[200],
            selectionColor: Colors.blue,
            selectionShape: DateRangePickerSelectionShape.circle,
            minDate: DateTime.now(),
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              final DateTime selectedDate = args.value;
              SmartDialog.dismiss(force: true, result: selectedDate);
            },
          ),
        ],
      ),
    );
  }
}
