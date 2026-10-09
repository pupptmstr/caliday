import 'package:caliday/data/static/release_notes_catalog.dart';
import 'package:caliday/features/profile/providers/whats_new_provider.dart';
import 'package:caliday/features/profile/screens/whats_new_screen.dart';
import 'package:caliday/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

/// A stand-in that remembers what the screen did to it, without Hive.
class _FakeSeen extends SeenReleaseNotifier {
  _FakeSeen(this.start);

  final String? start;
  int marked = 0;

  @override
  String? build() => start;

  @override
  void markSeen() {
    marked++;
    state = ReleaseNotesCatalog.latest.version;
  }
}

Future<_FakeSeen> _open(WidgetTester tester, {required String? seen, String locale = 'en'}) async {
  // Tall enough for the whole list: a ListView only builds what is on screen.
  tester.view.physicalSize = const Size(800, 6000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await initializeDateFormatting(locale);
  final fake = _FakeSeen(seen);
  await tester.pumpWidget(ProviderScope(
    overrides: [seenReleaseVersionProvider.overrideWith(() => fake)],
    child: MaterialApp(
      locale: Locale(locale),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const WhatsNewScreen(),
    ),
  ));
  await tester.pump();
  return fake;
}

void main() {
  testWidgets('the newest versions are listed with their changes', (tester) async {
    await _open(tester, seen: ReleaseNotesCatalog.latest.version);
    expect(find.text("What's new"), findsOneWidget);
    expect(find.text('RECENT UPDATES'), findsOneWidget);
    for (final n in ReleaseNotesCatalog.recent) {
      expect(find.text('Version ${n.version}'), findsOneWidget, reason: n.version);
    }
    final older = ReleaseNotesCatalog.all.skip(ReleaseNotesCatalog.recentCount);
    expect(older, isNotEmpty);
    for (final n in older) {
      expect(find.text('Version ${n.version}'), findsNothing,
          reason: '${n.version} is kept, not shown');
    }
  });

  testWidgets('the history is folded until tapped, then shows every line', (tester) async {
    await _open(tester, seen: ReleaseNotesCatalog.latest.version);
    expect(find.text('VERSION HISTORY'), findsOneWidget);
    expect(find.text('Version 0.1'), findsNothing);

    await tester.tap(find.text('VERSION HISTORY'));
    await tester.pumpAndSettle();
    for (final line in ReleaseNotesCatalog.lines) {
      expect(find.text('Version ${line.version}'), findsOneWidget, reason: line.version);
    }
    expect(find.textContaining('The first version'), findsOneWidget);
    expect(find.text('February – March 2026'), findsOneWidget, reason: 'the span of 0.1');
    expect(find.text('NEW'), findsNothing, reason: 'lines are never tagged');

    await tester.tap(find.text('VERSION HISTORY'));
    await tester.pumpAndSettle();
    expect(find.text('Version 0.1'), findsNothing);
  });

  // Seen up to the third newest entry: the two above it are new.
  final twoBehind = ReleaseNotesCatalog.all[2].version;

  testWidgets('only the entries not seen yet are tagged NEW', (tester) async {
    await _open(tester, seen: twoBehind);
    expect(find.text('NEW'), findsNWidgets(2), reason: 'the two newest entries');
  });

  testWidgets('a user who is up to date sees no tag', (tester) async {
    await _open(tester, seen: ReleaseNotesCatalog.latest.version);
    expect(find.text('NEW'), findsNothing);
  });

  testWidgets('opening it marks the notes as seen, but the tags stay for this visit', (tester) async {
    final fake = await _open(tester, seen: twoBehind);
    await tester.pump();
    expect(fake.marked, 1);
    expect(fake.state, ReleaseNotesCatalog.latest.version);
    expect(find.text('NEW'), findsNWidgets(2),
        reason: 'the tags must not vanish under the reader\'s eyes');
  });

  testWidgets('in Russian', (tester) async {
    await _open(tester, seen: null, locale: 'ru');
    expect(find.text('Что нового'), findsOneWidget);
    expect(find.text('Версия ${ReleaseNotesCatalog.latest.version}'), findsOneWidget);
    expect(find.text('НОВОЕ'), findsNWidgets(ReleaseNotesCatalog.recent.length),
        reason: 'every shown entry is new to someone who saw none');
    expect(find.text('ИСТОРИЯ ВЕРСИЙ'), findsOneWidget);
    await tester.tap(find.text('ИСТОРИЯ ВЕРСИЙ'));
    await tester.pumpAndSettle();
    expect(find.text('Версия 0.1'), findsOneWidget);
    expect(find.text('февраль – март 2026 г.'), findsOneWidget);
  });
}
