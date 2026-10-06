class InstallmentResultEntity {
  final int installmentNumber;
  final double emi;
  final double principalAmount;
  final double interestAmount;
  final double remainingAmount;
  final DateTime? dueDate;
  final DateTime? paidDate;
  final bool isPaid;

  InstallmentResultEntity(
      {required this.installmentNumber,
      required this.emi,
      required this.principalAmount,
      required this.interestAmount,
      required this.remainingAmount,
      required this.dueDate,
      required this.paidDate,
      required this.isPaid});
}
