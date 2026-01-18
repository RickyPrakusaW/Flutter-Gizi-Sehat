import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart' as excel_pkg;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';
import 'package:gizi_sehat_mobile_app/features/auth/models/user_model.dart';
import 'package:intl/intl.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: 'Verifikasi'),
              Tab(text: 'Daftar Dokter'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Keluar',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Keluar'),
                    content: const Text('Apakah Anda yakin ingin keluar?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Ya, Keluar'),
                      ),
                    ],
                  ),
                );

                if (confirm == true && context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [_buildVerificationTab(), _buildManagementTab(context)],
        ),
      ),
    );
  }

  Widget _buildVerificationTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'doctor')
          .where('status', isEqualTo: 'pending')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('Tidak ada dokter yang perlu diverifikasi saat ini.'),
          );
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final user = UserModel.fromJson(data);
            return _buildDoctorVerificationCard(context, user);
          },
        );
      },
    );
  }

  Widget _buildManagementTab(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _exportDoctorsToExcel(context),
              icon: const Icon(Icons.download),
              label: const Text('Export Data Dokter (Excel)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('role', isEqualTo: 'doctor')
                .where('status', whereIn: ['active', 'rejected']).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('Belum ada dokter terdaftar.'));
              }

              final docs = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final user = UserModel.fromJson(data);
                  return _buildDoctorManagementCard(context, user);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorVerificationCard(BuildContext context, UserModel user) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserHeader(user, 'Pending', Colors.orange),
            const SizedBox(height: 16),
            _buildDetailRow('Nomor STR', user.strNumber),
            _buildDetailRow('Nomor SIP', user.sipNumber),
            _buildDetailRow('Lokasi Praktik', user.practiceLocation),
            const SizedBox(height: 16),
            const Text(
              'Bukti Upload:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            _buildProofImage(context, user.proofUrl),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _rejectDoctor(context, user.id),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('Tolak'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _approveDoctor(context, user.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Setujui'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorManagementCard(BuildContext context, UserModel user) {
    final isActive = user.status == UserStatus.active;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ExpansionTile(
          shape: const Border(),
          leading: GestureDetector(
            onTap: user.profileImage != null
                ? () => _showFullImage(context, user.profileImage!)
                : null,
            child: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              backgroundImage: user.profileImage != null
                  ? NetworkImage(user.profileImage!)
                  : null,
              child: user.profileImage == null
                  ? const Icon(Icons.person, color: AppColors.primary)
                  : null,
            ),
          ),
          title: Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.email,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isActive ? 'Aktif' : 'Nonaktif/Ditolak',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          childrenPadding: const EdgeInsets.all(16),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const Text(
                  'Detail Informasi',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                _buildDetailRow('Spesialis', user.specialist),
                _buildDetailRow('Gelar', user.title),
                _buildDetailRow('Asal Lulusan', user.alumni),
                _buildDetailRow(
                  'Pengalaman',
                  '${user.experienceYear ?? "-"} Tahun',
                ),
                _buildDetailRow('Nomor STR', user.strNumber),
                _buildDetailRow('Nomor SIP', user.sipNumber),
                _buildDetailRow('Lokasi Praktik', user.practiceLocation),
                const SizedBox(height: 12),
                const Text(
                  'Foto Bukti Kompetensi:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                _buildProofImage(context, user.proofUrl, height: 100),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Status Akun:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Switch(
                      value: isActive,
                      activeThumbColor: Colors.white,
                      activeTrackColor: Colors.green,
                      onChanged: (val) {
                        if (val) {
                          _approveDoctor(context, user.id);
                        } else {
                          _rejectDoctor(context, user.id);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeader(
    UserModel user,
    String statusLabel,
    Color statusColor,
  ) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          backgroundImage: user.profileImage != null
              ? NetworkImage(user.profileImage!)
              : null,
          child: user.profileImage == null
              ? const Icon(Icons.person, color: AppColors.primary)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(user.email, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            statusLabel,
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProofImage(
    BuildContext context,
    String? url, {
    double height = 150,
  }) {
    return url != null
        ? GestureDetector(
            onTap: () => _showFullImage(context, url),
            child: Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(url),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        : Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Center(
              child: Text(
                'Tidak ada bukti upload',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          );
  }

  void _showFullImage(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.network(url, fit: BoxFit.contain),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(ctx),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _approveDoctor(BuildContext context, String uid) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'status': 'active',
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dokter berhasil disetujui')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _rejectDoctor(BuildContext context, String uid) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'status': 'rejected',
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dokter ditolak/dinonaktifkan')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _exportDoctorsToExcel(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(child: CircularProgressIndicator()),
      );

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'doctor')
          .get();

      var excel = excel_pkg.Excel.createExcel();
      excel_pkg.Sheet sheetObject = excel['Data Dokter'];
      excel.delete('Sheet1');

      // Styles in Excel 4.x often use properties directly or setters
      excel_pkg.CellStyle headerStyle = excel_pkg.CellStyle();
      // Styling is simplified to avoid version-specific type errors for now

      List<String> headers = [
        'Nama Lengkap',
        'Email',
        'Status',
        'Gelar',
        'Spesialis',
        'STR',
        'SIP',
        'Lokasi Praktik',
        'Alumni',
        'Pengalaman (Tahun)',
        'Link Foto Profil',
        'Link Bukti Kompetensi',
      ];

      for (var i = 0; i < headers.length; i++) {
        var cell = sheetObject.cell(
          excel_pkg.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
        );
        cell.value = excel_pkg.TextCellValue(headers[i]);
        cell.cellStyle = headerStyle;
      }

      for (var i = 0; i < querySnapshot.docs.length; i++) {
        final data = querySnapshot.docs[i].data();
        final user = UserModel.fromJson(data);
        final rowIndex = i + 1;

        sheetObject
            .cell(
              excel_pkg.CellIndex.indexByColumnRow(
                columnIndex: 0,
                rowIndex: rowIndex,
              ),
            )
            .value = excel_pkg.TextCellValue(
          user.name,
        );
        sheetObject
            .cell(
              excel_pkg.CellIndex.indexByColumnRow(
                columnIndex: 1,
                rowIndex: rowIndex,
              ),
            )
            .value = excel_pkg.TextCellValue(
          user.email,
        );
        sheetObject
            .cell(
              excel_pkg.CellIndex.indexByColumnRow(
                columnIndex: 2,
                rowIndex: rowIndex,
              ),
            )
            .value = excel_pkg.TextCellValue(
          user.status.name,
        );
        sheetObject
            .cell(
              excel_pkg.CellIndex.indexByColumnRow(
                columnIndex: 3,
                rowIndex: rowIndex,
              ),
            )
            .value = excel_pkg.TextCellValue(
          user.title ?? '-',
        );
        sheetObject
            .cell(
              excel_pkg.CellIndex.indexByColumnRow(
                columnIndex: 4,
                rowIndex: rowIndex,
              ),
            )
            .value = excel_pkg.TextCellValue(
          user.specialist ?? '-',
        );
        sheetObject
            .cell(
              excel_pkg.CellIndex.indexByColumnRow(
                columnIndex: 5,
                rowIndex: rowIndex,
              ),
            )
            .value = excel_pkg.TextCellValue(
          user.strNumber ?? '-',
        );
        sheetObject
            .cell(
              excel_pkg.CellIndex.indexByColumnRow(
                columnIndex: 6,
                rowIndex: rowIndex,
              ),
            )
            .value = excel_pkg.TextCellValue(
          user.sipNumber ?? '-',
        );
        sheetObject
            .cell(
              excel_pkg.CellIndex.indexByColumnRow(
                columnIndex: 7,
                rowIndex: rowIndex,
              ),
            )
            .value = excel_pkg.TextCellValue(
          user.practiceLocation ?? '-',
        );
        sheetObject
            .cell(
              excel_pkg.CellIndex.indexByColumnRow(
                columnIndex: 8,
                rowIndex: rowIndex,
              ),
            )
            .value = excel_pkg.TextCellValue(
          user.alumni ?? '-',
        );
        sheetObject
            .cell(
              excel_pkg.CellIndex.indexByColumnRow(
                columnIndex: 9,
                rowIndex: rowIndex,
              ),
            )
            .value = excel_pkg.TextCellValue(
          user.experienceYear?.toString() ?? '-',
        );
        sheetObject
            .cell(
              excel_pkg.CellIndex.indexByColumnRow(
                columnIndex: 10,
                rowIndex: rowIndex,
              ),
            )
            .value = excel_pkg.TextCellValue(
          user.profileImage ?? '-',
        );
        sheetObject
            .cell(
              excel_pkg.CellIndex.indexByColumnRow(
                columnIndex: 11,
                rowIndex: rowIndex,
              ),
            )
            .value = excel_pkg.TextCellValue(
          user.proofUrl ?? '-',
        );
      }

      final fileBytes = excel.save();
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = 'Data_Dokter_GiziSehat_$timestamp.xlsx';
      final file = File('${directory.path}/$fileName');

      if (fileBytes != null) {
        await file.writeAsBytes(fileBytes);
        if (context.mounted) Navigator.pop(context);

        await Share.shareXFiles([XFile(file.path)], text: 'Export Data Dokter');
      } else {
        if (context.mounted) Navigator.pop(context);
        throw Exception('Gagal generate file excel');
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.maybePop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export Gagal: $e')));
      }
    }
  }
}
