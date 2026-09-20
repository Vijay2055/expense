import 'package:expense_app/features/Expense/domain/enitty/expense_entity.dart';

class ExpenseState {
  final bool isLoading;
  final List<ExpenseEntity> expenses;
  final String message;

  ExpenseState(
      {this.isLoading = false, this.expenses = const [], this.message = ''});

  ExpenseState copyWith({
    bool? isLoading,
    List<ExpenseEntity>? expenses,
    String? message,
  }) {
    return ExpenseState(
        isLoading: isLoading ?? this.isLoading,
        expenses: expenses ?? this.expenses,
        message: message ?? this.message);
  }
}
