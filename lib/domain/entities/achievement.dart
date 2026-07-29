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
    this.isPro = false,
  });

  final String id;
  final String title;
  final String description;
  final AppIconType icon;
  final AchievementRarity rarity;
  final AchievementCondition condition;
  final bool isHidden;

  /// ヒマジンPro（課金）限定の実績。未加入では解除できずロック表示となる。
  final bool isPro;
}

class UnlockedAchievement {
  const UnlockedAchievement({
    required this.achievementId,
    required this.unlockedAt,
  });

  final String achievementId;
  final DateTime unlockedAt;
}
