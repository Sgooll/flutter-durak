import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    primarySwatch: AppColors.materialBlue,
    scaffoldBackgroundColor: AppColors.backgroundColor,
  );
}

class AppTextTheme {
  static TextStyle headline = TextStyle(color: Colors.black, fontSize: 40);
  static TextStyle button =
      TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 1.6);
}
