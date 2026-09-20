import 'package:dart_either/dart_either.dart';
import 'package:expense_app/core/error/failures.dart';
import 'package:expense_app/features/emi/domain/entity/loan_enity.dart';
import 'package:expense_app/features/emi/domain/repository/emi_repository.dart/emi_repository.dart';


class AddLoanUseCase {
  final LoanRepository repository;

  AddLoanUseCase(this.repository);

  Future<Either<Failure, void>> call(LoanEntity loan) {
    return repository.addLoan(loan);
  }
}