import 'package:expense_app/core/database/database_helper.dart';
import 'package:expense_app/features/emi/data/models/current_month_emi_model.dart';
import 'package:expense_app/features/emi/data/models/installment_model.dart';
import 'package:expense_app/features/emi/data/models/loanModel.dart';

abstract class EmiLocalDatasource {
  Future<void> insertLoan(LoanModel loan);
  Future<List<CurrentMonthEmiModel>> getCurrentMonthEmi();
  Future<LoanModel> getLoan(String loanId);
  Future<void> insertInstallment(InstallmentModel installment);
  Future<List<InstallmentModel>> getInstallment();
}

class EmiLocalDataSoruceImpl implements EmiLocalDatasource {
  final DatabaseHelper _helper;
  const EmiLocalDataSoruceImpl(this._helper);
  @override
  Future<LoanModel> getLoan(String loanId) {
    // TODO: implement getLoan
    throw UnimplementedError();
  }

  @override
  Future<List<CurrentMonthEmiModel>> getCurrentMonthEmi() async {
    final db = await _helper.database;

    final result = await db.rawQuery('''
SELECT
    loans.id,
    loans.bank_name,
    loans.principal,
    loans.interest_rate,
    loans.tenure_months,
    loans.start_date,
    loans.created_at,

    loan_installments.id AS installment_id,
    loan_installments.installment_number,
    loan_installments.due_date,
    loan_installments.is_paid,
    loan_installments.paid_date

FROM loans

LEFT JOIN loan_installments
    ON loans.id = loan_installments.loan_id
    AND strftime('%Y-%m', loan_installments.due_date)
        = strftime('%Y-%m', 'now')

ORDER BY loans.created_at DESC;



''');

    return result.map((item) => CurrentMonthEmiModel.fromMap(item)).toList();
  }

  @override
  Future<void> insertLoan(LoanModel loan) async {
    final db = await _helper.database;
    await db.insert('loans', loan.toJson());
  }

  @override
  Future<List<InstallmentModel>> getInstallment() {
    // TODO: implement getInstallment
    throw UnimplementedError();
  }

  @override
  Future<void> insertInstallment(InstallmentModel installment) async {
    final db = await _helper.database;
    await db.insert('loan_installments', installment.toJson());
  }
}
