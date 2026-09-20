class EmiCalculationEntity {
  final int installmentNumber;
  final double emi;
  final double principalAmount;
  final double interestAmount;
  final double remainingBalance;

  const EmiCalculationEntity({
    required this.installmentNumber,
    required this.emi,
    required this.principalAmount,
    required this.interestAmount,
    required this.remainingBalance,
  });
}