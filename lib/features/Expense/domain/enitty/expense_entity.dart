import 'package:expense_app/features/Expense/domain/enitty/expense_type_entity.dart';

class ExpenseEntity {
  final String id;
  final String customerId;
  final ExpenseTypeEntity type;
  final double amount;
  final String note;
  final DateTime date;

  ExpenseEntity(
      {required this.customerId,
      required this.id,
      required this.type,
      required this.amount,
      required this.note,
      required this.date});
}
