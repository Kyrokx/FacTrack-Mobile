import 'package:factrack_mobile/core/app_theme.dart';
import 'package:factrack_mobile/features/dashboard/price_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/bill_till.dart';
import '../../widgets/section_card.dart';
import '../../widgets/stats_card.dart';
import '../../widgets/type_stats_card.dart';
import 'dashboard_provider.dart';
import 'dashboard_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<DashboardProvider>().load());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    return SafeArea(child:Scaffold(
      /*appBar: AppBar(
        elevation: 0,
        title: const Text(
          'FacTrack',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          ElevatedButton(onPressed: (){
            AuthService.logout().then((_) {
              Navigator.of(context).pushReplacementNamed('/login');
            });
          }, child: Icon(Icons.logout)),
        ],
      ),*/
      body: provider.loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1E3A5F)))
          : provider.error != null
          ? Center(child: Text(provider.error!))
          : provider.data == null
          ? const SizedBox()
          : RefreshIndicator(
        onRefresh: () => context.read<DashboardProvider>().load(force: true),
        child: _DashboardBody(data: provider.data!),
      ),
    ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  final DashboardData data;

  const _DashboardBody({required this.data});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header
        const Text(
          'Tableau de bord',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Vue d\'ensemble de vos factures',
          style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 13),
        ),
        const SizedBox(height: 20),

        // Stats globales
        StatCard(
          title: 'Total des factures',
          value: '${_formatNumber(data.totalAmount)} FCFA',
          valueColor: Theme.of(context).colorScheme.primary,
          subtitle: 'SONABEL : ${_formatNumber(data.sonabelTotal)} FCFA\nONEA : ${_formatNumber(data.oneaTotal)} FCFA',
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Factures impayées',
                value: '${data.unpaidCount}',
                valueColor: Theme.of(context).colorScheme.error,
                subtitle: '${_formatNumber(data.unpaidTotal)} FCFA',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Factures payées',
                value: '${data.paidCount}',
                valueColor: AppColors.success,
                subtitle: '${data.totalCount} au total',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Stats SONABEL
        _SectionTitle(title: 'Statistiques SONABEL'),
        const SizedBox(height: 12),
        TypeStatsCard(
          type: 'SONABEL',
          avgConsumption: data.sonabelAvgConsumption,
          consumptionPct: data.sonabelConsumptionPct,
          avgPrice: data.sonabelAvgPrice,
          pricePct: data.sonabelPricePct,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 20),

        // Stats ONEA
        _SectionTitle(title: 'Statistiques ONEA'),
        const SizedBox(height: 12),
        TypeStatsCard(
          type: 'ONEA',
          avgConsumption: data.oneaAvgConsumption,
          consumptionPct: data.oneaConsumptionPct,
          avgPrice: data.oneaAvgPrice,
          pricePct: data.oneaPricePct,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 20),

        SectionCard(
          children: [
            Text(
              'Évolution des dépenses',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            PriceChart(
              periods: data.pricePeriods,
              sonabelPrices: data.sonabelPriceChart,
              oneaPrices: data.oneaPriceChart,
            ),
          ],
        ),

        const SizedBox(height: 20),


        // Dernières factures SONABEL
        _SectionTitle(title: 'Dernières factures SONABEL'),
        const SizedBox(height: 12),
        ...data.lastSonabel.map((bill) => BillTile(bill: bill)),
        const SizedBox(height: 20),

        // Dernières factures ONEA
        _SectionTitle(title: 'Dernières factures ONEA'),
        const SizedBox(height: 12),
        ...data.lastOnea.map((bill) => BillTile(bill: bill)),
        const SizedBox(height: 20),
      ],
    );
  }

  static String _formatNumber(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]} ',
    );
  }
}


class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}