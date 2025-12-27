import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_mobile_sales_mini/core/navigation/app_router.dart';
import 'package:l_mobile_sales_mini/core/theme/app_theme.dart';

void main() {
  runApp(
    ProviderScope(child: const LMobileSalesMini())
  );
}

class LMobileSalesMini extends StatelessWidget {
  const LMobileSalesMini({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'L-MobileSales Mini',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}

