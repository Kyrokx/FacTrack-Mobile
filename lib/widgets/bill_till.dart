import 'package:flutter/material.dart';

class BillTile extends StatelessWidget {
  final Map<String, dynamic> bill;

  const BillTile({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    final isPaid = bill['paid'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bill['type'],
                style: const TextStyle(fontWeight: FontWeight.bold, /*color: Color(0xFF1E3A5F*/),
              ),
              const SizedBox(height: 2),
              Text(
                'Période : ${bill['period']}',
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 12),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPaid
                      ? const Color(0xFF27AE60).withOpacity(0.1)
                      : const Color(0xFFE74C3C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isPaid ? '✓ Payée' : '✗ Impayée',
                  style: TextStyle(
                    color: isPaid ? const Color(0xFF27AE60) : const Color(0xFFE74C3C),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${bill['price_total']} FCFA',
                style: const TextStyle(fontWeight: FontWeight.bold,/* color: Color(0xFF1E3A5F)*/),
              ),
            ],
          ),
        ],
      ),
    );
  }
}