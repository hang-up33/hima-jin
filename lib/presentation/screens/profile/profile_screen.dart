import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/achievements_data.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/enums/activity_tag.dart';
import '../../providers/achievement_providers.dart';
import '../../providers/log_providers.dart';
import '../../providers/purchase_providers.dart';
import '../../widgets/icons/app_icon.dart';
import '../../widgets/icons/app_icon_type.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  String _getTitle(int count) {
    if (count >= 50) return '暇人の神';
    if (count >= 30) return '暇人の王';
    if (count >= 15) return '中級暇人';
    if (count >= 5) return '見習い暇人';
    return '新米暇人';
  }

  int _getLevel(int count) => (count / 5).floor() + 1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(logNotifierProvider).valueOrNull ?? [];
    final unlockedCount = ref.watch(unlockedCountProvider);
    final isPro = ref.watch(isProProvider);
    final totalAchievements = kVisibleAchievementCount;

    final totalMinutes = logs.fold(0, (sum, l) => sum + l.durationMinutes);
    final totalHours = totalMinutes ~/ 60;
    final level = _getLevel(unlockedCount);
    final title = _getTitle(unlockedCount);

    // タグ別集計
    final tagCounts = <ActivityTag, int>{};
    for (final log in logs) {
      tagCounts[log.tag] = (tagCounts[log.tag] ?? 0) + 1;
    }
    final topTags = tagCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // 連続ログイン計算
    int streak = 0;
    if (logs.isNotEmpty) {
      final days = logs
          .map((l) => DateTime(
              l.timestamp.year, l.timestamp.month, l.timestamp.day))
          .toSet()
          .toList()
        ..sort();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      if (days.last == today || days.last == today.subtract(const Duration(days: 1))) {
        streak = 1;
        for (int i = days.length - 1; i > 0; i--) {
          if (days[i].difference(days[i - 1]).inDays == 1) {
            streak++;
          } else {
            break;
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('プロフィール')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _LevelCard(level: level, title: title, unlockedCount: unlockedCount, total: totalAchievements),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _StatCard(label: '連続ログイン', value: '$streak日', icon: AppIconType.fire)),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(label: '総記録件数', value: '${logs.length}件', icon: AppIconType.clipboard)),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(label: '総時間', value: '$totalHours時間', icon: AppIconType.clock)),
              ],
            ),
            const SizedBox(height: 16),
            if (topTags.isNotEmpty)
              _TopTagsCard(topTags: topTags.take(5).toList()),
            const SizedBox(height: 16),
            _ProCard(isPro: isPro),
            const SizedBox(height: 16),
            const _AboutCard(),
          ],
        ),
      ),
    );
  }
}

class _ProCard extends StatelessWidget {
  const _ProCard({required this.isPro});

  final bool isPro;

  @override
  Widget build(BuildContext context) {
    if (isPro) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
          boxShadow: const [
            BoxShadow(color: AppColors.cardShadow, blurRadius: 4)
          ],
        ),
        child: Row(
          children: [
            const AppIcon(AppIconType.crown, size: 28, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ヒマジンPro 加入中',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Pro限定実績 $kProAchievementCount 種が解放されています',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => context.push('/paywall'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.accent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const AppIcon(AppIconType.crown, size: 28, color: AppColors.onPrimary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ヒマジンPro',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onPrimary,
                    ),
                  ),
                  Text(
                    'Pro限定実績 $kProAchievementCount 種を解放しよう',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.onPrimary.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.onPrimary),
          ],
        ),
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 4)
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: const AppIcon(AppIconType.openBook, size: 22, color: AppColors.textSecondary),
        title: const Text(
          'オープンソースライセンス',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: () {
          showLicensePage(
            context: context,
            applicationName: 'ヒマジン',
          );
        },
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.level,
    required this.title,
    required this.unlockedCount,
    required this.total,
  });

  final int level;
  final String title;
  final int unlockedCount;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const AppIcon(AppIconType.trophy, size: 48, color: AppColors.onPrimary),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.onPrimary,
            ),
          ),
          Text(
            'Lv.$level',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.onPrimary.withValues(alpha: 0.85),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: total > 0 ? unlockedCount / total : 0,
              minHeight: 8,
              backgroundColor: AppColors.onPrimary.withValues(alpha: 0.3),
              color: AppColors.onPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '実績 $unlockedCount / $total',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.onPrimary.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final AppIconType icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 4)
        ],
      ),
      child: Column(
        children: [
          AppIcon(icon, size: 24, color: AppColors.primary),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _TopTagsCard extends StatelessWidget {
  const _TopTagsCard({required this.topTags});

  final List<MapEntry<ActivityTag, int>> topTags;

  @override
  Widget build(BuildContext context) {
    final maxCount = topTags.first.value;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 4)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'よくやること TOP5',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...topTags.map((entry) {
            final ratio = entry.value / maxCount;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  AppIcon(entry.key.icon, size: 18, color: AppColors.textPrimary),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 60,
                    child: Text(
                      entry.key.label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: ratio,
                        minHeight: 8,
                        backgroundColor:
                            AppColors.textSecondary.withValues(alpha: 0.15),
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${entry.value}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
