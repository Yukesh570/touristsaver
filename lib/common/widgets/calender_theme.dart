import 'package:flutter/material.dart';
import '../../constants/global_colors.dart';

Theme calenderTheme(Widget? child) {
  return Theme(
    data: ThemeData.light().copyWith(
      primaryColor: GlobalColors.appColor1, // Customize the primary color
      // accentColor: Colors.blue, // Customize the accent color
      colorScheme: const ColorScheme.light(
          primary: GlobalColors.appColor1), // Customize the color scheme
      buttonTheme: const ButtonThemeData(
        textTheme: ButtonTextTheme.primary, // Customize the button text theme
      ),
    ),
    child: child!,
  );
}
