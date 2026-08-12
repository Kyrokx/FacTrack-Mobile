import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/action_button.dart';
import '../../widgets/info_row.dart';
import '../../widgets/profile_header.dart';
import '../../widgets/role_badge.dart';
import '../../widgets/section_card.dart';
import '../auth/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Avatar + nom
          ProfileHeader(username: user?['username'] ?? ''),
          const SizedBox(height: 20),

          // Infos personnelles
          SectionCard(
            children: [
              InfoRow(icon: Icons.person_outline, label: "Nom d'utilisateur", value: user?['username'] ?? '-'),
              const Divider(height: 24),
              InfoRow(icon: Icons.email_outlined, label: 'Email', value: user?['email']?.isEmpty ?? true ? 'Non renseigné' : user?['email']),
              const Divider(height: 24),
              InfoRow(
                icon: Icons.calendar_today_outlined,
                label: 'Membre depuis',
                value: _formatDate(user?['date_joined']),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Organisation
          if (user?['has_organization'] == true) ...[
            SectionCard(
              children: [
                InfoRow(icon: Icons.home_outlined, label: 'Organisation', value: user?['organization'] ?? '-'),
                const Divider(height: 24),
                InfoRow(icon: Icons.shield_outlined, label: 'Rôle', value: user?['role'] ?? '-',
                  valueWidget: RoleBadge(role: user?['role'] ?? ''),
                ),
                const Divider(height: 24),
                InfoRow(
                  icon: Icons.login_outlined,
                  label: 'Rejoint le',
                  value: _formatDate(user?['joined_at']),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Quitter le foyer
            ActionButton(
              label: 'Quitter le foyer',
              icon: Icons.door_back_door_outlined,
              color: Theme.of(context).colorScheme.error,
              onTap: () => _confirmLeave(context),
            ),
            const SizedBox(height: 12),
          ],

          // Déconnexion
          ActionButton(
            label: 'Se déconnecter',
            icon: Icons.logout,
            color: Theme.of(context).colorScheme.error,
            onTap: () => _confirmLogout(context),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  static String _formatDate(String? date) {
    if (date == null) return '-';
    try {
      final d = DateTime.parse(date);
      return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    } catch (_) {
      return '-';
    }
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Déconnexion', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthProvider>().logout();
            },
            child: Text('Déconnecter', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  void _confirmLeave(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Quitter le foyer', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Voulez-vous vraiment quitter cette organisation ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await context.read<AuthProvider>().leaveOrganization();
              if (!success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.read<AuthProvider>().error ?? 'Erreur lors de la sortie.')),
                );
              }
            },
            child: Text('Quitter', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }
}