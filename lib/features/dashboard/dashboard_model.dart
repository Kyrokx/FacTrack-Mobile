class DashboardData {
  final double totalAmount;
  final int unpaidCount;
  final double unpaidTotal;
  final int paidCount;
  final int totalCount;
  final double sonabelTotal;
  final double oneaTotal;
  final int sonabelAvgConsumption;
  final int sonabelConsumptionPct;
  final int sonabelAvgPrice;
  final int sonabelPricePct;
  final int oneaAvgConsumption;
  final int oneaConsumptionPct;
  final int oneaAvgPrice;
  final int oneaPricePct;
  final List<String> pricePeriods;
  final List<double> sonabelPriceChart;
  final List<double> oneaPriceChart;
  final List<Map<String, dynamic>> lastSonabel;
  final List<Map<String, dynamic>> lastOnea;

  DashboardData({
    required this.totalAmount,
    required this.unpaidCount,
    required this.unpaidTotal,
    required this.paidCount,
    required this.totalCount,
    required this.sonabelTotal,
    required this.oneaTotal,
    required this.sonabelAvgConsumption,
    required this.sonabelConsumptionPct,
    required this.sonabelAvgPrice,
    required this.sonabelPricePct,
    required this.oneaAvgConsumption,
    required this.oneaConsumptionPct,
    required this.oneaAvgPrice,
    required this.oneaPricePct,
    required this.pricePeriods,
    required this.sonabelPriceChart,
    required this.oneaPriceChart,
    required this.lastSonabel,
    required this.lastOnea,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      totalAmount: (json['total_amount'] as num).toDouble(),
      unpaidCount: json['unpaid_count'],
      unpaidTotal: (json['unpaid_total'] as num).toDouble(),
      paidCount: json['paid_count'],
      totalCount: json['total_count'],
      sonabelTotal: (json['sonabel_total'] as num).toDouble(),
      oneaTotal: (json['onea_total'] as num).toDouble(),
      sonabelAvgConsumption: json['sonabel_avg_consumption'],
      sonabelConsumptionPct: json['sonabel_consumption_pct'],
      sonabelAvgPrice: json['sonabel_avg_price'],
      sonabelPricePct: json['sonabel_price_pct'],
      oneaAvgConsumption: json['onea_avg_consumption'],
      oneaConsumptionPct: json['onea_consumption_pct'],
      oneaAvgPrice: json['onea_avg_price'],
      oneaPricePct: json['onea_price_pct'],
      pricePeriods: List<String>.from(json['price_periods']),
      sonabelPriceChart: List<double>.from(json['sonabel_price_chart'].map((e) => (e as num).toDouble())),
      oneaPriceChart: List<double>.from(json['onea_price_chart'].map((e) => (e as num).toDouble())),
      lastSonabel: List<Map<String, dynamic>>.from(json['last_sonabel']),
      lastOnea: List<Map<String, dynamic>>.from(json['last_onea']),
    );
  }
}