import 'package:caliday/data/static/release_notes_catalog.dart';
import 'package:caliday/features/profile/providers/whats_new_provider.dart';
import 'package:caliday/features/profile/widgets/whats_new_bell.dart';
import 'package:caliday/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class _Seen extends SeenReleaseNotifier {
  _Seen(this.start);
  final String? start;
  @override
  String? build() => start;
}

/// The bell on a throw-away router, so that opening it can be observed.
Future<List<String>> _pump(WidgetTester tester, {required String? seen}) async {
  final opened = <String>[];
  final router = GoRouter(routes: [
    GoRoute(path: '/', builder: (_, _) => Scaffold(appBar: AppBar(actions: const [WhatsNewBell()]))),
    GoRoute(
      path: '/whats-new',
      builder: (_, _) {
        opened.add('/whats-new');
        return const Scaffold(body: Text('notes'));
      },
    ),
  ]);
  await tester.pumpWidget(ProviderScope(
    overrides: [seenReleaseVersionProvider.overrideWith(() => _Seen(seen))],
    child: MaterialApp.router(
      routerConfig: router,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ),
  ));
  await tester.pumpAndSettle();
  return opened;
}

bool _dotShown(WidgetTester tester) =>
    tester.widget<Badge>(find.byType(Badge)).isLabelVisible;

void main() {
  testWidgets('a dot while there is an entry not opened yet', (tester) async {
    await _pump(tester, seen: '0.8.12');
    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    expect(_dotShown(tester), isTrue);
  });

  testWidgets('a user who has seen everything has no dot', (tester) async {
    await _pump(tester, seen: ReleaseNotesCatalog.latest.version);
    expect(_dotShown(tester), isFalse);
  });

  testWidgets('a user who has seen nothing has the dot', (tester) async {
    await _pump(tester, seen: null);
    expect(_dotShown(tester), isTrue);
  });

  testWidgets('tapping it opens "What\'s new"', (tester) async {
    final opened = await _pump(tester, seen: null);
    expect(find.byTooltip("What's new"), findsOneWidget);
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    expect(opened, ['/whats-new']);
    expect(find.text('notes'), findsOneWidget);
  });
}
