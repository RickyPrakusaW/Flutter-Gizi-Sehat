import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';

class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final headingColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;

    final subtitleColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    final sectionBg = theme.colorScheme.surface;
    final borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.lightBorder;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Menu & Rekomendasi Gizi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: headingColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ide MPASI, porsi harian, dan kandungan nutrisi.',
            style: TextStyle(
              fontSize: 14,
              color: subtitleColor,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          // Rekomendasi Hari Ini
          Container(
            decoration: BoxDecoration(
              color: sectionBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 1),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.restaurant_menu_outlined,
                  color: AppColors.accent,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Rekomendasi Hari Ini:\n'
                        '• Bubur salmon + telur\n'
                        '• Sup ayam sayur\n'
                        '• Pisang + tempe kukus',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: headingColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Catatan Ahli Gizi
          Container(
            decoration: BoxDecoration(
              color: sectionBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 1),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Catatan Ahli Gizi:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: headingColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Protein hewani penting untuk mencegah stunting. '
                      'Pastikan ada sumber hewani tiap makan utama.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: headingColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
