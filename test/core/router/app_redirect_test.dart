import 'package:caliday/core/router/app_redirect.dart';
import 'package:flutter_test/flutter_test.dart';

String? redirect(String uri, {required bool done}) =>
    appRedirect(uri: Uri.parse(uri), onboardingDone: done);

void main() {
  group('before onboarding is done', () {
    test('every screen leads to the onboarding', () {
      for (final path in ['/home', '/library', '/profile', '/workout', '/friends', '/settings']) {
        expect(redirect(path, done: false), '/onboarding', reason: path);
      }
    });

    test('the onboarding itself is left alone', () {
      expect(redirect('/onboarding', done: false), isNull);
      expect(redirect('/onboarding/step2', done: false), isNull);
    });

    test('deep links do not skip it either', () {
      expect(redirect('caliday://workout', done: false), '/onboarding');
      expect(redirect('caliday://friend?d=AqGy', done: false), '/onboarding');
    });
  });

  group('after onboarding', () {
    test('ordinary screens are left alone', () {
      for (final path in [
        '/home', '/library', '/library/exercises', '/profile', '/workout',
        '/summary', '/branch/push', '/friends', '/settings', '/about',
      ]) {
        expect(redirect(path, done: true), isNull, reason: path);
      }
    });

    test('the onboarding is never shown again', () {
      expect(redirect('/onboarding', done: true), '/home');
      expect(redirect('/onboarding/step2', done: true), '/home');
    });

    test('the Home Screen widget opens the workout', () {
      expect(redirect('caliday://workout', done: true), '/workout');
    });

    test('a friend QR code opened by the system camera opens the friends screen', () {
      // Not the workout: scanning a code must not start a training session.
      expect(redirect('caliday://friend?d=AqGyw9TlYGGCKTpLbG1-kA', done: true), '/friends');
      expect(redirect('caliday://friend?data=eyJ2IjoxfQ==', done: true), '/friends');
    });

    test('any other CaliDay link opens the workout as before', () {
      expect(redirect('caliday://', done: true), '/workout');
      expect(redirect('caliday://something/else', done: true), '/workout');
    });

    test('a link with another scheme is just a location', () {
      expect(redirect('https://example.com/home', done: true), isNull);
    });
  });

  test('the redirect target itself is stable: no redirect loops', () {
    for (final done in [true, false]) {
      for (final from in [
        '/home', '/onboarding', 'caliday://workout', 'caliday://friend?d=A', '/workout',
      ]) {
        final first = redirect(from, done: done);
        if (first == null) continue;
        expect(redirect(first, done: done), isNull,
            reason: '$from (done: $done) -> $first');
      }
    }
  });
}
