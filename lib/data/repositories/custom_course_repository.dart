import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';

import '../models/custom_branch.dart';
import '../models/custom_course.dart';
import 'skill_progress_repository.dart';

/// The user's own branches, oldest first (the order they were made in).
class CustomBranchRepository {
  Box<CustomBranch> get _box => Hive.box<CustomBranch>('custom_branches');

  List<CustomBranch> getAll() =>
      _box.values.toList()..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  Future<void> save(CustomBranch branch) => _box.put(branch.id, branch);

  Future<void> delete(String id) => _box.delete(id);
}

/// The user's own courses, oldest first (the order of the course pills).
class CustomCourseRepository {
  Box<CustomCourse> get _box => Hive.box<CustomCourse>('custom_courses');

  List<CustomCourse> getAll() =>
      _box.values.toList()..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  Future<void> save(CustomCourse course) => _box.put(course.id, course);

  Future<void> delete(String id) => _box.delete(id);
}

final customBranchRepositoryProvider =
    Provider<CustomBranchRepository>((_) => CustomBranchRepository());

final customCourseRepositoryProvider =
    Provider<CustomCourseRepository>((_) => CustomCourseRepository());

/// A new id for an own branch or course: like [CustomRoutine.id].
String newCustomId() => DateTime.now().microsecondsSinceEpoch.toRadixString(36);

// ── Notifiers ─────────────────────────────────────────────────────────────────

class CustomBranchesNotifier extends Notifier<List<CustomBranch>> {
  @override
  List<CustomBranch> build() => ref.read(customBranchRepositoryProvider).getAll();

  Future<void> save(CustomBranch branch) async {
    final repo = ref.read(customBranchRepositoryProvider);
    await repo.save(branch);
    state = repo.getAll();
  }

  /// Deletes the branch, its progress, and its place in every own course.
  Future<void> delete(String id) async {
    final key = CustomBranch.keyFor(id);
    final courses = ref.read(customCourseRepositoryProvider);
    for (final c in courses.getAll().where((c) => c.branchKeys.contains(key))) {
      c.branchKeys = [...c.branchKeys]..remove(key);
      await courses.save(c);
    }
    await ref.read(skillProgressRepositoryProvider).deleteProgress(key);
    final repo = ref.read(customBranchRepositoryProvider);
    await repo.delete(id);
    state = repo.getAll();
    ref.invalidate(customCoursesProvider);
  }
}

final customBranchesProvider =
    NotifierProvider<CustomBranchesNotifier, List<CustomBranch>>(
        CustomBranchesNotifier.new);

class CustomCoursesNotifier extends Notifier<List<CustomCourse>> {
  @override
  List<CustomCourse> build() => ref.read(customCourseRepositoryProvider).getAll();

  Future<void> save(CustomCourse course) async {
    final repo = ref.read(customCourseRepositoryProvider);
    await repo.save(course);
    state = repo.getAll();
  }

  /// Deletes the course; its branches and their progress stay.
  Future<void> delete(String id) async {
    final repo = ref.read(customCourseRepositoryProvider);
    await repo.delete(id);
    state = repo.getAll();
  }
}

final customCoursesProvider =
    NotifierProvider<CustomCoursesNotifier, List<CustomCourse>>(
        CustomCoursesNotifier.new);
