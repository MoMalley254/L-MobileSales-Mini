import 'package:flutter/material.dart';
import 'package:l_mobile_sales_mini/core/theme/app_colors.dart';
import 'package:l_mobile_sales_mini/core/theme/text_styles.dart';

final ThemeData appDarkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppColors.backgroundDark,

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
    ),

    colorScheme: ColorScheme.dark(
        primary: AppColors.containerDark
    ),

    textTheme: TextTheme(
        bodyLarge: AppTextStyles.bodyLargeDark,
        bodyMedium: AppTextStyles.bodyMediumDark,
        labelMedium: AppTextStyles.labelMediumDark
    )
);