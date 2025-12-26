import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_mobile_sales_mini/core/theme/app_theme.dart';
import 'package:l_mobile_sales_mini/presentation/screens/home_screen.dart';
import 'package:l_mobile_sales_mini/presentation/screens/login_screen.dart';

void main() {
  runApp(
    ProviderScope(child: const LMobileSalesMini())
  );
}

class LMobileSalesMini extends StatelessWidget {
  const LMobileSalesMini({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'L-MobileSales Mini',
      home: HomeScreen(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}

