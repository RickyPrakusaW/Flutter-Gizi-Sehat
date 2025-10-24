import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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

    final sectionBg = theme.colorScheme.surface; // dari theme (1C1C1C / white)
    final borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.lightBorder;

    Widget sectionCard({
      required IconData icon,
      required String text,
    }) {
      return Container(
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
              icon,
              color: AppColors.accent,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // HEADER
          Text(
            'Halo, Ibu 👋',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: headingColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Pantau pertumbuhan anak dan cek gizi harian di sini.',
            style: TextStyle(
              fontSize: 14,
              color: subtitleColor,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          // CARD 1 - AI Assistant
          sectionCard(
            icon: Icons.health_and_safety,
            text:
            'Tanya AI GiziSehat sekarang.\n“Kebutuhan gizi anak usia 2 tahun apa aja?”',
          ),
          const SizedBox(height: 16),

          // CARD 2 - Growth summary
          sectionCard(
            icon: Icons.show_chart,
            text:
            'Pertumbuhan anak terakhir: BB 10.2 kg, TB 82 cm.\nStatus: Normal.',
          ),
          const SizedBox(height: 16),

          // CARD 3 - Tips Gizi
          sectionCard(
            icon: Icons.restaurant_menu,
            text:
            'Tips hari ini:\nMPASI tinggi protein hewani bantu cegah stunting.',
          ),
        ],
      ),
    );
  }
}
