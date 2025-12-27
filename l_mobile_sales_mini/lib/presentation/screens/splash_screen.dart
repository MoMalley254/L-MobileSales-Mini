import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/route_names.dart';
import '../controllers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Future<void> _checkAuth() async {
    final authNotifier = ref.read(authProviderNotifier.notifier);

    final auth = await authNotifier.build();

    if (auth.isAuthenticated) {
      GoRouter.of(context).go(RouteNames.dashboardRoute);
    } else {
      GoRouter.of(context).go(RouteNames.loginRoute);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _checkAuth();
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.primary,),
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        width: double.infinity,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary,),
        child: Center(
          child: CircularProgressIndicator(),
        )
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }
}
