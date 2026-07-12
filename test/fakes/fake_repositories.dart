import 'package:hima_jin/data/repositories/achievement_repository.dart';
import 'package:hima_jin/data/repositories/log_repository.dart';
import 'package:hima_jin/domain/entities/achievement.dart';
import 'package:hima_jin/domain/entities/activity_log.dart';
import 'package:hima_jin/domain/enums/activity_tag.dart';
import 'package:uuid/uuid.dart';

/// In-memory stand-in for [LogRepository], for provider/widget tests that
/// shouldn't need real Hive I/O. Overrides every method so no Hive box is
/// ever opened.
class FakeLogRepository extends LogRepository {
  FakeLogRepository([List<ActivityLog>? initial])
      : _logs = List.of(initial ?? []);

  final List<ActivityLog> _logs;
  static const _uuid = Uuid();

  @override
  Future<List<ActivityLog>> getAll() async {
    final sorted = List<ActivityLog>.of(_logs)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted;
  }

  @override
  Future<ActivityLog> add({
    required ActivityTag tag,
    required String note,
    required int durationMinutes,
    DateTime? timestamp,
  }) async {
    final log = ActivityLog(
      id: _uuid.v4(),
      timestamp: timestamp ?? DateTime.now(),
      tag: tag,
      note: note,
      durationMinutes: durationMinutes,
    );
    _logs.add(log);
    return log;
  }

  @override
  Future<void> delete(String id) async {
    _logs.removeWhere((l) => l.id == id);
  }

  @override
  Future<ActivityLog?> update({
    required String id,
    required String note,
    required int durationMinutes,
  }) async {
    final index = _logs.indexWhere((l) => l.id == id);
    if (index < 0) return null;
    final existing = _logs[index];
    final updated = ActivityLog(
      id: existing.id,
      timestamp: existing.timestamp,
      tag: existing.tag,
      note: note,
      durationMinutes: durationMinutes,
    );
    _logs[index] = updated;
    return updated;
  }
}

/// In-memory stand-in for [AchievementRepository]. Tracks [unlockCallCount]
/// so tests can assert `checkAndUnlock()` doesn't redundantly re-unlock
/// already-unlocked achievements.
class FakeAchievementRepository extends AchievementRepository {
  FakeAchievementRepository([Map<String, UnlockedAchievement>? initial])
      : _unlocked = Map.of(initial ?? {});

  final Map<String, UnlockedAchievement> _unlocked;
  int unlockCallCount = 0;

  @override
  Future<List<UnlockedAchievement>> getUnlocked() async =>
      _unlocked.values.toList();

  @override
  Future<UnlockedAchievement> unlock(String achievementId) async {
    unlockCallCount++;
    final unlocked = UnlockedAchievement(
      achievementId: achievementId,
      unlockedAt: DateTime.now(),
    );
    _unlocked[achievementId] = unlocked;
    return unlocked;
  }

  @override
  Future<bool> isUnlocked(String achievementId) async =>
      _unlocked.containsKey(achievementId);
}
