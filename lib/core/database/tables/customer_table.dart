class CustomerTable {
  static const String createTable = '''
    CREATE TABLE customer(
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      mobile TEXT,
      address TEXT,
      sync_status TEXT NOT NULL DEFAULT 'pending'
    )
  ''';
}
