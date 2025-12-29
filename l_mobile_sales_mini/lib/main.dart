import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:l_mobile_sales_mini/core/navigation/app_router.dart';
import 'package:l_mobile_sales_mini/core/providers/data_provider.dart';
import 'package:l_mobile_sales_mini/core/theme/app_theme.dart';
import 'package:l_mobile_sales_mini/data/repositories/data_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dataRepo = DataRepository();
  // final auth = Auth

  await Future.wait([
    dataRepo.loadData(),
  ]);

  runApp(
    ProviderScope(
      overrides: [
        dataRepositoryProvider.overrideWith((ref) => dataRepo),
      ],
        child: const LMobileSalesMini()
    )
  );
}

class LMobileSalesMini extends ConsumerWidget {
  const LMobileSalesMini({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = createAppRouter(ref);
    return MaterialApp.router(
      title: 'L-MobileSales Mini',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      builder: FlutterSmartDialog.init(),
    );
  }
}

