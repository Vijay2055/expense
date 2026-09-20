class CustomerSummaryEntity {
  final String id;
  final String name;
  final String phone;
  final String address;
  final double totalInAmount;
  final double totalOutAmount;
  final DateTime lastDate;

  CustomerSummaryEntity(
      {required this.id,
      required this.name,
      required this.phone,
      required this.address,
      required this.totalInAmount,
      required this.lastDate,
      required this.totalOutAmount});

  double get totalAmount => (totalInAmount - totalOutAmount).abs();

  bool get isIn => (totalInAmount - totalOutAmount) > 0;

  bool get isOut => (totalInAmount - totalOutAmount) < 0;

  bool get isSettled => totalAmount == 0;
}
