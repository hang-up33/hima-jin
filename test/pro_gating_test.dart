import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hima_jin/domain/entities/activity_log.dart';
import 'package:hima_jin/domain/enums/activity_tag.dart';
import 'package:hima_jin/presentation/providers/achievement_providers.dart';
import 'package:hima_jin/presentation/providers/log_providers.dart';
import 'package:hima_jin/presentation/providers/purchase_providers.dart';

import 'fakes/fake_repositories.dart';

ActivityLog _log(ActivityTag tag, DateTime ts) => ActivityLog(
      id: '${tag.name}-${ts.millisecondsSinceEpoch}',
      timestamp: ts,
      note: '',
      tag: tag,
      durationMinutes: 0,
    );

ProviderContainer _makeContainer({
  required bool isPro,
  required List<ActivityLog> logs,
}) {
  final container = ProviderContainer(
    overrides: [
      logRepositoryProvider.overrideWithValue(FakeLogRepository(logs)),
      achievementRepositoryProvider
          .overrideWithValue(FakeAchievementRepository()),
      isProProvider.overrideWithValue(AsyncData(isPro)),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('Pro achievement gating', () {
    // 深夜(0〜4時)のログは pro_night_owl の条件を満たす。
    final nightLog = [_log(ActivityTag.nap, DateTime(2025, 6, 15, 2))];

    test('Pro 実績は未加入では解除されない', () async {
      final container = _makeContainer(isPro: false, logs: nightLog);
      await container.read(logNotifierProvider.future);

      final unlocked = await container
          .read(unlockedAchievementsProvider.notifier)
          .checkAndUnlock();

      expect(unlocked.any((a) => a.isPro), isFalse);
      expect(unlocked.any((a) => a.id == 'pro_night_owl'), isFalse);
    });

    test('Pro 加入時は条件を満たした Pro 実績が解除される', () async {
      final container = _makeContainer(isPro: true, logs: nightLog);
      await container.read(logNotifierProvider.future);

      final unlocked = await container
          .read(unlockedAchievementsProvider.notifier)
          .checkAndUnlock();

      expect(unlocked.any((a) => a.id == 'pro_night_owl'), isTrue);
      // pro_supporter は加入した時点で解除される感謝の実績。
      expect(unlocked.any((a) => a.id == 'pro_supporter'), isTrue);
    });

    test('Pro 加入時はログがなくても pro_supporter が解除される', () async {
      final container = _makeContainer(isPro: true, logs: []);
      await container.read(logNotifierProvider.future);

      final unlocked = await container
          .read(unlockedAchievementsProvider.notifier)
          .checkAndUnlock();

      expect(unlocked.any((a) => a.id == 'pro_supporter'), isTrue);
    });
  });
}
