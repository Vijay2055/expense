class ExpenseTable {
  static const String createTable = '''
 CREATE TABLE expense(
 id TEXT PRIMARY KEY,
 customerId TEXT NOT NULL,
 amount REAL NOT NULL,
 note TEXT,
 type TEXT NOT NULL,
 date TEXT NOT NULL,

 FOREIGN KEY (customerId)
 REFERENCES customer(id)
 ON DELETE CASCADE
 )
''';
}
