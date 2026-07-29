import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/achievements_data.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/activity_log.dart';
import '../../../domain/enums/activity_tag.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/achievement_providers.dart';
import '../../providers/log_providers.dart';
import '../../widgets/icons/app_icon.dart';
import '../../widgets/unlock_banner.dart';
import 'widgets/log_entry_sheet.dart';
import 'widgets/today_log_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  ActivityTag? _selectedTag;

  Future<void> _onTagSelected(ActivityTag tag) async {
    setState(() => _selectedTag = tag);
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LogEntrySheet(
        tag: tag,
        onSubmit: (note, minutes) => _submitAndCheckAchievements(() async {
          await ref.read(logNotifierProvider.notifier).add(
                tag: tag,
                note: note,
                durationMinutes: minutes,
              );
        }),
      ),
    );
    setState(() => _selectedTag = null);
  }

  Future<void> _onEditLog(ActivityLog log) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LogEntrySheet(
        tag: log.tag,
        initialNote: log.note,
        initialDurationMinutes: log.durationMinutes,
        submitLabel: AppLocalizations.of(context).updateButton,
        onSubmit: (note, minutes) => _submitAndCheckAchievements(() async {
          await ref.read(logNotifierProvider.notifier).edit(
                id: log.id,
                note: note,
                durationMinutes: minutes,
              );
        }),
      ),
    );
  }

  /// ログを記録/更新した後、新規実績があればバナーを表示する。
  Future<void> _submitAndCheckAchievements(Future<void> Function() action) async {
    await action();
    if (!mounted) return;
    final newAchievements =
        await ref.read(unlockedAchievementsProvider.notifier).checkAndUnlock();
    if (mounted && newAchievements.isNotEmpty) {
      UnlockBannerOverlay.show(context, newAchievements);
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayLogs = ref.watch(todayLogsProvider);
    final unlockedCount = ref.watch(unlockedCountProvider);
    final totalAchievements = kVisibleAchievementCount;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '$unlockedCount / $totalAchievements',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.homeHeading,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.homeSubtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final tag = ActivityTag.values[index];
                  final isSelected = _selectedTag == tag;
                  return _TagButton(
                    tag: tag,
                    isSelected: isSelected,
                    onTap: () => _onTagSelected(tag),
                  )
                      .animate(delay: (index * 30).ms)
                      .fadeIn(duration: 300.ms)
                      .scale(begin: const Offset(0.8, 0.8));
                },
                childCount: ActivityTag.values.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.1,
              ),
            ),
          ),
          if (todayLogs.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  l10n.homeTodaySection,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              sliver: TodayLogList(logs: todayLogs, onEditLog: _onEditLog),
            ),
          ] else
            const SliverToBoxAdapter(
              child: SizedBox(height: 32),
            ),
        ],
      ),
    );
  }
}

class _TagButton extends StatelessWidget {
  const _TagButton({
    required this.tag,
    required this.isSelected,
    required this.onTap,
  });

  final ActivityTag tag;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(
              tag.icon,
              size: 28,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
            ),
            const SizedBox(height: 6),
            Text(
              tag.labelFor(Localizations.localeOf(context)),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
