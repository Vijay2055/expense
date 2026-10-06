import 'package:expense_app/features/emi/data/models/current_month_emi_model.dart';
import 'package:expense_app/features/emi/data/models/installment_model.dart';
import 'package:expense_app/features/emi/domain/entity/current_month_emi_entity.dart';
import 'package:expense_app/features/emi/domain/entity/installment_entity.dart';

extension CurrentMonthEmiModelMapper on CurrentMonthEmiModel {
  CurrentMonthEmiEntity toEntity() {
    return CurrentMonthEmiEntity(
      loanId: loanId,
      bankName: bankName,
      principal: principal,
      interestRate: interestRate,
      tenureMonths: tenureMonths,
      startDate: DateTime.parse(startDate),
      createdAt: DateTime.parse(createdAt),
      installmentId: installmentId,
      installmentNumber: installmentNumber,
      dueDate: dueDate != null ? DateTime.parse(dueDate!) : null,
      paidDate: paidDate != null ? DateTime.parse(paidDate!) : null,
    );
  }
}

extension InstallmentModelX on InstallmentModel {
  InstallmentEntity toEntity() {
    return InstallmentEntity(
        id: id,
        loanId: loanId,
        installmentNumber: installmentNumber,
        dueDate: DateTime.tryParse(dueDate) ?? DateTime.now(),
        isPaid: isPaid,
        paidDate: paidDate == null ? null : DateTime.tryParse(paidDate!));
  }
}
