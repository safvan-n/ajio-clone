import 'package:flutter/material.dart';

class AjioTheme {
  // Brand Colors
  static const Color darkSlate = Color(0xFF0F172A); // #0f172a
  static const Color mediumSlate = Color(0xFF1E293B); // #1e293b
  static const Color ajioGold = Color(0xFF907028); // AJIO Gold/Bronze #907028
  static const Color ajioAccentGold = Color(0xFFB59344); // #b59344
  static const Color discountRed = Color(0xFFD32F2F); // #d32f2f
  static const Color lightGrey = Color(0xFFF1F5F9); // #f1f5f9
  static const Color borderGrey = Color(0xFFE2E8F0); // #e2e8f0
  static const Color textGrey = Color(0xFF64748B); // #64748b
  static const Color successGreen = Color(0xFF15803D); // #15803d

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: darkSlate,
      colorScheme: const ColorScheme.light(
        primary: darkSlate,
        secondary: ajioGold,
        error: discountRed,
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: darkSlate),
        titleTextStyle: TextStyle(
          color: darkSlate,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: darkSlate,
        unselectedItemColor: textGrey,
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: darkSlate, fontWeight: FontWeight.bold, fontSize: 32),
        headlineMedium: TextStyle(color: darkSlate, fontWeight: FontWeight.bold, fontSize: 24),
        titleLarge: TextStyle(color: darkSlate, fontWeight: FontWeight.bold, fontSize: 20),
        titleMedium: TextStyle(color: darkSlate, fontWeight: FontWeight.w600, fontSize: 16),
        bodyLarge: TextStyle(color: darkSlate, fontSize: 15),
        bodyMedium: TextStyle(color: textGrey, fontSize: 13),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkSlate,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // AJIO uses modern sharp rectangular designs!
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkSlate,
          side: const BorderSide(color: darkSlate, width: 1.2),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: lightGrey,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.zero,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.zero,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ajioGold, width: 1),
          borderRadius: BorderRadius.zero,
        ),
        hintStyle: TextStyle(color: textGrey, fontSize: 14),
      ),
    );
  }
}
