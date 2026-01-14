import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';

/// Halaman dashboard - menampilkan ringkasan pertumbuhan dan tips gizi
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

          // Card 1 - AI Assistant
          _SectionCard(
            backgroundColor: sectionBg,
            borderColor: borderColor,
            isDark: isDark,
            icon: Icons.health_and_safety,
            text: 'Tanya AI GiziSehat sekarang.\n"Kebutuhan gizi anak usia 2 tahun apa aja?"',
          ),
          const SizedBox(height: 16),

          // Card 2 - Growth summary
          _SectionCard(
            backgroundColor: sectionBg,
            borderColor: borderColor,
            isDark: isDark,
            icon: Icons.show_chart,
            text: 'Pertumbuhan anak terakhir: BB 10.2 kg, TB 82 cm.\nStatus: Normal.',
          ),
          const SizedBox(height: 16),

          // Card 3 - Nutrition Tips
          _SectionCard(
            backgroundColor: sectionBg,
            borderColor: borderColor,
            isDark: isDark,
            icon: Icons.restaurant_menu,
            text: 'Tips hari ini:\nMPASI tinggi protein hewani bantu cegah stunting.',
          ),
        ],
      ),
    );
  }
}

/// Widget untuk section card yang reusable
class _SectionCard extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final bool isDark;
  final IconData icon;
  final String text;

  const _SectionCard({
    required this.backgroundColor,
    required this.borderColor,
    required this.isDark,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
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
}
