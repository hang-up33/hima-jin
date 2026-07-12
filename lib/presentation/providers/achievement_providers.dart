import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/achievements_data.dart';
import '../../data/repositories/achievement_repository.dart';
import '../../domain/entities/achievement.dart';
import 'log_providers.dart';

final achievementRepositoryProvider =
    Provider<AchievementRepository>((ref) => AchievementRepository());

/// 解除済み実績のID → 日時マップ
class UnlockedAchievementsNotifier
    extends AsyncNotifier<Map<String, UnlockedAchievement>> {
  @override
  Future<Map<String, UnlockedAchievement>> build() async {
    final repo = ref.read(achievementRepositoryProvider);
    final unlocked = await repo.getUnlocked();
    return {for (final u in unlocked) u.achievementId: u};
  }

  Future<List<Achievement>> checkAndUnlock() async {
    final repo = ref.read(achievementRepositoryProvider);
    final logs = ref.read(logNotifierProvider).valueOrNull ?? [];
    final now = DateTime.now();
    final current = state.value ?? {};
    final newlyUnlocked = <Achievement>[];

    for (final achievement in kAllAchievements) {
      if (current.containsKey(achievement.id)) continue;
      if (achievement.condition.evaluate(logs, now)) {
        final unlocked = await repo.unlock(achievement.id);
        current[achievement.id] = unlocked;
        newlyUnlocked.add(achievement);
      }
    }

    if (newlyUnlocked.isNotEmpty) {
      state = AsyncData(Map.from(current));
    }
    return newlyUnlocked;
  }
}

final unlockedAchievementsProvider = AsyncNotifierProvider<
    UnlockedAchievementsNotifier, Map<String, UnlockedAchievement>>(
  UnlockedAchievementsNotifier.new,
);

/// 解除済みIDセット（高速ルックアップ用）
final unlockedIdSetProvider = Provider<Set<String>>((ref) {
  return ref.watch(unlockedAchievementsProvider).valueOrNull?.keys.toSet() ??
      {};
});

typedef EnrichedAchievement = ({Achievement achievement, UnlockedAchievement? unlocked});

/// 全実績 + 解除情報を結合したリスト
final enrichedAchievementsProvider =
    Provider<List<EnrichedAchievement>>((ref) {
  final unlockedMap =
      ref.watch(unlockedAchievementsProvider).valueOrNull ?? {};
  return kAllAchievements.map((a) {
    return (achievement: a, unlocked: unlockedMap[a.id]);
  }).toList();
});

/// 解除済み数
final unlockedCountProvider = Provider<int>((ref) {
  return ref.watch(unlockedIdSetProvider).length;
});

/// 各実績の進捗（0.0〜1.0）
final achievementProgressProvider =
    Provider.family<double, String>((ref, id) {
  final logs = ref.watch(logNotifierProvider).valueOrNull ?? [];
  final achievement = kAllAchievements.firstWhere((a) => a.id == id);
  return achievement.condition.progress(logs, DateTime.now());
});
