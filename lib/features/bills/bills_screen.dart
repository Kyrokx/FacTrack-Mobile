import 'package:factrack_mobile/core/utils/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/bill_card.dart';
import 'bill_create_screen.dart';
import 'bill_provider.dart';
import 'bill_model.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final filters = [null, 'SONABEL', 'ONEA'];
        context.read<BillProvider>().setFilter(filters[_tabController.index]);
      }
    });
    Future.microtask(() => context.read<BillProvider>().load());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BillProvider>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BillCreateScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Factures', style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: Theme.of(context).colorScheme.tertiary,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Toutes'),
                  Tab(text: 'SONABEL'),
                  Tab(text: 'ONEA'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: provider.loading
          ? CustomLoading()
          : provider.error != null
          ? Center(child: Text(provider.error!))
          : provider.bills.isEmpty
          ? const Center(child: Text('Aucune facture.'))
          : RefreshIndicator(
        onRefresh: () => context.read<BillProvider>().load(force: true),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.bills.length,
          itemBuilder: (context, index) {
            return BillCard(
              bill: provider.bills[index],
              onToggle: () => context.read<BillProvider>().togglePaid(provider.bills[index].id),
              onDelete: () => _confirmDelete(context, provider.bills[index].id),
            );
          },
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Supprimer', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Voulez-vous vraiment supprimer cette facture ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<BillProvider>().deleteBill(id);
            },
            child: Text('Supprimer', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }
}

