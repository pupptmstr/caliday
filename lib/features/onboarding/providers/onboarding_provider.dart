import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/skill_progress.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/repositories/skill_progress_repository.dart';
import '../../../data/repositories/user_repository.dart';

// ── Answer enums ─────────────────────────────────────────────────────────────

enum FitnessFrequency {
  never('Никогда', 'Только начинаю', '🛋️'),
  sometimes('Иногда', 'Тренируюсь время от времени', '🚶'),
  regular('Регулярно', 'Занимаюсь несколько раз в неделю', '💪');

  const FitnessFrequency(this.label, this.description, this.emoji);

  final String label;
  final String description;
  final String emoji;
}

enum PushupCount {
  zero('0', 'Пока ни одного', '🌱'),
  oneToFive('1–5', 'Совсем немного', '🌿'),
  fiveToFifteen('5–15', 'Уже неплохо', '🌳'),
  moreThan15('15+', 'Отличная база', '🏆');

  const PushupCount(this.label, this.description, this.emoji);

  final String label;
  final String description;
  final String emoji;
}

enum WorkoutMinutes {
  five(5, 'Быстро и эффективно', '⚡'),
  ten(10, 'Оптимальный вариант', '🎯'),
  fifteen(15, 'Полноценная тренировка', '🔥');

  const WorkoutMinutes(this.minutes, this.description, this.emoji);

  final int minutes;
  final String description;
  final String emoji;

  String get label => '$minutes минут';
}

enum FitnessGoal {
  generalFitness('Общая форма', 'Быть активным и здоровым', '🏃'),
  strengthPush('Отжимания и сила', 'Накачать грудь и трицепс', '💪'),
  calisthenics('Калистеника', 'Стойка на руках и трюки', '🤸');

  const FitnessGoal(this.label, this.description, this.emoji);

  final String label;
  final String description;
  final String emoji;
}

// ── State ────────────────────────────────────────────────────────────────────

class OnboardingState {
  const OnboardingState({
    this.step = 0,
    this.fitnessFrequency,
    this.pushupCount,
    this.workoutMinutes,
    this.fitnessGoal,
    this.reminderHour = 9,
    this.reminderMinute = 0,
    this.isSaving = false,
  });

  final int step;
  final FitnessFrequency? fitnessFrequency;
  final PushupCount? pushupCount;
  final WorkoutMinutes? workoutMinutes;
  final FitnessGoal? fitnessGoal;
  final int reminderHour;
  final int reminderMinute;
  final bool isSaving;

  // Steps: 0=welcome  1=frequency  2=pushups  3=minutes  4=goal  5=reminder
  static const int lastStep = 5;

  bool get canAdvance {
    switch (step) {
      case 0:
        return true;
      case 1:
        return fitnessFrequency != null;
      case 2:
        return pushupCount != null;
      case 3:
        return workoutMinutes != null;
      case 4:
        return fitnessGoal != null;
      case 5:
        return true; // reminder has a sensible default
      default:
        return false;
    }
  }

  bool get isLastStep => step == lastStep;

  OnboardingState copyWith({
    int? step,
    FitnessFrequency? fitnessFrequency,
    PushupCount? pushupCount,
    WorkoutMinutes? workoutMinutes,
    FitnessGoal? fitnessGoal,
    int? reminderHour,
    int? reminderMinute,
    bool? isSaving,
  }) {
    return OnboardingState(
      step: step ?? this.step,
      fitnessFrequency: fitnessFrequency ?? this.fitnessFrequency,
      pushupCount: pushupCount ?? this.pushupCount,
      workoutMinutes: workoutMinutes ?? this.workoutMinutes,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

// ── Notifier ─────────────────────────────────────────────────────────────────

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier(this._ref) : super(const OnboardingState());

  final Ref _ref;

  void selectFitnessFrequency(FitnessFrequency value) =>
      state = state.copyWith(fitnessFrequency: value);

  void selectPushupCount(PushupCount value) =>
      state = state.copyWith(pushupCount: value);

  void selectWorkoutMinutes(WorkoutMinutes value) =>
      state = state.copyWith(workoutMinutes: value);

  void selectFitnessGoal(FitnessGoal value) =>
      state = state.copyWith(fitnessGoal: value);

  void selectReminderTime(int hour, int minute) =>
      state = state.copyWith(reminderHour: hour, reminderMinute: minute);

  void nextStep() {
    if (state.canAdvance && state.step < OnboardingState.lastStep) {
      state = state.copyWith(step: state.step + 1);
    }
  }

  void previousStep() {
    if (state.step > 0) {
      state = state.copyWith(step: state.step - 1);
    }
  }

  /// Persists profile + calibrated skill progress, then opens the home screen.
  Future<void> completeOnboarding() async {
    state = state.copyWith(isSaving: true);

    final userRepo = _ref.read(userRepositoryProvider);
    final progressRepo = _ref.read(skillProgressRepositoryProvider);

    // Create user profile with notification preferences and selected locale.
    await userRepo.saveProfile(
      UserProfile(
        notificationHour: state.reminderHour,
        notificationMinute: state.reminderMinute,
        locale: _ref.read(localeProvider),
      ),
    );

    // Calibrate Push starting stage/reps from the pushup answer.
    await progressRepo.saveProgress(_calibratePush(state.pushupCount));

    // Core always starts at stage 1.
    await progressRepo.saveProgress(
      SkillProgress(
        branchId: BranchId.core,
        currentStage: 1,
        currentReps: 8,
        currentSets: 1,
        currentRestSec: 45,
      ),
    );

    // Signal the router to redirect to /home.
    _ref.read(isOnboardingCompleteProvider.notifier).state = true;
  }

  SkillProgress _calibratePush(PushupCount? count) {
    switch (count) {
      case PushupCount.zero:
        // Start at stage 1 (wall pushups) with a gentle entry.
        return SkillProgress(
          branchId: BranchId.push,
          currentStage: 1,
          currentReps: 3,
          currentSets: 1,
          currentRestSec: 60,
        );
      case PushupCount.oneToFive:
        // Stage 2 (knee pushups).
        return SkillProgress(
          branchId: BranchId.push,
          currentStage: 2,
          currentReps: 5,
          currentSets: 1,
          currentRestSec: 60,
        );
      case PushupCount.fiveToFifteen:
        // Stage 3 (full pushups), eased in.
        return SkillProgress(
          branchId: BranchId.push,
          currentStage: 3,
          currentReps: 5,
          currentSets: 1,
          currentRestSec: 60,
        );
      case PushupCount.moreThan15:
        // Stage 3 with a head start on reps and sets.
        return SkillProgress(
          branchId: BranchId.push,
          currentStage: 3,
          currentReps: 10,
          currentSets: 2,
          currentRestSec: 45,
        );
      default:
        return SkillProgress(
          branchId: BranchId.push,
          currentStage: 1,
          currentReps: 5,
          currentSets: 1,
          currentRestSec: 60,
        );
    }
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>(
  (ref) => OnboardingNotifier(ref),
);