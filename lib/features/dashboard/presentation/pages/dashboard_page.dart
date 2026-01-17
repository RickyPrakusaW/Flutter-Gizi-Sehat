import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';

/// Halaman utama dashboard beranda
/// Menampilkan header, card chat asisten, list anak-anak, dan aksi cepat
class DashboardPage extends StatelessWidget {
  /// Callback untuk navigasi ke tab tertentu (0=Beranda, 1=Tumbuh, 2=Menu, 3=Asisten, 4=Profil)
  final Function(int)? onNavigateToTab;

  const DashboardPage({super.key, this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan judul aplikasi
            _buildHeader(theme),
            // Card promosi chat dengan asisten gizi
            _buildChatAssistantCard(context, theme),
            // Section list anak-anak yang terdaftar
            _buildMyChildrenSection(context, theme),
            // Section aksi cepat (4 card shortcut)
            _buildQuickActionsSection(context, theme),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Membangun header dengan judul "GiziSehat" dan subtitle
  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        children: [
          Text(
            'GiziSehat',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Asisten Gizi Keluarga',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  /// Membangun card promosi chat dengan asisten gizi (warna biru)
  /// Ketika diklik, navigasi ke tab Asisten (index 3)
  Widget _buildChatAssistantCard(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: InkWell(
        onTap: () {
          onNavigateToTab?.call(3);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.smart_toy_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chat dengan Asisten Gizi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Konsultasi seputar nutrisi & tumbuh kembang',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF1976D2),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Membangun section untuk menampilkan list anak-anak yang terdaftar
  /// Termasuk card untuk setiap anak dan tombol tambah anak
  Widget _buildMyChildrenSection(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Anak-anak Saya',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildChildCard(
            theme: theme,
            name: 'Sari',
            age: '8 bulan',
            status: 'Normal',
            statusColor: AppColors.accent,
            checkDate: 'Cek: 3 hari lagi',
          ),
          const SizedBox(height: 12),
          _buildChildCard(
            theme: theme,
            name: 'Budi',
            age: '2 tahun 4 bulan',
            status: 'Berisiko',
            statusColor: Colors.orange,
            checkDate: 'Cek: Minggu depan',
          ),
          const SizedBox(height: 12),
          _buildAddChildButton(context, theme),
        ],
      ),
    );
  }

  /// Membangun card untuk menampilkan informasi satu anak
  /// Menampilkan: icon, nama, umur, badge status (Normal/Berisiko), dan jadwal cek
  Widget _buildChildCard({
    required ThemeData theme,
    required String name,
    required String age,
    required String status,
    required Color statusColor,
    required String checkDate,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? AppColors.darkBorder
              : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.child_care, color: AppColors.accent),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  age,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                checkDate,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Membangun tombol untuk menambahkan anak baru
  /// TODO: Implementasi navigasi ke halaman tambah anak
  Widget _buildAddChildButton(BuildContext context, ThemeData theme) {
    return InkWell(
      onTap: () {
        // TODO: Navigate to add child screen
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.brightness == Brightness.dark
                ? AppColors.darkBorder
                : AppColors.lightBorder,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: Colors.grey.shade400,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Tambah Anak',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Membangun section aksi cepat dengan 4 card dalam grid 2x2:
  /// - Cek Pertumbuhan, Skrining Risiko, Jadwal Posyandu, Chat Asisten
  Widget _buildQuickActionsSection(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aksi Cepat',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  context: context,
                  theme: theme,
                  icon: Icons.show_chart,
                  label: 'Cek Pertumbuhan',
                  iconColor: AppColors.accent,
                  onTap: () => onNavigateToTab?.call(1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  context: context,
                  theme: theme,
                  icon: Icons.warning_amber_rounded,
                  label: 'Skrining Risiko',
                  iconColor: Colors.orange,
                  onTap: () {}, // TODO
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  context: context,
                  theme: theme,
                  icon: Icons.calendar_month,
                  label: 'Jadwal Makan',
                  iconColor: Colors.orange,
                  onTap: () =>
                      Navigator.pushNamed(context, '/nutrition-schedule'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  context: context,
                  theme: theme,
                  icon: Icons.medical_services,
                  label: 'Konsultasi',
                  iconColor: Colors.purple,
                  onTap: () => Navigator.pushNamed(context, '/doctor-list'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  context: context,
                  theme: theme,
                  icon: Icons.shopping_bag,
                  label: 'Toko Sehat',
                  iconColor: Colors.green,
                  onTap: () => Navigator.pushNamed(context, '/marketplace'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  context: context,
                  theme: theme,
                  icon: Icons.smart_toy_outlined,
                  label: 'Chat Asisten',
                  iconColor: const Color(0xFF2196F3),
                  onTap: () => onNavigateToTab?.call(3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Membangun card untuk aksi cepat individual
  /// Masing-masing card memiliki icon dan label, dapat diklik untuk navigasi
  Widget _buildQuickActionCard({
    required BuildContext context,
    required ThemeData theme,
    required IconData icon,
    required String label,
    required Color iconColor,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.brightness == Brightness.dark
                ? AppColors.darkBorder
                : AppColors.lightBorder,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: iconColor),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
