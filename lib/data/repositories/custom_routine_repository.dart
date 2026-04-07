import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../models/custom_routine.dart';

class CustomRoutineRepository {
  Box<CustomRoutine> get _box => Hive.box<CustomRoutine>('custom_routines');

  List<CustomRoutine> getAll() {
    final list = _box.values.toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<void> save(CustomRoutine routine) => _box.put(routine.id, routine);

  Future<void> delete(String id) => _box.delete(id);
}

final customRoutineRepositoryProvider = Provider<CustomRoutineRepository>(
  (_) => CustomRoutineRepository(),
);

// ── StateNotifier ─────────────────────────────────────────────────────────────

class CustomRoutinesNotifier extends StateNotifier<List<CustomRoutine>> {
  CustomRoutinesNotifier(this._repo) : super(_repo.getAll());

  final CustomRoutineRepository _repo;

  Future<void> save(CustomRoutine routine) async {
    await _repo.save(routine);
    state = _repo.getAll();
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    state = _repo.getAll();
  }

  Future<void> markRun(String id) async {
    final routine = state.firstWhere((r) => r.id == id, orElse: () => throw StateError('Routine not found: $id'));
    routine.lastRunAt = DateTime.now();
    await _repo.save(routine);
    state = _repo.getAll();
  }
}

final customRoutinesProvider =
    StateNotifierProvider<CustomRoutinesNotifier, List<CustomRoutine>>((ref) {
  return CustomRoutinesNotifier(ref.read(customRoutineRepositoryProvider));
});