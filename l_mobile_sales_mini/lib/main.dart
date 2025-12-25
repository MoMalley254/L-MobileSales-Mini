import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'L-MobileSales Mini',
      home: LMobileSalesMini(),
    );
  }
}

class LMobileSalesMini extends StatelessWidget {
  const LMobileSalesMini({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

