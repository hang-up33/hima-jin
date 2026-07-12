import 'package:hive/hive.dart';

part 'unlocked_achievement_hive.g.dart';

@HiveType(typeId: 1)
class UnlockedAchievementHive extends HiveObject {
  @HiveField(0)
  final String achievementId;

  @HiveField(1)
  final DateTime unlockedAt;

  UnlockedAchievementHive({
    required this.achievementId,
    required this.unlockedAt,
  });
}
