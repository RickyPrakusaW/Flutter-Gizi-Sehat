import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';

class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  // Data dummy
  final String _selectedChildName = 'Sari';
  final String _selectedChildAge = '8 bulan';
  final String _period = 'Periode pengenalan makanan pendamping ASI';
  
  // Data target gizi hari ini
  final Map<String, Map<String, dynamic>> _nutritionTargets = {
    'kalori': {'current': 520, 'target': 600, 'unit': 'kkal'},
    'protein': {'current': 18, 'target': 20, 'unit': 'g'},
    'zat_besi': {'current': 3.2, 'target': 4, 'unit': 'mg'},
    'seng': {'current': 2.1, 'target': 3, 'unit': 'mg'},
  };
  
  // Data jadwal makan
  final List<Map<String, dynamic>> _mealSchedule = [
    {
      'time': '06:00',
      'meal': 'ASI/Formula',
      'description': 'Pemberian ASI eksklusif',
    },
    {
      'time': '08:00',
      'meal': 'Bubur Saring',
      'description': 'Bubur beras + sayuran + protein',
    },
    {
      'time': '10:00',
      'meal': 'ASI/Formula',
      'description': 'Pemberian ASI',
    },
    {
      'time': '12:00',
      'meal': 'Bubur Tim',
      'description': 'Nasi tim + lauk + sayur',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(isDark),
              const SizedBox(height: 24),
              
              // Card Informasi Anak
              _buildChildInfoCard(isDark),
              const SizedBox(height: 16),
              
              // Card Target Gizi Hari Ini
              _buildNutritionTargetCard(isDark),
              const SizedBox(height: 16),
              
              // Card Jadwal Makan Hari Ini
              _buildMealScheduleCard(isDark),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementasi tambah makanan/jadwal
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fitur tambah makanan akan segera tersedia'),
            ),
          );
        },
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  /// Membangun header dengan judul dan subtitle
  Widget _buildHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Perencanaan Menu',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            '1000 Hari Pertama Kehidupan',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ),
      ],
    );
  }

  /// Membangun card informasi anak
  Widget _buildChildInfoCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.refresh,
              size: 20,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_selectedChildName - $_selectedChildAge',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _period,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'MPASI',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Membangun card target gizi hari ini
  Widget _buildNutritionTargetCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.restaurant_menu,
                size: 20,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Target Gizi Hari Ini',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Progress bars untuk setiap nutrisi
          _buildNutritionProgress(
            label: 'Kalori',
            current: _nutritionTargets['kalori']!['current'] as int,
            target: _nutritionTargets['kalori']!['target'] as int,
            unit: _nutritionTargets['kalori']!['unit'] as String,
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildNutritionProgress(
            label: 'Protein',
            current: _nutritionTargets['protein']!['current'] as int,
            target: _nutritionTargets['protein']!['target'] as int,
            unit: _nutritionTargets['protein']!['unit'] as String,
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildNutritionProgress(
            label: 'Zat Besi',
            current: _nutritionTargets['zat_besi']!['current'] as double,
            target: _nutritionTargets['zat_besi']!['target'] as int,
            unit: _nutritionTargets['zat_besi']!['unit'] as String,
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildNutritionProgress(
            label: 'Seng',
            current: _nutritionTargets['seng']!['current'] as double,
            target: _nutritionTargets['seng']!['target'] as int,
            unit: _nutritionTargets['seng']!['unit'] as String,
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          
          // Section rekomendasi
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perlu tambahan: +80 kkal, +2g protein',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Coba bubur ayam atau telur kukus',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Membangun progress bar untuk nutrisi
  Widget _buildNutritionProgress({
    required String label,
    required num current,
    required int target,
    required String unit,
    required bool isDark,
  }) {
    final progress = (current / target).clamp(0.0, 1.0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            Text(
              '$current/$target $unit',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
          ),
        ),
      ],
    );
  }

  /// Membangun card jadwal makan hari ini
  Widget _buildMealScheduleCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 20,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Jadwal Makan Hari Ini',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // List meal entries
          ..._mealSchedule.map((meal) => _buildMealEntry(
            time: meal['time'] as String,
            meal: meal['meal'] as String,
            description: meal['description'] as String,
            isDark: isDark,
          )),
        ],
      ),
    );
  }

  /// Membangun entry untuk setiap meal
  Widget _buildMealEntry({
    required String time,
    required String meal,
    required String description,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Time section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                'WIB',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          
          // Meal info section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          // Camera icon
          IconButton(
            onPressed: () {
              // TODO: Implementasi foto makanan
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur foto makanan akan segera tersedia'),
                ),
              );
            },
            icon: Icon(
              Icons.camera_alt_outlined,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
