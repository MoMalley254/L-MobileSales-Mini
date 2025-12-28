import 'package:flutter/material.dart';

class ProductDescriptionWidget extends StatelessWidget {
  final String productDescription;
  const ProductDescriptionWidget({super.key, required this.productDescription});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Center(
        child: Text(
          productDescription,
          style: TextTheme.of(context).labelMedium,
        ),
      ),
    );
  }
}
