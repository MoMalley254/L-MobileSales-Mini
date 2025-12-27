import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l_mobile_sales_mini/core/navigation/route_names.dart';
import 'package:l_mobile_sales_mini/data/models/auth_model.dart';
import 'package:l_mobile_sales_mini/presentation/controllers/auth_provider.dart';
import 'package:l_mobile_sales_mini/presentation/screens/home_screen.dart';
import 'package:l_mobile_sales_mini/presentation/screens/inventory_screen.dart';
import 'package:l_mobile_sales_mini/presentation/screens/login_screen.dart';
import 'package:l_mobile_sales_mini/presentation/screens/product_screen.dart';

GoRouter createAppRouter(WidgetRef ref) {
  return GoRouter(
      initialLocation: RouteNames.loginRoute,
      redirect: (context, state) {
        final authState = ref.read(authProviderNotifier);
        final bool isSignedIn = authState.asData?.value.isAuthenticated ?? false;

        final isAuthScreen = state.uri.toString().startsWith('/login');

        if (!isSignedIn && isAuthScreen) {
          return RouteNames.loginRoute;
        }

        if (!isSignedIn && !isAuthScreen) {
          return RouteNames.dashboardRoute;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: RouteNames.loginRoute,
          name: 'Login',
          builder: (context, state) => const LoginScreen(),
        ),

        ShellRoute(
            builder: (context, state, child) {
              return Scaffold(
                body: child,
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
                          final productId = state.pathParameters['id'];
                          return const ProductScreen();
                        }
                    )
                  ]
              ),
            ]
        )
      ]
  );
}