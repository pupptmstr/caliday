import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';

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

// ── Notifier ──────────────────────────────────────────────────────────────────

class CustomRoutinesNotifier extends Notifier<List<CustomRoutine>> {
  @override
  List<CustomRoutine> build() => ref.read(customRoutineRepositoryProvider).getAll();

  Future<void> save(CustomRoutine routine) async {
    final repo = ref.read(customRoutineRepositoryProvider);
    await repo.save(routine);
    state = repo.getAll();
  }

  Future<void> delete(String id) async {
    final repo = ref.read(customRoutineRepositoryProvider);
    await repo.delete(id);
    state = repo.getAll();
  }

  Future<void> markRun(String id) async {
    final repo = ref.read(customRoutineRepositoryProvider);
    final routine = state.firstWhere((r) => r.id == id, orElse: () => throw StateError('Routine not found: $id'));
    routine.lastRunAt = DateTime.now();
    await repo.save(routine);
    state = repo.getAll();
  }
}

final customRoutinesProvider =
    NotifierProvider<CustomRoutinesNotifier, List<CustomRoutine>>(CustomRoutinesNotifier.new);