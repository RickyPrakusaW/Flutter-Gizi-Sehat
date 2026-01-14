import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class NutritionPage extends ConsumerWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekomendasi Gizi'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.spacingLarge),
        children: [
          Text(
            'Menu Sehat Hari Ini',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingLarge),

          _MenuCard(
            time: 'Sarapan (Pukul 07:00)',
            items: ['Nasi merah', 'Telur rebus', 'Sayuran hijau'],
          ),
          const SizedBox(height: AppConstants.spacingLarge),

          _MenuCard(
            time: 'Snack Pagi (Pukul 10:00)',
            items: ['Buah-buahan segar', 'Susu formula/ASI'],
          ),
          const SizedBox(height: AppConstants.spacingLarge),

          _MenuCard(
            time: 'Makan Siang (Pukul 12:00)',
            items: ['Nasi putih', 'Ikan/Ayam', 'Lauk pauk bergizi'],
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String time;
  final List<String> items;

  const _MenuCard({
    required this.time,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingSmall),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 20,
                ),
                const SizedBox(width: AppConstants.spacingMedium),
                Expanded(
                  child: Text(
                    item,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
}
