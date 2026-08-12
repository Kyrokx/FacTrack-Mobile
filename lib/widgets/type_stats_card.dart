import 'package:factrack_mobile/widgets/stat_row.dart';
import 'package:flutter/material.dart';

class TypeStatsCard extends StatelessWidget {
  final String type;
  final int avgConsumption;
  final int consumptionPct;
  final int avgPrice;
  final int pricePct;
  final Color color;

  const TypeStatsCard({super.key,
    required this.type,
    required this.avgConsumption,
    required this.consumptionPct,
    required this.avgPrice,
    required this.pricePct,
    required this.color,
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
        children: [
          StatRow(
            label: 'Conso. moyenne',
            value: '$avgConsumption ${type == 'SONABEL' ? 'kWh' : 'm³'}',
            pct: consumptionPct,
          ),
          const Divider(height: 20),
          StatRow(
            label: 'Prix moyen',
            value: '$avgPrice FCFA',
            pct: pricePct,
          ),
        ],
      ),
    );
  }
}