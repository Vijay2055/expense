import 'package:expense_app/core/database/database_helper.dart';
import 'package:expense_app/core/providers/database_provider.dart';
import 'package:expense_app/features/Expense/data/models/customer_data_model.dart';
import 'package:expense_app/features/Expense/data/models/customer_summary_model.dart';
import 'package:expense_app/features/Expense/data/models/expense_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class CustomerLocalDataSource {
  Future<List<CustomerSummaryModel>> getCustomer(
    String? name,
    String? date,
  );
  Future<CustomerModel?> getCustomerById(String id);

  Future<void> addCustomer(CustomerModel customer);

  Future<void> updateCustomer(CustomerModel customer);

  Future<void> deleteCustomer(String id);

  Future<void> addExpense(ExpenseModel expense);
  Future<List<ExpenseModel>> getExpenseByCustomerId(
      {required String customerId});
}

class CustomerLocalDatasourceImpl implements CustomerLocalDataSource {
  final DatabaseHelper databaseHelper;
  const CustomerLocalDatasourceImpl(this.databaseHelper);
  @override
  Future<void> addCustomer(CustomerModel customer) async {
    final db = await databaseHelper.database;
    await db.insert('customer', customer.toJson());
  }

  @override
  Future<void> deleteCustomer(String id) {
    // TODO: implement deleteCustomer
    throw UnimplementedError();
  }

  @override
  Future<CustomerModel?> getCustomerById(String id) {
    // TODO: implement getCustomerById
    throw UnimplementedError();
  }

  @override
  Future<void> updateCustomer(CustomerModel customer) {
    // TODO: implement updateCustomer
    throw UnimplementedError();
  }

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    // TODO: implement addExpense
    final db = await databaseHelper.database;
    await db.insert('expense', expense.toJson());
  }

  @override
  Future<List<CustomerSummaryModel>> getCustomer(
    String? name,
    String? date,
  ) async {
    final db = await databaseHelper.database;

    final args = <Object?>[];

    final sql = StringBuffer('''
    SELECT
      customer.id,
      customer.name,
      customer.mobile,
      customer.address,
      customer.sync_status,

      SUM(
        CASE
          WHEN expense.type = 'take'
          THEN expense.amount
          ELSE 0
        END
      ) AS TotalIn,

      SUM(
        CASE
          WHEN expense.type = 'give'
          THEN expense.amount
          ELSE 0
        END
      ) AS TotalOut,

      MAX(expense.date) AS LastDate

    FROM customer

    LEFT JOIN expense
      ON customer.id = expense.customerId
  ''');

    // -------------------------
    // Name search
    // -------------------------

    if (name != null && name.trim().isNotEmpty) {
      sql.write(' WHERE customer.name LIKE ? ');
      args.add('%${name.trim()}%');
    }

    sql.write('''
    GROUP BY customer.id
  ''');

    // -------------------------
    // Date filter
    // -------------------------

    if (date != null && date.trim().isNotEmpty) {
      sql.write('''
      HAVING DATE(MAX(expense.date)) = DATE(?)
    ''');

      args.add(date.trim());
    }

    sql.write('''
    ORDER BY LastDate DESC
  ''');

    final rows = await db.rawQuery(
      sql.toString(),
      args,
    );

    return rows.map((item) {
      final lastDate =
          item['LastDate'] as String? ?? DateTime.now().toIso8601String();

      final totalIn = (item['TotalIn'] as num?)?.toDouble() ?? 0.0;

      final totalOut = (item['TotalOut'] as num?)?.toDouble() ?? 0.0;

      return CustomerSummaryModel.fromMap(
        item,
        lastDate,
        totalIn,
        totalOut,
      );
    }).toList();
  }

  @override
  Future<List<ExpenseModel>> getExpenseByCustomerId(
      {required String customerId}) async {
    final db = await databaseHelper.database;
    final rows = await db.query('expense',
        where: 'customerId=?', whereArgs: [customerId], orderBy: 'date DESC');

    return rows.map((item) => ExpenseModel.fromMap(item)).toList();
  }
}

final customerLocalDataSourceProvider =
    Provider<CustomerLocalDataSource>((ref) {
  return CustomerLocalDatasourceImpl(ref.watch(databaseHelperProvider));
});
