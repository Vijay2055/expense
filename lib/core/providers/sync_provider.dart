import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expense_app/core/providers/database_provider.dart';
import 'package:expense_app/core/sync/data/data_sources/sync_queue_local_data_source.dart';
import 'package:expense_app/core/sync/data/data_sources/sync_queue_local_data_source_impl.dart';
import 'package:expense_app/core/sync/services/sync_handler.dart';
import 'package:expense_app/core/sync/services/sync_manager.dart';
import 'package:expense_app/core/sync/services/sync_service.dart';
import 'package:expense_app/features/Expense/data/data_sources/customer_local_datasource.dart';
import 'package:expense_app/features/Expense/data/data_sources/customer_remote_datasource.dart';

import 'package:expense_app/features/Expense/data/sync/customer_sync_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

final syncQueueDataSourceProvider =
    Provider<SyncQueueLocalDataSource>((ref) {
  final databaseHelper = ref.read(databaseHelperProvider);

  return SyncQueueLocalDataSourceImpl(
    databaseHelper,
  );
});

final customerLocalDataSourceProvider =
    Provider<CustomerLocalDataSource>((ref) {
  final databaseHelper = ref.read(databaseHelperProvider);

  return CustomerLocalDatasourceImpl(
    databaseHelper,
  );
});

final customerRemoteDataSourceProvider =
    Provider<CustomerRemoteDataSource>((ref) {
  return const CustomerRemoteDataSourceImpl();
});

final customerSyncHandlerProvider =
    Provider<SyncHandler>((ref) {
  final localDataSource =
      ref.read(customerLocalDataSourceProvider);

  final remoteDataSource =
      ref.read(customerRemoteDataSourceProvider);

  return CustomerSyncHandler(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
});

final syncServiceProvider = Provider<SyncService>((ref) {
  final queue =
      ref.read(syncQueueDataSourceProvider);

  final handlers = <SyncHandler>[
    ref.read(customerSyncHandlerProvider),
  ];

  return SyncService(
    queue: queue,
    handlers: handlers,
  );
});

final syncManagerProvider = Provider<SyncManager>((ref) {
  final syncService = ref.read(syncServiceProvider);

  final connectivity = ref.read(connectivityProvider);

  final manager = SyncManager(
    syncService: syncService,
    connectivity: connectivity,
  );

  ref.onDispose(manager.dispose);

  return manager;
});