/// Where to send the user for [uri], or null to stay on it. Pure: the router
/// only supplies the location and whether onboarding is finished.
///
/// - Nobody gets past the onboarding before it is done, deep links included
///   (there is no profile to train with).
/// - `caliday://workout` (the Home Screen widget) opens the workout screen.
/// - `caliday://friend?...` (a friend's QR code of a build before 0.9.5, which
///   had Friends, opened by the system camera) opens Home: scanning a code
///   must not start a training session.
/// - Any other `caliday://` link opens the workout screen as before.
/// - A finished onboarding is never shown again.
String? appRedirect({required Uri uri, required bool onboardingDone}) {
  final onOnboarding = uri.path.startsWith('/onboarding');

  if (!onboardingDone) return onOnboarding ? null : '/onboarding';
  if (uri.scheme == 'caliday') {
    return uri.host == 'friend' ? '/home' : '/workout';
  }
  if (onOnboarding) return '/home';
  return null;
}
