import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hima_jin/core/constants/achievements_data.dart';
import 'package:hima_jin/domain/entities/achievement.dart';
import 'package:hima_jin/domain/entities/activity_log.dart';
import 'package:hima_jin/domain/enums/activity_tag.dart';
import 'package:hima_jin/presentation/providers/achievement_providers.dart';
import 'package:hima_jin/presentation/providers/log_providers.dart';
import 'package:hima_jin/presentation/screens/home/home_screen.dart';
import 'package:hima_jin/presentation/screens/home/widgets/log_entry_sheet.dart';

import '../../fakes/fake_repositories.dart';
import '../../helpers/pump_app.dart';

Widget _wrap(FakeLogRepository logRepo, FakeAchievementRepository achRepo) {
  return wrapWithProviders(
    const HomeScreen(),
    overrides: [
      logRepositoryProvider.overrideWithValue(logRepo),
      achievementRepositoryProvider.overrideWithValue(achRepo),
    ],
  );
}

/// The 15-tag grid spans more rows than the default 800x600 test surface,
/// so the tag grid's [SliverGrid] only builds what's on-screen unless the
/// viewport is grown to fit every row. Applied to every test here so no
/// test's correctness depends on which tag happens to render first.
void _useTallViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 3000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

/// Every achievement whose condition depends only on the wall-clock hour a
/// log is submitted at (see achievements_data.dart's TimeOfDayCondition
/// entries). The "submit a log" test below can't control the timestamp
/// HomeScreen passes to the repository (it always uses DateTime.now()), so
/// it pre-unlocks all of these alongside 'first_log' to keep the resulting
/// unlocked count deterministic regardless of what time the suite runs.
const _timeOfDayAchievementIds = [
  'first_log',
  'night_owl',
  'early_bird',
  'dawn_logger',
  'morning_logger',
  'afternoon_logger',
  'midnight_logger',
  'hidden_3am',
];

void main() {
  testWidgets('renders a button for every activity tag and the app title',
      (tester) async {
    _useTallViewport(tester);
    await tester.pumpWidget(
        _wrap(FakeLogRepository(), FakeAchievementRepository()));
    await tester.pumpAndSettle();

    expect(find.text('ヒマジン'), findsOneWidget);
    for (final tag in ActivityTag.values) {
      expect(find.text(tag.label), findsOneWidget);
    }
    expect(find.text('0 / $kVisibleAchievementCount'), findsOneWidget);
  });

  testWidgets('tapping a tag opens the log entry sheet', (tester) async {
    _useTallViewport(tester);
    await tester.pumpWidget(
        _wrap(FakeLogRepository(), FakeAchievementRepository()));
    await tester.pumpAndSettle();

    await tester.tap(find.text(ActivityTag.nap.label));
    await tester.pumpAndSettle();

    expect(find.byType(LogEntrySheet), findsOneWidget);
    expect(find.text('どのくらい？'), findsOneWidget);
  });

  testWidgets(
      'submitting a log adds it to the today list without unlocking already-known achievements',
      (tester) async {
    _useTallViewport(tester);
    // Pre-unlock every achievement that could otherwise unlock purely from
    // the real wall-clock hour (see _timeOfDayAchievementIds), so the
    // exact-count assertion below can't flake depending on when this runs.
    final achRepo = FakeAchievementRepository({
      for (final id in _timeOfDayAchievementIds)
        id: UnlockedAchievement(achievementId: id, unlockedAt: DateTime(2025, 1, 1)),
    });
    await tester.pumpWidget(_wrap(FakeLogRepository(), achRepo));
    await tester.pumpAndSettle();

    await tester.tap(find.text(ActivityTag.other.label));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'メモ入力テスト');
    await tester.tap(find.byKey(const Key('log_submit_button')));
    await tester.pumpAndSettle();

    expect(find.text(ActivityTag.other.label), findsNWidgets(2));
    expect(find.text('メモ入力テスト'), findsOneWidget);
    expect(
      find.text('${_timeOfDayAchievementIds.length} / $kVisibleAchievementCount'),
      findsOneWidget,
    );
  });

  testWidgets(
      'tapping a today log opens the edit sheet prefilled and persists the update',
      (tester) async {
    _useTallViewport(tester);
    // Editing a single seeded log re-runs checkAndUnlock; pre-unlock the same
    // wall-clock-dependent achievements (plus first_log) so no unlock banner
    // fires and leaves a pending Timer for pumpAndSettle.
    final achRepo = FakeAchievementRepository({
      for (final id in _timeOfDayAchievementIds)
        id: UnlockedAchievement(achievementId: id, unlockedAt: DateTime(2025, 1, 1)),
    });
    final logRepo = FakeLogRepository([
      ActivityLog(
        id: 'seed',
        timestamp: DateTime.now(),
        tag: ActivityTag.nap,
        note: '編集前メモ',
        durationMinutes: 15,
      ),
    ]);
    await tester.pumpWidget(_wrap(logRepo, achRepo));
    await tester.pumpAndSettle();

    expect(find.text('編集前メモ'), findsOneWidget);

    // Tap the log tile (before the sheet opens '編集前メモ' is unambiguous).
    await tester.tap(find.text('編集前メモ'));
    await tester.pumpAndSettle();

    // The edit sheet opens pre-filled with the existing note and an update label.
    expect(find.byType(LogEntrySheet), findsOneWidget);
    expect(find.text('更新する'), findsOneWidget);
    expect(find.widgetWithText(TextField, '編集前メモ'), findsOneWidget);

    // Rewrite the note and submit.
    await tester.enterText(find.byType(TextField), '編集後メモ');
    await tester.tap(find.byKey(const Key('log_submit_button')));
    await tester.pumpAndSettle();

    // The today list reflects the update, and the old note is gone.
    expect(find.text('編集後メモ'), findsOneWidget);
    expect(find.text('編集前メモ'), findsNothing);
    // Editing only the note preserves the tag and duration through the UI
    // round-trip: the tile still shows the nap label (once in the tag grid,
    // once in the tile) and its original 15-minute duration.
    expect(find.text(ActivityTag.nap.label), findsNWidgets(2));
    expect(find.text('15分'), findsOneWidget);
  });
}
