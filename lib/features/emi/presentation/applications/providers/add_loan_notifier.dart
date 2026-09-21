import 'package:expense_app/features/emi/presentation/applications/states/add_loan_state.dart';
import 'package:expense_app/features/emi/providers/usecase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_app/features/emi/domain/entity/loan_enity.dart';
import 'package:expense_app/features/emi/domain/emi_calculator/emi_calculation.dart';

class AddLoanNotifier extends Notifier<AddLoanState> {
  @override
  AddLoanState build() {
    return AddLoanState(
      startDate: DateTime.now(),
    );
  }

  void setBankName(String value) {
    state = state.copyWith(
      bankName: value,
      clearError: true,
    );
  }

  void setPrincipal(String value) {
    state = state.copyWith(
      principal: value,
      clearError: true,
    );

    _calculateEmi();
  }

  void setInterestRate(String value) {
    state = state.copyWith(
      interestRate: value,
      clearError: true,
    );

    _calculateEmi();
  }

  void setTenure(int value) {
    state = state.copyWith(
      tenureMonths: value,
      clearError: true,
    );

    _calculateEmi();
  }

  void setStartDate(DateTime value) {
    state = state.copyWith(
      startDate: value,
      clearError: true,
    );
  }

  void _calculateEmi() {
    final principal = double.tryParse(state.principal);
    final rate = double.tryParse(state.interestRate);

    if (principal == null ||
        principal <= 0 ||
        rate == null ||
        rate < 0 ||
        state.tenureMonths <= 0) {
      state = state.copyWith(
        clearCalculatedEmi: true,
      );
      return;
    }

    final schedule = ref.read(emiCalculationProvider).calculateSchedule(
          principal: principal,
          annualInterestRate: rate,
          tenureMonths: state.tenureMonths,
        );

    if (schedule.isEmpty) {
      return;
    }

    state = state.copyWith(
      calculatedEmi: schedule.first.emi,
    );
  }

  Future<void> addLoan() async {
    final validationError = _validate();

    if (validationError != null) {
      state = state.copyWith(
        errorMessage: validationError,
        isSubmitting: false,
      );
      return;
    }

    final principal = double.parse(state.principal);
    final rate = double.parse(state.interestRate);

    state = state.copyWith(
      isSubmitting: true,
      clearError: true,
      isSuccess: false,
    );

    final loan = LoanEntity(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      bankName: state.bankName.trim(),
      principal: principal,
      interestRate: rate,
      tenureMonths: state.tenureMonths,
      startDate: state.startDate,
      createdAt: DateTime.now(),
    );

    final result = await ref.watch(addLoanProvider)(loan);

    result.fold(
      ifLeft: (failure) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: failure.toString(),
        );
      },
      ifRight: (_) {
        state = state.copyWith(
          isSubmitting: false,
          isSuccess: true,
        );
      },
    );
  }

  String? _validate() {
    if (state.bankName.trim().isEmpty) {
      return 'Please enter bank or lender name';
    }

    final principal = double.tryParse(state.principal);

    if (principal == null || principal <= 0) {
      return 'Please enter a valid loan amount';
    }

    final rate = double.tryParse(state.interestRate);

    if (rate == null || rate < 0) {
      return 'Please enter a valid interest rate';
    }

    if (state.tenureMonths <= 0) {
      return 'Please select a valid tenure';
    }

    return null;
  }
}

final addLoanNotifierProvider = NotifierProvider<AddLoanNotifier,AddLoanState>(AddLoanNotifier.new);
