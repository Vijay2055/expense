import 'package:dart_either/dart_either.dart';
import 'package:expense_app/core/error/failures.dart';
import 'package:expense_app/features/emi/domain/entity/current_month_emi_entity.dart';
import 'package:expense_app/features/emi/domain/entity/installment_entity.dart';
import 'package:expense_app/features/emi/domain/entity/loan_enity.dart';

abstract class LoanRepository {
  Future<Either<Failure, List<CurrentMonthEmiEntity>>> getCurrentMonthLoans();
  Future<Either<Failure, void>> addLoan(LoanEntity loan);
  Future<Either<Failure, void>> addInstallment(InstallmentEntity installment);
  Future<Either<Failure, List<InstallmentEntity>>> getInstallment({
    required String loanId,
   
  });
}
