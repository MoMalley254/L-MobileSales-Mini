import 'package:flutter/material.dart';

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 16,
      fixedColor: Colors.green,
      items: [
        BottomNavigationBarItem(
          label: 'Dashboard',
          tooltip: 'Dashboard',
          icon: Icon(
              Icons.dashboard
          ),
        ),
        BottomNavigationBarItem(
          label: 'Statistics',
          tooltip: 'Statistics',
          icon: Icon(
              Icons.trending_up
          ),
        ),
        BottomNavigationBarItem(
          label: 'Inventory',
          tooltip: 'Inventory',
          icon: Icon(
              Icons.inventory
          ),
        ),
        BottomNavigationBarItem(
          label: 'Settings',
          tooltip: 'Settings',
          icon: Icon(
              Icons.settings
          ),
        ),
      ],
    );
  }
}
