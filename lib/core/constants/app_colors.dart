import 'package:flutter/material.dart';

class AppColors {
  // =======================================================
  // 🎨 APP COLORS – PALET KEHIDUPAN UI
  // =======================================================
  // Warna boleh beda,
  // tapi konsistensi harus sama ❤️
  //
  // ASCII PALET:
  //  ┌──────────────┐
  //  │  🎨  UI ART  │
  //  │  █ █ █ █ █  │
  //  └──────────────┘
  //
  // =======================================================

  // 🟢 Warna utama brand
  // Dipakai di tombol, icon penting, dan harapan user
  static const accent = Color(0xFF4CAF50); // 🌱 Hijau = sehat & damai

  // =======================================================
  // 🌞 LIGHT MODE (siang hari, mata masih kuat)
  // =======================================================
  static const lightBackground = Color(0xFFF9F9F9); // 🧻 Background bersih
  static const lightSurface = Colors.white;         // 📄 Card & surface
  static const lightTextPrimary = Color(0xFF111111); // ✍️ Teks utama
  static const lightTextSecondary = Color(0xFF7D7D7D); // 📝 Teks pendukung
  static const lightBorder = Color(0xFFE8E8E8); // 🧱 Garis pemisah sopan

  // =======================================================
  // 🌙 DARK MODE (jam 2 pagi, mata berdarah)
  // =======================================================
  static const darkBackground = Color(0xFF111111); // 🌑 Background gelap
  static const darkSurface = Color(0xFF1C1C1C); // 🪨 Card gelap
  static const darkTextPrimary = Color(0xFFF5F5F5); // ✨ Teks terang
  static const darkTextSecondary = Color(0xFFA0A0A0); // 🌫️ Teks sekunder
  static const darkBorder = Color(0xFF2A2A2A); // 🧱 Border gelap

  // =======================================================
  // 🟢 STATUS COLORS (adaptif & penuh makna)
  // =======================================================
  // SUCCESS = hidup masih aman
  static const successLight = Color(0xFFC8FCE3); // 😄 Aman terkendali
  static const successDark = Color(0xFF2A4F3B);  // 😌 Aman versi gelap

  // WARNING = hati-hati, tapi belum kiamat
  static const warningLight = Color(0xFFFFF2C4); // 😬 Ada yang kurang
  static const warningDark = Color(0xFF4D4622);  // ⚠️ Jangan diabaikan

// =======================================================
// 🧪 DEBUG COLOR CHECK (mental)
// =======================================================
// Kalau UI aneh:
// 1. Cek warna
// 2. Cek theme
// 3. Cek hidup
//
// print("🎨 AppColors loaded successfully!");
// =======================================================
}

/*
===========================================================
ASCII MOTIVATION:

   (⌐■_■)
   < UI Dev >
   /  |  \
     / \

Tips warna:
- Jangan pakai warna random ❌
- Konsisten > estetik sementara ✅
- Dark mode bukan sekadar gelap 🌙

print("🎨 Warna aman, UI tenang");
===========================================================
*/
