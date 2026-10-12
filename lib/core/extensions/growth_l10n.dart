import 'package:caliday/l10n/app_localizations.dart';

import '../../data/models/branch_growth.dart';
import '../../data/models/enums.dart';
import '../../domain/models/branch.dart';
import 'exercise_l10n.dart';

/// What a [BranchGrowth] says in words ("10 → 12 reps", "2 → 3 sets", "new
/// stage: …"): Home's "Progress today" and the home-screen widget show the
/// same line.
class GrowthL10n {
  GrowthL10n._();

  static String change(AppLocalizations l10n, BranchGrowth g, Branch branch) {
    final exercise = branch.stage(g.toStage);
    final timed = branch.stage(g.fromStage)?.type == ExerciseType.timed;
    return switch (g.kind) {
      GrowthKind.stage => l10n.homeGrowthStage(
        exercise == null ? '' : ExerciseL10n.name(l10n, exercise.id),
      ),
      GrowthKind.sets => l10n.homeGrowthSets(g.fromSets, g.toSets),
      GrowthKind.amount =>
        timed
            ? l10n.homeGrowthSeconds(g.fromAmount, g.toAmount)
            : l10n.homeGrowthReps(g.fromAmount, g.toAmount),
      GrowthKind.rest => l10n.homeGrowthRest(g.fromRestSec, g.toRestSec),
      GrowthKind.challenge => l10n.homeGrowthChallenge,
    };
  }
}
