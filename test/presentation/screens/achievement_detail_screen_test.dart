import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hima_jin/domain/entities/achievement.dart';
import 'package:hima_jin/presentation/providers/achievement_providers.dart';
import 'package:hima_jin/presentation/providers/log_providers.dart';
import 'package:hima_jin/presentation/screens/detail/achievement_detail_screen.dart';

import '../../fakes/fake_repositories.dart';
import '../../helpers/pump_app.dart';

Widget _wrap(String achievementId, FakeAchievementRepository achRepo) {
  return wrapWithProviders(
    AchievementDetailScreen(achievementId: achievementId),
    overrides: [
      logRepositoryProvider.overrideWithValue(FakeLogRepository()),
      achievementRepositoryProvider.overrideWithValue(achRepo),
    ],
  );
}

void main() {
  testWidgets('locked, non-hidden achievement shows progress and no share button',
      (tester) async {
    await tester.pumpWidget(_wrap('first_walk', FakeAchievementRepository()));
    await tester.pumpAndSettle();

    expect(find.text('散歩デビュー'), findsOneWidget);
    expect(find.text('0%'), findsOneWidget);
    expect(find.byIcon(Icons.share), findsNothing);
  });

  testWidgets('unlocked achievement shows its unlock date and a share button',
      (tester) async {
    final achRepo = FakeAchievementRepository({
      'first_walk': UnlockedAchievement(
        achievementId: 'first_walk',
        unlockedAt: DateTime(2025, 6, 3, 9, 30),
      ),
    });
    await tester.pumpWidget(_wrap('first_walk', achRepo));
    await tester.pumpAndSettle();

    expect(find.text('散歩デビュー'), findsOneWidget);
    expect(find.textContaining('2025年6月3日'), findsOneWidget);
    expect(find.byIcon(Icons.share), findsOneWidget);
  });

  testWidgets('locked, hidden achievement shows "???" and no progress bar',
      (tester) async {
    await tester.pumpWidget(_wrap('hidden_3am', FakeAchievementRepository()));
    await tester.pumpAndSettle();

    expect(find.text('???'), findsOneWidget);
    expect(find.text('解除するまで謎のまま...'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });
}
