import 'package:flutter/material.dart';

import 'dark_theme.dart';
import 'light_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = appLightTheme;
  static ThemeData darkTheme = appDarkTheme;
}