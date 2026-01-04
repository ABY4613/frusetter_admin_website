import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- Core Palette ---
  static const Color black = Color(0xFF111827); // Deep Charcoal for text
  static const Color primaryColor = Color(0xFF8AC53D); // Frusette Green
  static const Color white = Colors.white;
  static const Color scaffoldBackgroundColor =
      Colors.white; // Explicitly White Background
  // --- Theme Data ---
  static ThemeData get lightTheme {
    return ThemeData(
      // 1. General Settings
      brightness: Brightness.light,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      primaryColor: primaryColor,
      useMaterial3: true,

      // 2. Color Scheme (Material 3)
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        onPrimary: Colors.white, // Text on primary buttons
        secondary: primaryColor,
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: black,
        error: Color(0xFFEF4444),
        onError: Colors.white,
      ),

      // 3. Text Theme (Google Fonts)
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: black,
        displayColor: black,
      ),

      // 4. Component Themes

      // Elevated Button: Primary Color bg, White text
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      // Text Button: Primary Color text
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      // Input Decorator (Text Fields)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF9FAFB), // Very light grey for inputs
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: Color(0xFFE5E7EB)), // Light border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: primaryColor, width: 2), // Primary focus
        ),
        labelStyle: const TextStyle(color: Color(0xFF6B7280)),
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: black,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: black),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: black),
    );
  }

  // Keeping darkTheme as a fallback or for future use, but aligning closely with the request
  // The user asked for "background color white", so light theme is the main focus.
  static ThemeData get darkTheme => lightTheme;
}
