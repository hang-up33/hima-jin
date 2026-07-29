import 'package:flutter/widgets.dart';

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
    this.titleEn,
    this.descriptionEn,
    this.isHidden = false,
  });

  final String id;

  /// Japanese title/description. English variants live in [titleEn] /
  /// [descriptionEn]; use [titleFor] / [descriptionFor] to resolve by locale.
  final String title;
  final String description;
  final String? titleEn;
  final String? descriptionEn;
  final AppIconType icon;
  final AchievementRarity rarity;
  final AchievementCondition condition;
  final bool isHidden;

  /// Localized title. Falls back to the Japanese [title] when no English
  /// variant is provided.
  String titleFor(Locale locale) =>
      locale.languageCode == 'ja' ? title : (titleEn ?? title);

  /// Localized description. Falls back to the Japanese [description] when no
  /// English variant is provided.
  String descriptionFor(Locale locale) =>
      locale.languageCode == 'ja' ? description : (descriptionEn ?? description);
}

class UnlockedAchievement {
  const UnlockedAchievement({
    required this.achievementId,
    required this.unlockedAt,
  });

  final String achievementId;
  final DateTime unlockedAt;
}
