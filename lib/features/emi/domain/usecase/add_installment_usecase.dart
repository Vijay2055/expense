import 'package:dart_either/dart_either.dart';
import 'package:expense_app/core/error/failures.dart';
import 'package:expense_app/features/emi/domain/entity/installment_entity.dart';
import 'package:expense_app/features/emi/domain/repository/emi_repository.dart/emi_repository.dart';

class AddInstallmentUsecase {
  final LoanRepository repository;

  AddInstallmentUsecase(this.repository);

  Future<Either<Failure, void>> call(InstallmentEntity installment) {
    return repository.addInstallment(installment);
  }
}
