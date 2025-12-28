import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l_mobile_sales_mini/core/navigation/route_names.dart';
import 'package:l_mobile_sales_mini/presentation/controllers/auth_provider.dart';
import 'package:l_mobile_sales_mini/presentation/screens/home_screen.dart';
import 'package:l_mobile_sales_mini/presentation/screens/inventory_screen.dart';
import 'package:l_mobile_sales_mini/presentation/screens/login_screen.dart';
import 'package:l_mobile_sales_mini/presentation/screens/product_screen.dart';
import 'package:l_mobile_sales_mini/presentation/screens/splash_screen.dart';

import '../../presentation/widgets/common/appbar_widget.dart';
import '../../presentation/widgets/common/bottom_navigation_widget.dart';

GoRouter createAppRouter(WidgetRef ref) {
  final authNotifier = ref.read(authProviderNotifier.notifier);

  return GoRouter(
      initialLocation: RouteNames.splashRoute,
      refreshListenable: authNotifier.authStateChanges,
      redirect: (context, state) {
        final authState = ref.read(authProviderNotifier);
        final isSignedIn = authState.asData?.value.isAuthenticated ?? false;

        final isSplash = state.matchedLocation == RouteNames.splashRoute;
        final isLogin = state.matchedLocation == RouteNames.loginRoute;

        if (authState.isLoading) return null;

        if (!isSignedIn) {
          return isLogin ? null : RouteNames.loginRoute;
        }

        if (isSignedIn && (isLogin || isSplash)) {
          return RouteNames.dashboardRoute;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: RouteNames.splashRoute,
          name: 'Splash',
          builder: (context, state) => const SplashScreen(),
        ),

        GoRoute(
          path: RouteNames.loginRoute,
          name: 'Login',
          builder: (context, state) => const LoginScreen(),
        ),

        ShellRoute(
            builder: (context, state, child) {
              int currentIndex = 0;
              if (state.uri.toString().startsWith(RouteNames.inventoryRoute)) {
                currentIndex = 2;
              } else if (state.uri.toString().startsWith('/statistics')) {
                currentIndex = 1;
              } else if (state.uri.toString().startsWith('/settings')) {
                currentIndex = 3;
              }
              return Scaffold(
                appBar: AppbarWidget(),
                body: child,
                bottomNavigationBar: BottomNavigationWidget(currentIndex: currentIndex),
              );
            },
            routes: [
              GoRoute(
                path: RouteNames.dashboardRoute,
                name: 'Dashboard',
                builder: (context, state) => const HomeScreen(),
              ),
              GoRoute(
                  path: RouteNames.inventoryRoute,
                  name: 'Inventory',
                  builder: (context, state) => const InventoryScreen(),
                  routes: [
                    GoRoute(
                        path: ':id',
                        name: 'Product Details',
                        builder: (context, state) {
                          final String? productId = state.pathParameters['id'];
                          if (productId == null || productId.isEmpty) {
                            return const Scaffold(
                              body: Center(
                                child: Text(
                                  'Error: Product ID is missing.'
                                ),
                              ),
                            );
                          }
                          return ProductScreen(productId: productId);
                        }
                    )
                  ]
              ),
            ]
        )
      ]
  );
}