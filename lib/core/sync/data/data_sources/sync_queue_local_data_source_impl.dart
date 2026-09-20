import 'package:expense_app/core/database/database_helper.dart';
import 'package:expense_app/core/sync/data/data_sources/sync_queue_local_data_source.dart';
import 'package:expense_app/core/sync/domain/entities/sync_item.dart';
import 'package:expense_app/core/sync/domain/enums/sync_entity_type.dart';
import 'package:expense_app/core/sync/domain/enums/sync_operation.dart';
import 'package:sqflite/sqflite.dart';

class SyncQueueLocalDataSourceImpl
    implements SyncQueueLocalDataSource {
  final DatabaseHelper databaseHelper;

  const SyncQueueLocalDataSourceImpl(
    this.databaseHelper,
  );

  @override
  Future<void> add(SyncItem item) async {
    final db = await databaseHelper.database;

    await db.insert(
      'sync_queue',
      {
        'id': item.id,
        'entity_type': item.entityType.name,
        'entity_id': item.entityId,
        'operation': item.operation.name,
        'created_at': item.createdAt.toIso8601String(),
        'retry_count': item.retryCount,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<SyncItem>> getPending() async {
    final db = await databaseHelper.database;

    final result = await db.query(
      'sync_queue',
      orderBy: 'created_at ASC',
    );

    return result.map((json) {
      return SyncItem(
        id: json['id'] as String,
        entityType: SyncEntityType.values.byName(
          json['entity_type'] as String,
        ),
        entityId: json['entity_id'] as String,
        operation: SyncOperation.values.byName(
          json['operation'] as String,
        ),
        createdAt: DateTime.parse(
          json['created_at'] as String,
        ),
        retryCount: json['retry_count'] as int,
      );
    }).toList();
  }

  @override
  Future<void> remove(String id) async {
    final db = await databaseHelper.database;

    await db.delete(
      'sync_queue',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> incrementRetry(String id) async {
    final db = await databaseHelper.database;

    await db.rawUpdate(
      '''
      UPDATE sync_queue
      SET retry_count = retry_count + 1
      WHERE id = ?
      ''',
      [id],
    );
  }
}