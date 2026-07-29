import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/achievements_data.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/achievement.dart';
import '../../../domain/enums/achievement_rarity.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/achievement_providers.dart';
import '../../widgets/icons/app_icon.dart';
import '../../widgets/icons/app_icon_type.dart';
import 'widgets/achievement_badge.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enriched = ref.watch(enrichedAchievementsProvider);
    final unlockedCount = ref.watch(unlockedCountProvider);
    final total = kVisibleAchievementCount;
    final l10n = AppLocalizations.of(context);

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.achievementsHeader(unlockedCount, total)),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: l10n.tabAll),
              ...AchievementRarity.values.map(
                (rarity) => Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (rarity.isLegendary)
                        AppIcon(
                          AppIconType.crown,
                          size: 14,
                          color: AppColors.rarityColor(rarity),
                        )
                      else
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            rarity.starCount,
                            (_) => AppIcon(
                              AppIconType.star,
                              size: 12,
                              color: AppColors.rarityColor(rarity),
                            ),
                          ),
                        ),
                      const SizedBox(width: 6),
                      Text(rarity.label),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: total > 0 ? unlockedCount / total : 0,
                  minHeight: 6,
                  backgroundColor: AppColors.textSecondary.withValues(alpha: 0.15),
                  color: AppColors.primary,
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _AchievementGrid(enriched: enriched, rarity: null),
                  _AchievementGrid(
                      enriched: enriched, rarity: AchievementRarity.common),
                  _AchievementGrid(
                      enriched: enriched, rarity: AchievementRarity.uncommon),
                  _AchievementGrid(
                      enriched: enriched, rarity: AchievementRarity.rare),
                  _AchievementGrid(
                      enriched: enriched,
                      rarity: AchievementRarity.legendary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementGrid extends StatelessWidget {
  const _AchievementGrid({required this.enriched, required this.rarity});

  final List<({Achievement achievement, UnlockedAchievement? unlocked})> enriched;
  final AchievementRarity? rarity;

  @override
  Widget build(BuildContext context) {
    final filtered = rarity == null
        ? enriched
        : enriched.where((e) => e.achievement.rarity == rarity).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context).emptyAchievements,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        return AchievementBadge(
          achievement: item.achievement,
          unlockedAt: item.unlocked?.unlockedAt,
          onTap: () => context.push('/achievement/${item.achievement.id}'),
        );
      },
    );
  }
}
