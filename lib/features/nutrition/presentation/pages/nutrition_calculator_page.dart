import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/features/nutrition/services/nutrition_service.dart';
import 'package:gizi_sehat_mobile_app/features/nutrition/models/who_standard_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';

class NutritionCalculatorPage extends StatefulWidget {
  const NutritionCalculatorPage({super.key});

  @override
  State<NutritionCalculatorPage> createState() =>
      _NutritionCalculatorPageState();
}

class _NutritionCalculatorPageState extends State<NutritionCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nutritionService = NutritionService();

  // Inputs
  bool _isMale = true;
  final _ageController = TextEditingController(); // months
  final _heightController = TextEditingController(); // cm
  final _weightController = TextEditingController(); // kg

  // Results
  bool _calculated = false;
  double _zScoreHeight = 0.0;
  String _statusHeight = '';
  List<WhoStandard> _chartData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _nutritionService.loadWhoStandards();
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final int age = int.parse(_ageController.text);
      final double height = double.parse(_heightController.text);

      final zScore = _nutritionService.calculateZScore(
        height,
        age,
        _isMale,
        'height',
      );
      final status = _nutritionService.classifyHeightStatus(zScore);
      final chartData = _nutritionService.getGrowthChartData(_isMale);

      // Sort chart data by month to ensure line correctness
      // Create a copy to avoid mutating the service's list if it's shared
      final sortedChartData = List<WhoStandard>.from(chartData);
      sortedChartData.sort((a, b) => a.month.compareTo(b.month));

      setState(() {
        _zScoreHeight = zScore;
        _statusHeight = status;
        _chartData = sortedChartData;
        _calculated = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Gizi Anak'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        'Data Anak',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Gender
                      Row(
                        children: [
                          const Text('Jenis Kelamin: '),
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text('Laki-laki'),
                              value: true,
                              groupValue: _isMale,
                              onChanged: (val) =>
                                  setState(() => _isMale = val!),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text('Perempuan'),
                              value: false,
                              groupValue: _isMale,
                              onChanged: (val) =>
                                  setState(() => _isMale = val!),
                            ),
                          ),
                        ],
                      ),
                      // Age
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Umur (Bulan)',
                          suffixText: 'bulan',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan umur';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      // Height
                      TextFormField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Tinggi Badan (cm)',
                          suffixText: 'cm',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan tinggi badan';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _calculate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text('CEK STATUS GIZI'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Result Section
            if (_calculated) ...[
              _buildResultCard(),
              const SizedBox(height: 24),
              _buildGrowthChart(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    Color statusColor;
    IconData statusIcon;

    if (_statusHeight.contains('Normal')) {
      statusColor = Colors.green;
      statusIcon = Icons.sentiment_satisfied_alt;
    } else if (_statusHeight.contains('Pendek')) {
      statusColor = Colors.orange;
      statusIcon = Icons.sentiment_dissatisfied;
    } else {
      statusColor = Colors.red;
      statusIcon = Icons.sentiment_very_dissatisfied;
    }

    return Card(
      color: statusColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: statusColor, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(statusIcon, size: 60, color: statusColor),
            const SizedBox(height: 8),
            Text(
              'Status Gizi (TB/U):',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 4),
            Text(
              _statusHeight,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Z-Score: ${_zScoreHeight.toStringAsFixed(2)} SD',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrowthChart() {
    if (_chartData.isEmpty) return const SizedBox.shrink();

    // Prepare chart spots
    final List<FlSpot> sd2negSpots = _chartData
        .map((e) => FlSpot(e.month.toDouble(), e.sd2neg))
        .toList();
    final List<FlSpot> sd0Spots = _chartData
        .map((e) => FlSpot(e.month.toDouble(), e.sd0))
        .toList();
    final List<FlSpot> sd2posSpots = _chartData
        .map((e) => FlSpot(e.month.toDouble(), e.sd2pos))
        .toList();

    // User Spot
    final double userAge = double.tryParse(_ageController.text) ?? 0;
    final double userHeight = double.tryParse(_heightController.text) ?? 0;

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Grafik Pertumbuhan (TB/U)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                minX: 0,
                // Ensure chart shows at least up to user age or 60
                maxX: (userAge > 60 ? userAge : 60).toDouble(),
                minY: 40,
                maxY: 130, // Adjust based on data
                lineBarsData: [
                  // SD -2 (Batas Bawah Normal/Stunting) - Orange
                  LineChartBarData(
                    spots: sd2negSpots,
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                  // SD 0 (Median/Ideal) - Green
                  LineChartBarData(
                    spots: sd0Spots,
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                  ),
                  // SD +2 (Batas Atas Normal) - Orange
                  LineChartBarData(
                    spots: sd2posSpots,
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                  ),
                  // User Position Point
                  LineChartBarData(
                    spots: [FlSpot(userAge, userHeight)],
                    color: Colors.blue,
                    barWidth: 0,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                            radius: 6,
                            color: Colors.blue,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          ),
                    ),
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 10,
                  verticalInterval: 10,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Color(0xffe7e8ec),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return const FlLine(
                      color: Color(0xffe7e8ec),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: const Color(0xff37434d)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(Colors.green, 'Ideal (Median)'),
              const SizedBox(width: 12),
              _buildLegendItem(Colors.orange, 'Batas Normal (-2SD / +2SD)'),
              const SizedBox(width: 12),
              _buildLegendItem(Colors.blue, 'Anak Anda'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
