import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:gizi_sehat_mobile_app/features/auth/state/auth_provider.dart';
import 'package:gizi_sehat_mobile_app/features/auth/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.userModel;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Area Dokter'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) =>
                    const Center(child: CircularProgressIndicator()),
              );

              final auth = context.read<AuthProvider>();
              await auth.logout();

              if (!context.mounted) return;
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Profile
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary,
                  backgroundImage: user.profileImage != null
                      ? NetworkImage(user.profileImage!)
                      : null,
                  child: user.profileImage == null
                      ? Text(
                          user.name[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.email,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: user.status == UserStatus.active
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: user.status == UserStatus.active
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                  child: Text(
                    user.status == UserStatus.active
                        ? 'Terverifikasi'
                        : 'Menunggu Verifikasi',
                    style: TextStyle(
                      color: user.status == UserStatus.active
                          ? Colors.green
                          : Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Konten Berdasarkan Status
            if (user.status == UserStatus.pending) ...[
              _buildVerificationCard(context, user),
            ] else if (user.status == UserStatus.active) ...[
              _buildActiveDashboard(context),
            ] else ...[
              const Center(child: Text('Akun Anda ditolak. Hubungi admin.')),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationCard(BuildContext context, UserModel user) {
    bool hasUploaded = user.proofUrl != null && user.proofUrl!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange[800]),
              const SizedBox(width: 12),
              Text(
                'Lengkapi Profil Anda',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[900],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Agar dapat melayani konsultasi, Admin perlu memverifikasi data kredensial Anda (STR/SIP).',
            style: TextStyle(height: 1.5, color: Colors.black87),
          ),
          const SizedBox(height: 24),
          if (hasUploaded) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 48),
                  const SizedBox(height: 8),
                  const Text(
                    'Dokumen Terkirim',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text('Mohon tunggu verifikasi Admin'),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => _uploadProof(context),
                    icon: const Icon(Icons.edit),
                    label: const Text('Update Dokumen'),
                  ),
                ],
              ),
            ),
          ] else ...[
            const Text(
              'Upload Foto STR / SIP / Kartu Nama:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => _uploadProof(context),
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload Dokumen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActiveDashboard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Menu Dokter',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildMenuCard(
              context,
              icon: Icons.chat_bubble_outline,
              label: 'Konsultasi (Chat)',
              color: Colors.blue,
              onTap: () {
                Navigator.pushNamed(context, AppRouter.chatList,
                    arguments: {'isDoctor': true});
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.people_outline,
              label: 'Riwayat Pasien',
              color: Colors.green,
              onTap: () {},
            ),
            _buildMenuCard(
              context,
              icon: Icons.account_circle_outlined,
              label: 'Profil Dokter',
              color: Colors.purple,
              onTap: () {
                Navigator.pushNamed(context, AppRouter.doctorProfile);
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.settings_outlined,
              label: 'Pengaturan',
              color: Colors.orange,
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.withOpacity(0.2)),
          ),
          child: const Column(
            children: [
              Text(
                'Status: Aktif',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Anda sekarang tampil di daftar dokter pengguna.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadProof(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text(
              'Fitur Upload sedang disiapkan... Menggunakan data simulasi.')),
    );

    try {
      final user = context.read<AuthProvider>().userModel;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .update({
          'proof_url': 'https://placehold.co/400x600/png?text=Bukti+Dokter',
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bukti berhasil diupload (Simulasi)')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}
