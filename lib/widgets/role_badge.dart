import 'package:flutter/material.dart';

class RoleBadge extends StatelessWidget {
  final String role;
  const RoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final colors = {
      'owner': (const Color(0xFFF5A623), const Color(0xFFFFF3E0)),
      'admin': (Theme.of(context).colorScheme.secondary, Theme.of(context).colorScheme.secondary.withOpacity(0.1)),
      'member': (Theme.of(context).colorScheme.tertiary, Colors.grey.shade100),
    };
    final c = colors[role] ?? (Theme.of(context).colorScheme.tertiary, Colors.grey.shade100);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.$2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(role, style: TextStyle(color: c.$1, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}