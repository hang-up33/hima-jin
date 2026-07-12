import 'package:flutter_test/flutter_test.dart';
import 'package:hima_jin/domain/conditions/achievement_condition.dart';
import 'package:hima_jin/domain/entities/activity_log.dart';
import 'package:hima_jin/domain/enums/activity_tag.dart';

ActivityLog _log(ActivityTag tag, DateTime ts, {int minutes = 0}) =>
    ActivityLog(
      id: '${tag.name}-${ts.millisecondsSinceEpoch}',
      timestamp: ts,
      note: '',
      tag: tag,
      durationMinutes: minutes,
    );

final now = DateTime(2025, 6, 15, 12, 0);

void main() {
  group('SameDayTagCountCondition', () {
    test('counts only same tag on same day', () {
      final logs = [
        _log(ActivityTag.nap, DateTime(2025, 6, 15, 9)),
        _log(ActivityTag.nap, DateTime(2025, 6, 15, 14)),
        _log(ActivityTag.nap, DateTime(2025, 6, 16, 10)), // different day
      ];
      final cond = const SameDayTagCountCondition(ActivityTag.nap, 2);
      expect(cond.evaluate(logs, now), isTrue);
    });

    test('false when count split across days', () {
      final logs = [
        _log(ActivityTag.nap, DateTime(2025, 6, 15, 9)),
        _log(ActivityTag.nap, DateTime(2025, 6, 16, 9)),
      ];
      final cond = const SameDayTagCountCondition(ActivityTag.nap, 2);
      expect(cond.evaluate(logs, now), isFalse);
    });

    test('progress uses best day', () {
      final logs = [
        _log(ActivityTag.nap, DateTime(2025, 6, 15, 9)),
        _log(ActivityTag.nap, DateTime(2025, 6, 15, 14)),
        _log(ActivityTag.nap, DateTime(2025, 6, 16, 10)),
      ];
      final cond = const SameDayTagCountCondition(ActivityTag.nap, 3);
      expect(cond.progress(logs, now), closeTo(2 / 3, 0.001));
    });
  });

  group('SameDayCombinationCondition', () {
    test('true when all tags present on same day', () {
      final logs = [
        _log(ActivityTag.nap, DateTime(2025, 6, 15, 9)),
        _log(ActivityTag.walk, DateTime(2025, 6, 15, 10)),
        _log(ActivityTag.tv, DateTime(2025, 6, 15, 20)),
      ];
      final cond = const SameDayCombinationCondition(
          [ActivityTag.nap, ActivityTag.walk, ActivityTag.tv]);
      expect(cond.evaluate(logs, now), isTrue);
    });

    test('false when tags split across days', () {
      final logs = [
        _log(ActivityTag.nap, DateTime(2025, 6, 15, 9)),
        _log(ActivityTag.walk, DateTime(2025, 6, 15, 10)),
        _log(ActivityTag.tv, DateTime(2025, 6, 16, 20)), // different day
      ];
      final cond = const SameDayCombinationCondition(
          [ActivityTag.nap, ActivityTag.walk, ActivityTag.tv]);
      expect(cond.evaluate(logs, now), isFalse);
    });

    test('progress reflects best day partial match', () {
      final logs = [
        _log(ActivityTag.nap, DateTime(2025, 6, 15, 9)),
        _log(ActivityTag.walk, DateTime(2025, 6, 15, 10)),
      ];
      final cond = const SameDayCombinationCondition(
          [ActivityTag.nap, ActivityTag.walk, ActivityTag.tv]);
      expect(cond.progress(logs, now), closeTo(2 / 3, 0.001));
    });

    test('empty logs return false and 0 progress', () {
      final cond = const SameDayCombinationCondition(
          [ActivityTag.nap, ActivityTag.walk]);
      expect(cond.evaluate([], now), isFalse);
      expect(cond.progress([], now), equals(0.0));
    });
  });

  group('MinTagVarietyCondition', () {
    test('true when enough unique tags', () {
      final logs = [
        _log(ActivityTag.nap, now),
        _log(ActivityTag.walk, now),
        _log(ActivityTag.nap, now), // duplicate, doesn't count
        _log(ActivityTag.tv, now),
      ];
      expect(
          const MinTagVarietyCondition(3).evaluate(logs, now), isTrue);
      expect(
          const MinTagVarietyCondition(4).evaluate(logs, now), isFalse);
    });

    test('progress proportional to unique tags', () {
      final logs = [
        _log(ActivityTag.nap, now),
        _log(ActivityTag.walk, now),
      ];
      expect(
          const MinTagVarietyCondition(4).progress(logs, now),
          closeTo(0.5, 0.001));
    });
  });

  group('AllTagsCondition', () {
    test('false until all tags used', () {
      final logs = ActivityTag.values
          .take(ActivityTag.values.length - 1)
          .map((t) => _log(t, now))
          .toList();
      expect(const AllTagsCondition().evaluate(logs, now), isFalse);
    });

    test('true when all tags present', () {
      final logs =
          ActivityTag.values.map((t) => _log(t, now)).toList();
      expect(const AllTagsCondition().evaluate(logs, now), isTrue);
    });
  });

  group('TimeOfDayCondition', () {
    test('false when logs empty', () {
      final cond = const TimeOfDayCondition(startHour: 0, endHour: 6);
      expect(cond.evaluate([], now), isFalse);
    });

    test('true when log is in range', () {
      final logs = [_log(ActivityTag.nap, DateTime(2025, 6, 15, 2))];
      final cond = const TimeOfDayCondition(startHour: 0, endHour: 6);
      expect(cond.evaluate(logs, now), isTrue);
    });

    test('false when log is out of range', () {
      final logs = [_log(ActivityTag.nap, DateTime(2025, 6, 15, 10))];
      final cond = const TimeOfDayCondition(startHour: 0, endHour: 6);
      expect(cond.evaluate(logs, now), isFalse);
    });
  });

  group('AndCondition', () {
    test('progress uses minimum of sub-conditions', () {
      final logs = [
        _log(ActivityTag.nap, now),
        _log(ActivityTag.nap, now),
        _log(ActivityTag.nap, now),
      ];
      // TagCount(nap,3)=100%, TagCount(walk,1)=0%
      final cond = const AndCondition([
        TagCountCondition(ActivityTag.nap, 3),
        TagCountCondition(ActivityTag.walk, 1),
      ]);
      expect(cond.progress(logs, now), equals(0.0));
    });
  });

  group('ConsecutiveDaysCondition', () {
    test('counts max streak correctly', () {
      final logs = [
        _log(ActivityTag.nap, DateTime(2025, 6, 1)),
        _log(ActivityTag.nap, DateTime(2025, 6, 2)),
        _log(ActivityTag.nap, DateTime(2025, 6, 3)),
        _log(ActivityTag.nap, DateTime(2025, 6, 5)), // gap
        _log(ActivityTag.nap, DateTime(2025, 6, 6)),
      ];
      expect(const ConsecutiveDaysCondition(3).evaluate(logs, now), isTrue);
      expect(const ConsecutiveDaysCondition(4).evaluate(logs, now), isFalse);
    });
  });
}
