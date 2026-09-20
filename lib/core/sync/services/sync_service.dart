import 'package:expense_app/core/sync/data/data_sources/sync_queue_local_data_source.dart';


import '../domain/entities/sync_item.dart';
import '../domain/enums/sync_operation.dart';
import 'sync_handler.dart';

class SyncService {
  final SyncQueueLocalDataSource queue;
  final List<SyncHandler> handlers;

  bool _isSyncing = false;

  SyncService({
    required this.queue,
    required this.handlers,
  });

  Future<void> sync() async {
    if (_isSyncing) {
      return;
    }

    _isSyncing = true;

    try {
      final items = await queue.getPending();

      for (final item in items) {
        await _process(item);
      }
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _process(SyncItem item) async {
    try {
      final handler = _findHandler(item);

      switch (item.operation) {
        case SyncOperation.create:
          await handler.create(item.entityId);
          break;

        case SyncOperation.update:
          await handler.update(item.entityId);
          break;

        case SyncOperation.delete:
          await handler.delete(item.entityId);
          break;
      }

      await queue.remove(item.id);
    } catch (_) {
      await queue.incrementRetry(item.id);
    }
  }

  SyncHandler _findHandler(SyncItem item) {
    return handlers.firstWhere(
      (handler) => handler.entityType == item.entityType,
    );
  }
}