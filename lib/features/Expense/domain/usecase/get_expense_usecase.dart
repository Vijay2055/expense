import 'package:dart_either/dart_either.dart';
import 'package:expense_app/core/error/failures.dart';
import 'package:expense_app/features/Expense/domain/enitty/expense_entity.dart';
import 'package:expense_app/features/Expense/domain/repository/customer_repository.dart';

class GetExpenseUsecase {
  final CustomerRepository _repository;
  const GetExpenseUsecase(this._repository);

  Future<Either<Failure, List<ExpenseEntity>>> call(
      {required String customerId}) {
    return _repository.getExpenseByCustomerId(customerId: customerId);
  }
}
