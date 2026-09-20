import 'package:expense_app/features/emi/data/models/installment_model.dart';
import 'package:expense_app/features/emi/data/models/loanModel.dart';
import 'package:expense_app/features/emi/domain/entity/installment_entity.dart';
import 'package:expense_app/features/emi/domain/entity/loan_enity.dart';

extension LoanEntityMapper on LoanEntity {
  LoanModel toModel() {
    return LoanModel(
      id: id,
      bankName: bankName,
      principal: principal,
      rate: interestRate,
      tenure_month: tenureMonths,
      startDate: startDate.toIso8601String(),
      create_at: createdAt.toIso8601String(),
    );
  }
}

extension InstallmentEntityMapper on InstallmentEntity {
  InstallmentModel toModel() {
    return InstallmentModel(
      id: id,
      loanId: loanId,
      installmentNumber: installmentNumber,
      dueDate: dueDate.toIso8601String(),
      isPaid: isPaid,
      paidDate: paidDate?.toIso8601String(),
    );
  }
}