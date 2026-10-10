import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/static/exercise_catalog.dart';
import 'package:caliday/domain/models/workout_plan.dart';
import 'package:caliday/features/home/widgets/workout_plan_button.dart';
import 'package:caliday/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _plan = WorkoutPlan(setType: SetType.daily, exercises: [
  PlannedExercise(
      exercise: ExerciseCatalog.pushS3FullPushup, targetAmount: 12, sets: 3, restSec: 60),
  PlannedExercise(
      exercise: ExerciseCatalog.flexS1HipFlexorStretch, targetAmount: 30, sets: 2, restSec: 30),
]);

// The thumbnails play Lottie animations in a loop, so the tests pump a fixed
// time instead of pumpAndSettle.
Future<void> _settle(WidgetTester tester) =>
    tester.pump(const Duration(milliseconds: 400));

void main() {
  testWidgets('folded at first; the arrow unfolds the plan, a start folds it again',
      (tester) async {
    var started = 0;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Align(
          alignment: Alignment.bottomCenter,
          child: WorkoutPlanButton(
            done: false,
            plan: _plan,
            estimatedMinutes: 9,
            maxPlanHeight: 400,
            onStart: () => started++,
          ),
        ),
      ),
    ));
    expect(find.text("Today's workout (≈ 9 min)"), findsOneWidget);
    expect(find.text('Full Push-Ups'), findsNothing);

    await tester.tap(find.byTooltip('Show the plan'));
    await _settle(tester);
    expect(find.text('3 × 12'), findsOneWidget);
    expect(find.text('2 × 30 s each side'), findsOneWidget);
    expect(find.byTooltip('Hide the plan'), findsOneWidget);

    await tester.tap(find.text("Today's workout (≈ 9 min)"));
    await _settle(tester);
    expect(started, 1);
    expect(find.text('3 × 12'), findsNothing, reason: 'starting folds the plan');
  });
}
