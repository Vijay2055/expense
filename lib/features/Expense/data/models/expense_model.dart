class ExpenseModel {
  final String id;
  final String customerId;
  final String type;
  final double amount;
  final String note;
  final String date;

  ExpenseModel(
      {required this.id,
      required this.customerId,
      required this.type,
      required this.amount,
      required this.note,
      required this.date});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'customerId': customerId,
      'type': type,
      "amount": amount,
      'note': note,
      'date': date
    };
  }

  factory ExpenseModel.fromMap(Map<String, Object?> map) {
    return ExpenseModel(
        id: map['id'] as String? ?? "",
        customerId: map['customerId'] as String? ?? '',
        type: map['type'] as String? ?? "unknown",
        amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
        note: map['note'] as String? ?? "",
        date: map['date'] as String? ?? DateTime.now().toIso8601String());
  }
}
