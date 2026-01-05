import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:l_mobile_sales_mini/core/navigation/route_names.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  AppbarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  final List<dynamic> primaryLocations = [
    RouteNames.dashboardRoute,
    RouteNames.inventoryRoute,
    RouteNames.customersRoute,
    RouteNames.checkoutRoute
  ];

  bool isInPrimaryScreen(String location) {
    return primaryLocations.contains(location);
  }

  void showNotifications() {
    print('Show notifications');
  }

  void openMenu() {
    print('Open menu');
  }

  void handleBackButtonClick(BuildContext context) {
   if (context.canPop()) {
     GoRouter.maybeOf(context)?.pop();
   } else {
     GoRouter.maybeOf(context)?.go(RouteNames.dashboardRoute);
   }
  }

  void showProfile() {
    print('Show profile');
  }

  @override
  Widget build(BuildContext context) {
    final String location = GoRouter.of(context).state.uri.toString();
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
      leading: buildMenuIcon(context, location),
      actions: [
        buildNotifications(context),
        const SizedBox(height: 10,),
        buildUserProfileWidget(context),
      ],
      iconTheme: const IconThemeData(
        color: Colors.black,
        size: 24
      ),
    );
  }

  Widget buildMenuIcon(BuildContext context, String location) {
    bool isInPrimary = isInPrimaryScreen(location);
    return IconButton(
        onPressed: () {
          isInPrimary ? openMenu() : handleBackButtonClick(context);
        },
        icon: Icon(
          isInPrimary ? Icons.menu : Icons.arrow_back
        )
    );
  }

  Widget buildNotifications(BuildContext context) {
    return InkWell(
      onTap: showNotifications,
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(
            Icons.notifications,
          ),
          // Notification badge
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Center(
                child: Text(
                  '3',
                  style: TextTheme.of(context).labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget buildUserProfileWidget(BuildContext context) {
    return InkWell(
      onTap: showProfile,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Image.network(
          'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
          height: Size.fromHeight(kToolbarHeight).height,
        ),
      ),
    );
  }
}
