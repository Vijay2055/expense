import 'package:expense_app/features/emi/domain/entity/current_month_emi_result_entity.dart';

class CurrentEmiListState {
  final bool isLoading;
  final String message;
  final List<CurrentMonthEmiResultEntity> result;

  const CurrentEmiListState(
      {this.isLoading = false, this.message = '', this.result = const []});

  CurrentEmiListState copyWith(
      {bool? isLoading,
      String? message,
      List<CurrentMonthEmiResultEntity>? result}) {
    return CurrentEmiListState(
      isLoading: isLoading?? this.isLoading,
      message: message?? this.message,
      result: result?? this.result
    );
  }
}
