import '../../core/services/sound_service.dart';
import '../../data/models/enums.dart';
import '../../domain/models/workout_plan.dart';
import 'providers/workout_provider.dart';

/// Which cue plays when (owner, 2026-10-12). The workout is hands-free: the
/// user is on the floor and not looking, so every moment has a cue of its own.
/// The screen asks [cueForSecond] once a second, before the timer ticks, and
/// [cueForChange] on every change of the workout state.

/// Countdowns tick through their last [kTickSeconds] seconds (5, 4, 3, 2, 1),
/// the last tick of a get-ready or rest countdown higher than the others.
const int kTickSeconds = 5;

/// A hold this long or longer gets a quiet cue at its halfway point.
const int kHalfwayMinSec = 20;

/// The cue that opens the workout: Skala's drum for a challenge.
SoundCue startCue(WorkoutPlan plan) =>
    plan.setType == SetType.challenge ? SoundCue.challengeStart : SoundCue.start;

/// The cue of the second about to pass in [s]: the ticks of a running
/// countdown (the get-ready one, the rest, the hold's last seconds) and the
/// halfway point of a long hold. null when the second passes silently.
SoundCue? cueForSecond(WorkoutState s) {
  final left = s.runningCountdownSec;
  if (s.isHolding) {
    final target = s.currentPlanned.targetAmount;
    // After this second the hold has half its length left.
    if (target >= kHalfwayMinSec && left == target ~/ 2 + 1) {
      return SoundCue.holdHalf;
    }
  }
  // The tick of `left` is heard as the countdown shows `left - 1`; at 1 the
  // countdown ends and the change of state has its own cue.
  if (left < 2 || left > kTickSeconds + 1) return null;
  if (s.isHolding) return SoundCue.tickHold;
  return left == 2 ? SoundCue.tickLast : SoundCue.tick;
}

/// The cue of the change from [prev] to [next], or null for a change nobody
/// needs to hear (a second passing, the rep counter).
SoundCue? cueForChange(WorkoutState prev, WorkoutState next) {
  if (next.phase == WorkoutPhase.done) {
    if (prev.phase == WorkoutPhase.done) return null;
    if (next.plan.setType != SetType.challenge) return SoundCue.complete;
    return next.challengePassed
        ? SoundCue.challengePassed
        : SoundCue.challengeFailed;
  }
  if (prev.phase == WorkoutPhase.exercise && next.phase == WorkoutPhase.rest) {
    return SoundCue.setDone;
  }
  if (prev.phase == WorkoutPhase.rest && next.phase == WorkoutPhase.exercise) {
    // The rest runs out at its last second; earlier it was skipped.
    if (prev.timerSec > 1) return SoundCue.skip;
    return next.exerciseIndex != prev.exerciseIndex
        ? SoundCue.nextExercise
        : SoundCue.restOver;
  }
  if (prev.phase != WorkoutPhase.exercise || next.phase != WorkoutPhase.exercise) {
    return null;
  }
  // From here on: within the exercise phase, no rest between.
  if (next.exerciseIndex != prev.exerciseIndex) return SoundCue.nextExercise;
  if (next.setIndex != prev.setIndex) return SoundCue.setDone;
  if (next.sideIndex > prev.sideIndex) return SoundCue.switchSides;
  if (prev.isGettingReady && next.isHolding) return SoundCue.go;
  if (!prev.prepPaused && next.prepPaused) return SoundCue.pause;
  if (prev.prepPaused && !next.prepPaused) return SoundCue.resume;
  return null;
}

/// The cues of the summary, in the order of its banners: an achievement, a
/// streak freeze used or earned, a challenge unlocked (Skala's drum), a new
/// stage. They follow the end-of-workout cue.
List<SoundCue> summaryCues({
  required bool achievement,
  required bool freezeUsed,
  required bool freezeEarned,
  required bool challengeUnlocked,
  required bool newStage,
}) =>
    [
      if (achievement) SoundCue.achievement,
      if (freezeUsed) SoundCue.freezeUsed,
      if (freezeEarned) SoundCue.freezeEarned,
      if (challengeUnlocked) SoundCue.challengeStart,
      if (newStage) SoundCue.stageUp,
    ];

/// When the first summary cue plays: after the end-of-workout cue (the
/// fanfare of a passed challenge is the longest, ~1.9 s).
const Duration kSummaryCueDelay = Duration(milliseconds: 2100);

/// The pause between two summary cues.
const Duration kSummaryCueGap = Duration(milliseconds: 900);
