import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/custom_loading.dart';
import '../../core/utils/snackbar_helper.dart';
import '../../widgets/info_row.dart';
import '../../widgets/role_badge.dart';
import '../../widgets/section_card.dart';
import '../auth/auth_provider.dart';
import 'membership_model.dart';
import 'organization_provider.dart';

class OrganizationScreen extends StatefulWidget {
  const OrganizationScreen({super.key});

  @override
  State<OrganizationScreen> createState() => _OrganizationScreenState();
}

class _OrganizationScreenState extends State<OrganizationScreen> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<OrganizationProvider>();
    provider.addListener(_onProviderChange);
    provider.load();
    provider.loadMembers();
  }

  void _onProviderChange() {
    final provider = context.read<OrganizationProvider>();
    if (provider.error != null) {
      showErrorSnackBar(context, provider.error!);
      provider.clearError();
    }
  }

  @override
  void dispose() {
    context.read<OrganizationProvider>().removeListener(_onProviderChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final organization = context.watch<OrganizationProvider>();
    final org = organization.organization;

    final auth = context.watch<AuthProvider>();
    final currentUserRole = auth.user?['role'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mon Foyer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: organization.loading
          ? CustomLoading()
          : organization.error != null
          ? Center(child: Text(organization.error!))
          : organization.organization == null
          ? const Center(child: Text('Aucun foyer [ERREUR CRITIQUE].'))
          : RefreshIndicator(
              onRefresh: () async {
                if (context.mounted) {
                  final provider = context.read<OrganizationProvider>();
                  await provider.load(force: true);
                  await provider.loadMembers(force: true);
                }
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Infos personnelles
                  SectionCard(
                    children: [
                      InfoRow(
                        icon: Icons.house_outlined,
                        label: "Nom de foyer",
                        value: org?.name ?? '-',
                      ),
                      const Divider(height: 24),
                      InfoRow(
                        icon: Icons.info_outline,
                        label: 'Identifiant unique',
                        value: org?.uid ?? '-',
                      ),
                      const Divider(height: 24),
                      InfoRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Créer le',
                        value: _formatDate(org?.createdAt),
                      ),
                      const Divider(height: 24),
                      InfoRow(
                        icon: Icons.qr_code,
                        label: 'Code d\'invitation',
                        value: org?.inviteCode ?? '-',
                        trailing: TextButton.icon(
                          onPressed: organization.inviteCodeLoading ? null : () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Régénérer le code ?'),
                                content: const Text('L\'ancien code ne fonctionnera plus. Les membres non encore rejoints devront utiliser le nouveau code.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('Annuler'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: Text(
                                      'Confirmer',
                                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true && context.mounted) {
                              await context.read<OrganizationProvider>().regenerateInviteCode();
                            }
                          },
                          label: Text('Régénérer', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                          icon: organization.inviteCodeLoading
                              ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          )
                              : Icon(Icons.loop_outlined, color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Organisation
                  SectionCard(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Membres',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            '${organization.members.length} membre(s)',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      organization.membersLoading
                          ? const CustomLoading()
                          : organization.members.isEmpty
                          ? const Center(child: Text('Aucun membre.'))
                          : Column(
                        children: organization.members.map((member) {
                          return _MemberTile(
                            member: member,
                            currentUserRole: currentUserRole,
                            onRemove: () async {
                              await context
                                  .read<OrganizationProvider>()
                                  .removeMember(member.id);
                            },
                            onPromote: () async {
                              await context
                                  .read<OrganizationProvider>()
                                  .promoteMember(member.id);
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
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
}


class _MemberTile extends StatelessWidget {
  final Membership member;
  final String currentUserRole;
  final VoidCallback onRemove;
  final VoidCallback onPromote;

  const _MemberTile({
    required this.member,
    required this.currentUserRole,
    required this.onRemove,
    required this.onPromote,
  });

  @override
  Widget build(BuildContext context) {
    final isOwner = currentUserRole == 'owner';
    final canPromote = isOwner && member.role == 'member';
    final canDemote = isOwner && member.role == 'admin';
    final canRemove = isOwner && member.role != 'owner';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              member.username[0].toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.username,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                RoleBadge(role: member.role),
              ],
            ),
          ),
          if (canPromote)
            IconButton(
              icon: Icon(Icons.arrow_upward, color: Theme.of(context).colorScheme.primary),
              tooltip: 'Promouvoir admin',
              onPressed: onPromote,
            ),
          if (canDemote)
            IconButton(
              icon: Icon(Icons.arrow_downward, color: Theme.of(context).colorScheme.tertiary),
              tooltip: 'Rétrograder membre',
              onPressed: onPromote, // même fonction, le backend gère le toggle
            ),
          if (canRemove)
            IconButton(
              icon: Icon(Icons.person_remove_outlined, color: Theme.of(context).colorScheme.error),
              tooltip: 'Retirer',
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}