import '../../presentation/widgets/icons/app_icon_type.dart';
import '../enums/achievement_rarity.dart';
import '../conditions/achievement_condition.dart';

class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.rarity,
    required this.condition,
    this.isHidden = false,
  });

  final String id;
  final String title;
  final String description;
  final AppIconType icon;
  final AchievementRarity rarity;
  final AchievementCondition condition;
  final bool isHidden;
}

class UnlockedAchievement {
  const UnlockedAchievement({
    required this.achievementId,
    required this.unlockedAt,
  });

  final String achievementId;
  final DateTime unlockedAt;
}
