import 'package:flutter/material.dart';

class ProductPriceTrendWidget extends StatelessWidget {
  final List<Map<String, dynamic>> prices;
  const ProductPriceTrendWidget({super.key, required this.prices});

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty) return Container();

    List<Map<String, dynamic>> reversedPrices = prices.reversed.toList();
    List<double> percentageChanges = [];
    double previousPrice = 0;

    for (int i = 0; i < reversedPrices.length; i++) {
      final entry = reversedPrices[i];
      final price = entry.values.first as double;

      double change = 0;
      if (i != 0 && previousPrice != 0) {
        change = ((price - previousPrice).abs() / previousPrice) * 100;
      }
      percentageChanges.add(change);
      previousPrice = price;
    }

    double maxChange = percentageChanges.reduce((a, b) => a > b ? a : b);

    previousPrice = 0;
    List<Widget> segments = [];

    for (int i = 0; i < reversedPrices.length; i++) {
      final entry = reversedPrices[i];
      final date = entry.keys.first;
      final price = entry[date] as double;

      double change = percentageChanges[i];

      double segmentWidth = maxChange > 0
          ? ((change / maxChange) * 300).clamp(150, 200)
          : 150;

      Color color = (i == 0 || price >= previousPrice)
          ? Colors.green[500]!
          : Colors.red[500]!;

      final String symbol = (i == 0 || price >= previousPrice) ? '+' : '-';

      segments.add(
        Container(
          width: segmentWidth,
          height: 70,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
              style: TextTheme.of(context).labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(text: '$date \n Ksh.'),
                TextSpan(
                  text:
                  '${price.toStringAsFixed(2)}($symbol${change.toStringAsFixed(2)}%)',
                ),
              ],
            ),
          ),
        ),
      );

      previousPrice = price;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: segments.reversed.toList()),
    );
  }
}
