import 'package:flutter/material.dart';

import '../../data/models/custom_branch.dart';
import '../../data/models/enums.dart';
import '../../data/models/exercise.dart';
import '../../data/static/exercise_catalog.dart';
import '../../data/static/supplementary_exercise_catalog.dart';
import '../../l10n/app_localizations.dart';
import '../services/custom_stages.dart';

/// A branch the user can train: a built-in [BranchId] or one they made
/// ([CustomBranch]). Everything that runs a branch (the generator, the
/// progression, the Courses tab, the Branch Journey) goes through this, so an
/// own branch behaves like a built-in one. Two branches are equal when their
/// [key]s are.
sealed class Branch {
  const Branch();

  /// The branch stored as [key] ([Branch.key]): a built-in one by its name or
  /// one of [own]; null when it no longer exists.
  static Branch? resolve(String key, Iterable<CustomBranch> own) {
    if (key.startsWith(CustomBranch.keyPrefix)) {
      final id = key.substring(CustomBranch.keyPrefix.length);
      final data = own.where((b) => b.id == id).firstOrNull;
      return data == null ? null : OwnBranch(data);
    }
    final id = BranchId.values.where((b) => b.name == key).firstOrNull;
    return id == null ? null : BuiltInBranch(id);
  }

  /// The `SkillProgress` key: "push" for a built-in branch,
  /// `CustomBranch.keyFor` for an own one.
  String get key;

  String name(AppLocalizations l10n);

  IconData get icon;

  /// The stage exercises, stage 1 first (`Exercise.stage` = place).
  List<Exercise> get stages;

  int get stageCount => stages.length;

  /// The exercise of stage [n], or null when there is none.
  Exercise? stage(int n);

  /// The stand-in for stage [n] when the user has no pull-up bar.
  Exercise? equipmentFreeStage(int n) => null;

  /// The warm-up when the workout starts with this branch at stage [n].
  Exercise? warmupAt(int n);

  /// The cool-downs of this branch at stage [n].
  List<Exercise> cooldownsAt(int n);

  /// Hidden without a pull-up bar (the whole branch, like Pull).
  bool get requiresEquipment => false;

  @override
  bool operator ==(Object other) => other is Branch && other.key == key;

  @override
  int get hashCode => key.hashCode;
}

final class BuiltInBranch extends Branch {
  const BuiltInBranch(this.id);

  final BranchId id;

  @override
  String get key => id.name;

  @override
  String name(AppLocalizations l10n) => id.localizedName(l10n);

  @override
  IconData get icon => id.icon;

  @override
  List<Exercise> get stages => ExerciseCatalog.progressionFor(id);

  @override
  int get stageCount => id.stageCount;

  @override
  Exercise? stage(int n) => ExerciseCatalog.forStage(id, n);

  @override
  Exercise? equipmentFreeStage(int n) =>
      ExerciseCatalog.equipmentFreeForStage(id, n);

  @override
  Exercise? warmupAt(int n) => ExerciseCatalog.warmupFor(id);

  @override
  List<Exercise> cooldownsAt(int n) => ExerciseCatalog.cooldownsFor(id);

  @override
  bool get requiresEquipment => id.requiresEquipment;
}

/// A branch the user made: their exercises in their order, the amounts
/// derived by [CustomStages]. The warm-up and cool-downs are those of the
/// built-in branch the current stage's exercise comes from.
final class OwnBranch extends Branch {
  OwnBranch(this.data)
      : stages = CustomStages.build([
          for (final id in data.exerciseIds) ?exerciseById(id),
        ]);

  final CustomBranch data;

  @override
  final List<Exercise> stages;

  /// Every exercise an own branch can be made of: the catalog, the warm-ups
  /// and cool-downs, the supplementary pool (what the routine builder offers).
  static List<Exercise> get pickable => [
        ...ExerciseCatalog.libraryAll,
        ...SupplementaryExerciseCatalog.all,
      ];

  /// The catalog exercise [id] in [pickable], or null.
  static Exercise? exerciseById(String id) =>
      ExerciseCatalog.byId(id) ??
      ExerciseCatalog.libraryAll.where((e) => e.id == id).firstOrNull ??
      SupplementaryExerciseCatalog.all.where((e) => e.id == id).firstOrNull;

  @override
  String get key => CustomBranch.keyFor(data.id);

  @override
  String name(AppLocalizations l10n) => data.name;

  @override
  IconData get icon => Icons.extension;

  @override
  Exercise? stage(int n) => n >= 1 && n <= stages.length ? stages[n - 1] : null;

  @override
  Exercise? warmupAt(int n) {
    final e = stage(n);
    return e == null ? null : ExerciseCatalog.warmupFor(e.branch);
  }

  @override
  List<Exercise> cooldownsAt(int n) {
    final e = stage(n);
    return e == null ? const [] : ExerciseCatalog.cooldownsFor(e.branch);
  }
}
