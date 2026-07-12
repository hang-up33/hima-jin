import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hima_jin/domain/enums/activity_tag.dart';
import 'package:hima_jin/presentation/providers/achievement_providers.dart';
import 'package:hima_jin/presentation/providers/log_providers.dart';

import '../../fakes/fake_repositories.dart';

// Noon avoids every TimeOfDayCondition window in achievements_data.dart
// (including the nap-specific 6-12h one, whose end is exclusive), so
// achievements unlocked below are deterministic regardless of when the
// suite actually runs.
final _fixedNow = DateTime(2025, 6, 15, 12, 0);

void main() {
  late FakeLogRepository fakeLogRepo;
  late FakeAchievementRepository fakeAchievementRepo;
  late ProviderContainer container;

  ProviderContainer buildContainer() => ProviderContainer(
        overrides: [
          logRepositoryProvider.overrideWithValue(fakeLogRepo),
          achievementRepositoryProvider.overrideWithValue(fakeAchievementRepo),
        ],
      );

  Future<void> seedNapLogAndLoad() async {
    await fakeLogRepo.add(
      tag: ActivityTag.nap,
      note: '',
      durationMinutes: 0,
      timestamp: _fixedNow,
    );
    await container.read(logNotifierProvider.future);
    await container.read(unlockedAchievementsProvider.future);
  }

  setUp(() {
    fakeLogRepo = FakeLogRepository();
    fakeAchievementRepo = FakeAchievementRepository();
    container = buildContainer();
  });

  tearDown(() => container.dispose());

  test('build loads previously unlocked achievements from the repository',
      () async {
    await fakeAchievementRepo.unlock('first_log');
    container.dispose();
    container = buildContainer();

    final unlocked = await container.read(unlockedAchievementsProvider.future);

    expect(unlocked.keys, contains('first_log'));
  });

  test('checkAndUnlock unlocks achievements whose condition is met, and only those',
      () async {
    await seedNapLogAndLoad();

    final newlyUnlocked =
        await container.read(unlockedAchievementsProvider.notifier).checkAndUnlock();
    final ids = newlyUnlocked.map((a) => a.id).toSet();

    expect(ids, {'first_log', 'first_nap'});
  });

  test('checkAndUnlock does not redundantly re-unlock already-unlocked achievements',
      () async {
    await seedNapLogAndLoad();

    final first =
        await container.read(unlockedAchievementsProvider.notifier).checkAndUnlock();
    final callCountAfterFirst = fakeAchievementRepo.unlockCallCount;

    final second =
        await container.read(unlockedAchievementsProvider.notifier).checkAndUnlock();

    expect(first, isNotEmpty);
    expect(second, isEmpty);
    expect(fakeAchievementRepo.unlockCallCount, callCountAfterFirst);
  });

  test('unlockedCountProvider and unlockedIdSetProvider reflect the unlocked state',
      () async {
    await seedNapLogAndLoad();

    await container.read(unlockedAchievementsProvider.notifier).checkAndUnlock();

    expect(container.read(unlockedCountProvider), 2);
    expect(container.read(unlockedIdSetProvider), {'first_log', 'first_nap'});
  });
}
