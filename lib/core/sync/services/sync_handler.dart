import 'package:expense_app/core/sync/domain/enums/sync_entity_type.dart';

abstract class SyncHandler {
  SyncEntityType get entityType;

  Future<void> create(String entityId);

  Future<void> update(String entityId);

  Future<void> delete(String entityId);
}