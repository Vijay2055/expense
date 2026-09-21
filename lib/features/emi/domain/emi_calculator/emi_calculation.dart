import 'dart:math';

import 'package:expense_app/features/emi/domain/entity/emi_calcuation_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmiCalculator {
  List<EmiCalculationEntity> calculateSchedule({
    required double principal,
    required double annualInterestRate,
    required int tenureMonths,
  }) {
    final monthlyRate = annualInterestRate / 12 / 100;

    final emi = monthlyRate == 0
        ? principal / tenureMonths
        : principal *
            monthlyRate *
            pow(1 + monthlyRate, tenureMonths) /
            (pow(1 + monthlyRate, tenureMonths) - 1);

    var balance = principal;

    final schedule = <EmiCalculationEntity>[];

    for (int i = 1; i <= tenureMonths; i++) {
      final interest = balance * monthlyRate;
      final principalPaid = emi - interest;

      balance -= principalPaid;

      if (balance < 0) {
        balance = 0;
      }

      schedule.add(
        EmiCalculationEntity(
          installmentNumber: i,
          emi: emi,
          principalAmount: principalPaid,
          interestAmount: interest,
          remainingBalance: balance,
        ),
      );
    }

    return schedule;
  }
}

final emiCalculationProvider = Provider((ref) {
  return EmiCalculator();
});
