import 'package:expense_app/features/emi/presentation/applications/states/emi_detail_state.dart';
import 'package:expense_app/features/emi/providers/usecase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InstallmentNotifier extends Notifier<EmiDetailState> {
  @override
  EmiDetailState build() {
    return EmiDetailState();
  }

  Future<void> loadInstallment(
      {required String loandId,
      required double annualIntr,
      required double principal,
      required int tenureMonth}) async {
    state = state.copyWith(isLoading: true, error: null);
    final data = await ref.read(getInstallmentUsecaseProvider)(
      annualInterestRate: annualIntr,
      loanId: loandId,
      principal: principal,
      tenureMonths: tenureMonth,
    );

    data.fold(ifLeft: (failure) {
      state = state.copyWith(error: failure.message, isLoading: false);
    }, ifRight: (installment) {
      print(installment.length);
      state = state.copyWith(data: installment, error: null, isLoading: false);
    });
  }
}

final installmentProvider =
    NotifierProvider<InstallmentNotifier, EmiDetailState>(
        InstallmentNotifier.new);
