import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';

// =======================================================
// 🌞 LIGHT THEME – MODE SIANG HARI
// =======================================================
// Dipakai saat:
// - Mata masih segar
// - Kopi belum habis ☕
// - User belum aktifkan dark mode 😌
//
// ASCII THEME:
//
//    🌞
//   \ | /
//  -- ☀ --
//   / | \
//
// =======================================================

ThemeData buildLightTheme() {
  print("");
  print("🌞 ================================");
  print("🌞 Membangun LIGHT THEME");
  print("🌞 UI bersih, terang, dan damai");
  print("🌞 ================================");
  print("");

  // ===================================================
  // 🎨 Warna Dasar Light Mode
  // ===================================================
  const background = Color(0xFFF9F9F9);   // 🧻 Background utama
  const surface = Colors.white;           // 📄 Card & surface
  const textPrimary = Color(0xFF111111);  // ✍️ Teks utama
  const textSecondary = Color(0xFF7D7D7D); // 📝 Teks sekunder
  const border = Color(0xFFE8E8E8);       // 🧱 Border halus

  // ===================================================
  // 🎨 ColorScheme
  // ===================================================
  final colorScheme = ColorScheme.light(
    primary: AppColors.accent, // 🌱 Warna brand
    background: background,
    surface: surface,
    onBackground: textPrimary,
    onSurface: textPrimary,
  );

  // ===================================================
  // 🧩 ThemeData
  // ===================================================
  return ThemeData(
    useMaterial3: true, // 🚀 Ikut zaman
    brightness: Brightness.light,
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
      backgroundColor: Colors.transparent, // 🫥 Transparan elegan
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
        borderRadius: BorderRadius.circular(16), // 🔵 Rounded ramah
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
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.accent, // 🌱 Aktif
      unselectedItemColor: Colors.black87, // 😐 Non-aktif
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
    < LIGHT >
    < THEME >
     /     \

Tips Theme:
- Warna terang ≠ silau ❌
- Kontras itu wajib ♿
- Konsistensi > eksperimen dadakan ✅

print("🌞 Light theme ready!");
===========================================================
*/
