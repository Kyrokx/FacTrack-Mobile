import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PriceChart extends StatelessWidget {
  final List<String> periods;
  final List<double> sonabelPrices;
  final List<double> oneaPrices;

  const PriceChart({
    super.key,
    required this.periods,
    required this.sonabelPrices,
    required this.oneaPrices,
  });

  @override
  Widget build(BuildContext context) {
    final sonabelColor = Theme.of(context).colorScheme.primary;
    final oneaColor = Theme.of(context).colorScheme.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Légende
        Row(
          children: [
            _LegendDot(color: sonabelColor, label: 'SONABEL'),
            const SizedBox(width: 16),
            _LegendDot(color: oneaColor, label: 'ONEA'),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (periods.length - 1).toDouble(),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (val) => FlLine(
                  color: Colors.grey.shade200,
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 48,
                    getTitlesWidget: (value, meta) => Text(
                      '${(value / 1000).toStringAsFixed(0)}k',
                      style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.tertiary),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (value != index.toDouble()) return const SizedBox();
                      if (index < 0 || index >= periods.length) return const SizedBox();
                      final parts = periods[index].split('-');
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '${parts[1]}/${parts[0].substring(2)}',
                          style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.tertiary),
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (spots) => spots.map((spot) {
                    final isSonabel = spot.barIndex == 0;
                    return LineTooltipItem(
                      '${spot.y.toStringAsFixed(0)} FCFA',
                      TextStyle(
                        color: isSonabel ? sonabelColor : oneaColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  }).toList(),
                ),
              ),
              lineBarsData: [
                _buildLine(sonabelPrices, sonabelColor),
                _buildLine(oneaPrices, oneaColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  LineChartBarData _buildLine(List<double> prices, Color color) {
    return LineChartBarData(
      spots: prices.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
      isCurved: true,
      color: color,
      barWidth: 2.5,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: color.withValues(alpha: 0.08),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.tertiary)),
      ],
    );
  }
}