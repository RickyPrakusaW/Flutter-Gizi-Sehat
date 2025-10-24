import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';

class GrowthPage extends StatelessWidget {
  const GrowthPage({super.key});

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
            'Pantau Pertumbuhan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: headingColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Catat berat badan (BB), tinggi badan (TB), dan usia anak.\nLihat grafik sesuai standar WHO.',
            style: TextStyle(
              fontSize: 14,
              color: subtitleColor,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          // DATA TERAKHIR
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
                  'Data Terakhir',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: headingColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• BB: 10.2 kg\n'
                      '• TB: 82 cm\n'
                      '• Usia: 24 bulan\n'
                      '• Kategori: Normal',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: headingColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // GRAFIK
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
                  Icons.show_chart_outlined,
                  color: AppColors.accent,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Grafik Pertumbuhan\n[akan ditampilkan di sini]',
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
        ],
      ),
    );
  }
}
