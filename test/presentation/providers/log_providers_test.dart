import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hima_jin/domain/entities/activity_log.dart';
import 'package:hima_jin/domain/enums/activity_tag.dart';
import 'package:hima_jin/presentation/providers/log_providers.dart';

import '../../fakes/fake_repositories.dart';

void main() {
  late FakeLogRepository fakeRepo;
  late ProviderContainer container;

  ProviderContainer buildContainer(FakeLogRepository repo) =>
      ProviderContainer(
        overrides: [logRepositoryProvider.overrideWithValue(repo)],
      );

  setUp(() {
    fakeRepo = FakeLogRepository();
    container = buildContainer(fakeRepo);
  });

  tearDown(() => container.dispose());

  test('build loads existing logs from the repository', () async {
    await fakeRepo.add(
        tag: ActivityTag.nap, note: 'seeded', durationMinutes: 10);
    container.dispose();
    container = buildContainer(fakeRepo);

    final logs = await container.read(logNotifierProvider.future);

    expect(logs, hasLength(1));
    expect(logs.single.note, 'seeded');
  });

  test('add appends a new log and updates state', () async {
    await container.read(logNotifierProvider.future);

    final log = await container.read(logNotifierProvider.notifier).add(
          tag: ActivityTag.walk,
          note: 'hi',
          durationMinutes: 15,
        );

    final state = container.read(logNotifierProvider).value!;
    expect(state, contains(log));
    expect(state.first.id, log.id);
  });

  test('delete removes a log from state', () async {
    await container.read(logNotifierProvider.future);
    final log = await container.read(logNotifierProvider.notifier).add(
          tag: ActivityTag.walk,
          note: 'hi',
          durationMinutes: 15,
        );

    await container.read(logNotifierProvider.notifier).delete(log.id);

    final state = container.read(logNotifierProvider).value!;
    expect(state, isNot(contains(log)));
  });

  test('edit updates a log note and duration in state', () async {
    await container.read(logNotifierProvider.future);
    final log = await container.read(logNotifierProvider.notifier).add(
          tag: ActivityTag.walk,
          note: 'before',
          durationMinutes: 5,
        );

    await container.read(logNotifierProvider.notifier).edit(
          id: log.id,
          note: 'after',
          durationMinutes: 20,
        );

    final state = container.read(logNotifierProvider).value!;
    final edited = state.firstWhere((l) => l.id == log.id);
    expect(edited.note, 'after');
    expect(edited.durationMinutes, 20);
    expect(edited.tag, ActivityTag.walk);
  });

  test('edit of an unknown id leaves state unchanged', () async {
    await container.read(logNotifierProvider.future);
    final log = await container.read(logNotifierProvider.notifier).add(
          tag: ActivityTag.nap,
          note: 'keep',
          durationMinutes: 0,
        );

    await container.read(logNotifierProvider.notifier).edit(
          id: 'does-not-exist',
          note: 'ignored',
          durationMinutes: 99,
        );

    final state = container.read(logNotifierProvider).value!;
    expect(state, hasLength(1));
    expect(state.single.id, log.id);
    expect(state.single.note, 'keep');
  });

  test('todayLogsProvider only includes logs from today', () async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    fakeRepo = FakeLogRepository([
      ActivityLog(
        id: 'today',
        timestamp: now,
        tag: ActivityTag.nap,
        note: '',
        durationMinutes: 0,
      ),
      ActivityLog(
        id: 'yesterday',
        timestamp: yesterday,
        tag: ActivityTag.walk,
        note: '',
        durationMinutes: 0,
      ),
    ]);
    container.dispose();
    container = buildContainer(fakeRepo);
    await container.read(logNotifierProvider.future);

    final todayLogs = container.read(todayLogsProvider);

    expect(todayLogs.map((l) => l.id), ['today']);
  });
}
