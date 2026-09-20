class CurrentMonthEmiEntity {
  // Loan details
  final String loanId;
  final String bankName;
  final double principal;
  final double interestRate;
  final int tenureMonths;
  final DateTime startDate;
  final DateTime createdAt;

  // Current month installment details
  final String? installmentId;
  final int? installmentNumber;
  final DateTime? dueDate;
  final DateTime? paidDate;

  const CurrentMonthEmiEntity({
    required this.loanId,
    required this.bankName,
    required this.principal,
    required this.interestRate,
    required this.tenureMonths,
    required this.startDate,
    required this.createdAt,
    this.installmentId,
    this.installmentNumber,
    this.dueDate,
    this.paidDate,
  });

  bool get isPaid => installmentId != null;
}