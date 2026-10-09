import '../../data/models/custom_branch.dart';
import '../../data/models/custom_course.dart';
import '../../data/models/enums.dart';
import '../../data/static/course_catalog.dart';
import '../../l10n/app_localizations.dart';
import 'branch.dart';

/// A course the user can pick in the Courses tab: a built-in [CourseId] or
/// one they put together ([CustomCourse]). Two courses are equal when their
/// [key]s are.
sealed class Course {
  const Course();

  String get key;

  String name(AppLocalizations l10n);

  /// The course whose host leads this one (Home, Profile, the summary).
  CourseId get host;

  /// Every branch, in rotation order.
  List<Branch> get allBranches;

  /// The branches a workout draws from: without a pull-up bar the branches
  /// that need one are left out, as in [UserProfile.branchesForCourse].
  List<Branch> branchesFor({required bool hasPullUpBar}) => hasPullUpBar
      ? allBranches
      : allBranches.where((b) => !b.requiresEquipment).toList();

  /// Whether a bonus workout adds two supplementary exercises.
  bool get addsSupplementary;

  /// The built-in course this is; null for an own one.
  CourseId? get builtIn => null;

  @override
  bool operator ==(Object other) => other is Course && other.key == key;

  @override
  int get hashCode => key.hashCode;
}

final class BuiltInCourse extends Course {
  const BuiltInCourse(this.id);

  final CourseId id;

  @override
  String get key => id.name;

  @override
  String name(AppLocalizations l10n) => id.localizedName(l10n);

  @override
  CourseId get host => id;

  @override
  List<Branch> get allBranches =>
      [for (final b in CourseCatalog.branchesFor(id)) BuiltInBranch(b)];

  @override
  bool get addsSupplementary => CourseCatalog.addsSupplementary(id);

  @override
  CourseId get builtIn => id;
}

/// A course the user made, its branches resolved against their own [own]
/// branches (a branch that was deleted is left out).
final class OwnCourse extends Course {
  OwnCourse(this.data, Iterable<CustomBranch> own)
      : allBranches = [
          for (final k in data.branchKeys) ?Branch.resolve(k, own),
        ];

  final CustomCourse data;

  @override
  final List<Branch> allBranches;

  @override
  String get key => CustomBranch.keyFor(data.id);

  @override
  String name(AppLocalizations l10n) => data.name;

  @override
  CourseId get host =>
      data.hostIndex >= 0 && data.hostIndex < CourseId.values.length
          ? CourseId.values[data.hostIndex]
          : CourseId.calisthenics;

  @override
  bool get addsSupplementary => true;
}
