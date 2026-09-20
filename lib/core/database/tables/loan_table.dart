class LoanTable {
static String createTable='''CREATE TABLE loans (
    id TEXT PRIMARY KEY,
    bank_name TEXT NOT NULL,
    principal REAL NOT NULL,
    interest_rate REAL NOT NULL,
    tenure_months INTEGER NOT NULL,
    start_date TEXT NOT NULL,
    created_at TEXT NOT NULL
)''';
}