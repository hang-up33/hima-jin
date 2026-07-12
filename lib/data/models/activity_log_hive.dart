import 'package:hive/hive.dart';

part 'activity_log_hive.g.dart';

@HiveType(typeId: 0)
class ActivityLogHive extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final int tagIndex;

  @HiveField(3)
  final String note;

  @HiveField(4)
  final int durationMinutes;

  ActivityLogHive({
    required this.id,
    required this.timestamp,
    required this.tagIndex,
    required this.note,
    required this.durationMinutes,
  });
}
