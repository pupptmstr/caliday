import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/health_service.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/skill_progress.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/repositories/skill_progress_repository.dart';
import '../../../data/repositories/user_repository.dart';

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

// ── State ────────────────────────────────────────────────────────────────────

class OnboardingState {
  const OnboardingState({
    this.step = 0,
    this.displayName = '',
    this.pushupCount,
    this.workoutMinutes,
    this.selectedCourseIds = const [CourseId.calisthenics],
    this.hasPullUpBar,
    this.healthEnabled = false,
    this.reminderHour = 9,
    this.reminderMinute = 0,
    this.isSaving = false,
  });

  final int step;
  final String displayName;
  final PushupCount? pushupCount;
  final WorkoutMinutes? workoutMinutes;

  /// Courses selected during onboarding. Defaults to [calisthenics].
  final List<CourseId> selectedCourseIds;

  /// null = not yet answered; true = has bar; false = no bar.
  final bool? hasPullUpBar;

  /// Whether user opted in to Health integration during onboarding.
  final bool healthEnabled;
  final int reminderHour;
  final int reminderMinute;
  final bool isSaving;

  // Steps: 0=welcome  1=name  2=pushups  3=minutes  4=courses
  //        5=pullupbar  6=health  7=reminder
  static const int lastStep = 7;

  bool get _calisthenicsSelected =>
      selectedCourseIds.contains(CourseId.calisthenics);

  bool get canAdvance {
    switch (step) {
      case 0:
        return true;
      case 1:
        return true; // name is optional
      case 2:
        return pushupCount != null;
      case 3:
        return workoutMinutes != null;
      case 4:
        return selectedCourseIds.isNotEmpty;
      case 5:
        // Pull-up bar only required if calisthenics is selected.
        return !_calisthenicsSelected || hasPullUpBar != null;
      case 6:
        return true; // health is optional
      case 7:
        return true; // reminder has a sensible default
      default:
        return false;
    }
  }

  bool get isLastStep => step == lastStep;

  OnboardingState copyWith({
    int? step,
    String? displayName,
    PushupCount? pushupCount,
    WorkoutMinutes? workoutMinutes,
    List<CourseId>? selectedCourseIds,
    bool? hasPullUpBar,
    bool? healthEnabled,
    int? reminderHour,
    int? reminderMinute,
    bool? isSaving,
  }) {
    return OnboardingState(
      step: step ?? this.step,
      displayName: displayName ?? this.displayName,
      pushupCount: pushupCount ?? this.pushupCount,
      workoutMinutes: workoutMinutes ?? this.workoutMinutes,
      selectedCourseIds: selectedCourseIds ?? this.selectedCourseIds,
      hasPullUpBar: hasPullUpBar ?? this.hasPullUpBar,
      healthEnabled: healthEnabled ?? this.healthEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  /// Returns a copy with [hasPullUpBar] set to [value], allowing null.
  OnboardingState withHasPullUpBar(bool value) => OnboardingState(
        step: step,
        displayName: displayName,
        pushupCount: pushupCount,
        workoutMinutes: workoutMinutes,
        selectedCourseIds: selectedCourseIds,
        hasPullUpBar: value,
        healthEnabled: healthEnabled,
        reminderHour: reminderHour,
        reminderMinute: reminderMinute,
        isSaving: isSaving,
      );
}

// ── Notifier ─────────────────────────────────────────────────────────────────

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier(this._ref) : super(const OnboardingState());

  final Ref _ref;

  void setDisplayName(String value) =>
      state = state.copyWith(displayName: value.trim());

  void selectPushupCount(PushupCount value) =>
      state = state.copyWith(pushupCount: value);

  void selectWorkoutMinutes(WorkoutMinutes value) =>
      state = state.copyWith(workoutMinutes: value);

  void toggleCourse(CourseId course) {
    final current = List<CourseId>.from(state.selectedCourseIds);
    if (current.contains(course)) {
      if (current.length > 1) current.remove(course);
    } else {
      current.add(course);
    }
    state = state.copyWith(selectedCourseIds: current);
  }

  void selectHasPullUpBar(bool value) =>
      state = state.withHasPullUpBar(value);

  void selectHealthEnabled(bool value) =>
      state = state.copyWith(healthEnabled: value);

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
    final hasPullUpBar = state.hasPullUpBar ?? false;

    // Request Health permissions if the user opted in.
    bool healthGranted = false;
    if (state.healthEnabled) {
      healthGranted =
          await HealthService.instance.requestPermissions(readWeight: false);
    }

    // Create user profile with notification preferences and selected locale.
    final name = state.displayName.isNotEmpty ? state.displayName : null;
    final courseIds =
        state.selectedCourseIds.map((c) => c.index).toList();
    await userRepo.saveProfile(
      UserProfile(
        notificationHour: state.reminderHour,
        notificationMinute: state.reminderMinute,
        locale: _ref.read(localeProvider),
        preferredWorkoutMinutes: state.workoutMinutes?.minutes,
        hasPullUpBar: hasPullUpBar,
        displayName: name,
        healthWorkoutsEnabled: state.healthEnabled && healthGranted,
        activeCourseIds: courseIds,
        activeCourseIndex: 0,
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

    // Legs always starts at stage 1.
    await progressRepo.saveProgress(
      SkillProgress(
        branchId: BranchId.legs,
        currentStage: 1,
        currentReps: 10,
        currentSets: 1,
        currentRestSec: 45,
      ),
    );

    // Balance always starts at stage 1.
    await progressRepo.saveProgress(
      SkillProgress(
        branchId: BranchId.balance,
        currentStage: 1,
        currentReps: 20,
        currentSets: 1,
        currentRestSec: 30,
      ),
    );

    // Pull starts at stage 1 only if user has a pull-up bar.
    if (hasPullUpBar) {
      await progressRepo.saveProgress(
        SkillProgress(
          branchId: BranchId.pull,
          currentStage: 1,
          currentReps: 5,
          currentSets: 1,
          currentRestSec: 60,
        ),
      );
    }

    // Initialize Healthy Body branches if selected.
    if (state.selectedCourseIds.contains(CourseId.healthyBody)) {
      await progressRepo.saveProgress(
        SkillProgress(
          branchId: BranchId.posture,
          currentStage: 1,
          currentReps: 10,
          currentSets: 1,
          currentRestSec: 30,
        ),
      );
      await progressRepo.saveProgress(
        SkillProgress(
          branchId: BranchId.neck,
          currentStage: 1,
          currentReps: 15,
          currentSets: 1,
          currentRestSec: 15,
        ),
      );
    }

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
