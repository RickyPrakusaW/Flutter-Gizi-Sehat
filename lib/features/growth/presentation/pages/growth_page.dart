import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class GrowthPage extends ConsumerWidget {
  const GrowthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemantauan Pertumbuhan'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.spacingLarge),
        children: [
          Text(
            'Grafik Pertumbuhan Anak',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingLarge),

          // Placeholder untuk grafik
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: const Center(
              child: Text('Grafik Pertumbuhan akan ditampilkan di sini'),
            ),
          ),
          const SizedBox(height: AppConstants.spacing2xl),

          Text(
            'Data Terakhir',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingLarge),

          _DataRow(label: 'Berat Badan', value: '-- kg'),
          const SizedBox(height: AppConstants.spacingMedium),
          _DataRow(label: 'Tinggi Badan', value: '-- cm'),
          const SizedBox(height: AppConstants.spacingMedium),
          _DataRow(label: 'Status Gizi', value: 'Belum ada data'),
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  final String label;
  final String value;

  const _DataRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
