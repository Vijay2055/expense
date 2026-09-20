import 'package:dart_either/dart_either.dart';
import 'package:expense_app/core/error/failures.dart';
import 'package:expense_app/features/Expense/domain/enitty/customer_summary_entity.dart';
import 'package:expense_app/features/Expense/domain/repository/customer_repository.dart';

class GetCustomerSummaryUsecase {
  final CustomerRepository _repository;
  const GetCustomerSummaryUsecase(this._repository);
  Future<Either<Failure, List<CustomerSummaryEntity>>> call({
    String? name,
    DateTime? date,
  }) {
    return _repository.getCustomers(name, date);
  }
}
