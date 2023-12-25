import 'package:flutter/material.dart';

ThemeData lightThemeData() {
  return ThemeData(
    fontFamily: 'IranSans',
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: const Color(0xff0244C7),
    disabledColor: const Color(0xff0244C7).withOpacity(0.2),
    dividerColor: Colors.black87,
    useMaterial3: false,
    textTheme: const TextTheme(
      bodySmall: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.blue,
      contentTextStyle: TextStyle(
        fontFamily: 'IranSans',
        color: Colors.white,
      ),
    ),
  );
}
