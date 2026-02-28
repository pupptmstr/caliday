import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/user_repository.dart';
import '../../data/repositories/workout_repository.dart';
import '../../domain/services/streak_service.dart';

/// Текущее эмоциональное состояние маскота Горо.
enum GoroExpression { happy, sad, angry, sleeping, excited, supportive }

extension GoroExpressionAsset on GoroExpression {
  /// Путь к SVG-ассету для данного выражения.
  String get assetPath => 'assets/goro/goro_face_$name.svg';
}

/// Вычисляет текущее выражение Горо на основе контекста:
/// времени суток, факта тренировки сегодня и состояния стрика.
///
/// Приоритет (сверху вниз):
/// 23:00–06:00                    → sleeping
/// hasWorkoutToday                → happy
/// hour ≥ 22 && streak > 0        → angry  (стрик горит)
/// hour ≥ 20 && !hasWorkoutToday  → sad    (вечер, не занимался)
/// daysSince ≥ 2                  → supportive (возврат после пропуска)
/// default                        → happy
final goroExpressionProvider = Provider.autoDispose<GoroExpression>((ref) {
  final profile = ref.watch(userRepositoryProvider).getProfile();
  final hasWorkoutToday =
      ref.watch(workoutRepositoryProvider).hasWorkoutToday();
  final displayStreak = ref.watch(displayStreakProvider);
  final streakService = ref.read(streakServiceProvider);
  final hour = DateTime.now().hour;

  if (hour >= 23 || hour < 6) return GoroExpression.sleeping;
  if (hasWorkoutToday) return GoroExpression.happy;
  if (hour >= 22 && displayStreak > 0) return GoroExpression.angry;
  if (hour >= 20) return GoroExpression.sad;
  final days = streakService.daysSinceLastWorkout(profile);
  if (days >= 2) return GoroExpression.supportive;
  return GoroExpression.happy;
});
