import 'package:expense_app/features/Expense/domain/enitty/customer_summary_entity.dart';

class CustomerState {
  final String message;
  final List<CustomerSummaryEntity> customers;
  final bool isLoading;

  CustomerState(
      {this.message = '', this.customers = const [], this.isLoading = false});

  CustomerState copyWith(
      {String? message, bool? isLoading, List<CustomerSummaryEntity>? customers}) {
    return CustomerState(
        customers: customers ?? this.customers,
        isLoading: isLoading ?? this.isLoading,
        message: message ?? this.message);
  }
}
