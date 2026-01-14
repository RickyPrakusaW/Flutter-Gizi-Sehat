import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Widget untuk menampilkan status anak (Normal, Berisiko, dll)
class StatusBadge extends StatelessWidget {
  final String label;
  final bool isWarning;

  const StatusBadge({
    super.key,
    required this.label,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isWarning
        ? Colors.orange.withOpacity(0.15)
        : Colors.green.withOpacity(0.15);

    final textColor = isWarning
        ? Colors.orange.shade700
        : Colors.green.shade700;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
