import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/activity_log.dart';
import '../../domain/enums/activity_tag.dart';
import '../models/activity_log_hive.dart';

class LogRepository {
  static const _boxName = 'activity_logs';
  static const _uuid = Uuid();

  Future<Box<ActivityLogHive>> _openBox() =>
      Hive.openBox<ActivityLogHive>(_boxName);

  Future<List<ActivityLog>> getAll() async {
    final box = await _openBox();
    return box.values.map(_fromHive).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<ActivityLog> add({
    required ActivityTag tag,
    required String note,
    required int durationMinutes,
    DateTime? timestamp,
  }) async {
    final box = await _openBox();
    final id = _uuid.v4();
    final ts = timestamp ?? DateTime.now();
    final hive = ActivityLogHive(
      id: id,
      timestamp: ts,
      tagIndex: tag.index,
      note: note,
      durationMinutes: durationMinutes,
    );
    await box.put(id, hive);
    return _fromHive(hive);
  }

  Future<void> delete(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  /// 対象のログが既に削除されている場合は null を返す。
  Future<ActivityLog?> update({
    required String id,
    required String note,
    required int durationMinutes,
  }) async {
    final box = await _openBox();
    final existing = box.get(id);
    if (existing == null) {
      return null;
    }
    final updated = ActivityLogHive(
      id: existing.id,
      timestamp: existing.timestamp,
      tagIndex: existing.tagIndex,
      note: note,
      durationMinutes: durationMinutes,
    );
    await box.put(id, updated);
    return _fromHive(updated);
  }

  ActivityLog _fromHive(ActivityLogHive h) => ActivityLog(
        id: h.id,
        timestamp: h.timestamp,
        tag: ActivityTag.values[h.tagIndex],
        note: h.note,
        durationMinutes: h.durationMinutes,
      );
}
