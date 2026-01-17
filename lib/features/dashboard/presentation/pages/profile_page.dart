import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';
import 'package:gizi_sehat_mobile_app/features/profile/state/theme_provider.dart';
import 'package:gizi_sehat_mobile_app/features/auth/state/auth_provider.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';
import 'package:gizi_sehat_mobile_app/widgets/status_badge.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final headingColor =
    isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    final subtitleColor =
    isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final sectionBg = theme.colorScheme.surface;
    final borderColor =
    isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final innerCardBg =
    isDark ? const Color(0xFF262626) : const Color(0xFFF9F9F9);

    final avatarBg = AppColors.accent.withOpacity(0.15);

    final themeProvider = context.watch<ThemeProvider>();
    final darkModeOn = themeProvider.isDark;

    final auth = context.watch<AuthProvider>();
    final userEmail = auth.currentEmail ?? '-';

    // Widget builder childTile
    Widget childTile({
      required String name,
      required String desc1,
      required String desc2,
      required Widget badge,
    }) {
      return Container(
        decoration: BoxDecoration(
          color: innerCardBg,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar anak
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: avatarBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.health_and_safety_outlined,
                color: AppColors.accent,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),

            // Tulisan anak
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // row: nama + badge + edit
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: headingColor,
                          ),
                        ),
                      ),
                      badge,
                      const SizedBox(width: 8),
                      Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: headingColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$desc1 •\n$desc2',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // section wrapper
    Widget sectionCard({required Widget child}) {
      return Container(
        decoration: BoxDecoration(
          color: sectionBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 24),
        child: child,
      );
    }

    Future<void> handleLogout() async {
      await context.read<AuthProvider>().logout();

      // setelah logout, arahkan balik ke login
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRouter.login,
              (route) => false,
        );
      }
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ===== HEADER PROFILE =====
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: avatarBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.accent,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),

            // Nama orang tua (sementara hardcode, nanti ambil dari Firestore profile user)
            Text(
              'Orang Tua',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: headingColor,
              ),
            ),
            const SizedBox(height: 4),

            // email dari Firebase Auth
            Text(
              userEmail,
              style: TextStyle(
                fontSize: 14,
                color: subtitleColor,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: headingColor,
                ),
                const SizedBox(width: 6),
                Text(
                  'Edit Profil',
                  style: TextStyle(
                    fontSize: 14,
                    color: headingColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ===== KELOLA ANAK =====
            sectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.tag_faces_outlined,
                        color: headingColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Kelola Anak',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: headingColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  childTile(
                    name: 'Sari',
                    desc1: '8 bulan',
                    desc2: 'Perempuan',
                    badge: const StatusBadge(
                      label: 'Normal',
                      isWarning: false,
                    ),
                  ),

                  childTile(
                    name: 'Budi',
                    desc1: '2 tahun 4 bulan',
                    desc2: 'Laki-laki',
                    badge: const StatusBadge(
                      label: 'Berisiko',
                      isWarning: true,
                    ),
                  ),

                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: borderColor,
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: 18,
                          color: headingColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tambah Anak',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: headingColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ===== PENGATURAN TAMPILAN =====
            sectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.settings_outlined,
                        color: headingColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Pengaturan Tampilan',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: headingColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        darkModeOn
                            ? Icons.dark_mode_outlined
                            : Icons.wb_sunny_outlined,
                        color: headingColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mode Gelap',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: headingColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              darkModeOn ? 'Aktif' : 'Nonaktif',
                              style: TextStyle(
                                fontSize: 13,
                                color: subtitleColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: darkModeOn,
                        activeThumbColor: AppColors.accent,
                        onChanged: (val) {
                          context.read<ThemeProvider>().toggleTheme(val);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ===== Logout Button =====
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: sectionBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor, width: 1),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: handleLogout,
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      'Keluar Akun',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Anda akan keluar dari aplikasi ini',
                    style: TextStyle(
                      fontSize: 13,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
