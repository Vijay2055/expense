import 'package:dart_either/dart_either.dart';
import 'package:expense_app/core/error/failures.dart';
import 'package:expense_app/features/Expense/domain/enitty/expense_entity.dart';
import 'package:expense_app/features/Expense/domain/enitty/expense_type_entity.dart';
import 'package:expense_app/features/Expense/domain/repository/customer_repository.dart';
import 'package:uuid/uuid.dart';

class AddExpenseUsecase {
  final CustomerRepository _repository;
  final Uuid _uuid;
  const AddExpenseUsecase(this._repository, {Uuid uuid = const Uuid()})
      : _uuid = uuid;
  Future<Either<Failure, void>> call({
    required String customerId,
    required double amount,
    required String note,
    required ExpenseTypeEntity type,
    required DateTime date,
  }) {
    final expense = ExpenseEntity(
      customerId: customerId,
      id: _uuid.v4(),
      type: type,
      amount: amount,
      note: note,
      date: date,
    );
    return _repository.addExpense(expense: expense);
  }
}
