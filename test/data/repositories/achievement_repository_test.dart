import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hima_jin/data/models/unlocked_achievement_hive.dart';
import 'package:hima_jin/data/repositories/achievement_repository.dart';

void main() {
  late Directory tempDir;
  late AchievementRepository repo;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hima_jin_test_');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UnlockedAchievementHiveAdapter());
    }
    repo = AchievementRepository();
  });

  tearDown(() async {
    try {
      await Hive.close();
    } finally {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    }
  });

  test('unlock persists an entry and returns it', () async {
    final unlocked = await repo.unlock('first_log');

    expect(unlocked.achievementId, 'first_log');
    expect(unlocked.unlockedAt, isNotNull);
  });

  test('isUnlocked is false before unlocking and true after', () async {
    expect(await repo.isUnlocked('first_log'), isFalse);

    await repo.unlock('first_log');

    expect(await repo.isUnlocked('first_log'), isTrue);
  });

  test('getUnlocked lists every unlocked achievement', () async {
    await repo.unlock('first_log');
    await repo.unlock('first_nap');

    final unlocked = await repo.getUnlocked();

    expect(unlocked.map((u) => u.achievementId).toSet(),
        {'first_log', 'first_nap'});
  });

  test('unlocking the same id twice overwrites rather than duplicates',
      () async {
    await repo.unlock('first_log');
    await repo.unlock('first_log');

    final unlocked = await repo.getUnlocked();
    expect(unlocked.where((u) => u.achievementId == 'first_log'), hasLength(1));
  });

  test('getUnlocked on an empty box returns an empty list', () async {
    expect(await repo.getUnlocked(), isEmpty);
  });

  test('data persists across a Hive close/reopen cycle', () async {
    await repo.unlock('first_log');
    await Hive.close();

    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UnlockedAchievementHiveAdapter());
    }
    final reopened = AchievementRepository();

    expect(await reopened.isUnlocked('first_log'), isTrue);
  });
}
