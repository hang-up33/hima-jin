import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hima_jin/core/constants/achievements_data.dart';
import 'package:hima_jin/core/router/app_router.dart';
import 'package:hima_jin/domain/entities/achievement.dart';
import 'package:hima_jin/domain/enums/achievement_rarity.dart';
import 'package:hima_jin/presentation/providers/achievement_providers.dart';
import 'package:hima_jin/presentation/providers/log_providers.dart';
import 'package:hima_jin/presentation/screens/achievements/widgets/achievement_badge.dart';

import '../../fakes/fake_repositories.dart';
import '../../helpers/pump_app.dart';

Widget _wrap(FakeAchievementRepository achRepo) {
  // Reuses the app's real router/route table instead of a hand-rolled
  // duplicate, so a change to the production route paths breaks this test
  // instead of silently going unnoticed.
  return wrapWithProvidersAndRouter(
    appRouter,
    overrides: [
      // achievement_detail_screen's progress provider also reads
      // logNotifierProvider, so this must be faked even though this
      // screen itself never touches logs.
      logRepositoryProvider.overrideWithValue(FakeLogRepository()),
      achievementRepositoryProvider.overrideWithValue(achRepo),
    ],
  );
}

/// appRouter is a shared top-level singleton (built once for the whole
/// test process), so its navigation state would otherwise leak between
/// tests in this file depending on run order. Forcing it back to the
/// achievements tab on every pump keeps each test's starting point fixed.
Future<void> _pumpAchievementsScreen(
  WidgetTester tester,
  FakeAchievementRepository achRepo,
) async {
  await tester.pumpWidget(_wrap(achRepo));
  appRouter.go('/achievements');
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('renders すべて and one tab per rarity', (tester) async {
    await _pumpAchievementsScreen(tester, FakeAchievementRepository());

    expect(find.text('すべて'), findsOneWidget);
    for (final rarity in AchievementRarity.values) {
      expect(find.text(rarity.label), findsOneWidget);
    }
  });

  testWidgets('header shows unlocked count over total', (tester) async {
    final achRepo = FakeAchievementRepository({
      'first_log': UnlockedAchievement(
          achievementId: 'first_log', unlockedAt: DateTime(2025, 1, 1)),
      'first_nap': UnlockedAchievement(
          achievementId: 'first_nap', unlockedAt: DateTime(2025, 1, 1)),
    });
    await _pumpAchievementsScreen(tester, achRepo);

    expect(find.text('実績 2 / $kVisibleAchievementCount'), findsOneWidget);
  });

  testWidgets(
      'switching to the Legendary tab filters out non-legendary achievements',
      (tester) async {
    await _pumpAchievementsScreen(tester, FakeAchievementRepository());

    // first_log is common-rarity and visible on the default 'すべて' tab.
    expect(find.text('暇人への第一歩'), findsOneWidget);

    await tester.tap(find.text(AchievementRarity.legendary.label));
    await tester.pumpAndSettle();

    expect(find.text('暇人への第一歩'), findsNothing);
  });

  testWidgets(
      'tapping the first achievement badge navigates to its detail screen',
      (tester) async {
    await _pumpAchievementsScreen(tester, FakeAchievementRepository());

    await tester.tap(find.byType(AchievementBadge).first);
    await tester.pumpAndSettle();

    expect(find.text('実績詳細'), findsOneWidget);
    expect(find.text('暇人への第一歩'), findsOneWidget);
  });
}
