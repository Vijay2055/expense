class CurrentMonthEmiModel {
  // Loan details
  final String loanId;
  final String bankName;
  final double principal;
  final double interestRate;
  final int tenureMonths;
  final String startDate;
  final String createdAt;

  // Current month installment details
  final String? installmentId;
  final int? installmentNumber;
  final String? dueDate;
  final String? paidDate;

  const CurrentMonthEmiModel({
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

  factory CurrentMonthEmiModel.fromMap(Map<String, dynamic> map) {
    return CurrentMonthEmiModel(
      // Loan details
      loanId: map['id'] as String,
      bankName: map['bank_name'] as String,
      principal: (map['principal'] as num).toDouble(),
      interestRate: (map['interest_rate'] as num).toDouble(),
      tenureMonths: map['tenure_months'] as int,
      startDate: map['start_date'] as String,
      createdAt: map['created_at'] as String,

      // Installment details
      // NULL when LEFT JOIN finds no installment
      installmentId: map['installment_id'] as String?,
      installmentNumber: map['installment_number'] as int?,
      dueDate: map['due_date'] as String?,
      paidDate: map['paid_date'] as String?,
    );
  }

  bool get isPaid => installmentId != null;
}