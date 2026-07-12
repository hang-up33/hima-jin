import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/achievement.dart';
import '../models/unlocked_achievement_hive.dart';

class AchievementRepository {
  static const _boxName = 'unlocked_achievements';

  Future<Box<UnlockedAchievementHive>> _openBox() =>
      Hive.openBox<UnlockedAchievementHive>(_boxName);

  Future<List<UnlockedAchievement>> getUnlocked() async {
    final box = await _openBox();
    return box.values
        .map((h) => UnlockedAchievement(
              achievementId: h.achievementId,
              unlockedAt: h.unlockedAt,
            ))
        .toList();
  }

  Future<UnlockedAchievement> unlock(String achievementId) async {
    final box = await _openBox();
    final now = DateTime.now();
    await box.put(
      achievementId,
      UnlockedAchievementHive(
        achievementId: achievementId,
        unlockedAt: now,
      ),
    );
    return UnlockedAchievement(
      achievementId: achievementId,
      unlockedAt: now,
    );
  }

  Future<bool> isUnlocked(String achievementId) async {
    final box = await _openBox();
    return box.containsKey(achievementId);
  }
}
