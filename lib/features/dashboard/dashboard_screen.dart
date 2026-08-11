import 'package:factrack_mobile/features/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'FacTrack',
          style: TextStyle(color: Color(0xFF1E3A5F), fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          ElevatedButton(onPressed: (){
            AuthService.logout().then((_) {
              Navigator.of(context).pushReplacementNamed('/login');
            });
          }, child: Icon(Icons.logout)),
        ],
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1E3A5F)))
          : provider.error != null
          ? Center(child: Text(provider.error!))
          : provider.data == null
          ? const SizedBox()
          : RefreshIndicator(
        onRefresh: () => context.read<DashboardProvider>().load(),
        child: _DashboardBody(data: provider.data!),
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
            color: Color(0xFF1E3A5F),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Vue d\'ensemble de vos factures',
          style: TextStyle(color: Color(0xFF718096), fontSize: 13),
        ),
        const SizedBox(height: 20),

        // Stats globales
        _StatCard(
          title: 'Total des factures',
          value: '${_formatNumber(data.totalAmount)} FCFA',
          valueColor: const Color(0xFF1E3A5F),
          subtitle: 'SONABEL : ${_formatNumber(data.sonabelTotal)} FCFA\nONEA : ${_formatNumber(data.oneaTotal)} FCFA',
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Factures impayées',
                value: '${data.unpaidCount}',
                valueColor: const Color(0xFFE74C3C),
                subtitle: '${_formatNumber(data.unpaidTotal)} FCFA',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'Factures payées',
                value: '${data.paidCount}',
                valueColor: const Color(0xFF27AE60),
                subtitle: '${data.totalCount} au total',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Stats SONABEL
        _SectionTitle(title: 'Statistiques SONABEL'),
        const SizedBox(height: 12),
        _TypeStatsCard(
          type: 'SONABEL',
          avgConsumption: data.sonabelAvgConsumption,
          consumptionPct: data.sonabelConsumptionPct,
          avgPrice: data.sonabelAvgPrice,
          pricePct: data.sonabelPricePct,
          color: const Color(0xFF2E86AB),
        ),
        const SizedBox(height: 20),

        // Stats ONEA
        _SectionTitle(title: 'Statistiques ONEA'),
        const SizedBox(height: 12),
        _TypeStatsCard(
          type: 'ONEA',
          avgConsumption: data.oneaAvgConsumption,
          consumptionPct: data.oneaConsumptionPct,
          avgPrice: data.oneaAvgPrice,
          pricePct: data.oneaPricePct,
          color: const Color(0xFF1E3A5F),
        ),
        const SizedBox(height: 20),

        // Dernières factures SONABEL
        _SectionTitle(title: 'Dernières factures SONABEL'),
        const SizedBox(height: 12),
        ...data.lastSonabel.map((bill) => _BillTile(bill: bill)),
        const SizedBox(height: 20),

        // Dernières factures ONEA
        _SectionTitle(title: 'Dernières factures ONEA'),
        const SizedBox(height: 12),
        ...data.lastOnea.map((bill) => _BillTile(bill: bill)),
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

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  final String subtitle;

  const _StatCard({
    required this.title,
    required this.value,
    required this.valueColor,
    required this.subtitle,
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
            color: const Color(0xFF1E3A5F).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF718096), fontSize: 12)),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                color: valueColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Color(0xFF718096), fontSize: 12)),
        ],
      ),
    );
  }
}

class _TypeStatsCard extends StatelessWidget {
  final String type;
  final int avgConsumption;
  final int consumptionPct;
  final int avgPrice;
  final int pricePct;
  final Color color;

  const _TypeStatsCard({
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
            color: const Color(0xFF1E3A5F).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _StatRow(
            label: 'Conso. moyenne',
            value: '$avgConsumption ${type == 'SONABEL' ? 'kWh' : 'm³'}',
            pct: consumptionPct,
          ),
          const Divider(height: 20),
          _StatRow(
            label: 'Prix moyen',
            value: '$avgPrice FCFA',
            pct: pricePct,
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final int pct;

  const _StatRow({required this.label, required this.value, required this.pct});

  @override
  Widget build(BuildContext context) {
    final isPositive = pct >= 0;
    final pctColor = isPositive ? const Color(0xFFE74C3C) : const Color(0xFF27AE60);
    final pctIcon = isPositive ? '↑' : '↓';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF718096), fontSize: 12)),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                  color: Color(0xFF1E3A5F),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                )),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: pctColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$pctIcon $pct%',
            style: TextStyle(color: pctColor, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _BillTile extends StatelessWidget {
  final Map<String, dynamic> bill;

  const _BillTile({required this.bill});

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
            color: const Color(0xFF1E3A5F).withOpacity(0.05),
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
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
              ),
              const SizedBox(height: 2),
              Text(
                'Période : ${bill['period']}',
                style: const TextStyle(color: Color(0xFF718096), fontSize: 12),
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
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
              ),
            ],
          ),
        ],
      ),
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
        color: Color(0xFF1E3A5F),
      ),
    );
  }
}