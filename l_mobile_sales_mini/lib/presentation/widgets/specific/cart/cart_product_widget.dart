import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_mobile_sales_mini/presentation/controllers/cart_provider.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/cart/section_head.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/cart/selected_product_widget.dart';

import '../../../../core/utils/inventory/stock_utils.dart';
import '../../../../data/models/customers/customer_model.dart';
import '../../../../data/models/products/product_model.dart';

class CartProductWidget extends ConsumerStatefulWidget {
  final Product product;
  final Customer customer;
  final void Function(Product product) onRemove;
  final void Function(
    Product product,
    int quantity,
    double totals,
    double discount,
    double totalsWithDiscount,
  )
  onConfirm;
  const CartProductWidget({
    super.key,
    required this.product,
    required this.customer,
    required this.onRemove,
    required this.onConfirm,
  });

  @override
  ConsumerState<CartProductWidget> createState() => _CartProductWidgetState();
}

class _CartProductWidgetState extends ConsumerState<CartProductWidget> {
  int quantity = 1;
  int maxQty = 99;
  double discount = 0.0;
  double discountedAmount = 0.0;
  bool isDiscountPercentage = false;
  double lineTotals = 0.00;
  double lineTotalsWithDiscount = 0.00;
  final TextEditingController _cartQtyController = TextEditingController();

  bool isConfirmed = false;

  void updateCartQty(bool increase) {
    setState(() {
      quantity = increase ? quantity + 1 : quantity - 1;
      quantity = quantity.clamp(0, maxQty);

      _cartQtyController.text = quantity.toString();
    });

    doTotals();
  }

  void setCartQty() {
    setState(() {
      quantity = int.tryParse(_cartQtyController.text) ?? 0;
      quantity = quantity.clamp(0, maxQty);

      _cartQtyController.text = quantity.toString();
    });

    doTotals();
  }

  void doTotals() {
    double newLineTotals = widget.product.price * quantity;
    double newLineTotalsWithDiscount = getTotalsAfterDiscount(newLineTotals);

    setState(() {
      lineTotals = newLineTotals;
      lineTotalsWithDiscount = newLineTotalsWithDiscount;
      discountedAmount = isDiscountPercentage ? discountedAmount : discount;
      isConfirmed = false;
    });
  }

  double getTotalsAfterDiscount(double newLineTotals) {
    if (isDiscountPercentage) {
      double discounted = widget.product.price * (discount / 100);
      setState(() {
        discountedAmount = discounted;
      });
      return newLineTotals - discounted;
    } else {
      return newLineTotals - discount;
    }
  }

  void confirmProduct() {
    widget.onConfirm(
      widget.product,
      quantity,
      lineTotals,
      discountedAmount,
      lineTotalsWithDiscount,
    );
    setState(() {
      isConfirmed = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _cartQtyController.text = quantity.toString();
    maxQty = getItemStockTotals(widget.product!.stock);
  }

  @override
  void dispose() {
    _cartQtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isConfirmed ? Colors.green[200] : Colors.transparent,
        borderRadius: BorderRadius.circular(7)
      ),
      child: Column(
        children: [
          SectionHead(title: 'Product:'),
          SelectedProductWidget(product: widget.product),
          const SizedBox(height: 5),
          buildActions(context, widget.product),
          buildParentFunctions(context, widget.product),
        ],
      ),
    );
  }

  Widget buildActions(BuildContext context, Product product) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400]!,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          buildQuantitySelection(context),
          const SizedBox(height: 5),
          buildDiscountSelection(context),
          const SizedBox(height: 5),
          buildTotals(context),
        ],
      ),
    );
  }

  Widget buildQuantitySelection(BuildContext context) {
    return buildQuantitySection(context);
  }

  Widget buildQuantitySection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        children: [
          buildMaxQtyLabel(context),
          Row(
            children: [
              buildQuantityButton(context, false),
              buildQuantityInput(context),
              buildQuantityButton(context, true),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildMaxQtyLabel(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextTheme.of(context).labelMedium,
        children: [
          TextSpan(text: 'Available : '),
          TextSpan(
            text: maxQty.toString(),
            style: TextTheme.of(
              context,
            ).labelMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildQuantityInput(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Center(
        child: TextFormField(
          controller: _cartQtyController,
          onChanged: (String? value) {
            setCartQty();
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintStyle: TextTheme.of(context).bodyMedium,
            filled: true,
            fillColor: Theme.of(context).appBarTheme.backgroundColor,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          ),
        ),
      ),
    );
  }

  Widget buildQuantityButton(BuildContext context, bool increase) {
    return IconButton(
      onPressed: () => updateCartQty(increase),
      icon: Icon(
        increase ? Icons.add : Icons.remove,
        size: 20,
        color: Colors.black,
      ),
    );
  }

  Widget buildDiscountSelection(BuildContext context) {
    return Row(
      children: [
        const Text('Discount:'),
        const SizedBox(width: 10),
        SizedBox(
          width: 80,
          child: TextFormField(
            initialValue: discount.toString(),
            keyboardType: TextInputType.number,
            onChanged: (val) {
              setState(() => discount = double.tryParse(val) ?? 0);
              doTotals();
            },
          ),
        ),
        const SizedBox(width: 10),
        DropdownButton<bool>(
          value: isDiscountPercentage,
          items: const [
            DropdownMenuItem(value: false, child: Text('Amount')),
            DropdownMenuItem(value: true, child: Text('%')),
          ],
          onChanged: (val) {
            setState(() => isDiscountPercentage = val ?? false);
            doTotals();
          },
        ),
      ],
    );
  }

  Widget buildTotalsWithDiscount(BuildContext context) {
    String symbol = isDiscountPercentage ? '%' : '';
    return lineTotalsWithDiscount < 1
        ? SizedBox.shrink()
        : RichText(
            text: TextSpan(
              style: TextTheme.of(context).labelMedium,
              children: [
                TextSpan(text: 'TOTAL AFTER DISCOUNT: '),
                TextSpan(
                  text: lineTotalsWithDiscount.toStringAsFixed(2),
                  style: TextTheme.of(context).bodyMedium,
                ),
                TextSpan(
                  text: '(Discount: $discount$symbol)',
                  style: TextTheme.of(
                    context,
                  ).labelMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
  }

  Widget buildTotals(BuildContext context) {
    return Column(
      children: [buildTotalsRow(context), buildTotalsWithDiscount(context)],
    );
  }

  Widget buildTotalsRow(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextTheme.of(context).labelMedium,
        children: [
          TextSpan(text: 'TOTAL: '),
          TextSpan(
            text: lineTotals.toStringAsFixed(2),
            style: TextTheme.of(context).bodyMedium,
          ),
          TextSpan(
            text: ' TAX: (${widget.product.taxRate.toStringAsFixed(1)})',
            style: TextTheme.of(
              context,
            ).labelMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildParentFunctions(BuildContext context, Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildConfirmProductButton(context, product),
        buildRemoveProductButton(context, product),
      ],
    );
  }

  Widget buildConfirmProductButton(BuildContext context, Product product) {
    return isConfirmed ? SizedBox.shrink() : ElevatedButton.icon(
      onPressed: () {
       confirmProduct();
      },
      icon: Icon(Icons.done, size: 20, color: Colors.green),
      label: Text('Confirm', style: TextTheme.of(context).bodyMedium),
    );
  }

  Widget buildRemoveProductButton(BuildContext context, Product product) {
    return ElevatedButton.icon(
      onPressed: () {
        print('Remove ${product.name}');
        widget.onRemove(product);
      },
      icon: Icon(Icons.delete, size: 20, color: Colors.red),
      label: Text('Remove', style: TextTheme.of(context).bodyMedium),
    );
  }
}
