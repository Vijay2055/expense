import 'package:dart_either/dart_either.dart';
import 'package:expense_app/core/error/failures.dart';
import 'package:expense_app/features/emi/domain/emi_calculator/emi_calculation.dart';
import 'package:expense_app/features/emi/domain/entity/current_month_emi_result_entity.dart';
import 'package:expense_app/features/emi/domain/repository/emi_repository.dart/emi_repository.dart';

class GetCurrentMonthEmiUseCase {
  final LoanRepository repository;
  final EmiCalculator emiCalculator;

  GetCurrentMonthEmiUseCase({
    required this.repository,
    required this.emiCalculator,
  });

  Future<Either<Failure, List<CurrentMonthEmiResultEntity>>> call() async {
    final result = await repository.getCurrentMonthLoans();

    return result.map((loans) {
      return loans.map((loan) {
        final installmentNumber = loan.installmentNumber ?? 1;

        final schedule = emiCalculator.calculateSchedule(
          principal: loan.principal,
          annualInterestRate: loan.interestRate,
          tenureMonths: loan.tenureMonths,
        );

        final calculation = schedule[installmentNumber - 1];

        return CurrentMonthEmiResultEntity(
          loan: loan,
          calculation: calculation,
        );
      }).toList();
    });
  }
}