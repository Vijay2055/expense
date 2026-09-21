class AddLoanState {
  final String bankName;
  final String principal;
  final String interestRate;
  final int tenureMonths;
  final DateTime startDate;

  final double? calculatedEmi;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  const AddLoanState({
    this.bankName = '',
    this.principal = '',
    this.interestRate = '',
    this.tenureMonths = 12,
    required this.startDate,
    this.calculatedEmi,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  AddLoanState copyWith({
    String? bankName,
    String? principal,
    String? interestRate,
    int? tenureMonths,
    DateTime? startDate,
    double? calculatedEmi,
    bool clearCalculatedEmi = false,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AddLoanState(
      bankName: bankName ?? this.bankName,
      principal: principal ?? this.principal,
      interestRate: interestRate ?? this.interestRate,
      tenureMonths: tenureMonths ?? this.tenureMonths,
      startDate: startDate ?? this.startDate,
      calculatedEmi: clearCalculatedEmi
          ? null
          : calculatedEmi ?? this.calculatedEmi,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}