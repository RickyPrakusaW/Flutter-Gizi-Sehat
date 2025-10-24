import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';

ThemeData buildLightTheme() {
  const background = Color(0xFFF9F9F9);
  const surface = Colors.white;
  const textPrimary = Color(0xFF111111);
  const textSecondary = Color(0xFF7D7D7D);
  const border = Color(0xFFE8E8E8);

  final colorScheme = ColorScheme.light(
    primary: AppColors.accent,
    background: background,
    surface: surface,
    onBackground: textPrimary,
    onSurface: textPrimary,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: background,
    colorScheme: colorScheme,

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textPrimary),
      bodyMedium: TextStyle(color: textSecondary),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
    ),

    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: border, width: 1),
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.accent,
      unselectedItemColor: Colors.black87,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),

    dividerColor: border,
  );
}
