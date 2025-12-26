import 'dart:math';

import 'package:flutter/material.dart';

class TransactionsPreviewWidget extends StatelessWidget {
  const TransactionsPreviewWidget({super.key});

  Future<Map<String, dynamic>> getRecentTransactions() async {
    try {
      // Simulate a delay
      await Future.delayed(const Duration(seconds: 1));

      final random = Random();

      final List<Map<String, dynamic>> transactions = List.generate(5, (index) {
        return {
          'id': random.nextInt(100000), // numeric ID
          'type': random.nextBool(),
          'time': DateTime.now()
              .subtract(Duration(minutes: random.nextInt(120))),
          'price': double.parse(
            (random.nextDouble() * 500 + 10).toStringAsFixed(2),
          ),
        };
      });

      return {
        'status': true,
        'transactions': transactions
      };
    } catch (getRecentTransactionsError) {
      return {
        'status': false,
        'error': getRecentTransactionsError.toString(),
      };
    }
  }

  String getElapsedTime(DateTime transactionTime) {
    final duration = DateTime.now().difference(transactionTime);

    if (duration.inMinutes < 1) {
      return 'Just now';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes} min ago';
    } else if (duration.inHours < 24) {
      return '${duration.inHours} hr ago';
    } else {
      return '${duration.inDays} day(s) ago';
    }
  }

  void showAllTransaction() {
    print('Show all transactions');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getRecentTransactions(),
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
            final Map<String, dynamic> transactionsMap = snapshot.data!;
            if (!transactionsMap['status']) {
              return Text('Error loading date :: ${transactionsMap['error']}');
            } else {
              return Container(
                height: MediaQuery.of(context).size.height * .7,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[400]!,
                      blurRadius: 4,
                      offset: Offset(0 ,2)
                    )
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildHeader(context),
                    const SizedBox(height: 5,),
                    buildTransactions(context, transactionsMap['transactions']),
                  ],
                ),
              );
            }
          }
        }
    );
  }

  Widget buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildTitle(context),
        buildViewAll(context),
      ],
    );
  }

  Widget buildTitle(BuildContext context) {
    return Text(
        'Daily Revenue',
        style: TextStyle(
            fontSize: 14,
            color: Colors.black26
        )
    );
  }

  Widget buildViewAll(BuildContext context) {
    return TextButton(
        onPressed: showAllTransaction,
        child: Text(
            'View All',
            style: TextStyle(
                fontSize: 14,
                color: Colors.green
            )
        )
    );
  }

  Widget buildTransactions(BuildContext context, List<Map<String, dynamic>> transactions) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> transaction = transactions[index];
            return buildSingleTransaction(context, transaction);
          },
        ),
      ),
    );
  }

  Widget buildSingleTransaction(BuildContext context, Map<String, dynamic> transaction) {
    return InkWell(
      child: Container(
        height: MediaQuery.of(context).size.height * .1,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: transaction['type'] ? Colors.green[100]! : Colors.red[100]!,
              blurRadius: 4,
              offset: Offset(0, 2)
            )
          ]
        ),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            buildTransactionIcon(context, transaction['type']),
            buildTransactionIdTime(context, transaction['id'], transaction['time'], transaction['type']),
            buildTransactionTotals(context, transaction['price'], transaction['type']),
          ],
        ),
      ),
    );
  }

  Widget buildTransactionIcon(BuildContext context, bool isOrder) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: isOrder ? Colors.green[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Icon(
        isOrder ? Icons.receipt_long : Icons.keyboard_return,
        color: isOrder ? Colors.green : Colors.red,
        size: 20,
      ),
    );
  }

  Widget buildTransactionIdTime(BuildContext context, int id, DateTime time, bool isOrder) {
    return Column(
      children: [
        Text(
          '${isOrder ? 'Order' : 'Return'} #$id',
          style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            fontWeight: FontWeight.bold
          ),
        ),
        Text(
          getElapsedTime(time),
          style: TextStyle(
              color: Colors.black26,
              fontSize: 14
          ),
        )
      ],
    );
  }

  Widget buildTransactionTotals(BuildContext context, double price, bool isOrder) {
    return Text(
      '${isOrder ? '+' : '-'} Ksh.${price.toStringAsFixed(2)}',
      style: TextStyle(
        color: isOrder ? Colors.green : Colors.red,
        fontSize: 16,
        fontWeight: FontWeight.bold
      ),
    );
  }
}
