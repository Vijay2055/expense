class InstallmentTable {
  static String createTable = '''CREATE TABLE loan_installments (
    id TEXT PRIMARY KEY,
    loan_id TEXT NOT NULL,
    installment_number INTEGER NOT NULL,
    due_date TEXT NOT NULL,
    is_paid INTEGER NOT NULL DEFAULT 0,
    paid_date TEXT,

    FOREIGN KEY (loan_id)
        REFERENCES loans(id)
        ON DELETE CASCADE
)''';
}
 