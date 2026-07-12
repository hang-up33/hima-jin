import 'package:hima_jin/domain/entities/activity_log.dart';
import 'package:hima_jin/domain/enums/activity_tag.dart';

/// Builds an [ActivityLog] with a deterministic id derived from [tag] and
/// [ts], for tests that need throwaway log fixtures.
ActivityLog buildLog(ActivityTag tag, DateTime ts, {int minutes = 0}) =>
    ActivityLog(
      id: '${tag.name}-${ts.millisecondsSinceEpoch}',
      timestamp: ts,
      tag: tag,
      note: '',
      durationMinutes: minutes,
    );
