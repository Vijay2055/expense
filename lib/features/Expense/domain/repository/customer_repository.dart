import 'package:dart_either/dart_either.dart';
import 'package:expense_app/core/error/failures.dart';
import 'package:expense_app/features/Expense/domain/enitty/customer_entity.dart';
import 'package:expense_app/features/Expense/domain/enitty/customer_summary_entity.dart';
import 'package:expense_app/features/Expense/domain/enitty/expense_entity.dart';

abstract class CustomerRepository {
  Future<Either<Failure, List<CustomerSummaryEntity>>> getCustomers(
    String? name,
    DateTime? date,
  );

  Future<Either<Failure, CustomerEntity?>> getCustomerById(int id);

  Future<Either<Failure, void>> addCustomer(
    CustomerEntity customer,
  );

  Future<Either<Failure, void>> updateCustomer(
    CustomerEntity customer,
  );

  Future<Either<Failure, void>> deleteCustomer(
    int id,
  );

// Expense related
  Future<Either<Failure, void>> addExpense({required ExpenseEntity expense});

  Future<Either<Failure, List<ExpenseEntity>>> getExpenseByCustomerId(
      {required String customerId});
}
