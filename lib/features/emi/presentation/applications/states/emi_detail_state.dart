import 'package:expense_app/features/emi/domain/entity/installment_result_entity.dart';

class EmiDetailState {
  final bool isLoading;
  final String error;
  final List<InstallmentResultEntity> data;

  const EmiDetailState(
      {this.isLoading = false, this.error = "", this.data = const []});

  EmiDetailState copyWith({
    bool? isLoading,
    String? error,
    List<InstallmentResultEntity>? data,
  }) {
    return EmiDetailState(
        data: data ?? this.data,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading);
  }
}
