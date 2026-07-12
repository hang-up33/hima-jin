import 'package:flutter_test/flutter_test.dart';
import 'package:hima_jin/app.dart';
import 'package:hima_jin/presentation/providers/achievement_providers.dart';
import 'package:hima_jin/presentation/providers/log_providers.dart';

import 'fakes/fake_repositories.dart';
import 'helpers/pump_app.dart';

void main() {
  testWidgets('the app builds, renders the home screen and its nav bar',
      (tester) async {
    await tester.pumpWidget(
      wrapWithProviderScope(
        const HimaJinApp(),
        overrides: [
          logRepositoryProvider.overrideWithValue(FakeLogRepository()),
          achievementRepositoryProvider
              .overrideWithValue(FakeAchievementRepository()),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ヒマジン'), findsOneWidget);
    expect(find.text('ホーム'), findsOneWidget);
    expect(find.text('実績'), findsOneWidget);
    expect(find.text('プロフィール'), findsOneWidget);
  });
}
