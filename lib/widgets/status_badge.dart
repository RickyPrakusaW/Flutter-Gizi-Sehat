import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String label; // misal: "Normal" / "Berisiko"
  final bool isWarning; // kalau true → warna kuning, kalau false → hijau

  const StatusBadge({
    super.key,
    required this.label,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Warna background badge
    final backgroundColor = isWarning
        ? (isDark ? AppColors.warningDark : AppColors.warningLight)
        : (isDark ? AppColors.successDark : AppColors.successLight);

    // Warna teks di dalam badge
    final textColor = isWarning
        ? (isDark ? Colors.amber[100] : Colors.brown[800])
        : (isDark ? Colors.greenAccent[100] : Colors.green[900]);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
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
