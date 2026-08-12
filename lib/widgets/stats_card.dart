import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  final String subtitle;

  const StatCard({super.key,
    required this.title,
    required this.value,
    required this.valueColor,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 12)),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                color: valueColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 12)),
        ],
      ),
    );
  }
}