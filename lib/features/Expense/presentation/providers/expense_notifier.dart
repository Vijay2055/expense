import 'package:expense_app/features/Expense/presentation/state/expense_state.dart';
import 'package:expense_app/features/Expense/providers/usecase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseNotifier extends Notifier<ExpenseState> {
  @override
  ExpenseState build() {
    return ExpenseState();
  }

  Future<void> loadExpense({required String customerId}) async {
    state = state.copyWith(isLoading: true, message: '');
    final result =
        await ref.read(getExpenseUseCaseProvider)(customerId: customerId);

    result.fold(
        ifLeft: (failure) =>
          state=  state.copyWith(isLoading: false, message: failure.message),
        ifRight: (data) =>
          state=  state.copyWith(expenses: data, isLoading: false, message: ""));
  }
}

final expenseListProvider =
    NotifierProvider<ExpenseNotifier, ExpenseState>(ExpenseNotifier.new);
