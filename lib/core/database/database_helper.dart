import 'package:expense_app/core/database/tables/customer_table.dart';
import 'package:expense_app/core/database/tables/expense_tale.dart';
import 'package:expense_app/core/database/tables/installment_table.dart';
import 'package:expense_app/core/database/tables/loan_table.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String _databaseName = 'expense.db';
  static const int _version = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();
    batch.execute(CustomerTable.createTable);
    batch.execute(ExpenseTable.createTable);
    batch.execute(LoanTable.createTable);
    batch.execute(InstallmentTable.createTable);
    // batch.execute(SyncQueueTable.createTable);
    await batch.commit();
  }
}
