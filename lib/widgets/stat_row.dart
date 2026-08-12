import 'package:factrack_mobile/core/app_theme.dart';
import 'package:flutter/material.dart';

class StatRow extends StatelessWidget {
  final String label;
  final String value;
  final int pct;

  const StatRow({super.key, required this.label, required this.value, required this.pct});

  @override
  Widget build(BuildContext context) {
    final isPositive = pct >= 0;
    final pctColor = isPositive ? AppColors.success : Theme.of(context).colorScheme.error;
    final pctIcon = isPositive ? '↑' : '↓';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(/*color: Color(0xFF718096),*/ fontSize: 12)),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                  //color: Color(0xFF1E3A5F),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                )),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: pctColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$pctIcon $pct%',
            style: TextStyle(color: pctColor, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}