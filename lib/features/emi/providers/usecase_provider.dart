import 'package:expense_app/features/emi/data/repository/emi_repostitory_iml.dart';
import 'package:expense_app/features/emi/domain/emi_calculator/emi_calculation.dart';
import 'package:expense_app/features/emi/domain/usecase/add_loan_usecase.dart';
import 'package:expense_app/features/emi/domain/usecase/get_current_month_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getCurrentMonthEmiUseCaseProvider =
    Provider<GetCurrentMonthEmiUseCase>((ref) {
  return GetCurrentMonthEmiUseCase(
      repository: ref.watch(emiRepositoryProvider),
      emiCalculator: ref.watch(emiCalculationProvider));
});

final addLoanProvider = Provider<AddLoanUseCase>((ref) {
  return AddLoanUseCase(ref.watch(emiRepositoryProvider));
});
