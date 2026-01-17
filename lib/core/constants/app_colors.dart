import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette (Soft Blue) - DOMINANT
  static const primary = Color(0xFF5C9DFF); // Soft Blue
  static const primaryDark = Color(0xFF3A7BC8);
  static const primaryLight = Color(0xFFE3F0FF);

  // Secondary/Action Colors
  static const accent = Color(
    0xFF00BFA5,
  ); // Teal/Tosca for generic accents/actions
  static const actionColor = accent;

  // Gender Colors
  static const femalePink = Color(0xFFFF9AA2); // ONLY for female indicators
  static const maleBlue = Color(0xFF90CAF9); // ONLY for male indicators
  static const pinkLight = Color(0xFFFFF0F1);

  // Status Colors
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFC107);
  static const error = Color(0xFFE57373);
  static const info = Color(0xFF64B5F6);

  static const lightBackground = Color(0xFFF8FAFC); // Cool gray/white
  static const lightSurface = Colors.white;
  static const lightTextPrimary = Color(0xFF2D3748);
  static const lightTextSecondary = Color(0xFF718096);
  static const lightBorder = Color(0xFFE2E8F0);

  // Dark Mode Support (Optional but good to have)
  static const darkBackground = Color(0xFF1A202C);
  static const darkSurface = Color(0xFF2D3748);
  static const darkTextPrimary = Color(0xFFF7FAFC);
  static const darkTextSecondary = Color(0xFFA0AEC0);
  static const darkBorder = Color(0xFF4A5568);

  static const successLight = Color(0xFFC6F6D5);
  static const successDark = Color(0xFF22543D);

  static const warningLight = Color(0xFFFEFCBF);
  static const warningDark = Color(0xFF744210);
}
