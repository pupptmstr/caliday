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
  testWidgets('every version is listed with its changes', (tester) async {
    await _open(tester, seen: ReleaseNotesCatalog.latest.version);
    expect(find.text("What's new"), findsOneWidget);
    expect(find.text('Version ${ReleaseNotesCatalog.latest.version}'), findsOneWidget);
    expect(find.textContaining('A bell in the profile'), findsOneWidget);
  });

  testWidgets('only the entries not seen yet are tagged NEW', (tester) async {
    await _open(tester, seen: '0.8.13');
    expect(find.text('NEW'), findsNWidgets(2), reason: '0.8.15 and 0.8.14');
  });

  testWidgets('a user who is up to date sees no tag', (tester) async {
    await _open(tester, seen: ReleaseNotesCatalog.latest.version);
    expect(find.text('NEW'), findsNothing);
  });

  testWidgets('opening it marks the notes as seen, but the tags stay for this visit', (tester) async {
    final fake = await _open(tester, seen: '0.8.13');
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
    expect(find.text('НОВОЕ'), findsNWidgets(ReleaseNotesCatalog.all.length));
  });
}
