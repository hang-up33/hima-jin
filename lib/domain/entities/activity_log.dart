import '../enums/activity_tag.dart';

class ActivityLog {
  const ActivityLog({
    required this.id,
    required this.timestamp,
    required this.tag,
    this.note = '',
    this.durationMinutes = 0,
  });

  final String id;
  final DateTime timestamp;
  final ActivityTag tag;
  final String note;
  final int durationMinutes;
}
