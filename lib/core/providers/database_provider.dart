import 'package:expense_app/core/database/database_helper.dart' show DatabaseHelper;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});