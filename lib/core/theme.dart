import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xFF6B48FF); 
  static const secondaryColor = Color(0xFFC840FF); 
  static const darkBackgroundColor = Color(0xFF0F101A);
  static const lightBackgroundColor = Color(0xFFFAFBFD);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: lightBackgroundColor,
    cardColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      surface: Colors.white,
      secondary: secondaryColor,
    ),
    fontFamily: 'Roboto',
    useMaterial3: true,
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    cardColor: const Color(0xFF1E1F29),
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      surface: Color(0xFF1E1F29),
      secondary: secondaryColor,
    ),
    fontFamily: 'Roboto',
    useMaterial3: true,
  );
}
