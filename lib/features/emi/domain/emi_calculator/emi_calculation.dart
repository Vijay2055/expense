// import 'dart:math';

// import 'package:expense_app/features/emi/domain/entity/emi_calcuation_entity.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class EmiCalculator {
//   List<EmiCalculationEntity> calculateSchedule({
//     required double principal,
//     required double annualInterestRate,
//     required int tenureMonths,
//   }) {
//     final monthlyRate = annualInterestRate / 12 / 100;

//     final emi = monthlyRate == 0
//         ? principal / tenureMonths
//         : principal *
//             monthlyRate *
//             pow(1 + monthlyRate, tenureMonths) /
//             (pow(1 + monthlyRate, tenureMonths) - 1);

//     var balance = principal;

//     final schedule = <EmiCalculationEntity>[];

//     for (int i = 1; i <= tenureMonths; i++) {
//       final interest = balance * monthlyRate;
//       final principalPaid = emi - interest;

//       balance -= principalPaid;

//       if (balance < 0) {
//         balance = 0;
//       }

//       schedule.add(
//         EmiCalculationEntity(
//           installmentNumber: i,
//           emi: emi,
//           principalAmount: principalPaid,
//           interestAmount: interest,
//           remainingBalance: balance,
//         ),
//       );
//     }

//     return schedule;
//   }
// }

// final emiCalculationProvider = Provider((ref) {
//   return EmiCalculator();
// });

import 'dart:math';

import 'package:expense_app/features/emi/domain/entity/emi_calcuation_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmiCalculator {
  double _roundToPaise(double amount) {
    return (amount * 100).roundToDouble() / 100;
  }

  List<EmiCalculationEntity> calculateSchedule({
    required double principal,
    required double annualInterestRate,
    required int tenureMonths,
  }) {
    // Validate inputs.
    if (!principal.isFinite || principal <= 0) {
      throw ArgumentError('Principal must be greater than zero.');
    }

    if (!annualInterestRate.isFinite || annualInterestRate < 0) {
      throw ArgumentError(
        'Annual interest rate cannot be negative.',
      );
    }

    if (tenureMonths <= 0) {
      throw ArgumentError('Tenure must be greater than zero.');
    }

    final monthlyRate = annualInterestRate / 12 / 100;

    // Calculate the theoretical EMI.
    final double rawEmi;

    if (monthlyRate == 0) {
      rawEmi = principal / tenureMonths;
    } else {
      final factor = pow(1 + monthlyRate, tenureMonths);

      rawEmi = principal * monthlyRate * factor / (factor - 1);
    }

    // Round the regular EMI to the nearest paise.
    final regularEmi = _roundToPaise(rawEmi);

    var balance = _roundToPaise(principal);

    final schedule = <EmiCalculationEntity>[];

    for (int i = 1; i <= tenureMonths; i++) {
      // Interest on the outstanding principal.
      final interest = _roundToPaise(balance * monthlyRate);

      // Total amount due for this installment.
      final totalDue = _roundToPaise(balance + interest);

      // Adjust the last installment to clear the loan.
      final installmentEmi =
          (i == tenureMonths || regularEmi >= totalDue) ? totalDue : regularEmi;

      // Principal repaid in this installment.
      final principalPaid = _roundToPaise(
        installmentEmi - interest,
      );

      // Outstanding balance after payment.
      balance = _roundToPaise(balance - principalPaid);

      // Eliminate floating-point residuals.
      if (balance.abs() < 0.01) {
        balance = 0;
      }

      schedule.add(
        EmiCalculationEntity(
          installmentNumber: i,
          emi: installmentEmi,
          principalAmount: principalPaid,
          interestAmount: interest,
          remainingBalance: balance,
        ),
      );
    }

    return schedule;
  }
}

final emiCalculationProvider = Provider<EmiCalculator>((ref) {
  return EmiCalculator();
});
