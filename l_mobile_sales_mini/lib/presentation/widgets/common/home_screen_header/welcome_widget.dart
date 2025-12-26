import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  final String username = 'Risper';

  Future<Map<String, String>> getDayDate() async {
    final currentDate = DateTime.now();
    return {
      'day': DateFormat('EEEE').format(currentDate).toUpperCase(),
      'month': DateFormat('MMMM').format(currentDate),
      'date': DateFormat('d').format(currentDate),
      'period': getTimeOfDay(currentDate),
    };
  }

  String getTimeOfDay(DateTime currentDate) {
    final int currentHour = currentDate.hour;
    if (currentHour >= 5 && currentHour < 12) {
      return 'Morning';
    } else if (currentHour >= 12 && currentHour < 17) {
      return 'Afternoon';
    } else if (currentHour >= 17 && currentHour < 21) {
      return 'Evening';
    } else {
      return 'Night';
    }
  }

  Icon getGreetingIcon(String period) {
    switch (period) {
      case 'Morning':
        return const Icon(Icons.coffee, color: Colors.orange, size: 30,);
      case 'Afternoon':
        return const Icon(Icons.wb_sunny, color: Colors.yellow, size: 30,);
      case 'Evening':
        return const Icon(Icons.wb_twilight, color: Colors.deepOrange, size: 30,);
      case 'Night':
        return const Icon(Icons.nightlight_round, color: Colors.indigo, size: 30,);
      default:
        return const Icon(Icons.person, size: 30,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * .1,
          maxHeight: MediaQuery.of(context).size.height * .15,
        ),
      child: FutureBuilder(
          future: getDayDate(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Error loading date');
            } else if (!snapshot.hasData) {
              return const Text('No data');
            } else {
              final Map<String, String> dateMap = snapshot.data!;
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  // color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildDate(context, dateMap),
                    const Spacer(),
                    buildWelcomeText(context, dateMap),
                    buildUsername(context, dateMap),
                    const Spacer(),
                  ],
                ),
              );
            }
          }
      ),
    );
  }

  Widget buildDate(BuildContext context, Map<String, String> dateMap) {
    return RichText(
        text: TextSpan(
          style: TextStyle(
              fontSize: 14,
              color: Colors.black26
          ),
          children: [
            TextSpan(
              text: '${dateMap['day']}, ',
            ),
            TextSpan(
              text: '${dateMap['month']} ',
            ),
            TextSpan(
              text: '${dateMap['date']}',
            ),
          ],
        )
    );
  }

  Widget buildWelcomeText(BuildContext context, Map<String, String> dateMap) {
    return RichText(
        text: TextSpan(
          style: TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.bold
          ),
          children: [
            TextSpan(
              text: 'Good ',
            ),
            TextSpan(
              text: '${dateMap['period']},',
            ),
          ],
        )
    );
  }

  Widget buildUsername(BuildContext context, Map<String, String> dateMap) {
    return Row(
      children: [
        Text(
          username,
          style: TextStyle(
            fontSize: 22,
            color: Colors.green,
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(width: 10,),
        getGreetingIcon(dateMap['period']!),
      ],
    );
  }
}
