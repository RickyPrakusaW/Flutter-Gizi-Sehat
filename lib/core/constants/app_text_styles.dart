import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ===== Static Defaults (dipakai untuk komponen tetap seperti button) =====
  static const buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // ===== Dinamis Berdasarkan Theme =====
  static TextStyle headingBold(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: isDark
          ? AppColors.darkTextPrimary
          : AppColors.lightTextPrimary,
    );
  }

  static TextStyle subtitle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: isDark
          ? AppColors.darkTextSecondary
          : AppColors.lightTextSecondary,
    );
  }

  static TextStyle bodyRegular(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: isDark
          ? AppColors.darkTextPrimary
          : AppColors.lightTextPrimary,
    );
  }

  static TextStyle bodySmall(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: isDark
          ? AppColors.darkTextSecondary
          : AppColors.lightTextSecondary,
    );
  }

  static TextStyle sectionTitle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: isDark
          ? AppColors.darkTextPrimary
          : AppColors.lightTextPrimary,
    );
  }
}
