import 'package:flutter/material.dart';

class SectionHead extends StatelessWidget {
  final String title;
  const SectionHead({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextTheme.of(context).labelMedium,
      textAlign: TextAlign.center,
    );
  }
}
