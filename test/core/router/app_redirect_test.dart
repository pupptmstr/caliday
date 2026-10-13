import 'package:treniday/core/router/app_redirect.dart';
import 'package:flutter_test/flutter_test.dart';

String? redirect(String uri, {required bool done}) =>
    appRedirect(uri: Uri.parse(uri), onboardingDone: done);

void main() {
  group('before onboarding is done', () {
    test('every screen leads to the onboarding', () {
      for (final path in ['/home', '/library', '/profile', '/workout', '/settings']) {
        expect(redirect(path, done: false), '/onboarding', reason: path);
      }
    });

    test('the onboarding itself is left alone', () {
      expect(redirect('/onboarding', done: false), isNull);
      expect(redirect('/onboarding/step2', done: false), isNull);
    });

    test('deep links do not skip it either', () {
      expect(redirect('treniday://workout', done: false), '/onboarding');
      expect(redirect('treniday://friend?d=AqGy', done: false), '/onboarding');
    });
  });

  group('after onboarding', () {
    test('ordinary screens are left alone', () {
      for (final path in [
        '/home', '/library', '/library/exercises', '/profile', '/workout',
        '/summary', '/branch/push', '/settings', '/about',
      ]) {
        expect(redirect(path, done: true), isNull, reason: path);
      }
    });

    test('the onboarding is never shown again', () {
      expect(redirect('/onboarding', done: true), '/home');
      expect(redirect('/onboarding/step2', done: true), '/home');
    });

    test('each home-screen widget opens its place', () {
      expect(redirect('treniday://workout', done: true), '/workout');
      expect(redirect('treniday://home', done: true), '/home');
      expect(redirect('treniday://calendar', done: true), '/calendar');
      expect(redirect('treniday://profile', done: true), '/profile');
    });

    test('a widget link before the onboarding still waits for it', () {
      for (final link in ['treniday://home', 'treniday://calendar', 'treniday://profile']) {
        expect(redirect(link, done: false), '/onboarding');
      }
    });

    test('an old friend QR code opened by the system camera opens Home', () {
      // Friends are gone (0.9.5); scanning a code must not start a workout.
      expect(redirect('treniday://friend?d=AqGyw9TlYGGCKTpLbG1-kA', done: true), '/home');
      expect(redirect('treniday://friend?data=eyJ2IjoxfQ==', done: true), '/home');
    });

    test('any other TreniDay link opens the workout as before', () {
      expect(redirect('treniday://', done: true), '/workout');
      expect(redirect('treniday://something/else', done: true), '/workout');
    });

    test('a link with another scheme is just a location', () {
      expect(redirect('https://example.com/home', done: true), isNull);
    });
  });

  test('the redirect target itself is stable: no redirect loops', () {
    for (final done in [true, false]) {
      for (final from in [
        '/home', '/onboarding', 'treniday://workout', 'treniday://friend?d=A', '/workout',
      ]) {
        final first = redirect(from, done: done);
        if (first == null) continue;
        expect(redirect(first, done: done), isNull,
            reason: '$from (done: $done) -> $first');
      }
    }
  });
}
