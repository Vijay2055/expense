import 'package:expense_app/features/Expense/data/models/customer_data_model.dart';
import 'package:expense_app/features/Expense/data/models/expense_model.dart';
import 'package:expense_app/features/Expense/domain/enitty/customer_entity.dart';
import 'package:expense_app/features/Expense/domain/enitty/expense_entity.dart';

extension CustomerEntityX on CustomerEntity {
  CustomerModel toModel() {
    return CustomerModel(id: id, name: name, address: address, mobile: mobile);
  }
}

extension ExpenseEntityX on ExpenseEntity {
  ExpenseModel toModel() {
    return ExpenseModel(
        id: id,
        customerId: customerId,
        type: type.name,
        amount: amount,
        note: note,
        date: date.toIso8601String());
  }
}
