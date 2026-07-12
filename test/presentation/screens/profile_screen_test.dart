import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hima_jin/domain/entities/achievement.dart';
import 'package:hima_jin/domain/entities/activity_log.dart';
import 'package:hima_jin/domain/enums/activity_tag.dart';
import 'package:hima_jin/presentation/providers/achievement_providers.dart';
import 'package:hima_jin/presentation/providers/log_providers.dart';
import 'package:hima_jin/presentation/screens/profile/profile_screen.dart';

import '../../fakes/fake_repositories.dart';
import '../../helpers/activity_log_factory.dart';
import '../../helpers/pump_app.dart';

FakeAchievementRepository _achWithCount(int count) => FakeAchievementRepository({
      for (var i = 0; i < count; i++)
        'dummy_$i': UnlockedAchievement(
          achievementId: 'dummy_$i',
          unlockedAt: DateTime(2025, 1, 1),
        ),
    });

Widget _wrap({List<ActivityLog> logs = const [], int unlockedCount = 0}) {
  return wrapWithProviders(
    const ProfileScreen(),
    overrides: [
      logRepositoryProvider.overrideWithValue(FakeLogRepository(logs)),
      achievementRepositoryProvider
          .overrideWithValue(_achWithCount(unlockedCount)),
    ],
  );
}

void main() {
  testWidgets('a brand-new profile shows level 1 and 新米暇人', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    expect(find.text('新米暇人'), findsOneWidget);
    expect(find.text('Lv.1'), findsOneWidget);
    expect(find.text('連続ログイン'), findsOneWidget);
    expect(find.text('0日'), findsOneWidget);
  });

  testWidgets('5 unlocked achievements shows 見習い暇人 at level 2',
      (tester) async {
    await tester.pumpWidget(_wrap(unlockedCount: 5));
    await tester.pumpAndSettle();

    expect(find.text('見習い暇人'), findsOneWidget);
    expect(find.text('Lv.2'), findsOneWidget);
  });

  testWidgets('15 unlocked achievements shows 中級暇人 at level 4',
      (tester) async {
    await tester.pumpWidget(_wrap(unlockedCount: 15));
    await tester.pumpAndSettle();

    expect(find.text('中級暇人'), findsOneWidget);
    expect(find.text('Lv.4'), findsOneWidget);
  });

  testWidgets('50 unlocked achievements shows 暇人の神 at level 11',
      (tester) async {
    await tester.pumpWidget(_wrap(unlockedCount: 50));
    await tester.pumpAndSettle();

    expect(find.text('暇人の神'), findsOneWidget);
    expect(find.text('Lv.11'), findsOneWidget);
  });

  testWidgets('streak counts consecutive days ending today', (tester) async {
    final now = DateTime.now();
    final logs = [
      buildLog(ActivityTag.nap, now),
      buildLog(ActivityTag.nap, now.subtract(const Duration(days: 1))),
      buildLog(ActivityTag.nap, now.subtract(const Duration(days: 2))),
    ];

    await tester.pumpWidget(_wrap(logs: logs));
    await tester.pumpAndSettle();

    expect(find.text('3日'), findsOneWidget);
  });

  testWidgets('a gap further back does not break a streak anchored on today',
      (tester) async {
    final now = DateTime.now();
    final logs = [
      buildLog(ActivityTag.nap, now),
      buildLog(ActivityTag.nap, now.subtract(const Duration(days: 3))),
    ];

    await tester.pumpWidget(_wrap(logs: logs));
    await tester.pumpAndSettle();

    expect(find.text('1日'), findsOneWidget);
  });

  testWidgets('streak resets to 0 when the last log is older than yesterday',
      (tester) async {
    final now = DateTime.now();
    final logs = [buildLog(ActivityTag.nap, now.subtract(const Duration(days: 3)))];

    await tester.pumpWidget(_wrap(logs: logs));
    await tester.pumpAndSettle();

    expect(find.text('0日'), findsOneWidget);
  });

  testWidgets('total hours and top tags reflect the logged activity',
      (tester) async {
    final now = DateTime.now();
    final logs = [
      buildLog(ActivityTag.nap, now, minutes: 65),
      buildLog(ActivityTag.nap, now, minutes: 60),
      buildLog(ActivityTag.walk, now, minutes: 0),
    ];

    await tester.pumpWidget(_wrap(logs: logs));
    await tester.pumpAndSettle();

    expect(find.text('3件'), findsOneWidget);
    expect(find.text('2時間'), findsOneWidget);
    expect(find.text('よくやること TOP5'), findsOneWidget);
    expect(find.text(ActivityTag.nap.label), findsOneWidget);
    expect(find.text(ActivityTag.walk.label), findsOneWidget);
  });

  testWidgets('the OSS license entry is always shown', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    expect(find.text('オープンソースライセンス'), findsOneWidget);
  });
}
