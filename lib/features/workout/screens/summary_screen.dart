import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// Post-workout summary screen.
///
/// Expects a [Map<String, dynamic>] via [GoRouterState.extra] with:
///   - `spEarned`      — [int]
///   - `durationSec`   — [int]
///   - `exerciseCount` — [int]
class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key, required this.extras});

  final Map<String, dynamic> extras;

  @override
  Widget build(BuildContext context) {
    final spEarned = extras['spEarned'] as int? ?? 0;
    final durationSec = extras['durationSec'] as int? ?? 0;
    final exerciseCount = extras['exerciseCount'] as int? ?? 0;
    final freezeEarned = extras['freezeEarned'] as bool? ?? false;
    final freezeUsed = extras['freezeUsed'] as bool? ?? false;

    final mins = durationSec ~/ 60;
    final secs = durationSec % 60;
    final durationStr =
        mins > 0 ? '$mins мин $secs сек' : '$secs сек';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: SvgPicture.asset(
                  'assets/goro/goro_flex.svg',
                  height: 120,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Отличная тренировка!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Так держать — ещё один шаг вперёд 💪',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatTile(value: '+$spEarned', label: 'SP'),
                  _StatTile(value: durationStr, label: 'Время'),
                  _StatTile(value: '$exerciseCount', label: 'Упр.'),
                ],
              ),

              const SizedBox(height: 24),

              if (freezeUsed) const _FreezeUsedBanner(),
              if (freezeUsed && freezeEarned) const SizedBox(height: 10),
              if (freezeEarned) const _FreezeEarnedBanner(),

              const SizedBox(height: 28),

              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => context.go('/home'),
                child: const Text(
                  'Домой',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FreezeUsedBanner extends StatelessWidget {
  const _FreezeUsedBanner();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Text('❄️', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Заморозка сохранила стрик!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                'Серия продолжается — так держать',
                style: TextStyle(
                  fontSize: 12,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FreezeEarnedBanner extends StatelessWidget {
  const _FreezeEarnedBanner();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Text('❄️', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Получена заморозка стрика!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                'Используй, если пропустишь день',
                style: TextStyle(
                  fontSize: 12,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: scheme.primary,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: scheme.onSurfaceVariant,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}