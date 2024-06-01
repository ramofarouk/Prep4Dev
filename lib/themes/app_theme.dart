import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF015055);
  static const Color secondaryColor = Color.fromARGB(255, 177, 198, 93);
  static const Color thirdyColor = Color.fromARGB(255, 50, 130, 210);
  static const Color primaryColorLight = Color.fromARGB(255, 28, 147, 156);
  static const placeholder = Color(0xFFB6B7B7);
  static const placeholderBg = Color(0xFFF2F2F2);

  static const String fontFamilyQuick = "Quicksand";

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
    fontFamily: fontFamilyQuick,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    primaryColor: secondaryColor,
    colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
    fontFamily: fontFamilyQuick,
  );
}
