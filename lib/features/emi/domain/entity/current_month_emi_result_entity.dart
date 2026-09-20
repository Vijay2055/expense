import 'package:expense_app/features/emi/domain/entity/current_month_emi_entity.dart';
import 'package:expense_app/features/emi/domain/entity/emi_calcuation_entity.dart';

class CurrentMonthEmiResultEntity {
  final CurrentMonthEmiEntity loan;
  final EmiCalculationEntity calculation;

  const CurrentMonthEmiResultEntity({
    required this.loan,
    required this.calculation,
  });
}