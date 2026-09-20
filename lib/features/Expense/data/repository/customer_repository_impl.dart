

import 'package:dart_either/src/dart_either.dart';
import 'package:expense_app/core/error/failures.dart';
import 'package:expense_app/core/providers/sync_provider.dart';
import 'package:expense_app/core/sync/data/data_sources/sync_queue_local_data_source.dart';

import 'package:expense_app/features/Expense/data/data_sources/customer_local_datasource.dart'
    hide customerLocalDataSourceProvider;
import 'package:expense_app/features/Expense/data/mapper/entity_to_model.dart';
import 'package:expense_app/features/Expense/data/mapper/model_to_entity.dart';
import 'package:expense_app/features/Expense/domain/enitty/customer_entity.dart';
import 'package:expense_app/features/Expense/domain/enitty/customer_summary_entity.dart';
import 'package:expense_app/features/Expense/domain/enitty/expense_entity.dart';
import 'package:expense_app/features/Expense/domain/repository/customer_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerLocalDataSource localDataSource;
  final SyncQueueLocalDataSource syncQueue;

  const CustomerRepositoryImpl({
    required this.localDataSource,
    required this.syncQueue,
  });

  @override
  Future<Either<Failure, void>> addCustomer(CustomerEntity customer) async {
    try {
      final model = customer.toModel();

      // Local database first.
      await localDataSource.addCustomer(model);

      // Add synchronization task.
      // await syncQueue.add(
      //   SyncItem(
      //     id: const Uuid().v4(),
      //     entityType: SyncEntityType.customer,
      //     entityId: customer.id,
      //     operation: SyncOperation.create,
      //     createdAt: DateTime.now(),
      //   ),
      // );

      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(
        LocalDatabaseFailure(
          message: e.toString(),
        ),
      );
    } catch (e) {
      return Left(
        LocalDatabaseFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteCustomer(int id) {
    // TODO: implement deleteCustomer
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, CustomerEntity?>> getCustomerById(int id) {
    // TODO: implement getCustomerById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<CustomerSummaryEntity>>> getCustomers(String? name,DateTime? date) async {
    try {
      final result = await localDataSource.getCustomer(name,date?.toIso8601String());

      return Right(result.map((item) => item.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCustomer(CustomerEntity customer) {
    // TODO: implement updateCustomer
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> addExpense(
      {required ExpenseEntity expense}) async {
    // TODO: implement addExpense
    try {
      await localDataSource.addExpense(expense.toModel());
      return Right(null);
    } on DatabaseException catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ExpenseEntity>>> getExpenseByCustomerId(
      {required String customerId}) async {
    try {
      final result =
          await localDataSource.getExpenseByCustomerId(customerId: customerId);
      return Right(result.map((item) => item.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}

final customerReposiotryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepositoryImpl(
      localDataSource: ref.watch(customerLocalDataSourceProvider),
      syncQueue: ref.read(syncQueueDataSourceProvider));
});
