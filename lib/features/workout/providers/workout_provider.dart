import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/enums.dart';
import '../../../data/models/exercise_result.dart';
import '../../../data/models/workout_log.dart';
import '../../../data/repositories/skill_progress_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/workout_repository.dart';
import '../../../domain/models/workout_plan.dart';
import '../../../domain/services/progression_service.dart';
import '../../../domain/services/sp_service.dart';
import '../../../domain/services/streak_service.dart';
import '../../../domain/services/workout_generator_service.dart';
import '../../../core/services/notification_service.dart';
import '../../home/providers/home_provider.dart';

// ── Challenge branch selector ──────────────────────────────────────────────────

/// Set to a [BranchId] before navigating to /workout to launch a challenge.
/// null means normal daily workout. Reset automatically after workout ends.
final challengeBranchProvider = StateProvider<BranchId?>((ref) => null);

// ── Phase ─────────────────────────────────────────────────────────────────────

enum WorkoutPhase { exercise, rest, done }

// ── State ─────────────────────────────────────────────────────────────────────

class WorkoutState {
  const WorkoutState({
    required this.plan,
    required this.exerciseIndex,
    required this.setIndex,
    required this.phase,
    required this.repsInput,
    required this.timerSec,
    required this.results,
    required this.startedAt,
    this.spEarned = 0,
    this.durationSec = 0,
    this.isInterExerciseRest = false,
    this.freezeEarned = false,
    this.freezeUsed = false,
    this.challengeUnlocked = false,
    this.challengePassed = false,
    this.newStageExerciseId,
  });

  final WorkoutPlan plan;

  /// Index of the current [PlannedExercise] in [plan.exercises].
  final int exerciseIndex;

  /// 0-based index of the current set within the current exercise.
  final int setIndex;

  final WorkoutPhase phase;

  /// For reps exercises: the count the user is about to confirm.
  /// Starts at [PlannedExercise.targetAmount] and can be adjusted.
  final int repsInput;

  /// Rest phase: seconds remaining until next set.
  /// Timed exercise phase: seconds remaining in the hold.
  final int timerSec;

  /// One slot per [plan.exercises] entry; null until that slot is complete.
  final List<ExerciseResult?> results;

  final DateTime startedAt;

  /// Populated when [phase] == [WorkoutPhase.done].
  final int spEarned;
  final int durationSec;

  /// True when a streak freeze was awarded at the end of this workout.
  final bool freezeEarned;

  /// True when a streak freeze was consumed to preserve the streak.
  final bool freezeUsed;

  /// True during the rest phase that sits between two different exercises
  /// (as opposed to rest between sets of the same exercise).
  final bool isInterExerciseRest;

  /// True when a challenge was unlocked for the first time during this workout.
  final bool challengeUnlocked;

  /// True when a challenge workout succeeded and stage was advanced.
  final bool challengePassed;

  /// Exercise id of the newly reached stage (if [challengePassed]).
  final String? newStageExerciseId;

  // ── Convenience ───────────────────────────────────────────────────────────

  PlannedExercise get currentPlanned => plan.exercises[exerciseIndex];
  bool get isLastSet => setIndex >= currentPlanned.sets - 1;
  bool get isLastExercise => exerciseIndex >= plan.exercises.length - 1;

  WorkoutState copyWith({
    int? exerciseIndex,
    int? setIndex,
    WorkoutPhase? phase,
    int? repsInput,
    int? timerSec,
    List<ExerciseResult?>? results,
    int? spEarned,
    int? durationSec,
    bool? isInterExerciseRest,
    bool? freezeEarned,
    bool? freezeUsed,
    bool? challengeUnlocked,
    bool? challengePassed,
    String? newStageExerciseId,
  }) {
    return WorkoutState(
      plan: plan,
      exerciseIndex: exerciseIndex ?? this.exerciseIndex,
      setIndex: setIndex ?? this.setIndex,
      phase: phase ?? this.phase,
      repsInput: repsInput ?? this.repsInput,
      timerSec: timerSec ?? this.timerSec,
      results: results ?? this.results,
      startedAt: startedAt,
      spEarned: spEarned ?? this.spEarned,
      durationSec: durationSec ?? this.durationSec,
      isInterExerciseRest: isInterExerciseRest ?? this.isInterExerciseRest,
      freezeEarned: freezeEarned ?? this.freezeEarned,
      freezeUsed: freezeUsed ?? this.freezeUsed,
      challengeUnlocked: challengeUnlocked ?? this.challengeUnlocked,
      challengePassed: challengePassed ?? this.challengePassed,
      newStageExerciseId: newStageExerciseId ?? this.newStageExerciseId,
    );
  }

  factory WorkoutState.initial(WorkoutPlan plan) {
    final first = plan.exercises.isNotEmpty ? plan.exercises[0] : null;
    return WorkoutState(
      plan: plan,
      exerciseIndex: 0,
      setIndex: 0,
      phase: WorkoutPhase.exercise,
      repsInput: first?.targetAmount ?? 0,
      timerSec: (first != null &&
              first.exercise.type == ExerciseType.timed)
          ? first.targetAmount
          : 0,
      results: List.filled(plan.exercises.length, null),
      startedAt: DateTime.now(),
    );
  }
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class WorkoutNotifier extends StateNotifier<WorkoutState> {
  WorkoutNotifier(this._ref)
      : super(WorkoutState.initial(_buildPlan(_ref)));

  static WorkoutPlan _buildPlan(Ref ref) {
    final challengeBranch = ref.read(challengeBranchProvider);
    final generator = ref.read(workoutGeneratorServiceProvider);
    if (challengeBranch != null) {
      return generator.generateChallenge(challengeBranch);
    }
    final profile = ref.read(userRepositoryProvider).getProfile();
    return generator.generateDaily(
      activeBranches: profile.activeBranches,
      preferredMinutes: profile.preferredWorkoutMinutes ?? 10,
    );
  }

  final Ref _ref;

  /// Adjusts the reps counter (for reps exercises) by [delta].
  void adjustReps(int delta) {
    state = state.copyWith(repsInput: (state.repsInput + delta).clamp(0, 999));
  }

  /// Confirms completion of the current set.
  ///
  /// For timed exercises pass [actualDurationSec]; for reps exercises
  /// the current [WorkoutState.repsInput] is used automatically.
  void confirmSet({int? actualDurationSec}) {
    if (state.phase != WorkoutPhase.exercise) return;

    final planned = state.currentPlanned;
    final isTimed = planned.exercise.type == ExerciseType.timed;

    // Build a result only when this is the last set of the exercise.
    ExerciseResult? completedResult;
    if (state.isLastSet) {
      if (isTimed) {
        final actual = actualDurationSec ?? planned.targetAmount;
        completedResult = ExerciseResult(
          exerciseId: planned.exercise.id,
          targetReps: planned.targetAmount,
          completedReps: 0,
          targetDurationSec: planned.targetAmount,
          actualDurationSec: actual,
        );
      } else {
        completedResult = ExerciseResult(
          exerciseId: planned.exercise.id,
          targetReps: planned.targetAmount,
          completedReps: state.repsInput,
        );
      }
    }

    if (state.isLastSet) {
      // Record result and advance to the next exercise.
      final newResults = List<ExerciseResult?>.from(state.results);
      newResults[state.exerciseIndex] = completedResult!;

      if (state.isLastExercise) {
        _finishWorkout(newResults);
      } else {
        final nextIdx = state.exerciseIndex + 1;
        final next = state.plan.exercises[nextIdx];
        // Show a rest screen between exercises when the completed exercise
        // had a non-zero rest period (warmup/cooldown have restSec == 0).
        if (planned.restSec > 0) {
          state = state.copyWith(
            phase: WorkoutPhase.rest,
            timerSec: planned.restSec,
            isInterExerciseRest: true,
            results: newResults,
          );
        } else {
          state = state.copyWith(
            exerciseIndex: nextIdx,
            setIndex: 0,
            phase: WorkoutPhase.exercise,
            repsInput: next.targetAmount,
            timerSec: next.exercise.type == ExerciseType.timed
                ? next.targetAmount
                : 0,
            results: newResults,
          );
        }
      }
    } else {
      // Not the last set → rest before next set (or skip rest if restSec == 0).
      if (planned.restSec > 0) {
        state = state.copyWith(
          phase: WorkoutPhase.rest,
          timerSec: planned.restSec,
        );
      } else {
        state = state.copyWith(setIndex: state.setIndex + 1);
      }
    }
  }

  /// Decrements the active timer by one second.
  ///
  /// Should be called once per second from the screen's [Timer.periodic].
  void tick() {
    if (state.phase == WorkoutPhase.rest) {
      if (state.timerSec <= 1) {
        _endRest();
      } else {
        state = state.copyWith(timerSec: state.timerSec - 1);
      }
    } else if (state.phase == WorkoutPhase.exercise &&
        state.currentPlanned.exercise.type == ExerciseType.timed) {
      if (state.timerSec <= 1) {
        // Full target duration reached → auto-confirm.
        confirmSet(actualDurationSec: state.currentPlanned.targetAmount);
      } else {
        state = state.copyWith(timerSec: state.timerSec - 1);
      }
    }
  }

  /// Skips the rest timer and immediately begins the next set.
  void skipRest() {
    if (state.phase == WorkoutPhase.rest) _endRest();
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  void _endRest() {
    if (state.isInterExerciseRest) {
      // Advance to the next exercise.
      final nextIdx = state.exerciseIndex + 1;
      final next = state.plan.exercises[nextIdx];
      state = state.copyWith(
        exerciseIndex: nextIdx,
        setIndex: 0,
        phase: WorkoutPhase.exercise,
        repsInput: next.targetAmount,
        timerSec: next.exercise.type == ExerciseType.timed
            ? next.targetAmount
            : 0,
        isInterExerciseRest: false,
      );
    } else {
      // Advance to the next set of the same exercise.
      final planned = state.currentPlanned;
      state = state.copyWith(
        setIndex: state.setIndex + 1,
        phase: WorkoutPhase.exercise,
        repsInput: planned.targetAmount,
        timerSec: planned.exercise.type == ExerciseType.timed
            ? planned.targetAmount
            : 0,
      );
    }
  }

  void _finishWorkout(List<ExerciseResult?> results) {
    final now = DateTime.now();
    final durationSec = now.difference(state.startedAt).inSeconds;

    // Build parallel lists of matched results and exercises (skip nulls).
    final matchedResults = <ExerciseResult>[];
    final matchedExercises = <dynamic>[];
    for (var i = 0; i < state.plan.exercises.length; i++) {
      final r = results[i];
      if (r != null) {
        matchedResults.add(r);
        matchedExercises.add(state.plan.exercises[i].exercise);
      }
    }

    // ── SP ────────────────────────────────────────────────────────────────
    final spService = _ref.read(spServiceProvider);
    final workoutRepo = _ref.read(workoutRepositoryProvider);
    final isFirstToday = !workoutRepo.hasWorkoutToday();
    final spEarned = spService.forWorkout(
      results: matchedResults,
      exercises: List.from(matchedExercises),
      isFirstToday: isFirstToday,
    );

    // ── Profile (SP + streak) ─────────────────────────────────────────────
    final userRepo = _ref.read(userRepositoryProvider);
    final profile = userRepo.getProfile();
    spService.applyToProfile(profile, spEarned);
    final streakService = _ref.read(streakServiceProvider);
    final freezeUsed = streakService.applyWorkout(profile, now);
    final freezeEarned = streakService.tryAwardFreeze(profile);
    userRepo.saveProfile(profile);

    // ── Progression ───────────────────────────────────────────────────────
    final progressionService = _ref.read(progressionServiceProvider);
    final progressRepo = _ref.read(skillProgressRepositoryProvider);
    bool challengeUnlocked = false;
    bool challengePassed = false;
    String? newStageExerciseId;

    for (var i = 0; i < state.plan.exercises.length; i++) {
      final planned = state.plan.exercises[i];
      final result = results[i];
      if (result == null || planned.exercise.stage == 0) continue;

      final progress = progressRepo.getProgress(planned.exercise.branch);

      if (planned.exercise.stage > progress.currentStage) {
        // Challenge exercise: check result against challengeTargetReps.
        final exercise = planned.exercise;
        final passed = exercise.type == ExerciseType.timed
            ? (result.actualDurationSec ?? 0) >= exercise.challengeTargetReps
            : result.completedReps >= exercise.challengeTargetReps;
        if (passed) {
          progressionService.advanceStage(progress, exercise);
          challengePassed = true;
          newStageExerciseId = exercise.id;
        }
        // If failed: isChallengeUnlocked stays true, progress unchanged.
      } else {
        final unlocked = progressionService.applyResult(progress, planned.exercise, result);
        if (unlocked) challengeUnlocked = true;
      }
      progressRepo.saveProgress(progress);
    }

    // Reset challenge branch after workout.
    _ref.read(challengeBranchProvider.notifier).state = null;

    // ── Workout log ───────────────────────────────────────────────────────
    // Fire-and-forget: Hive write is async but nearly instantaneous locally.
    unawaited(workoutRepo.addLog(WorkoutLog(
      date: now,
      setType: state.plan.setType,
      exercises: matchedResults,
      spEarned: spEarned,
      durationSec: durationSec,
    )));

    // Cancel today's evening / streak-threat / streak-lost notifications.
    unawaited(NotificationService.instance.cancelDayReminders());
    // Schedule a streak-lost alert for tomorrow morning in case the user
    // misses the next workout. Cancelled automatically on the next completion.
    unawaited(NotificationService.instance.scheduleStreakLost(profile));

    // Invalidate home data so the Home screen reflects the new state.
    _ref.invalidate(homeDataProvider);

    state = state.copyWith(
      phase: WorkoutPhase.done,
      results: results,
      spEarned: spEarned,
      durationSec: durationSec,
      freezeEarned: freezeEarned,
      freezeUsed: freezeUsed,
      challengeUnlocked: challengeUnlocked,
      challengePassed: challengePassed,
      newStageExerciseId: newStageExerciseId,
    );
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

/// Auto-disposed so every new workout session starts with a freshly generated
/// plan and a clean state machine.
final workoutProvider =
    StateNotifierProvider.autoDispose<WorkoutNotifier, WorkoutState>(
  (ref) => WorkoutNotifier(ref),
);
