import 'package:factrack_mobile/core/app_theme.dart';
import 'package:flutter/material.dart';

import '../features/bills/bill_model.dart';

class BillCard extends StatelessWidget {
  final Bill bill;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const BillCard({super.key,
    required this.bill,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = bill.paid;
    final paidColor = isPaid ? AppColors.success : Theme.of(context).colorScheme.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: bill.type == 'SONABEL'
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                          : Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      bill.type,
                      style: TextStyle(
                        color: bill.type == 'SONABEL'
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: paidColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isPaid ? '✓ Payée' : '✗ Impayée',
                      style: TextStyle(color: paidColor, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              PopupMenuButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    onTap: onToggle,
                    child: Row(
                      children: [
                        Icon(isPaid ? Icons.close : Icons.check, size: 18),
                        const SizedBox(width: 8),
                        Text(isPaid ? 'Marquer impayée' : 'Marquer payée'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: onDelete,
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 18, color: Theme.of(context).colorScheme.error),
                        const SizedBox(width: 8),
                        Text('Supprimer', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Période', style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 11)),
                  Text(bill.period, style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Échéance', style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 11)),
                  Text(bill.deadline, style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Total', style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 11)),
                  Text(
                    '${bill.priceTotal.toStringAsFixed(0)} FCFA',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Conso: ${bill.totalConsumption} ${bill.type == 'SONABEL' ? 'kWh' : 'm³'}',
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}