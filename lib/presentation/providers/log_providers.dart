import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/log_repository.dart';
import '../../domain/entities/activity_log.dart';
import '../../domain/enums/activity_tag.dart';

final logRepositoryProvider = Provider<LogRepository>((ref) => LogRepository());

class LogNotifier extends AsyncNotifier<List<ActivityLog>> {
  @override
  Future<List<ActivityLog>> build() async {
    return ref.read(logRepositoryProvider).getAll();
  }

  Future<ActivityLog> add({
    required ActivityTag tag,
    required String note,
    required int durationMinutes,
  }) async {
    final repo = ref.read(logRepositoryProvider);
    final log = await repo.add(
      tag: tag,
      note: note,
      durationMinutes: durationMinutes,
    );
    state = AsyncData([log, ...state.value ?? []]);
    return log;
  }

  Future<void> delete(String id) async {
    final repo = ref.read(logRepositoryProvider);
    await repo.delete(id);
    state = AsyncData(
      (state.value ?? []).where((l) => l.id != id).toList(),
    );
  }

  Future<void> edit({
    required String id,
    required String note,
    required int durationMinutes,
  }) async {
    final repo = ref.read(logRepositoryProvider);
    final updated = await repo.update(
      id: id,
      note: note,
      durationMinutes: durationMinutes,
    );
    if (updated == null) return;
    state = AsyncData([
      for (final l in state.value ?? [])
        if (l.id == id) updated else l,
    ]);
  }
}

final logNotifierProvider =
    AsyncNotifierProvider<LogNotifier, List<ActivityLog>>(LogNotifier.new);

/// 今日のログだけ
final todayLogsProvider = Provider<List<ActivityLog>>((ref) {
  final logs = ref.watch(logNotifierProvider).valueOrNull ?? [];
  final now = DateTime.now();
  return logs.where((l) {
    final d = l.timestamp;
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }).toList();
});
