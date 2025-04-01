import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color Definitions
  static const Color _primaryGreen = Color(0xFF2E7D32);
  static const Color _accentGreen = Color(0xFF81C784);
  static const Color _errorRed = Color(0xFFD32F2F);
  static const Color _lightBackground = Color(0xFFF5F5F5);
  static const Color _darkBackground = Color(0xFF121212);
  static const Color _darkSurface = Color(0xFF1E1E1E);

  // Tajawal Arabic Text Theme
  static TextTheme get _tajawalTextTheme => TextTheme(
    displayLarge: GoogleFonts.tajawal(fontSize: 57, fontWeight: FontWeight.w400),
    displayMedium: GoogleFonts.tajawal(fontSize: 45, fontWeight: FontWeight.w400),
    displaySmall: GoogleFonts.tajawal(fontSize: 36, fontWeight: FontWeight.w400),
    headlineLarge: GoogleFonts.tajawal(fontSize: 32, fontWeight: FontWeight.w400),
    headlineMedium: GoogleFonts.tajawal(fontSize: 28, fontWeight: FontWeight.w400),
    headlineSmall: GoogleFonts.tajawal(fontSize: 24, fontWeight: FontWeight.w500),
    titleLarge: GoogleFonts.tajawal(fontSize: 22, fontWeight: FontWeight.w500),
    titleMedium: GoogleFonts.tajawal(fontSize: 16, fontWeight: FontWeight.w500),
    titleSmall: GoogleFonts.tajawal(fontSize: 14, fontWeight: FontWeight.w500),
    bodyLarge: GoogleFonts.tajawal(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: GoogleFonts.tajawal(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: GoogleFonts.tajawal(fontSize: 12, fontWeight: FontWeight.w400),
    labelLarge: GoogleFonts.tajawal(fontSize: 14, fontWeight: FontWeight.w500),
    labelMedium: GoogleFonts.tajawal(fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall: GoogleFonts.tajawal(fontSize: 11, fontWeight: FontWeight.w500),
  );

  // Light Theme
  static ThemeData get lightTheme {
    final baseTheme = ThemeData.light(useMaterial3: true);
    return baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: _primaryGreen,
        secondary: _accentGreen,
        surface: Colors.white,
        background: _lightBackground,
        error: _errorRed,
      ),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
        backgroundColor: _primaryGreen,
        elevation: 4,
        centerTitle: true,
        titleTextStyle: _tajawalTextTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      textTheme: _tajawalTextTheme,
      cardTheme: const CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        margin: EdgeInsets.all(8),
        color: Colors.white,
        shadowColor: Colors.black12,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryGreen,
          foregroundColor: Colors.white,
          elevation: 4,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryGreen, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryGreen.withOpacity(0.5), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _errorRed, width: 1.5),
        ),
        labelStyle: _tajawalTextTheme.bodyLarge?.copyWith(color: _primaryGreen),
        hintStyle: _tajawalTextTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        backgroundColor: Colors.white,
        titleTextStyle: _tajawalTextTheme.titleLarge?.copyWith(
          color: _primaryGreen,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: _tajawalTextTheme.bodyMedium,
      ),
      dividerTheme: const DividerThemeData(color: Colors.grey, thickness: 1, space: 0),
      scaffoldBackgroundColor: _lightBackground,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    final baseTheme = ThemeData.dark(useMaterial3: true);
    return baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: _primaryGreen,
        secondary: _accentGreen,
        surface: _darkSurface,
        background: _darkBackground,
        error: _errorRed,
      ),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: _darkSurface,
        elevation: 4,
        centerTitle: true,
        titleTextStyle: _tajawalTextTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: _tajawalTextTheme,
      cardTheme: const CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        margin: EdgeInsets.all(8),
        color: _darkSurface,
      ),
      elevatedButtonTheme: lightTheme.elevatedButtonTheme,
      inputDecorationTheme: lightTheme.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: _darkSurface,
        labelStyle: _tajawalTextTheme.bodyLarge?.copyWith(color: _accentGreen),
      ),
      scaffoldBackgroundColor: _darkBackground,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
