import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';

// =======================================================
// 🏷️ STATUS BADGE – PENANDA NASIB DATA
// =======================================================
// Kecil, tapi penting.
// Satu badge bisa bikin user tenang 😌
// atau mikir ulang 🤔
//
// ASCII BADGE:
//
//   ┌───────────┐
//   │  STATUS   │
//   │  ✔ / ⚠️   │
//   └───────────┘
//
// =======================================================

class StatusBadge extends StatelessWidget {
  // 🏷️ Teks di dalam badge
  // contoh: "Normal", "Berisiko", "Aman", "Waspada"
  final String label;

  // ⚠️ Flag status
  // true  → warning (kuning)
  // false → aman (hijau)
  final bool isWarning;

  const StatusBadge({
    super.key,
    required this.label,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    // 🌗 Deteksi tema
    final isDark = Theme.of(context).brightness == Brightness.dark;

    print("");
    print("🏷️ ================================");
    print("🏷️ StatusBadge dibangun");
    print("🏷️ Label     : $label");
    print("🏷️ Mode      : ${isDark ? "Dark 🌙" : "Light 🌞"}");
    print("🏷️ Warning?  : $isWarning");
    print("🏷️ ================================");
    print("");

    // ===================================================
    // 🎨 Warna Background Badge
    // ===================================================
    // Warning → kuning
    // Aman    → hijau
    final backgroundColor = isWarning
        ? (isDark ? AppColors.warningDark : AppColors.warningLight)
        : (isDark ? AppColors.successDark : AppColors.successLight);

    // ===================================================
    // ✍️ Warna Teks
    // ===================================================
    // Kontras tetap aman, mata user selamat 👀
    final textColor = isWarning
        ? (isDark ? Colors.amber[100] : Colors.brown[800])
        : (isDark ? Colors.greenAccent[100] : Colors.green[900]);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8), // 🔵 Biar ramah
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/*
===========================================================
ASCII MOTIVATION:

   (⌐■_■)
    < BADGE >
    < STATUS >
     /     \

Tips UI:
- Badge kecil = info cepat ⚡
- Warna harus konsisten 🎨
- Jangan pakai merah kalau belum darurat 🚨

print("🏷️ StatusBadge ready!");
===========================================================
*/
