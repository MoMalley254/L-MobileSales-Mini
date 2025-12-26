import 'dart:math';

import 'package:flutter/material.dart';

class DailySummaryWidget extends StatelessWidget {
  const DailySummaryWidget({super.key});

  final double dailyTarget = 3000.00;

  Future<Map<String, dynamic>> getDailyStatistics() async {
    try {
      // Simulate a delay
      await Future.delayed(const Duration(seconds: 1));

      final random = Random();

      // Randomized sales statistics
      final salesToday = random.nextDouble() * 1000;

      final trend = random.nextBool();

      return {
        'status': true,
        'sales': salesToday,
        'trend': trend,
      };
    } catch (getDailyStatisticsError) {
      return {
        'status': false,
        'error': getDailyStatisticsError.toString(),
      };
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDailyStatistics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Text('Error loading date');
          } else if (!snapshot.hasData) {
            return const Text('No data');
          } else {
            final Map<String, dynamic> statisticsMap = snapshot.data!;
            if (!statisticsMap['status']) {
              return Text('Error loading date :: ${statisticsMap['error']}');
            } else {
              return Container(
                height: MediaQuery.of(context).size.height * .18,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white70,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: statisticsMap['trend'] ? Colors.green[100]! : Colors.red[100]!,
                          blurRadius: 4,
                          offset: Offset(0, 4)
                      )
                    ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildHeader(context, statisticsMap['trend']),
                    const SizedBox(height: 5,),
                    buildRevenueNumbers(context, statisticsMap['sales']),
                    const SizedBox(height: 3,),
                    buildProgress(context, statisticsMap['sales']),
                  ],
                ),
              );
            }
          }
        }
    );
  }

  Widget buildHeader(BuildContext context, bool trend) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildTitle(context),
        buildTrend(context, trend),
      ],
    );
  }

  Widget buildTitle(BuildContext context) {
    return Text(
      'Daily Revenue',
      style: TextTheme.of(context).labelMedium,
    );
  }

  Widget buildTrend(BuildContext context, bool trend) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: trend ? Colors.green[100] : Colors.red[100],
          borderRadius: BorderRadius.circular(50)
        ),
        child: Icon(
          trend ? Icons.trending_up : Icons.trending_down,
          size: 30,
          color: trend ? Colors.green : Colors.red,
        ),
      )
    );
  }

  Widget buildRevenueNumbers(BuildContext context, double sales) {
    return RichText(
        text: TextSpan(
          style: TextTheme.of(context).labelMedium,
          children: [
            TextSpan(
                text: 'Goal '
            ),
            TextSpan(
                text: '${dailyTarget.toString()}\n',
                style: TextTheme.of(context).bodyMedium,
            ),
            TextSpan(
                text: 'Ksh. '
            ),
            TextSpan(
              text: '${sales.toStringAsFixed(2)} ',
              style: TextTheme.of(context).bodyLarge?.copyWith(
                color: Colors.green
              )
            ),
          ],
        )
    );
  }

  Widget buildProgress(BuildContext context, double sales) {
    final double clampedSales = sales.clamp(0, dailyTarget);
    final double progressPercent = clampedSales / dailyTarget;
    final double remainingAmount = dailyTarget - clampedSales;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progressPercent * 100).toStringAsFixed(1)}% Achieved',
                style: TextTheme.of(context).labelMedium?.copyWith(
                  color: Colors.green
                ),
              ),

              Text(
                'Ksh. ${remainingAmount.toStringAsFixed(1)} remaining',
                style: TextTheme.of(context).labelMedium,
              ),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              // Background bar
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Foreground progress bar
              Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: progressPercent,
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
