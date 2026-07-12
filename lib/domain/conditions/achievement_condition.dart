import '../entities/activity_log.dart';
import '../enums/activity_tag.dart';

String _dayKey(DateTime dt) => '${dt.year}-${dt.month}-${dt.day}';

Map<String, List<ActivityLog>> _groupByDay(List<ActivityLog> logs) {
  final result = <String, List<ActivityLog>>{};
  for (final l in logs) {
    result.putIfAbsent(_dayKey(l.timestamp), () => []).add(l);
  }
  return result;
}

Set<ActivityTag> _usedTags(List<ActivityLog> logs) =>
    logs.map((l) => l.tag).toSet();

sealed class AchievementCondition {
  const AchievementCondition();
  bool evaluate(List<ActivityLog> logs, DateTime now);
  double progress(List<ActivityLog> logs, DateTime now);
}

/// 初回ログ
class FirstLogCondition extends AchievementCondition {
  const FirstLogCondition();

  @override
  bool evaluate(List<ActivityLog> logs, DateTime now) => logs.isNotEmpty;

  @override
  double progress(List<ActivityLog> logs, DateTime now) =>
      logs.isNotEmpty ? 1.0 : 0.0;
}

/// 特定タグの初回ログ
class FirstTagCondition extends AchievementCondition {
  const FirstTagCondition(this.tag);
  final ActivityTag tag;

  @override
  bool evaluate(List<ActivityLog> logs, DateTime now) =>
      logs.any((l) => l.tag == tag);

  @override
  double progress(List<ActivityLog> logs, DateTime now) =>
      evaluate(logs, now) ? 1.0 : 0.0;
}

/// 特定タグをX回ログ
class TagCountCondition extends AchievementCondition {
  const TagCountCondition(this.tag, this.count);
  final ActivityTag tag;
  final int count;

  @override
  bool evaluate(List<ActivityLog> logs, DateTime now) =>
      logs.where((l) => l.tag == tag).length >= count;

  @override
  double progress(List<ActivityLog> logs, DateTime now) =>
      (logs.where((l) => l.tag == tag).length / count).clamp(0.0, 1.0);
}

/// 任意タグをX回ログ
class TotalCountCondition extends AchievementCondition {
  const TotalCountCondition(this.count);
  final int count;

  @override
  bool evaluate(List<ActivityLog> logs, DateTime now) => logs.length >= count;

  @override
  double progress(List<ActivityLog> logs, DateTime now) =>
      (logs.length / count).clamp(0.0, 1.0);
}

/// 特定タグの合計時間がX分以上
class TagDurationCondition extends AchievementCondition {
  const TagDurationCondition(this.tag, this.minutes);
  final ActivityTag tag;
  final int minutes;

  @override
  bool evaluate(List<ActivityLog> logs, DateTime now) {
    final total = logs
        .where((l) => l.tag == tag)
        .fold(0, (sum, l) => sum + l.durationMinutes);
    return total >= minutes;
  }

  @override
  double progress(List<ActivityLog> logs, DateTime now) {
    final total = logs
        .where((l) => l.tag == tag)
        .fold(0, (sum, l) => sum + l.durationMinutes);
    return (total / minutes).clamp(0.0, 1.0);
  }
}

/// 1回のログでX分以上
class SingleSessionDurationCondition extends AchievementCondition {
  const SingleSessionDurationCondition(this.tag, this.minutes);
  final ActivityTag tag;
  final int minutes;

  @override
  bool evaluate(List<ActivityLog> logs, DateTime now) =>
      logs.any((l) => l.tag == tag && l.durationMinutes >= minutes);

  @override
  double progress(List<ActivityLog> logs, DateTime now) {
    final best = logs
        .where((l) => l.tag == tag)
        .fold(0, (best, l) => l.durationMinutes > best ? l.durationMinutes : best);
    return (best / minutes).clamp(0.0, 1.0);
  }
}

/// 1日にX回同タグをログ
class SameDayTagCountCondition extends AchievementCondition {
  const SameDayTagCountCondition(this.tag, this.count);
  final ActivityTag tag;
  final int count;

  @override
  bool evaluate(List<ActivityLog> logs, DateTime now) {
    return _groupByDay(logs).values.any(
      (dayLogs) => dayLogs.where((l) => l.tag == tag).length >= count,
    );
  }

  @override
  double progress(List<ActivityLog> logs, DateTime now) {
    final best = _groupByDay(logs).values.fold(0, (b, dayLogs) {
      final c = dayLogs.where((l) => l.tag == tag).length;
      return c > b ? c : b;
    });
    return (best / count).clamp(0.0, 1.0);
  }
}

/// X日連続ログイン（アプリを開いた記録 = 当日に何らかのログがある日）
class ConsecutiveDaysCondition extends AchievementCondition {
  const ConsecutiveDaysCondition(this.days);
  final int days;

  @override
  bool evaluate(List<ActivityLog> logs, DateTime now) =>
      _maxStreak(logs) >= days;

  @override
  double progress(List<ActivityLog> logs, DateTime now) =>
      (_maxStreak(logs) / days).clamp(0.0, 1.0);

  int _maxStreak(List<ActivityLog> logs) {
    if (logs.isEmpty) return 0;
    final days = logs
        .map((l) =>
            DateTime(l.timestamp.year, l.timestamp.month, l.timestamp.day))
        .toSet()
        .toList()
      ..sort();
    int maxStreak = 1;
    int current = 1;
    for (int i = 1; i < days.length; i++) {
      if (days[i].difference(days[i - 1]).inDays == 1) {
        current++;
        if (current > maxStreak) maxStreak = current;
      } else {
        current = 1;
      }
    }
    return maxStreak;
  }
}

/// 特定時間帯にログを記録（hour以上nextHour未満）
class TimeOfDayCondition extends AchievementCondition {
  const TimeOfDayCondition({required this.startHour, required this.endHour});
  final int startHour;
  final int endHour;

  @override
  bool evaluate(List<ActivityLog> logs, DateTime now) {
    if (logs.isEmpty) return false;
    return logs.any(
      (l) => l.timestamp.hour >= startHour && l.timestamp.hour < endHour,
    );
  }

  @override
  double progress(List<ActivityLog> logs, DateTime now) =>
      evaluate(logs, now) ? 1.0 : 0.0;
}

/// 全タグを1回以上ログ
class AllTagsCondition extends AchievementCondition {
  const AllTagsCondition();

  @override
  bool evaluate(List<ActivityLog> logs, DateTime now) =>
      ActivityTag.values.every((t) => _usedTags(logs).contains(t));

  @override
  double progress(List<ActivityLog> logs, DateTime now) =>
      (_usedTags(logs).length / ActivityTag.values.length).clamp(0.0, 1.0);
}

/// AND条件（複数条件すべて満たす）
class AndCondition extends AchievementCondition {
  const AndCondition(this.conditions);
  final List<AchievementCondition> conditions;

  @override
  bool evaluate(List<ActivityLog> logs, DateTime now) =>
      conditions.every((c) => c.evaluate(logs, now));

  @override
  double progress(List<ActivityLog> logs, DateTime now) {
    if (conditions.isEmpty) return 1.0;
    return conditions.map((c) => c.progress(logs, now)).reduce((a, b) => a < b ? a : b);
  }
}

/// X種類以上のタグを使う
class MinTagVarietyCondition extends AchievementCondition {
  const MinTagVarietyCondition(this.minCount);
  final int minCount;

  @override
  bool evaluate(List<ActivityLog> logs, DateTime now) =>
      _usedTags(logs).length >= minCount;

  @override
  double progress(List<ActivityLog> logs, DateTime now) =>
      (_usedTags(logs).length / minCount).clamp(0.0, 1.0);
}

/// 同日に複数タグをすべてログ
class SameDayCombinationCondition extends AchievementCondition {
  const SameDayCombinationCondition(this.tags);
  final List<ActivityTag> tags;

  @override
  bool evaluate(List<ActivityLog> logs, DateTime now) {
    return _groupByDay(logs).values.any(
      (dayLogs) => tags.every((t) => dayLogs.any((l) => l.tag == t)),
    );
  }

  @override
  double progress(List<ActivityLog> logs, DateTime now) {
    final best = _groupByDay(logs).values.fold(0, (best, dayLogs) {
      final dayTags = dayLogs.map((l) => l.tag).toSet();
      final matched = tags.where((t) => dayTags.contains(t)).length;
      return matched > best ? matched : best;
    });
    return (best / tags.length).clamp(0.0, 1.0);
  }
}
