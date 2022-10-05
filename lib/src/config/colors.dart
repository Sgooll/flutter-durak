import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static const blue = Color(0xff007aff);
  static const backgroundColor = Color(0xff5883b4);

  static const MaterialColor materialBlue = MaterialColor(
    0xff007aff, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff007aff), //10%
      100: Color(0xff007aff), //20%
      200: Color(0xff007aff), //30%
      300: Color(0xff007aff), //40%
      400: Color(0xff007aff), //50%
      500: Color(0xff007aff), //60%
      600: Color(0xff007aff), //70%
      700: Color(0xff007aff), //80%
      800: Color(0xff007aff), //90%
      900: Color(0xff007aff), //100%
    },
  );
}
