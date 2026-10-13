/// Where to send the user for [uri], or null to stay on it. Pure: the router
/// only supplies the location and whether onboarding is finished.
///
/// - Nobody gets past the onboarding before it is done, deep links included
///   (there is no profile to train with).
/// - `treniday://…` links come from the home-screen widgets: see
///   [deepLinkTarget].
/// - A finished onboarding is never shown again.
String? appRedirect({required Uri uri, required bool onboardingDone}) {
  final onOnboarding = uri.path.startsWith('/onboarding');

  if (!onboardingDone) return onOnboarding ? null : '/onboarding';
  if (uri.scheme == 'treniday') return deepLinkTarget(uri);
  if (onOnboarding) return '/home';
  return null;
}

/// Where a `treniday://` link opens:
/// - `workout` (the Today widget) the workout screen;
/// - `home` (the Goro widget) Home;
/// - `calendar` (the Streak widget) the workout calendar;
/// - `profile` (the Rank widget) the Profile;
/// - `friend?...` (a friend's QR code of a build before 0.9.5, which had
///   Friends, opened by the system camera) Home: scanning a code must not
///   start a training session;
/// - any other the workout screen, as the only widget link once did.
String deepLinkTarget(Uri uri) => switch (uri.host) {
  'home' || 'friend' => '/home',
  'calendar' => '/calendar',
  'profile' => '/profile',
  _ => '/workout',
};
