import 'package:treniday/core/providers/goro_expression_provider.dart';
import 'package:treniday/data/models/enums.dart';
import 'package:treniday/features/home/widgets/home_middle.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/all_translations.dart';

/// The moods Home can show before the first workout of the day.
const _moods = [
  GoroExpression.happy,
  GoroExpression.sad,
  GoroExpression.angry,
  GoroExpression.supportive,
  GoroExpression.sleeping,
];

void main() {
  test('every host has four lines of its own for every mood, in every language',
      () {
    for (final l10n in allTranslations) {
      for (final host in CourseId.values) {
        final all = <String>[];
        for (final mood in _moods) {
          final lines = HostLineCard.linesFor(l10n, host, mood);
          final where = '${l10n.localeName} ${host.name} ${mood.name}';
          expect(lines, hasLength(4), reason: where);
          for (final line in lines) {
            expect(line.trim(), isNotEmpty, reason: where);
            expect(line.length, lessThanOrEqualTo(80),
                reason: '$where: fits two lines of the bubble — "$line"');
          }
          all.addAll(lines);
        }
        expect(all.toSet(), hasLength(all.length),
            reason: '${l10n.localeName} ${host.name}: no line twice');
      }
    }
  });

  test('the host greets by name in every language, at any hour', () {
    for (final l10n in allTranslations) {
      final greetings = <String>{};
      for (var hour = 0; hour < 24; hour++) {
        final g = HostLineCard.greetingFor(l10n, '  Alexandra ', hour)!;
        expect(g, contains('Alexandra'), reason: '${l10n.localeName} $hour');
        expect(g, isNot(contains(' Alexandra ')),
            reason: 'the name is trimmed');
        expect(g.length, lessThanOrEqualTo(40), reason: g);
        greetings.add(g);
      }
      expect(greetings, hasLength(4),
          reason: '${l10n.localeName}: one greeting per part of the day');
      expect(HostLineCard.greetingFor(l10n, null, 9), isNull);
      expect(HostLineCard.greetingFor(l10n, '   ', 9), isNull);
    }
  });

  test('the hosts do not share their happy lines', () {
    for (final l10n in allTranslations) {
      final happy = [
        for (final host in CourseId.values)
          ...HostLineCard.linesFor(l10n, host, GoroExpression.happy),
      ];
      expect(happy.toSet(), hasLength(happy.length), reason: l10n.localeName);
    }
  });
}
