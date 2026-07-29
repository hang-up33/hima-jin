import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/achievement.dart';
import '../../../widgets/icons/app_icon.dart';
import '../../../widgets/icons/app_icon_type.dart';

class AchievementBadge extends StatelessWidget {
  const AchievementBadge({
    super.key,
    required this.achievement,
    required this.unlockedAt,
    required this.onTap,
  });

  final Achievement achievement;
  final DateTime? unlockedAt;
  final VoidCallback onTap;

  bool get isUnlocked => unlockedAt != null;
  bool get isHiddenLocked => achievement.isHidden && !isUnlocked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isUnlocked ? AppColors.surface : AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: isUnlocked
              ? Border.all(
                  color: AppColors.rarityColor(achievement.rarity),
                  width: 1.5,
                )
              : null,
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: AppColors.rarityGlow[achievement.rarity]!,
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isHiddenLocked)
              AppIcon(
                AppIconType.lock,
                size: 30,
                color: AppColors.textSecondary,
              )
            else if (!isUnlocked)
              AppIcon(
                achievement.icon,
                size: 30,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              )
            else
              AppIcon(
                achievement.icon,
                size: 30,
                color: AppColors.rarityColor(achievement.rarity),
              ),
            const SizedBox(height: 6),
            Text(
              isHiddenLocked
                  ? '???'
                  : achievement.titleFor(Localizations.localeOf(context)),
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    isUnlocked ? FontWeight.w700 : FontWeight.w400,
                color:
                    isUnlocked ? AppColors.textPrimary : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (isUnlocked && unlockedAt != null) ...[
              const SizedBox(height: 2),
              Text(
                DateFormat('M/d').format(unlockedAt!),
                style: TextStyle(
                  fontSize: 9,
                  color: AppColors.rarityColor(achievement.rarity),
                ),
              ),
            ],
          ],
        ),
      )
          .animate(target: isUnlocked ? 1 : 0)
          .scale(
            begin: const Offset(0.95, 0.95),
            end: const Offset(1.0, 1.0),
          ),
    );
  }
}
