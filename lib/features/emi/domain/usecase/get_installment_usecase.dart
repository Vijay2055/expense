import 'package:dart_either/dart_either.dart';
import 'package:expense_app/core/error/failures.dart';
import 'package:expense_app/features/emi/domain/emi_calculator/emi_calculation.dart';
import 'package:expense_app/features/emi/domain/entity/installment_result_entity.dart';
import 'package:expense_app/features/emi/domain/repository/emi_repository.dart/emi_repository.dart';

class GetInstallmentUsecase {
  final LoanRepository _repository;
  final EmiCalculator calculator;

  const GetInstallmentUsecase(this._repository, this.calculator);

  Future<Either<Failure, List<InstallmentResultEntity>>> call({
    required String loanId,
    required double principal,
    required double annualInterestRate,
    required int tenureMonths,
  }) async {
    final calculations = calculator.calculateSchedule(
      principal: principal,
      annualInterestRate: annualInterestRate,
      tenureMonths: tenureMonths,
    );

    final installmentsResult = await _repository.getInstallment(
      loanId: loanId,
    );

    return installmentsResult.fold(
      ifLeft: (failure) {
        return Left(failure);
      },
      ifRight: (installments) {
        final installmentMap = {
          for (final installment in installments)
            installment.installmentNumber: installment,
        };

        final data = calculations.map((calculation) {
          final installment = installmentMap[calculation.installmentNumber];

          if (installment != null) {
            return InstallmentResultEntity(
              installmentNumber: installment.installmentNumber,
              dueDate: installment.dueDate,
              isPaid: installment.isPaid,
              paidDate: installment.paidDate,
              emi: calculation.emi,
              principalAmount: calculation.principalAmount,
              interestAmount: calculation.interestAmount,
              remainingAmount: calculation.remainingBalance,
            );
          }

          return InstallmentResultEntity(
            installmentNumber: calculation.installmentNumber,
            dueDate: null,
            isPaid: false,
            paidDate: null,
            emi: calculation.emi,
            principalAmount: calculation.principalAmount,
            interestAmount: calculation.interestAmount,
            remainingAmount: calculation.remainingBalance,
          );
        }).toList();

        return Right(data);
      },
    );
  }
}
