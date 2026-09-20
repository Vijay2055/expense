class LoanModel {
  final String id;
  final String bankName;
  final double principal;
  final double rate;
  final int tenure_month;
  final String startDate;
  final String create_at;

  const LoanModel({
    required this.id,
    required this.bankName,
    required this.principal,
    required this.rate,
    required this.tenure_month,
    required this.startDate,
    required this.create_at,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bank_name': bankName,
      'principal': principal,
      'interest_rate': rate,
      'tenure_months': tenure_month,
      'start_date': startDate,
      'created_at': create_at,
    };
  }

 
}
