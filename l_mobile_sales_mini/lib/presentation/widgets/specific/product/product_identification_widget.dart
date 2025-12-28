import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/products/product_model.dart';

class ProductIdentificationWidget extends StatelessWidget {
  final Product product;
  const ProductIdentificationWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildProductName(context, product.name),
          const SizedBox(height: 5),
          buildProductSKU(context, product.sku),
          const SizedBox(height: 5),
          buildProductCategories(context, product.category, product.subcategory),
        ],
      ),
    );
  }

  Widget buildProductName(BuildContext context, String productName) {
    return Text(productName, style: TextTheme.of(context).bodyLarge);
  }

  Widget buildProductSKU(BuildContext context, String productSKU) {
    return RichText(
      text: TextSpan(
        style: TextTheme.of(context).labelMedium,
        children: [
          TextSpan(text: 'SKU: '),
          TextSpan(
            text: productSKU,
            style: TextTheme.of(
              context,
            ).labelMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildProductCategories(BuildContext context, String productCategory, String productSubcategory) {
    final List<String> categories = [productCategory, productSubcategory];
    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 10);
        },
        itemBuilder: (context, index) {
          return buildProductCategory(context, categories[index]);
        },
      ),
    );
  }

  Widget buildProductCategory(BuildContext context, String category) {
    return InkWell(
      onTap: () => GoRouter.of(context).go('/category/{$category}'),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          category,
          style: TextTheme.of(
            context,
          ).labelMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

}
