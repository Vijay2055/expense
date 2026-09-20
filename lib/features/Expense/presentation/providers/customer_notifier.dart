import 'package:expense_app/features/Expense/presentation/state/customer_state.dart';
import 'package:expense_app/features/Expense/providers/usecase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerNotifier extends Notifier<CustomerState> {
  String? _searchName;
  DateTime? _searchDate;
  @override
  CustomerState build() {
    Future.microtask(() {
      loadCustomers();
    });
    // ref.read(getCustomerUseCaseProvider)();

    return CustomerState();
  }

  Future<void> loadCustomers() async {
    state = state.copyWith(isLoading: true, message: '');

    final result = await ref.read(getCustomerUseCaseProvider)(
        date: _searchDate, name: _searchName);
    result.fold(ifLeft: (failure) {
      state = state.copyWith(isLoading: false, message: failure.message);
    }, ifRight: (data) {
      state = state.copyWith(isLoading: false, customers: data, message: "");
    });
  }

  Future<void> searchCustomer(String value) async {
    _searchName = value.trim().isEmpty ? null : value.trim();

    await loadCustomers();
  }

  Future<void> filterByDate(DateTime? date) async {
    _searchDate = date;

    await loadCustomers();
  }

  Future<void> clearDateFilter() async {
    _searchDate = null;
    _searchName = null;

    await loadCustomers();
  }
}

final customerListProvider =
    NotifierProvider<CustomerNotifier, CustomerState>(CustomerNotifier.new);
