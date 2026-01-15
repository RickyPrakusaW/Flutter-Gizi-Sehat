import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';

class AppTextStyles {
  // =======================================================
  // ✍️ APP TEXT STYLES – SUARA DARI UI
  // =======================================================
  // Kalau warna itu pakaian,
  // maka text style itu nada bicara 🎙️
  // =======================================================

  // 🚫 Private constructor
  // Class ini cuma gudang style, bukan buat di-instansiasi
  AppTextStyles._();

  // =======================================================
  // 🔒 STATIC DEFAULTS
  // =======================================================
  // Dipakai untuk komponen tetap
  // Contoh: Button, CTA, "YA SAYA SETUJU"
  static const buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // =======================================================
  // 🎯 DYNAMIC TEXT (berdasarkan theme)
  // =======================================================
  // Light mode / Dark mode?
  // Biarkan context yang menjawab 🤔

  // ===============================
  // 🧱 Heading Besar & Tegas
  // ===============================
  static TextStyle headingBold(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    print("");
    print("✍️ headingBold() dipanggil");
    print("🌗 Mode: ${isDark ? "Dark 🌙" : "Light 🌞"}");
    print("");

    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: isDark
          ? AppColors.darkTextPrimary
          : AppColors.lightTextPrimary,
    );
  }

  // ===============================
  // 📝 Subtitle
  // ===============================
  // Teks penjelas, lembut tapi penting
  static TextStyle subtitle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    print("📝 subtitle() → ${isDark ? "Dark" : "Light"} mode");

    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: isDark
          ? AppColors.darkTextSecondary
          : AppColors.lightTextSecondary,
    );
  }

  // ===============================
  // 📄 Body Regular
  // ===============================
  // Teks utama yang paling sering muncul
  static TextStyle bodyRegular(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    print("📄 bodyRegular() dipakai");

    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: isDark
          ? AppColors.darkTextPrimary
          : AppColors.lightTextPrimary,
    );
  }

  // ===============================
  // 🔍 Body Small
  // ===============================
  // Catatan kecil, disclaimer, teks ikhlas
  static TextStyle bodySmall(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    print("🔍 bodySmall() aktif");

    return TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: isDark
          ? AppColors.darkTextSecondary
          : AppColors.lightTextSecondary,
    );
  }

  // ===============================
  // 🧭 Section Title
  // ===============================
  // Judul per bagian, bukan drama utama
  static TextStyle sectionTitle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    print("🧭 sectionTitle() dipanggil");

    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: isDark
          ? AppColors.darkTextPrimary
          : AppColors.lightTextPrimary,
    );
  }
}

/*
===========================================================
ASCII MOTIVATION:

  (⌐■_■)
   < TEXT >
   < STYLE >
    /   \

Tips UI Text:
- Jangan campur fontWeight sembarangan ❌
- Konsistensi > kreatif mendadak ✅
- Line-height itu penting (1.4–1.6) 📐

print("✍️ TextStyle aman, UI terasa hidup");
===========================================================
*/
