import 'package:flutter/material.dart';
import 'package:caliday/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../data/models/enums.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/option_card.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final currentLocale = ref.watch(localeProvider);

    // Animate to the new step whenever it changes.
    ref.listen<int>(
      onboardingProvider.select((s) => s.step),
      (_, next) => _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _TopBar(
                  step: state.step,
                  onBack: state.step > 0
                      ? () => ref.read(onboardingProvider.notifier).previousStep()
                      : null,
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _WelcomeStep(),
                      _FrequencyStep(),
                      _PushupStep(),
                      _DurationStep(),
                      _GoalStep(),
                      _ReminderStep(),
                    ],
                  ),
                ),
                _BottomButton(state: state),
              ],
            ),

            // Language toggle — visible only on the welcome step.
            if (state.step == 0)
              Positioned(
                top: 10,
                right: 16,
                child: _LanguageToggle(
                  currentLocale: currentLocale,
                  onChanged: (locale) {
                    ref.read(localeProvider.notifier).state = locale;
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Language toggle ───────────────────────────────────────────────────────────

class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle({
    required this.currentLocale,
    required this.onChanged,
  });

  final String currentLocale;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LangButton(
          label: 'RU',
          selected: currentLocale == 'ru',
          onTap: () => onChanged('ru'),
          scheme: scheme,
        ),
        const SizedBox(width: 4),
        _LangButton(
          label: 'EN',
          selected: currentLocale == 'en',
          onTap: () => onChanged('en'),
          scheme: scheme,
        ),
      ],
    );
  }
}

class _LangButton extends StatelessWidget {
  const _LangButton({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.scheme,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? scheme.primary : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// ── Top bar with progress dots ────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({required this.step, required this.onBack});

  final int step;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Back button — invisible on step 0 to keep layout stable.
          SizedBox(
            width: 40,
            child: onBack != null
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: onBack,
                    padding: EdgeInsets.zero,
                  )
                : null,
          ),
          // Progress dots (steps 1–5; step 0 is the welcome page).
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(OnboardingState.lastStep, (i) {
                final filled = i < step;
                final active = i == step - 1;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: filled || active
                        ? scheme.primary
                        : scheme.outlineVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 40), // mirror of back button
        ],
      ),
    );
  }
}

// ── Bottom CTA button ─────────────────────────────────────────────────────────

class _BottomButton extends ConsumerWidget {
  const _BottomButton({required this.state});

  final OnboardingState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final notifier = ref.read(onboardingProvider.notifier);
    final l10n = context.l10n;
    final label = state.isLastStep ? l10n.onboardingStart : l10n.onboardingContinue;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor:
                state.canAdvance ? scheme.primary : scheme.surfaceContainerHighest,
            foregroundColor:
                state.canAdvance ? scheme.onPrimary : scheme.onSurfaceVariant,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: state.canAdvance && !state.isSaving
              ? () async {
                  if (state.isLastStep) {
                    await notifier.completeOnboarding();
                  } else {
                    notifier.nextStep();
                  }
                }
              : null,
          child: state.isSaving
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              : Text(
                  label,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700),
                ),
        ),
      ),
    );
  }
}

// ── Step 0: Welcome ───────────────────────────────────────────────────────────

class _WelcomeStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/goro/goro_face.svg', height: 120),
          const SizedBox(height: 24),
          Text(
            l10n.onboardingWelcomeTitle,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.onboardingWelcomeBody,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.onboardingWelcomeCta,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Step 1: Fitness frequency ─────────────────────────────────────────────────

class _FrequencyStep extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(
        onboardingProvider.select((s) => s.fitnessFrequency));
    final notifier = ref.read(onboardingProvider.notifier);
    final l10n = context.l10n;

    return _StepScaffold(
      question: l10n.onboardingQ1,
      children: FitnessFrequency.values
          .map(
            (v) => OptionCard(
              emoji: v.emoji,
              label: v.localizedLabel(l10n),
              description: v.localizedDescription(l10n),
              isSelected: selected == v,
              onTap: () => notifier.selectFitnessFrequency(v),
            ),
          )
          .toList(),
    );
  }
}

// ── Step 2: Pushup count ──────────────────────────────────────────────────────

class _PushupStep extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected =
        ref.watch(onboardingProvider.select((s) => s.pushupCount));
    final notifier = ref.read(onboardingProvider.notifier);
    final l10n = context.l10n;

    return _StepScaffold(
      question: l10n.onboardingQ2,
      children: PushupCount.values
          .map(
            (v) => OptionCard(
              emoji: v.emoji,
              label: v.label, // numeric labels are locale-agnostic
              description: v.localizedDescription(l10n),
              isSelected: selected == v,
              onTap: () => notifier.selectPushupCount(v),
            ),
          )
          .toList(),
    );
  }
}

// ── Step 3: Workout duration ──────────────────────────────────────────────────

class _DurationStep extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected =
        ref.watch(onboardingProvider.select((s) => s.workoutMinutes));
    final notifier = ref.read(onboardingProvider.notifier);
    final l10n = context.l10n;

    return _StepScaffold(
      question: l10n.onboardingQ3,
      children: WorkoutMinutes.values
          .map(
            (v) => OptionCard(
              emoji: v.emoji,
              label: l10n.minutesLabel(v.minutes),
              description: v.localizedDescription(l10n),
              isSelected: selected == v,
              onTap: () => notifier.selectWorkoutMinutes(v),
            ),
          )
          .toList(),
    );
  }
}

// ── Step 4: Fitness goal ──────────────────────────────────────────────────────

class _GoalStep extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected =
        ref.watch(onboardingProvider.select((s) => s.fitnessGoal));
    final notifier = ref.read(onboardingProvider.notifier);
    final l10n = context.l10n;

    return _StepScaffold(
      question: l10n.onboardingQ4,
      children: FitnessGoal.values
          .map(
            (v) => OptionCard(
              emoji: v.emoji,
              label: v.localizedLabel(l10n),
              description: v.localizedDescription(l10n),
              isSelected: selected == v,
              onTap: () => notifier.selectFitnessGoal(v),
            ),
          )
          .toList(),
    );
  }
}

// ── Step 5: Reminder time ─────────────────────────────────────────────────────

class _ReminderStep extends ConsumerWidget {
  static const _presets = [
    (7, 0, '07:00', '☀️', _TimeLabel.morning),
    (8, 0, '08:00', '🌅', _TimeLabel.morning),
    (9, 0, '09:00', '🌤', _TimeLabel.day),
    (12, 0, '12:00', '🌞', _TimeLabel.lunch),
    (18, 0, '18:00', '🌆', _TimeLabel.evening),
    (20, 0, '20:00', '🌙', _TimeLabel.evening),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hour = ref.watch(
        onboardingProvider.select((s) => s.reminderHour));
    final minute = ref.watch(
        onboardingProvider.select((s) => s.reminderMinute));
    final notifier = ref.read(onboardingProvider.notifier);
    final l10n = context.l10n;

    return _StepScaffold(
      question: l10n.onboardingQ5,
      children: _presets.map((p) {
        final isSelected = hour == p.$1 && minute == p.$2;
        return OptionCard(
          emoji: p.$4,
          label: p.$3,
          description: p.$5.localizedLabel(l10n),
          isSelected: isSelected,
          onTap: () => notifier.selectReminderTime(p.$1, p.$2),
        );
      }).toList(),
    );
  }
}

enum _TimeLabel { morning, day, lunch, evening }

extension _TimeLabelL10n on _TimeLabel {
  String localizedLabel(AppLocalizations l10n) => switch (this) {
        _TimeLabel.morning => l10n.timeOfDayMorning,
        _TimeLabel.day => l10n.timeOfDayDay,
        _TimeLabel.lunch => l10n.timeOfDayLunch,
        _TimeLabel.evening => l10n.timeOfDayEvening,
      };
}

// ── Shared step scaffold ──────────────────────────────────────────────────────

class _StepScaffold extends StatelessWidget {
  const _StepScaffold({
    required this.question,
    required this.children,
  });

  final String question;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 24),
          ...children.map((child) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: child,
              )),
        ],
      ),
    );
  }
}

// ── Localization extensions for onboarding enums ──────────────────────────────

extension FitnessFrequencyL10n on FitnessFrequency {
  String localizedLabel(AppLocalizations l10n) => switch (this) {
        FitnessFrequency.never => l10n.frequencyNeverLabel,
        FitnessFrequency.sometimes => l10n.frequencySometimesLabel,
        FitnessFrequency.regular => l10n.frequencyRegularLabel,
      };

  String localizedDescription(AppLocalizations l10n) => switch (this) {
        FitnessFrequency.never => l10n.frequencyNeverDesc,
        FitnessFrequency.sometimes => l10n.frequencySometimesDesc,
        FitnessFrequency.regular => l10n.frequencyRegularDesc,
      };
}

extension PushupCountL10n on PushupCount {
  String localizedDescription(AppLocalizations l10n) => switch (this) {
        PushupCount.zero => l10n.pushupZeroDesc,
        PushupCount.oneToFive => l10n.pushupOneToFiveDesc,
        PushupCount.fiveToFifteen => l10n.pushupFiveToFifteenDesc,
        PushupCount.moreThan15 => l10n.pushupMoreThan15Desc,
      };
}

extension WorkoutMinutesL10n on WorkoutMinutes {
  String localizedDescription(AppLocalizations l10n) => switch (this) {
        WorkoutMinutes.five => l10n.minutesFiveDesc,
        WorkoutMinutes.ten => l10n.minutesTenDesc,
        WorkoutMinutes.fifteen => l10n.minutesFifteenDesc,
      };
}

extension FitnessGoalEmoji on FitnessGoal {
  String get emoji => switch (this) {
        FitnessGoal.generalFitness => '🏃',
        FitnessGoal.strengthPush => '💪',
        FitnessGoal.calisthenics => '🤸',
      };
}

extension FitnessGoalL10n on FitnessGoal {
  String localizedLabel(AppLocalizations l10n) => switch (this) {
        FitnessGoal.generalFitness => l10n.goalGeneralLabel,
        FitnessGoal.strengthPush => l10n.goalStrengthLabel,
        FitnessGoal.calisthenics => l10n.goalCalisthenicsLabel,
      };

  String localizedDescription(AppLocalizations l10n) => switch (this) {
        FitnessGoal.generalFitness => l10n.goalGeneralDesc,
        FitnessGoal.strengthPush => l10n.goalStrengthDesc,
        FitnessGoal.calisthenics => l10n.goalCalisthenicsDesc,
      };
}
