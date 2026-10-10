import 'package:caliday/core/providers/goro_expression_provider.dart';
import 'package:caliday/data/models/enums.dart';
import 'package:caliday/features/home/widgets/home_middle.dart';
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
