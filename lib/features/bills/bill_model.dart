class Bill {
  final int id;
  final String type;
  final String period;
  final String deadline;
  final double priceTotal;
  final int previousIndex;
  final int newIndex;
  final int totalConsumption;
  final bool paid;

  Bill({
    required this.id,
    required this.type,
    required this.period,
    required this.deadline,
    required this.priceTotal,
    required this.previousIndex,
    required this.newIndex,
    required this.totalConsumption,
    required this.paid,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      type: json['type'],
      period: json['period'],
      deadline: json['deadline'],
      priceTotal: double.parse(json['price_total'].toString()),
      previousIndex: json['previous_index'],
      newIndex: json['new_index'],
      totalConsumption: json['total_consumption'],
      paid: json['paid'],
    );
  }
}