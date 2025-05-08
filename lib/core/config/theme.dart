// lib/core/theme/theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const primaryPurple = Color(0xFF8B3DFF);
  static const gradientStart = Color(0xFF8B3DFF);
  static const gradientMiddle = Color(0xFFFF6B6B);
  static const gradientEnd = Color(0xFFFF8C48);
  static const textColor = Colors.white;
  static const splashScreenStart = Colors.black;
  static const splashScreenMiddle = Color(0xFF1C003E);
  static const splashScreenEnd = Color(0xFF7F00FF);

  static final ThemeData theme = ThemeData(
    primaryColor: primaryPurple,
    scaffoldBackgroundColor: Colors.black,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
    ),
  );
}
