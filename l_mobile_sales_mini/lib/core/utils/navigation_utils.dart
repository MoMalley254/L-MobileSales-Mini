import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../navigation/route_names.dart';

void expandNotifications(BuildContext context) {
  Scaffold.of(context).closeDrawer();
  GoRouter.of(context).push(RouteNames.notificationsRoute);
}

void goToSettings(BuildContext context) {
  Scaffold.of(context).closeDrawer();
  GoRouter.of(context).push(RouteNames.settingsRoute);
}

void goToProfileScreen(BuildContext context) {
  GoRouter.of(context).push(RouteNames.settingsRoute);
}

void goToNewProductScreen(BuildContext context) {
  Scaffold.of(context).closeDrawer();
  GoRouter.of(context).push(RouteNames.newProductRoute);
}