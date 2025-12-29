import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/navigation/route_names.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;

  const BottomNavigationWidget({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 16,
      fixedColor: Colors.green,
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            GoRouter.of(context).go(RouteNames.dashboardRoute);
            break;
          case 1:
            GoRouter.of(context).go(RouteNames.customersRoute);
            break;
          case 2:
            GoRouter.of(context).go(RouteNames.inventoryRoute);
            break;
          case 3:
            GoRouter.of(context).go(RouteNames.checkoutRoute);
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          label: 'Dashboard',
          tooltip: 'Dashboard',
          icon: Icon(
              Icons.dashboard
          ),
        ),
        BottomNavigationBarItem(
          label: 'Customers',
          tooltip: 'Customers',
          icon: Icon(
              Icons.people
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
          label: 'Checkout',
          tooltip: 'Checkout',
          icon: Icon(
              Icons.shopping_cart_checkout
          ),
        ),
      ],
    );
  }
}
