class CustomerSummaryModel {
  final String id;
  final String name;
  final String phone;
  final String address;
  final double totalInAmount;
  final double totalOutAmount;
  final String lastDate;

  CustomerSummaryModel(
      {required this.id,
      required this.name,
      required this.phone,
      required this.address,
      required this.totalInAmount,
      required this.lastDate,
      required this.totalOutAmount});

  factory CustomerSummaryModel.fromMap(
      Map<String, Object?> map, String date, double totalIn, double totalOut) {
    return CustomerSummaryModel(
        id: map['id'] as String,
        name: map['name'] as String,
        phone: map['mobile'] as String,
        address: map['address'] as String,
        totalInAmount: totalIn,
        lastDate: date,
        totalOutAmount: totalOut);
  }
}
