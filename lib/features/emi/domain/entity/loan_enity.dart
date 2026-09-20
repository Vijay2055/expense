class LoanEntity {
  final String id;
  final String bankName;
  final double principal;
  final double interestRate;
  final int tenureMonths;
  final DateTime startDate;
  final DateTime createdAt;

  const LoanEntity({
    required this.id,
    required this.bankName,
    required this.principal,
    required this.interestRate,
    required this.tenureMonths,
    required this.startDate,
    required this.createdAt,
  });
}