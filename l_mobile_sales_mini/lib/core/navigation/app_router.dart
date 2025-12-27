import 'package:go_router/go_router.dart';
import 'package:l_mobile_sales_mini/core/navigation/route_names.dart';
import 'package:l_mobile_sales_mini/presentation/screens/home_screen.dart';
import 'package:l_mobile_sales_mini/presentation/screens/inventory_screen.dart';
import 'package:l_mobile_sales_mini/presentation/screens/login_screen.dart';
import 'package:l_mobile_sales_mini/presentation/screens/product_screen.dart';

final GoRouter appRouter = GoRouter(
    initialLocation: RouteNames.loginRoute,
    redirect: (context, state) {
      final bool isSignedIn = false;

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