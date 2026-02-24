import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../models/workout_log.dart';

/// Provides access to the append-only [WorkoutLog] history stored in Hive.
///
/// Logs are stored with auto-incrementing integer keys via [Box.add].
/// All multi-entry reads return lists sorted newest-first.
class WorkoutRepository {
  static const _boxName = 'workout_log';

  Box<WorkoutLog> get _box => Hive.box<WorkoutLog>(_boxName);

  /// Appends [log] to the history.
  Future<void> addLog(WorkoutLog log) => _box.add(log);

  /// Returns all logs, newest first.
  List<WorkoutLog> getAll() {
    return _box.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Returns the log for [date] (time component ignored), or null.
  WorkoutLog? getForDate(DateTime date) {
    final target = _dateOnly(date);
    for (final log in _box.values) {
      if (_dateOnly(log.date) == target) return log;
    }
    return null;
  }

  /// Returns all logs between [from] and [to] (inclusive), newest first.
  List<WorkoutLog> getInRange(DateTime from, DateTime to) {
    final start = _dateOnly(from);
    final end = _dateOnly(to);
    return _box.values
        .where((log) {
          final d = _dateOnly(log.date);
          return !d.isBefore(start) && !d.isAfter(end);
        })
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Returns the [count] most recent logs.
  List<WorkoutLog> getRecent(int count) {
    final all = getAll();
    return all.length <= count ? all : all.sublist(0, count);
  }

  /// True if at least one workout was logged on today's date.
  bool hasWorkoutToday() => getForDate(DateTime.now()) != null;

  /// Total number of logged workouts.
  int get totalCount => _box.length;

  static DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
}

final workoutRepositoryProvider = Provider<WorkoutRepository>(
  (_) => WorkoutRepository(),
);