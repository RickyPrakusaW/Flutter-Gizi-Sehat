import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:gizi_sehat_mobile_app/features/dashboard/data/models/child_model.dart';
import 'package:gizi_sehat_mobile_app/features/nutrition/models/child_model.dart'; // For GrowthRecord

class GrowthResultScreen extends StatelessWidget {
  final ChildModel child;
  // ignore: unused_field
  final GrowthRecord record;

  const GrowthResultScreen({
    super.key,
    required this.child,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Kalkulator Perhitungan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Status Perkembangan Gizi Anak',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF8BC34A),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // --- Chart 1: Berat Badan menurut Umur ---
            _ChartSection(
              title: 'Berat Badan Menurut Umur',
              childName: 'Anak Anda', // or child.name
              age: record.ageInMonths,
              value: record.weight,
              valueLabel: '${record.weight} Kg',
              chartType: _ChartType.weightForAge,
              child: child,
            ),

            const SizedBox(height: 32),

            // --- Chart 2: Tinggi Badan menurut Umur ---
            _ChartSection(
              title: 'Tinggi Badan Menurut Umur',
              childName: 'Anak Anda',
              age: record.ageInMonths,
              value: record.height,
              valueLabel: '${record.height} Cm',
              chartType: _ChartType.heightForAge,
              child: child,
            ),

            // --- Summary Box ---
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF8BC34A).withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Anak Anda',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.7)),
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryRow(
                    'Jenis Kelamin',
                    child.gender, // Already 'Laki-laki' or 'Perempuan' string
                  ),
                  _buildSummaryRow('Usia', '${record.ageInMonths} Bulan'),
                  _buildSummaryRow('Berat Badan', '${record.weight} Kg'),
                  _buildSummaryRow('Tinggi Badan',
                      '${record.height} Cm'), // Typo in reference Image 4 "8.50 Cm" likely meant 85 or 72cm (baby height). But user input 8.5 for TB? Maybe 72 is weight? No, 72kg for 9mo is impossible.
                  // Referensi Image 2: "72.00 Kg" for weight is impossible for 9 month old (usually 8-10kg).
                  // "8.50 Cm" for height? Impossible (usually 70cm).
                  // Probably User meant 7.2 Kg and 68.5 Cm ?
                  // Or maybe the reference image has dummy large values.
                  // I will display what is input.

                  const SizedBox(height: 16),
                  const Text(
                    'Berat Badan Menurut Umur',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Berat badan anak anda menurut umur Lebih, perlu perbaikan gizi dengan makanan sehat dan bergizi.',
                    style: TextStyle(color: Colors.white),
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    'Berat Badan Menurut Umur', // Should be different title based on calculation
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  Text(
                    'Rekomendasi berat badan anak seharusnya 8.9 kg.', // Logic placeholder
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Reset / New Data
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Data Baru'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8BC34A),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chevron_right, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          SizedBox(
              width: 120,
              child: Text(label, style: const TextStyle(color: Colors.white))),
          const Text(':', style: TextStyle(color: Colors.white)),
          const SizedBox(width: 8),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

enum _ChartType { weightForAge, heightForAge }

class _ChartSection extends StatelessWidget {
  final String title;
  final String childName;
  final int age; // x-axis current
  final double value; // y-axis current
  final String valueLabel;
  final _ChartType chartType;
  final ChildModel child;

  const _ChartSection({
    required this.title,
    required this.childName,
    required this.age,
    required this.value,
    required this.valueLabel,
    required this.chartType,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 16),
        Container(
          height: 250,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: LineChart(
            _buildChartData(),
          ),
        ),
        const SizedBox(height: 8),
        // Legend
        Wrap(
          spacing: 12,
          children: [
            _legendItem(Colors.blue, 'Anak Anda'),
            _legendItem(Colors.green, 'Median'),
            _legendItem(Colors.red, '+/- 2 SD'),
            _legendItem(Colors.red.shade900, '+/- 3 SD'),
          ],
        ),
      ],
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  LineChartData _buildChartData() {
    // Generate Dummy Curves (Logarithmic-ish for growth)
    // Age on X (0 to 24 months as in image)
    // Value on Y

    // Weight: 0mo ~3kg -> 24mo ~12kg
    // Height: 0mo ~50cm -> 24mo ~90cm

    final isWeight = chartType == _ChartType.weightForAge;

    // Scale factors
    double startY = isWeight ? 3.0 : 48.0;
    double endY = isWeight ? 15.0 : 92.0;

    // Helper to make curve
    List<FlSpot> makeCurve(double offset) {
      return List.generate(25, (index) {
        // Simple linear+log growth approximation
        double t = index / 24.0;
        double val = startY +
            (endY - startY) * (t * 0.7 + (t * t) * 0.3); // slight curve
        return FlSpot(index.toDouble(), val + offset);
      });
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: isWeight ? 10 : 10,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) =>
            FlLine(color: Colors.grey.shade300, strokeWidth: 1),
        getDrawingVerticalLine: (value) =>
            FlLine(color: Colors.grey.shade300, strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final val = value.toInt();
              if (val % 2 == 0)
                return Text('$val',
                    style: const TextStyle(fontSize: 10)); // 0, 2, 4
              return const SizedBox.shrink();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 10,
            reservedSize: 30,
            getTitlesWidget: (value, meta) =>
                Text('${value.toInt()}', style: const TextStyle(fontSize: 10)),
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
          show: true, border: Border.all(color: Colors.grey.shade300)),
      minX: 0,
      maxX: 24,
      minY: isWeight ? 0 : 40,
      maxY: isWeight ? 20 : 100,
      lineBarsData: [
        // +3 SD
        LineChartBarData(
            spots: makeCurve(isWeight ? 4 : 8),
            isCurved: true,
            color: Colors.red.shade900,
            dotData: FlDotData(show: false),
            barWidth: 1),
        // +2 SD
        LineChartBarData(
            spots: makeCurve(isWeight ? 2.5 : 5),
            isCurved: true,
            color: Colors.red,
            dotData: FlDotData(show: false),
            barWidth: 1),
        // +1 SD
        LineChartBarData(
            spots: makeCurve(isWeight ? 1.2 : 2.5),
            isCurved: true,
            color: Colors.orange,
            dotData: FlDotData(show: false),
            barWidth: 1),
        // Median
        LineChartBarData(
            spots: makeCurve(0),
            isCurved: true,
            color: Colors.green,
            dotData: FlDotData(show: false),
            barWidth: 2),
        // -1 SD
        LineChartBarData(
            spots: makeCurve(isWeight ? -1.2 : -2.5),
            isCurved: true,
            color: Colors.orange,
            dotData: FlDotData(show: false),
            barWidth: 1),
        // -2 SD
        LineChartBarData(
            spots: makeCurve(isWeight ? -2.5 : -5),
            isCurved: true,
            color: Colors.red,
            dotData: FlDotData(show: false),
            barWidth: 1),
        // -3 SD
        LineChartBarData(
            spots: makeCurve(isWeight ? -4 : -8),
            isCurved: true,
            color: Colors.red.shade900,
            dotData: FlDotData(show: false),
            barWidth: 1),

        // USER POINT
        LineChartBarData(
          spots: [FlSpot(age.toDouble(), value)],
          isCurved: false,
          color: Colors.blue,
          barWidth: 0, // No line, just dot
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
                    radius: 4, color: Colors.blue, strokeWidth: 0),
          ),
        ),
      ],
    );
  }
}
