import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/custom_text_filed.dart';
import '../../core/utils/field_validators.dart';
import '../auth/auth_provider.dart';
import 'setup_service.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Créer
  final _createFormKey = GlobalKey<FormState>();
  final _orgNameController = TextEditingController();
  final _orgNameFocusNode = FocusNode();

  // Rejoindre
  final _joinFormKey = GlobalKey<FormState>();
  final _inviteCodeController = TextEditingController();
  final _inviteCodeFocusNode = FocusNode();

  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _orgNameController.dispose();
    _inviteCodeController.dispose();
    _orgNameFocusNode.dispose();
    _inviteCodeFocusNode.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (!_createFormKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });

    try {
      await SetupService.createOrganization(_orgNameController.text.trim());
      await context.read<AuthProvider>().refreshUser();
    } catch (_) {
      setState(() => _error = 'Erreur lors de la création.');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _join() async {
    if (!_joinFormKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });

    try {
      await SetupService.joinOrganization(_inviteCodeController.text.trim());
      await context.read<AuthProvider>().refreshUser();
    } catch (_) {
      setState(() => _error = 'Code invalide ou organisation introuvable.');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F4F8),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Bienvenue !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A5F),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Créez un foyer ou rejoignez-en un avec un code d\'invitation.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF718096), fontSize: 13),
                ),
                const SizedBox(height: 32),

                // Tabs
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: const Color(0xFF1E3A5F),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: const Color(0xFF718096),
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: 'Créer un foyer'),
                      Tab(text: 'Rejoindre'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                if (_error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE74C3C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Color(0xFFE74C3C), fontSize: 13),
                    ),
                  ),

                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab Créer
                      Form(
                        key: _createFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomTextField(
                              controller: _orgNameController,
                              focusNode: _orgNameFocusNode,
                              label: 'Nom du foyer',
                              hinText: 'Ex: Famille Diallo',
                              prefixIcon: Icons.home_outlined,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Veuillez entrer un nom';
                                }
                                if (value.trim().length < 2) {
                                  return 'Nom trop court';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: _loading ? null : _create,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E3A5F),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _loading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                'Créer le foyer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Tab Rejoindre
                      Form(
                        key: _joinFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomTextField(
                              controller: _inviteCodeController,
                              focusNode: _inviteCodeFocusNode,
                              label: 'Code d\'invitation',
                              hinText: 'Ex: FAM-XXXXXX',
                              prefixIcon: Icons.key_outlined,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Veuillez entrer un code';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: _loading ? null : _join,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E3A5F),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _loading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                'Rejoindre',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}