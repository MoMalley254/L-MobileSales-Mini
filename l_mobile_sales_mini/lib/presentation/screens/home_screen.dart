import 'package:flutter/material.dart';
import 'package:l_mobile_sales_mini/core/theme/app_colors.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/common/appbar_widget.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/common/bottom_navigation_widget.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/common/home_screen_header/welcome_widget.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/dashboard/daily_summary_widget.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/dashboard/quick_actions_widget.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/dashboard/transactions_preview_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(),
      body: buildHomeScreenBody(context),
      bottomNavigationBar: BottomNavigationWidget(),
    );
  }

  Widget buildHomeScreenBody(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            WelcomeWidget(),
            const SizedBox(height: 5,),
            DailySummaryWidget(),
            const SizedBox(height: 10,),
            QuickActionsWidget(),
            const SizedBox(height: 10,),
            TransactionsPreviewWidget()
          ],
        ),
      ),
    );
  }
}
