import 'package:dart_either/dart_either.dart';
import 'package:expense_app/core/error/failures.dart';
import 'package:expense_app/features/emi/data/data_source/emi_local_datasource.dart';
import 'package:expense_app/features/emi/data/mapper/entity_to_model.dart';
import 'package:expense_app/features/emi/data/mapper/model_to_entity.dart';
import 'package:expense_app/features/emi/domain/entity/current_month_emi_entity.dart';
import 'package:expense_app/features/emi/domain/entity/installment_entity.dart';
import 'package:expense_app/features/emi/domain/entity/loan_enity.dart';
import 'package:expense_app/features/emi/domain/repository/emi_repository.dart/emi_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmiRepostitoryIml implements LoanRepository {
  final EmiLocalDatasource localDataSource;

  EmiRepostitoryIml({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, void>> addLoan(LoanEntity loan) async {
    try {
      final model = loan.toModel();

      await localDataSource.insertLoan(model);

      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> addInstallment(
    InstallmentEntity installment,
  ) async {
    try {
      final model = installment.toModel();

      await localDataSource.insertInstallment(model);

      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<CurrentMonthEmiEntity>>>
      getCurrentMonthLoans() async {
    try {
      final models = await localDataSource.getCurrentMonthEmi();

      final entities = models.map((model) => model.toEntity()).toList();

      return Right(entities);
    } catch (e) {
      return Left(
        CacheFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<InstallmentEntity>>> getInstallment(
      {required String loanId}) async {
    try {
      final instalment = await localDataSource.getInstallment(loanId: loanId);
      return Right(instalment.map((item) => item.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}

final emiRepositoryProvider = Provider<LoanRepository>((ref) {
  return EmiRepostitoryIml(
      localDataSource: ref.watch(emiLocalDatasourceProvider));
});
