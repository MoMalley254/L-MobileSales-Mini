import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/route_names.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  void goToInventory() {

  }

  void goToCustomers() {
    print('Go to customers');
  }

  void goToNewSale() {
    print('Go to new sale');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .22,
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
                offset: Offset(0, 4)
            )
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildTitle(context),
          const SizedBox(height: 3,),
          buildNewSale(context),
          const SizedBox(height: 3,),
          buildInventoryCustomerSect(context)
        ],
      ),
    );
  }

  Widget buildTitle(BuildContext context) {
    return Text(
        'Quick Actions',
        style: TextTheme.of(context).labelMedium,
    );
  }

  Widget buildNewSale(BuildContext context) {
    return InkWell(
      onTap: goToNewSale,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              Icons.shopping_cart_checkout,
              size: 30,
            ),
            Text(
              'New Transaction',
              style: TextTheme.of(context).bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInventoryCustomerSect(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      runAlignment: WrapAlignment.spaceEvenly,
      alignment: WrapAlignment.spaceEvenly,
      runSpacing: 5,
      spacing: 20,
      children: [
        buildContainerButton(
            context,
            'Inventory',
            Icons.inventory,
            () => GoRouter.of(context).go(RouteNames.inventoryRoute)
        ),
        buildContainerButton(
            context,
            'Customers',
            Icons.person_search_outlined,
            goToCustomers
        ),
      ],
    );
  }

  Widget buildContainerButton(BuildContext context, String label, IconData iconData, void Function() handleNavigate) {
    return InkWell(
      onTap: handleNavigate,
      child: Container(
        width: MediaQuery.of(context).size.width * .4,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ]
        ),
        child: Column(
          children: [
            Icon(
              iconData,
              size: 30,
            ),
            Text(
              label,
              style: TextTheme.of(context).bodyLarge,
            )
          ],
        ),
      ),
    );
  }
}
