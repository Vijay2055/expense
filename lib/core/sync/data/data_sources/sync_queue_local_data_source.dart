import 'package:expense_app/core/sync/domain/entities/sync_item.dart';

abstract class SyncQueueLocalDataSource {
  Future<void> add(SyncItem item);

  Future<List<SyncItem>> getPending();

  Future<void> remove(String id);

  Future<void> incrementRetry(String id);
}