class InstallmentEntity {
  final String id;
  final String loanId;
  final int installmentNumber;
  final DateTime dueDate;
  final bool isPaid;
  final DateTime? paidDate;

  const InstallmentEntity({
    required this.id,
    required this.loanId,
    required this.installmentNumber,
    required this.dueDate,
    required this.isPaid,
    this.paidDate,
  });
}