import 'package:dart_either/dart_either.dart';
import 'package:expense_app/core/error/failures.dart';
import 'package:expense_app/features/Expense/domain/enitty/customer_entity.dart';
import 'package:expense_app/features/Expense/domain/repository/customer_repository.dart';
import 'package:uuid/uuid.dart';

class AddCustomerUsecase {
  final CustomerRepository _repository;
  final Uuid _uuid;
  const AddCustomerUsecase(this._repository, {Uuid uuid = const Uuid()})
      : _uuid = uuid;
  Future<Either<Failure, void>> call({
    required String name,
    String? mobile,
    String? address,
  }) {
    final customer = CustomerEntity(
        id: _uuid.v4(), name: name, mobile: mobile, address: address);

    return _repository.addCustomer(customer);
  }
}
