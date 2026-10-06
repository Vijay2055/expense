class InstallmentModel {
  final String id;
  final String loanId;
  final int installmentNumber;
  final String dueDate;
  final bool isPaid;
  final String? paidDate;

  const InstallmentModel({
    required this.id,
    required this.loanId,
    required this.installmentNumber,
    required this.dueDate,
    required this.isPaid,
    this.paidDate,
  });

  factory InstallmentModel.fromMap(Map<String, Object?> map) {
    return InstallmentModel(
      id: map['id'] as String,
      loanId: map['loan_id'] as String,
      installmentNumber: map['installment_number'] as int,
      dueDate: map['due_date'] as String,
      isPaid: (map['is_paid'] as int) == 1,
      paidDate: map['paid_date'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loan_id': loanId,
      'installment_number': installmentNumber,
      'due_date': dueDate,
      'is_paid': isPaid ? 1 : 0,
      'paid_date': paidDate
    };
  }
}
