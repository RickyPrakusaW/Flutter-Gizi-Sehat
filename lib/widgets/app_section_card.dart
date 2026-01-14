import 'package:flutter/material.dart';

// =======================================================
// 📦 APP SECTION CARD – KOTAK AMAN UNTUK KONTEN
// =======================================================
// Kalau UI itu rumah,
// card ini adalah ruang tamu 🛋️
// Rapi, bersih, dan bikin betah.
//
// ASCII CARD:
//
//   ┌──────────────────┐
//   │   📦 SECTION     │
//   │   CARD           │
//   │   (aman & rapi)  │
//   └──────────────────┘
//
// =======================================================

class AppSectionCard extends StatelessWidget {
  // 🧩 Isi card (bebas: text, column, form, apa pun)
  final Widget child;

  // 📐 Padding dalam card
  final EdgeInsetsGeometry padding;

  // 📏 Margin luar card
  final EdgeInsetsGeometry margin;

  const AppSectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    print("");
    print("📦 ================================");
    print("📦 AppSectionCard dibangun");
    print("📦 Padding : $padding");
    print("📦 Margin  : $margin");
    print("📦 Warna   : PUTIH SELALU 🤍");
    print("📦 ================================");
    print("");

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        // 🤍 Putih SELALU
        // Sesuai profil page, tidak ikut dark mode
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // 🔵 Rounded = ramah
        border: Border.all(
          color: const Color(0xFFE0E0E0), // 🧱 Border halus
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // 🌫️ Bayangan sopan
            blurRadius: 8,
            offset: const Offset(0, 4), // ⬇️ Shadow ke bawah
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

/*
===========================================================
ASCII MOTIVATION:

   (⌐■_■)
    < CARD >
    < CLEAN >
     /     \

Tips UI Card:
- Jangan kebanyakan shadow ❌
- Radius konsisten itu seksi ✅
- Putih kadang lebih elegan dari gelap 🤍

print("📦 AppSectionCard ready!");
===========================================================
*/
