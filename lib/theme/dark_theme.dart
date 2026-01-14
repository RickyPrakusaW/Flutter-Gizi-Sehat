import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';

// =======================================================
// 🌙 DARK THEME – MODE MALAM HARI
// =======================================================
// Dipakai saat:
// - Lampu mati
// - Kopi dingin ☕
// - Mata hampir menyerah 😵‍💫
//
// ASCII NIGHT:
//
//     🌙
//    /___\
//   | DARK |
//    \___/
//
// =======================================================

ThemeData buildDarkTheme() {
  print("");
  print("🌙 ================================");
  print("🌙 Membangun DARK THEME");
  print("🌙 Mode malam aktif – mata diselamatkan");
  print("🌙 ================================");
  print("");

  // ===================================================
  // 🎨 Warna Dasar Dark Mode
  // ===================================================
  const background = Color(0xFF111111);    // 🌑 Background utama
  const surface = Color(0xFF1C1C1C);       // 🪨 Surface & card
  const textPrimary = Color(0xFFF5F5F5);   // ✨ Teks utama
  const textSecondary = Color(0xFFA0A0A0); // 🌫️ Teks sekunder
  const border = Color(0xFF2A2A2A);        // 🧱 Border gelap

  // ===================================================
  // 🎨 ColorScheme (Dark)
  // ===================================================
  final colorScheme = ColorScheme.dark(
    primary: AppColors.accent, // 🌱 Tetap brand
    background: background,
    surface: surface,
    onBackground: textPrimary,
    onSurface: textPrimary,
  );

  // ===================================================
  // 🧩 ThemeData
  // ===================================================
  return ThemeData(
    useMaterial3: true, // 🚀 Material 3 tetap jalan
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: colorScheme,

    // ===============================
    // ✍️ Text Theme
    // ===============================
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textPrimary),
      bodyMedium: TextStyle(color: textSecondary),
    ),

    // ===============================
    // 🧭 AppBar Theme
    // ===============================
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent, // 🫥 Clean & modern
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
    ),

    // ===============================
    // 📦 Card Theme
    // ===============================
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // 🔵 Konsisten
        side: const BorderSide(
          color: border,
          width: 1,
        ),
      ),
    ),

    // ===============================
    // 🧭 Bottom Navigation Bar
    // ===============================
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF111111), // 🌑 Nyatu sama background
      selectedItemColor: AppColors.accent, // 🌱 Aktif
      unselectedItemColor: Colors.white70, // 😴 Non-aktif
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),

    // ===============================
    // ➖ Divider
    // ===============================
    dividerColor: border,
  );
}

/*
===========================================================
ASCII MOTIVATION:

   (⌐■_■)
    < DARK >
    < THEME >
     /     \

Tips Dark Mode:
- Jangan pakai hitam pekat ❌
- Abu gelap lebih ramah mata 👀
- Accent tetap hidup 🌱

print("🌙 Dark theme ready!");
===========================================================
*/
