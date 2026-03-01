import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// Persists earned achievements as achievementId → earnedAt [DateTime].
///
/// Uses Hive's native [DateTime] support — no TypeAdapter required.
/// All writes are fire-and-forget (Hive is synchronous in-memory).
class AchievementRepository {
  static const _boxName = 'achievements';

  Box<DateTime> get _box => Hive.box<DateTime>(_boxName);

  bool isEarned(String id) => _box.containsKey(id);

  /// Marks [id] as earned now (no-op if already earned).
  Future<void> markEarned(String id) async {
    if (!isEarned(id)) await _box.put(id, DateTime.now());
  }

  /// All earned achievement IDs sorted newest-first.
  List<String> getAllEarnedIds() {
    final keys = _box.keys.cast<String>().toList();
    keys.sort((a, b) {
      final ta = _box.get(a) ?? DateTime(0);
      final tb = _box.get(b) ?? DateTime(0);
      return tb.compareTo(ta);
    });
    return keys;
  }

  /// Full map of earned achievement IDs → earned timestamps.
  Map<String, DateTime> getAllEarned() =>
      {for (final k in _box.keys.cast<String>()) k: _box.get(k)!};

  DateTime? earnedAt(String id) => _box.get(id);
}

final achievementRepositoryProvider = Provider<AchievementRepository>(
  (_) => AchievementRepository(),
);
