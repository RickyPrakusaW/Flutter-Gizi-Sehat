// Konstanta desain yang digunakan di seluruh aplikasi
import 'package:flutter/material.dart';

abstract class AppConstants {
  // Spacing
  static const double spacingXs = 4;
  static const double spacingSmall = 8;
  static const double spacingMedium = 12;
  static const double spacingLarge = 16;
  static const double spacingXl = 20;
  static const double spacing2xl = 24;
  static const double spacing3xl = 32;

  // Border Radius
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusXl = 20;

  // Icon Sizes
  static const double iconSmall = 16;
  static const double iconMedium = 24;
  static const double iconLarge = 32;
  static const double iconXl = 48;

  // Animation Duration
  static const Duration animationShort = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationLong = Duration(milliseconds: 500);
}
