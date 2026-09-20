import 'package:expense_app/core/sync/domain/enums/sync_entity_type.dart';
import 'package:expense_app/core/sync/services/sync_handler.dart';
import 'package:expense_app/features/Expense/data/data_sources/customer_local_datasource.dart';
import 'package:expense_app/features/Expense/data/data_sources/customer_remote_datasource.dart';

class CustomerSyncHandler implements SyncHandler {
  final CustomerLocalDataSource localDataSource;
  final CustomerRemoteDataSource remoteDataSource;

  const CustomerSyncHandler({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  SyncEntityType get entityType {
    return SyncEntityType.customer;
  }

  @override
  Future<void> create(String entityId) async {
    final customer =
        await localDataSource.getCustomerById(entityId);

    if (customer == null) {
      return;
    }

    await remoteDataSource.addCustomer(customer);
  }

  @override
  Future<void> update(String entityId) async {
    final customer =
        await localDataSource.getCustomerById(entityId);

    if (customer == null) {
      return;
    }

    await remoteDataSource.updateCustomer(customer);
  }

  @override
  Future<void> delete(String entityId) {
    return remoteDataSource.deleteCustomer(entityId);
  }
}