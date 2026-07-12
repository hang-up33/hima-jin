import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hima_jin/data/models/activity_log_hive.dart';
import 'package:hima_jin/data/repositories/log_repository.dart';
import 'package:hima_jin/domain/enums/activity_tag.dart';

void main() {
  late Directory tempDir;
  late LogRepository repo;

  void initHive(Directory dir) {
    Hive.init(dir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ActivityLogHiveAdapter());
    }
  }

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hima_jin_test_');
    initHive(tempDir);
    repo = LogRepository();
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

  test('add persists and returns an entity with the given fields', () async {
    final log = await repo.add(
      tag: ActivityTag.nap,
      note: 'zzz',
      durationMinutes: 30,
    );

    expect(log.tag, ActivityTag.nap);
    expect(log.note, 'zzz');
    expect(log.durationMinutes, 30);
    expect(log.id, isNotEmpty);
  });

  test('add uses the given timestamp when provided', () async {
    final ts = DateTime(2025, 3, 10, 8);
    final log = await repo.add(
      tag: ActivityTag.read,
      note: '',
      durationMinutes: 0,
      timestamp: ts,
    );

    expect(log.timestamp, ts);
  });

  test('getAll returns entries sorted newest-first', () async {
    await repo.add(
      tag: ActivityTag.nap,
      note: 'first',
      durationMinutes: 0,
      timestamp: DateTime(2025, 1, 1),
    );
    await repo.add(
      tag: ActivityTag.walk,
      note: 'second',
      durationMinutes: 0,
      timestamp: DateTime(2025, 1, 3),
    );
    await repo.add(
      tag: ActivityTag.tv,
      note: 'third',
      durationMinutes: 0,
      timestamp: DateTime(2025, 1, 2),
    );

    final all = await repo.getAll();

    expect(all.map((l) => l.note).toList(), ['second', 'third', 'first']);
  });

  test('delete removes the entry with the matching id', () async {
    final log = await repo.add(
      tag: ActivityTag.nap,
      note: '',
      durationMinutes: 0,
    );
    await repo.add(tag: ActivityTag.walk, note: 'keep', durationMinutes: 0);

    await repo.delete(log.id);

    final all = await repo.getAll();
    expect(all, hasLength(1));
    expect(all.single.note, 'keep');
  });

  test('delete of an unknown id is a no-op', () async {
    await repo.add(tag: ActivityTag.nap, note: '', durationMinutes: 0);

    await repo.delete('does-not-exist');

    final all = await repo.getAll();
    expect(all, hasLength(1));
  });

  test('getAll on an empty box returns an empty list', () async {
    final all = await repo.getAll();
    expect(all, isEmpty);
  });

  test('data persists across a Hive close/reopen cycle', () async {
    await repo.add(
      tag: ActivityTag.read,
      note: 'persisted',
      durationMinutes: 45,
    );
    await Hive.close();

    initHive(tempDir);
    final reopened = LogRepository();

    final all = await reopened.getAll();
    expect(all, hasLength(1));
    expect(all.single.note, 'persisted');
    expect(all.single.durationMinutes, 45);
  });

  test('update rewrites note and duration and persists them', () async {
    final original = await repo.add(
      tag: ActivityTag.read,
      note: 'before',
      durationMinutes: 10,
    );

    final updated = await repo.update(
      id: original.id,
      note: 'after',
      durationMinutes: 25,
    );

    expect(updated, isNotNull);
    expect(updated!.id, original.id);
    expect(updated.note, 'after');
    expect(updated.durationMinutes, 25);

    // 永続化されていること(getAll経由でも反映)
    final all = await repo.getAll();
    expect(all, hasLength(1));
    expect(all.single.note, 'after');
    expect(all.single.durationMinutes, 25);
  });

  test('update preserves the original timestamp and tag', () async {
    final ts = DateTime(2025, 5, 20, 9, 30);
    final original = await repo.add(
      tag: ActivityTag.walk,
      note: 'walk',
      durationMinutes: 15,
      timestamp: ts,
    );

    final updated = await repo.update(
      id: original.id,
      note: 'edited',
      durationMinutes: 40,
    );

    expect(updated!.tag, ActivityTag.walk);
    expect(updated.timestamp, ts);
  });

  test('update returns null for an unknown id without throwing', () async {
    await repo.add(tag: ActivityTag.nap, note: 'keep', durationMinutes: 0);

    final result = await repo.update(
      id: 'does-not-exist',
      note: 'ignored',
      durationMinutes: 99,
    );

    expect(result, isNull);

    // 既存データは書き換わっていないこと
    final all = await repo.getAll();
    expect(all, hasLength(1));
    expect(all.single.note, 'keep');
  });
}
