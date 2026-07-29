import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart'; // ignore: unused_import
import '../../../core/constants/achievements_data.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/achievement_providers.dart';
import '../../widgets/icons/app_icon.dart';
import '../../widgets/icons/app_icon_type.dart';
import '../../widgets/rarity_badge.dart';

class AchievementDetailScreen extends ConsumerWidget {
  const AchievementDetailScreen({super.key, required this.achievementId});

  final String achievementId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievement = kAllAchievements.firstWhere((a) => a.id == achievementId);
    final unlockedMap = ref.watch(unlockedAchievementsProvider).valueOrNull;
    final unlocked = unlockedMap?[achievementId];
    final isUnlocked = unlocked != null;
    final progress = ref.watch(achievementProgressProvider(achievementId));
    final rarityColor = AppColors.rarityColor(achievement.rarity);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final title = achievement.titleFor(locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.detailTitle),
        actions: [
          if (isUnlocked)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                Share.share(l10n.shareText(title));
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            AppIcon(
              isUnlocked ? achievement.icon : AppIconType.lock,
              size: 80,
              color: isUnlocked ? rarityColor : AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: rarityColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: rarityColor),
              ),
              child: RarityBadge(rarity: achievement.rarity, color: rarityColor),
            ),
            const SizedBox(height: 16),
            Text(
              (!isUnlocked && achievement.isHidden) ? '???' : title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              (!isUnlocked && achievement.isHidden)
                  ? l10n.hiddenLockedDescription
                  : achievement.descriptionFor(locale),
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (isUnlocked) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: rarityColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: rarityColor.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      l10n.unlockedAtLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.formatUnlockedAt(unlocked.unlockedAt),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: rarityColor,
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (!achievement.isHidden) ...[
              Text(
                l10n.progressLabel,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor:
                      AppColors.textSecondary.withValues(alpha: 0.15),
                  color: rarityColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 13,
                  color: rarityColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
