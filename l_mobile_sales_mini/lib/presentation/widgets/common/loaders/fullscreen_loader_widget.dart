import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

void showFullScreenLoader(String actionDescription) {
  SmartDialog.show(
    builder: (_) => FullscreenLoaderWidget(actionDescription: actionDescription),
    clickMaskDismiss: false
  );
}

class FullscreenLoaderWidget extends StatelessWidget {
  final String actionDescription;

  const FullscreenLoaderWidget({
    super.key,
    required this.actionDescription,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          width: size.width,
          height: size.height,
          color: Colors.black.withValues(alpha: 0.6),
        ),

        Center(
          child: Container(
            width: size.width * 0.75,
            height: size.height * 0.75,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
                const SizedBox(height: 24),

                Text(
                  actionDescription,
                  textAlign: TextAlign.center,
                  style: TextTheme.of(context).bodyMedium?.copyWith(
                    color: Colors.white
                  )
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


