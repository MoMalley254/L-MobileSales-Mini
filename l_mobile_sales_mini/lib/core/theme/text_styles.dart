import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';
import 'package:l_mobile_sales_mini/core/theme/app_colors.dart';

class AppTextStyles{
  AppTextStyles._();

  static final bodyLargeLight = GoogleFonts.lato(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.bodyTextLight
  );

  static final bodyLargeDark = GoogleFonts.lato(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.bodyTextDark
  );

  static final bodyMediumLight = GoogleFonts.lato(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: AppColors.bodyTextLight,
  );

  static final bodyMediumDark = GoogleFonts.lato(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: AppColors.bodyTextDark,
  );

  static final labelMediumLight = GoogleFonts.lato(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.labelTextLight
  );

  static final labelMediumDark = GoogleFonts.lato(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.labelTextDark
  );
}