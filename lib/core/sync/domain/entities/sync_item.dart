import 'package:expense_app/core/sync/domain/enums/sync_entity_type.dart';
import 'package:expense_app/core/sync/domain/enums/sync_operation.dart';

class SyncItem {
  final String id;
  final SyncEntityType entityType;
  final String entityId;
  final SyncOperation operation;
  final DateTime createdAt;
  final int retryCount;

  const SyncItem({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.createdAt,
    this.retryCount = 0,
  });
}