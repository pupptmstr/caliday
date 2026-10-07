import 'package:caliday/l10n/app_localizations_en.dart';
import 'package:caliday/l10n/app_localizations_ru.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/all_translations.dart';

void main() {
  test('every language: a counted message always carries its number', () {
    // A plural branch that drops the number ("one{a day}") reads fine in one
    // language and says nothing in the next one.
    for (final l10n in allTranslations) {
      for (final n in [0, 1, 2, 3, 5, 11, 21, 22, 101]) {
        for (final text in [
          l10n.homeStreakDays(n),
          l10n.exerciseLibraryCount(n),
          l10n.rankDecayWarning(n),
          l10n.notificationStreakLostBody(n),
          l10n.profileFriendsCount(n),
          l10n.customWorkoutExerciseCount(n),
          l10n.summaryBonusCount(n),
          l10n.friendsScanConfirmBody(500, n),
          l10n.homeChallengeNormReps(n),
          l10n.workoutAmountReps(n),
          l10n.historyDetailReps(0, n),
          l10n.branchJourneyParams(n, n, 60),
          l10n.branchJourneyParamsTimed(30, n, 60),
        ]) {
          expect(text, contains('$n'), reason: '${l10n.localeName}: $text');
        }
      }
    }
  });

  group('Russian day plurals', () {
    final ru = AppLocalizationsRu();

    test('homeStreakDays picks the right form', () {
      const expected = {
        0: '0 дней',
        1: '1 день',
        2: '2 дня',
        4: '4 дня',
        5: '5 дней',
        11: '11 дней',
        12: '12 дней',
        14: '14 дней',
        21: '21 день',
        22: '22 дня',
        25: '25 дней',
        101: '101 день',
      };
      expected.forEach((n, text) {
        expect(ru.homeStreakDays(n), text, reason: '$n');
      });
    });

    test('rankDecayWarning declines the number of days', () {
      expect(ru.rankDecayWarning(21), contains('21 день'));
      expect(ru.rankDecayWarning(23), contains('23 дня'));
      expect(ru.rankDecayWarning(35), contains('35 дней'));
    });

    test('exerciseLibraryCount names the exercises', () {
      const expected = {
        0: '0 упражнений',
        1: '1 упражнение',
        2: '2 упражнения',
        4: '4 упражнения',
        5: '5 упражнений',
        11: '11 упражнений',
        21: '21 упражнение',
        22: '22 упражнения',
        25: '25 упражнений',
        61: '61 упражнение',
      };
      expected.forEach((n, text) {
        expect(ru.exerciseLibraryCount(n), text, reason: '$n');
      });
    });
  });

  group('Russian counted nouns', () {
    final ru = AppLocalizationsRu();

    test('friends, exercises, times, a friend\'s streak', () {
      const friends = {1: '1 друг', 2: '2 друга', 5: '5 друзей', 11: '11 друзей', 21: '21 друг'};
      friends.forEach((n, t) => expect(ru.profileFriendsCount(n), t, reason: '$n'));
      const exercises = {1: '1 упражнение', 3: '3 упражнения', 5: '5 упражнений', 21: '21 упражнение'};
      exercises.forEach((n, t) => expect(ru.customWorkoutExerciseCount(n), t, reason: '$n'));
      expect(ru.summaryBonusCount(2), contains('2 раза'));
      expect(ru.summaryBonusCount(5), contains('5 раз!'));
      expect(ru.summaryBonusCount(22), contains('22 раза'));
      expect(ru.friendsScanConfirmBody(500, 1), endsWith('стрик 1 день'));
      expect(ru.friendsScanConfirmBody(500, 3), endsWith('стрик 3 дня'));
      expect(ru.friendsScanConfirmBody(500, 12), endsWith('стрик 12 дней'));
    });
  });

  group('English counted nouns: one is singular', () {
    final en = AppLocalizationsEn();

    test('friends, exercises, times', () {
      expect(en.profileFriendsCount(1), '1 friend');
      expect(en.profileFriendsCount(4), '4 friends');
      expect(en.customWorkoutExerciseCount(1), '1 exercise');
      expect(en.customWorkoutExerciseCount(6), '6 exercises');
      expect(en.summaryBonusCount(1), contains('1 time today'));
      expect(en.summaryBonusCount(3), contains('3 times today'));
    });

    test('reps and sets (many first stages have 1 set; the hardest norms are 1 rep)', () {
      expect(en.workoutAmountReps(1), '1 rep');
      expect(en.workoutAmountReps(8), '8 reps');
      expect(en.homeChallengeNormReps(1), 'Goal: 1 rep');
      expect(en.historyDetailReps(1, 1), '1 / 1 rep');
      expect(en.branchJourneyParams(5, 1, 60), startsWith('5 reps × 1 set  ·'));
      expect(en.branchJourneyParams(1, 3, 60), startsWith('1 rep × 3 sets  ·'));
      expect(en.branchJourneyParamsTimed(30, 1, 60), startsWith('30 s × 1 set  ·'));
      expect(en.workoutNextSet(2, en.workoutAmountReps(1)), 'Next: set 2 • 1 rep');
    });
  });

  group('English day plurals', () {
    final en = AppLocalizationsEn();

    test('homeStreakDays', () {
      expect(en.homeStreakDays(0), '0 days');
      expect(en.homeStreakDays(1), '1 day');
      expect(en.homeStreakDays(2), '2 days');
    });

    test('rankDecayWarning', () {
      expect(en.rankDecayWarning(21), contains('21 days'));
      expect(en.rankDecayWarning(1), contains('1 day '));
    });

    test('exerciseLibraryCount', () {
      expect(en.exerciseLibraryCount(0), '0 exercises');
      expect(en.exerciseLibraryCount(1), '1 exercise');
      expect(en.exerciseLibraryCount(2), '2 exercises');
    });
  });
}
