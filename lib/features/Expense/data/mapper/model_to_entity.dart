import 'package:expense_app/features/Expense/data/models/customer_summary_model.dart';
import 'package:expense_app/features/Expense/data/models/expense_model.dart';
import 'package:expense_app/features/Expense/domain/enitty/customer_summary_entity.dart';
import 'package:expense_app/features/Expense/domain/enitty/expense_entity.dart';
import 'package:expense_app/features/Expense/domain/enitty/expense_type_entity.dart';

extension CustomerSummaryModelX on CustomerSummaryModel {
  CustomerSummaryEntity toEntity() {
    return CustomerSummaryEntity(
        id: id,
        name: name,
        phone: phone,
        address: address,
        totalInAmount: totalInAmount,
        lastDate: DateTime.tryParse(lastDate) ?? DateTime.now(),
        totalOutAmount: totalOutAmount);
  }
}

extension ExpenseTypeX on String {
  ExpenseTypeEntity getExpenseType(String value) {
    switch (value) {
      case "take":
        return ExpenseTypeEntity.take;
      case "give":
        return ExpenseTypeEntity.give;
      default:
        return ExpenseTypeEntity.give;
    }
  }
}

extension ExpenseModelX on ExpenseModel {
  ExpenseEntity toEntity() {
    return ExpenseEntity(
        customerId: customerId,
        id: id,
        type: type.getExpenseType(type),
        amount: amount,
        note: note,
        date: DateTime.tryParse(date) ?? DateTime.now());
  }
}
