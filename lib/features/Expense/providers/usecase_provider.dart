import 'package:expense_app/features/Expense/data/repository/customer_repository_impl.dart';
import 'package:expense_app/features/Expense/domain/usecase/add_customer_usecasee.dart';
import 'package:expense_app/features/Expense/domain/usecase/add_expense_usecase.dart';
import 'package:expense_app/features/Expense/domain/usecase/get_customer_usecase.dart';
import 'package:expense_app/features/Expense/domain/usecase/get_expense_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getCustomerUseCaseProvider = Provider<GetCustomerSummaryUsecase>((ref) {
  return GetCustomerSummaryUsecase(ref.watch(customerReposiotryProvider));
});

final getExpenseUseCaseProvider = Provider<GetExpenseUsecase>((ref) {
  return GetExpenseUsecase(ref.watch(customerReposiotryProvider));
});

final addCustomerUsecaseProvider = Provider<AddCustomerUsecase>((ref) {
  return AddCustomerUsecase(ref.watch(customerReposiotryProvider));
});

final addExpenseUsecaseProvider = Provider<AddExpenseUsecase>((ref) {
  return AddExpenseUsecase(ref.watch(customerReposiotryProvider));
});

