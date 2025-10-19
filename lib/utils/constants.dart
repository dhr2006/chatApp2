import 'package:flutter/material.dart';

class AppColors {
  // Main gradient colors - Amber to Deep Orange theme
  static const Color primary = Color(0xFFF59E0B); // Amber 500
  static const Color primaryDark = Color(0xFFEA580C); // Orange 600
  static const Color accent = Color(0xFFFB923C); // Orange 400
  
  // Background colors - Dark slate theme
  static const Color background = Color(0xFF0F172A); // Slate 900
  static const Color backgroundLight = Color(0xFF1E293B); // Slate 800
  static const Color surface = Color(0xFF334155); // Slate 700
  
  // Text colors
  static const Color textPrimary = Color(0xFFF8FAFC); // Slate 50
  static const Color textSecondary = Color(0xFF94A3B8); // Slate 400
  static const Color textHint = Color(0xFF64748B); // Slate 500
  
  // Message bubble colors
  static const Color myMessageBubble = Color(0xFFF59E0B); // Amber 500
  static const Color otherMessageBubble = Color(0xFF475569); // Slate 600
  
  // Border colors
  static const Color border = Color(0xFF475569); // Slate 600
  static const Color borderLight = Color(0xFF334155); // Slate 700
  
  // Status colors
  static const Color online = Color(0xFF10B981); // Green 500
  static const Color offline = Color(0xFF6B7280); // Gray 500
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color success = Color(0xFF10B981); // Green 500
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        // ignore: deprecated_member_use
        background: AppColors.background,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // ignore: deprecated_member_use
        fillColor: AppColors.surface.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        hintStyle: const TextStyle(color: AppColors.textHint),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

class AppConstants {
  static const String appName = 'ChatFlow';
  static const double borderRadius = 12.0;
  static const double avatarSize = 40.0;
  static const double messageBubbleRadius = 16.0;
}