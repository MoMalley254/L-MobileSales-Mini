import 'package:flutter/material.dart';
import 'package:l_mobile_sales_mini/core/theme/app_colors.dart';
import 'package:l_mobile_sales_mini/core/theme/text_styles.dart';

final ThemeData appLightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  scaffoldBackgroundColor: AppColors.backgroundLight,

  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.backgroundLight,
  ),

  colorScheme: ColorScheme.light(
    primary: AppColors.containerLight
  ),

  textTheme: TextTheme(
    bodyLarge: AppTextStyles.bodyLargeLight,
    bodyMedium: AppTextStyles.bodyMediumLight,
    labelMedium: AppTextStyles.labelMediumLight
  )
);