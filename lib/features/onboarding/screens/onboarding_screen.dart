import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        child: Column(
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
    final label = state.isLastStep ? 'Начать тренировку 🔥' : 'Продолжить';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🏋️', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 24),
          Text(
            'Привет! Я CaliDay',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Короткие сеты, прокачка навыков, стрики и очки.\nОт отжиманий с колен до стойки на руках — шаг за шагом.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Настроим всё под тебя за 1 минуту',
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

    return _StepScaffold(
      question: 'Как часто ты занимаешься спортом?',
      children: FitnessFrequency.values
          .map(
            (v) => OptionCard(
              emoji: v.emoji,
              label: v.label,
              description: v.description,
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

    return _StepScaffold(
      question: 'Сколько отжиманий ты можешь сделать?',
      children: PushupCount.values
          .map(
            (v) => OptionCard(
              emoji: v.emoji,
              label: v.label,
              description: v.description,
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

    return _StepScaffold(
      question: 'Сколько минут в день готов уделять?',
      children: WorkoutMinutes.values
          .map(
            (v) => OptionCard(
              emoji: v.emoji,
              label: v.label,
              description: v.description,
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

    return _StepScaffold(
      question: 'К чему ты стремишься?',
      children: FitnessGoal.values
          .map(
            (v) => OptionCard(
              emoji: v.emoji,
              label: v.label,
              description: v.description,
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
    (7, 0, '07:00', '☀️ Утро'),
    (8, 0, '08:00', '🌅 Утро'),
    (9, 0, '09:00', '🌤 День'),
    (12, 0, '12:00', '🌞 Обед'),
    (18, 0, '18:00', '🌆 Вечер'),
    (20, 0, '20:00', '🌙 Вечер'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hour = ref.watch(
        onboardingProvider.select((s) => s.reminderHour));
    final minute = ref.watch(
        onboardingProvider.select((s) => s.reminderMinute));
    final notifier = ref.read(onboardingProvider.notifier);

    return _StepScaffold(
      question: 'Во сколько напомнить о тренировке?',
      children: _presets.map((p) {
        final isSelected = hour == p.$1 && minute == p.$2;
        return OptionCard(
          emoji: p.$4.split(' ')[0],
          label: p.$3,
          description: p.$4.split(' ')[1],
          isSelected: isSelected,
          onTap: () => notifier.selectReminderTime(p.$1, p.$2),
        );
      }).toList(),
    );
  }
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