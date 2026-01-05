import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class ConfirmDeleteDialogWidget extends StatelessWidget {
  final String title;
  final String description;
  const ConfirmDeleteDialogWidget({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height  * .5,
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white60,
          borderRadius: BorderRadius.circular(7)
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextTheme.of(context).bodyMedium,
              ),
              TextButton(
                onPressed: () => SmartDialog.dismiss(force: true),
                child: Text('Close', style: TextTheme.of(context).bodyMedium),
              )
            ],
          ),
          const SizedBox(height: 15),
          buildDescription(context),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildConfirmButton(context, false),
              buildConfirmButton(context, true),
            ],
          )
        ],
      ),
    );
  }

  Widget buildDescription(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white
      ),
      child: Center(
        child: Text(
          description,
          style: TextTheme.of(context).bodyMedium
        ),
      ),
    );
  }

  Widget buildConfirmButton(BuildContext context, bool confirm) {
    return ElevatedButton(
        onPressed: () {
          SmartDialog.dismiss(force: true, result: confirm);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: confirm ? Colors.red : Colors.green
        ),
        child: Text(
          confirm ? 'Confirm' : 'Cancel',
          style: TextTheme.of(context).bodyMedium?.copyWith(
            color: Colors.white
          ),
        )
    );
  }
}
