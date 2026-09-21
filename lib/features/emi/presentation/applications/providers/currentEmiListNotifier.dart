import 'package:expense_app/features/emi/presentation/applications/states/current_emi_list_state.dart';
import 'package:expense_app/features/emi/providers/usecase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Currentemilistnotifier extends Notifier<CurrentEmiListState> {
  @override
  CurrentEmiListState build() {
    Future.microtask(() {
      _loadEmi();
    });
    return CurrentEmiListState();
  }

  Future<void> _loadEmi() async {
    state = state.copyWith(isLoading: true, message: null);
    final data = await ref.read(getCurrentMonthEmiUseCaseProvider)();
    data.fold(ifLeft: (failure) {
      state = state.copyWith(message: failure.message, isLoading: false);
    }, ifRight: (emis) {
      state = state.copyWith(result: emis, message: null, isLoading: false);
    });
  }
}

final currentMonthEmiNotifierProvider =
    NotifierProvider<Currentemilistnotifier, CurrentEmiListState>(
        Currentemilistnotifier.new);
