# Platforms: notifications, widgets, Health, iOS, Android, web, CI

> Part of the project notes — the index is [internal_docs/README.md](../README.md).

## Notifications

| ID | Key | When |
|----|-----|------|
| 1 | `morning` | Morning reminder |
| 2 | `evening` | Evening reminder |
| 3 | `streak` | Streak at risk (~22:00 if no workout today) |
| 4 | `streak_lost` | Streak lost: morning (reminder time +30 min) of `StreakService.streakLostDate` — 2 days after the last workout, 3 with a freeze; only if streak≥2 and notifications are on |
| 5 | `rank_risk` | Rank at risk: 14 days after the last workout (reminder time) |

The key is the Android channel id; the ids never change (`NotificationKind`).

**Texts** are ARB messages (`notificationMorningTitle` … `notificationRankAtRiskBody`; the streak-lost body is a plural of the days) read without a BuildContext: `NotificationPlanner.textsFor(profile.locale)` = `l10nFor(locale ?? 'ru')` — Russian when the profile has no language (the old default of `UserProfile.locale`), English for one the app is not translated into. A new language gets its notifications with its ARB file.

**Who does what.** `NotificationPlanner` (`domain/services/notification_planner.dart`, pure) takes the profile and `now` (a `tz.TZDateTime`) and returns the list of `PlannedNotification`s; `NotificationService` only cancels and hands that list to `flutter_local_notifications`. A repeating reminder takes its time of day from the first date, so "tomorrow" is computed from the calendar date, never as `now + 24 h` — on a DST change that lands an hour off and stays there (this was a bug; `notification_planner_test.dart` pins it for Berlin 2026-03-29 and 2026-10-25).

## Home-screen widgets (0.9.7)

Four widgets, agreed with the owner on a mock-up (2026-10-12): Goro everywhere (not the course hosts), the brand-blue gradient of Home's hero, Goro cut out of his tile on a soft glow, the streak always orange, done in green.

| Widget | iOS kind / Android provider | Sizes | Shows | Tap |
|--------|-----------------------------|-------|-------|-----|
| Today | `TreniDayWidget` / `TreniDayWidgetReceiver` | small, medium, large; iOS lock screen rectangular; Android one resizable widget 2×2 … 4×4 | Goro's pose of the day (flex once trained), the streak, freezes, SP and rank, the week (Monday first), the day's plan ("5 exercises · ≈ 9 min", the large one lists the exercises with their amounts) or "Done · +45 SP" (the large one: today's SP and how the branches grew), the way to the next rank | `treniday://workout` |
| Goro | `TreniDayGoroWidget` / `GoroWidgetReceiver` | small | Goro's face by the mood of the day (the rules of `goroExpressionProvider`), a night sky with stars while he sleeps, the streak chip | `treniday://home` |
| Streak | `TreniDayStreakWidget` / `StreakWidgetReceiver` | small; iOS lock screen circular and inline ("🔥 12 days · Athlete") | the big orange number on a dark ember, "days", three snowflakes (the freezes held), the week | `treniday://calendar` |
| Rank | `TreniDayRankWidget` / `RankWidgetReceiver` | small, medium; iOS lock screen circular (a ring) | another pose of the day, the rank, SP, the bar and "760 SP to Champion" (or "Top rank") | `treniday://profile` |

**The data.** `WidgetSnapshot.build` (`lib/core/services/widget_snapshot.dart`, pure, `test/core/widget_snapshot_test.dart`) decides everything the widgets show and every text, in the app's language from the ARB files (native resources would follow the system language); `WidgetService.update(snapshot)` writes it (`home_widget`: the App Group `group.com.pupptmstr.treniday` on iOS, `HomeWidgetPreferences` on Android) and asks every kind / provider to redraw. `HomeWidgetSync.push()` (`features/home/providers/home_widget_sync.dart`) builds the snapshot from the repositories: at start-up, after a workout, after a language change and whenever the app is hidden (`AppLifecycleListener.onHide` — the plan follows the course, the workout size, the bar…, so leaving the app is when the widgets catch up). Not on the web.

**The widgets decide by the moment they render**, because they draw without the app, often hours or days after the snapshot. The snapshot carries the days (`day`, `lastWorkoutDay`, `trainedDays` of the last 14 days, as "2026-10-12"), and the native code applies the app's rules — mirrored in `ios/TreniDayWidget/WidgetState.swift` and `android/.../WidgetState.kt`; change all three together:
- done today = `trainedDays` holds the render day; the plan, the SP of the day and the growth only while `day` is the render day (else "Time to train");
- the streak shown = `streak` while the last workout is today or yesterday, or two days ago with a freeze left, else 0 (`HomeData.displayStreak`); `streakText` / `streakZeroText` give the plural for either;
- Goro's face: asleep 23–6, happy after a workout, angry from 22 with a streak to lose, sad from 20, supportive after two days without one;
- the pose of the day: calendar days since 2024-01-01 modulo the six fun poses (the same list in both files; a test compares them), the Rank widget three poses further.

iOS: one timeline for all four kinds, an entry now and at 0, 6, 20, 22 and 23 o'clock for a day (`policy: .atEnd`). Android: `updatePeriodMillis` 30 min (the mood and the day catch up within half an hour), and a resize re-renders (`onAppWidgetOptionsChanged`).

**The art** is rendered from the app's SVGs by `tools/characters/export_widget_art.py` (headless Chrome; the tile left out, cropped to the figure, 384 px): `ios/TreniDayWidget/Assets.xcassets/goro_*.imageset` and `android/app/src/main/res/drawable-nodpi/goro_*.png` — 5 faces, 6 poses, flex. Run it after redrawing any of them.

**Texts the app cannot hand over:** the names and descriptions in the widget galleries, shown before the app has ever run — `gallery()` in `TreniDayWidget.swift` (a table per app language, by `Locale.preferredLanguages`) and `res/values*/widget_strings.xml` on Android (the system language). `widget_service_test` checks both have every app language, that Russian appears nowhere else in the native code, that both platforms read every snapshot key, the pose lists match, the art is the same on both, every kind / provider is declared, and each widget link opens a place of its own.

**iOS specifics.** `WidgetState.swift` (data and rules), `WidgetViews.swift` (all the views; `widgetBackground` = `containerBackground` on iOS 17+, padding + background on 16), `TreniDayWidget.swift` (the `WidgetBundle`, the gallery table); the extension's deployment target is 16 like the app (lock-screen families need 16, so no `#available` for them). The Goro glow fades out at the inscribed circle of its frame (a fixed radius left a visible square). Lock-screen widgets are drawn by iOS in one colour, so they use SF Symbols and text, not Goro.

**Android specifics.** `TreniDayWidgets.kt` (the four providers on `SizedWidget`: on Android 12+ a `RemoteViews(Map<SizeF, RemoteViews>)` lets the launcher pick small / medium / large while resizing, below that the reported size picks one; thresholds 250 dp wide, 280 dp high), `WidgetState.kt`, layouts `res/layout/widget_*.xml` (the week is an `<include>`), drawables `widget_*` / `ic_widget_*`, provider infos `res/xml/widget_*_info.xml` with `previewLayout`. RemoteViews quirks: a plain `View` is not allowed (spacers are empty `FrameLayout`s, the divider an `ImageView`); an action on a view id the layout does not have is skipped, so one fill function can serve several layouts; the root's background changes through `setInt(…, "setBackgroundResource", …)`, an image's alpha through `setImageAlpha`.

**Checked (2026-10-12)** in the iOS 27 simulator (iPhone 17 Pro: every kind and size in the gallery and on the home screen, the four lock-screen widgets) and the Android 17 emulator (Today 4×2 and 4×4, Goro, Streak; the widget tap opened the workout; leaving the app after a debug workout redrew all three).

## iOS specifics

- **Xcode 27 needs a deployment target of 15 or more**; the app and the widget are at **16** (`IPHONEOS_DEPLOYMENT_TARGET` in `project.pbxproj`, `platform :ios, '16.0'` in the Podfile, whose `post_install` raises any pod below 16 — some plugins still declare 11–14).
- **Plugins come through Swift Package Manager** since Flutter 3.47 (the project was migrated by `flutter build`: `FlutterGeneratedPluginSwiftPackage` in the project; CocoaPods keeps only the Flutter pod). CocoaPods is still needed for that (`brew install cocoapods`).
- **Signing:** automatic, team `7MPZ3B5273` on the app; `Runner.entitlements` (HealthKit + App Group), `TreniDayWidget.entitlements` (App Group). In the simulator both work without an account (checked 2026-10-12: the Health permission sheet appeared, the widget reads what the app writes). **For a real device** Xcode needs the owner's Apple ID (Settings → Accounts) so automatic signing can register the App IDs, the App Group and HealthKit — the owner's step; nobody else enters that password.

## Health Integration

- **Write:** workout session (`TRADITIONAL_STRENGTH_TRAINING`) + calories (MET 5.5 × 70kg × hours)
- **Read:** body weight (optional, for more accurate calorie calculation)
- All features are opt-in via Settings → HEALTH
- `HealthService.instance.configure()` is wrapped in `.timeout(5s)` (otherwise hangs on splash)

**Critical for Android:**
- `MainActivity` extends `FlutterFragmentActivity` (not `FlutterActivity`)
- `activity-alias` with `HEALTH_PERMISSIONS` in AndroidManifest is required for the permissions dialog

**iOS:** `Runner.entitlements` contains `com.apple.developer.healthkit` + App Group; `CODE_SIGN_ENTITLEMENTS` is set in all 3 build configs. See § iOS specifics for signing.

## Android Specifics

- Release signing: `android/key.properties` (git-ignored) → upload keystore; without the file the release build uses the debug key. CI writes it from secrets
- Glance: `home_widget` 0.9.1 asked for `androidx.glance:glance-appwidget:1.+`, which began to resolve to an alpha needing compileSdk 37 / AGP 9.1, so `android/build.gradle.kts` forced 1.1.1. Since `home_widget` 0.9.2 the plugin pins 1.1.1 itself and the force is gone (0.9.2). After a plugin upgrade, a stale incremental Kotlin build in `build/<plugin>/` can report the plugin's own classes as unresolved: delete that folder (not the whole `build/`, which holds the animation stands)
- `minSdk = 26` (health package requires API 26+)
- `build.gradle.kts`: `isCoreLibraryDesugaringEnabled = true` + `desugar_jdk_libs:2.1.4`
- Root `build.gradle.kts`: `compilerOptions { jvmTarget.set(JvmTarget.JVM_17) }`, **not** `kotlinOptions` (compile error)
- `flutter_timezone ^5.0.0`: use field `.identifier` (not `.name`)
- `build_runner ^2.13.1` (unblocked after migrating to `hive_ce_generator ^1.11.1` which uses `analyzer ^10.0.0`)
- NotificationService init — ONLY in `postFrameCallback`, not in `main()` before `runApp()`
- AndroidManifest permissions: `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, `USE_EXACT_ALARM` + `SCHEDULE_EXACT_ALARM`, `VIBRATE`, Health Connect `READ_WEIGHT` / `WRITE_EXERCISE` / `WRITE_TOTAL_CALORIES_BURNED`
- Proguard: `keep.xml` (drawable) + `proguard-rules.pro` (dexterous + TypeToken)

### Android Notifications
- Small icon (monochrome, status bar): `AndroidInitializationSettings('ic_goro_notif')` + `drawable/ic_goro_notif.xml`
- Large icon (color, notification shade, Android 12+): app adaptive icon, added automatically
- The name `ic_notification` must not be used (conflicts with a resource inside the package)
- Notification IDs: 1=morning, 2=evening, 3=streakThreat, 4=streakLost, 5=rankAtRisk
- `scheduleAll` starts with `cancelAll()` and runs on every cold start and every notification setting change — anything that must survive it has to be re-created inside it (`scheduleStreakLost` and `scheduleRankAtRisk` are)

### Android Widget
- Glance → **AppWidgetProvider + RemoteViews** (Glance requires the Compose Compiler Plugin, which is not included in Flutter projects by default)
- `updateWidget(qualifiedAndroidName: ...)` — use `qualifiedAndroidName`, not `androidName` (otherwise the package appends the package name twice)
- **A local build needs JDK 17 or 21:** Gradle 8.14 does not run on Java 25, which Android Studio bundles and Flutter prefers over `JAVA_HOME`; point Flutter at another JDK with `flutter config --jdk-dir=…` (CI uses 17).

## Web Build

Same Flutter app compiled for the browser; data stays local (Hive CE → **IndexedDB**, one database per box).

- **URL:** `https://pupptmstr.github.io/treniday/app/` (hash routing: `#/home`); the landing page is the root of the same site (§ Landing page)
- **The address moved in 0.9.9** (CaliDay → TreniDay, the repository renamed): it was `/caliday/…`. GitHub redirects a renamed repository but not its Pages site, so the old address answers 404. The data stays: IndexedDB belongs to the origin `pupptmstr.github.io`, not the path.
- **Build:** `flutter build web --release --base-href /treniday/app/`
- **Deploy:** `.github/workflows/web.yml` on every push to `main` — builds the app + Jekyll-renders `docs/` (legal docs keep their URLs `/treniday/PRIVACY_POLICY`, `/treniday/TERMS_OF_USE`) + renders the landing page (`tools/site/build_site.py _site`) → one Pages artifact. Requires Settings → Pages → Source = **GitHub Actions**. The `deploy` job needs both `build` and a parallel `test` job (`flutter test`), so a push that breaks the tests does not reach the live site (guarded in `test/repo/workflows_test.dart`).
- **Flutter version** is pinned in all three workflows (`web.yml`, `ci.yml`, `release.yml`, `3.47.7` since 0.9.7) to match `pubspec.lock` (SDK-pinned packages like `matcher`, `test_api`). Bump all of them together with the local SDK; `test/repo/workflows_test.dart` fails when they differ.
- **`main` is protected** (owner, 2026-10-10; repository ruleset "Protect main"): changes only through a pull request, merged as a **squash** (merge commits and rebase merges are off for the whole repository; the commit takes the PR title and body), the CI jobs `check` and `android` must pass, linear history, no force pushes, no deletion. Nobody pushes to `main` directly, an admin included; an admin may merge a PR past red checks (bypass "pull request only"). Merged branches are deleted automatically (a closed PR keeps its commits and can restore the branch).
- **Checks:** `.github/workflows/ci.yml` on every push to `main` and every pull request — `flutter gen-l10n` must leave `lib/l10n` unchanged (the generated files are committed), `flutter analyze`, `flutter test`, and a debug Android build (`flutter build apk --debug`, which is what catches a broken Gradle / plugin setup such as the Glance range). Older runs of the same ref are cancelled.
- **Release builds:** `.github/workflows/release.yml` (APK / AAB / iOS build / draft GitHub Release) is drafted and **disabled** until the repository variable `RELEASE_BUILDS_ENABLED` is `true`; see `internal_docs/reference/platform.md` § Release builds (CI).

### Feature matrix (guarded with `kIsWeb`)

| Feature | Web | How |
|---------|-----|-----|
| Workouts, progression, SP, streaks, achievements, library, custom routines | ✅ | — |
| Sound | ✅ | `WebCuePlayer` (Web Audio, one context unlocked by the first tap; 0.9.8) — audioplayers' `<audio>` elements stayed silent on iPhone when the timer started them. On iOS the cues follow the silent switch and mix with music |
| Haptics | ⚠️ Android Chrome only | engine maps to `navigator.vibrate` |
| Notifications | ❌ | `NotificationService.init/scheduleAll/scheduleStreakLost/scheduleRankAtRisk` no-op (every new scheduler needs its own `kIsWeb` guard: without `init()` the timezone database is never loaded); Settings section hidden |
| Health | ❌ | Settings section + onboarding step hidden |
| Home Screen Widget, widget deep links | ❌ | `main.dart` skips the whole post-frame native init; `WidgetService.update` no-op |
| Orientation lock | ❌ | skipped in `main()` |

### Web-only UI
- `_WebFrame` (`main.dart`, via `MaterialApp.router(builder:)`) — on wide windows the app renders in a centred 480 px column over `AppTheme.heroGradient`; `MediaQuery.size` is overridden to the column size.
- `web/index.html` — brand splash (removed on the `flutter-first-frame` DOM event) + `navigator.storage.persist()` to reduce eviction risk.
- Web icons are generated by `flutter_launcher_icons` (`web:` section in pubspec) from `assets/icon/icon.png`.

### Caveats
- Data is per browser/origin; clearing site data wipes progress. Safari may evict storage of sites not added to the Home Screen after 7 days without a visit — on iOS, install via Share → Add to Home Screen.

## Landing page (0.9.8)

`https://pupptmstr.github.io/treniday/` (English), `ru/`, `de/`, `es/` — what the app is, with links to the web app, the stores (coming soon) and GitHub; the same languages as the app (owner, 2026-10-12).
- **Sources:** `site/template.html` (`{{key}}` placeholders), `site/strings/<code>.json` (one per language, the same keys as `en.json`; a missing key fails the build), `site/site.css` (the app's tokens: brand gradients, the orange streak, tiles; light and dark), `site/site.js` (the exercise animations, the running hold on the mock-up, the reveal), `site/icons.svg`, `site/og-<code>.png` (link previews, `tools/site/make_og.py`).
- **Build:** `python3 tools/site/build_site.py OUT [--url …]` renders a page per language (`hreflang`, canonical, Open Graph, JSON-LD `SoftwareApplication`), writes `sitemap.xml`, and copies from the app what the site shows: the characters' SVGs into `img/`, the exercise animations into `anim/` with `anim/crops.json` (the squares of `animation_crops.dart`, so the figures are cropped like `ExerciseThumb`). The address is `--url` (default the github.io one): a custom domain is that argument plus the DNS — and then the web app's `--base-href` and the legal URLs move too.
- **The phones** of the first screen are HTML drawn with the app's tokens, not screenshots; they play the real Lottie files (lottie-web 5.12.2 light from cdnjs, with SRI).
- **Search:** `robots.txt` is read only at a domain's root, so on a project site the sitemap is sent through Google Search Console: the owner's URL-prefix property `https://pupptmstr.github.io/treniday/` is verified by the `google-site-verification` meta tag in the template's `<head>` (2026-10-13) — removing it loses the verification.
- **Preview:** `python3 tools/site/build_site.py build/site_preview`, then the `treniday-site` server of `.claude/launch.json` (port 8097). The app and the legal links point at `app/` and `PRIVACY_POLICY`, which only the deployed site has.
- **Store links:** placeholders until the listings exist; Apple's "Download on the App Store" badge may only be used for an app that is on the store. The listings themselves are ready in `fastlane/metadata/` — [specs/store-listing.md](../specs/store-listing.md).
- **Support contact:** the FAQ's last question gives the email; it is what the App Store's support URL (`…/treniday/#faq`) points at — Apple wants contact information there.

## Release builds (CI) — drafted, disabled

`.github/workflows/release.yml` builds the release files. It is **off**: every job needs the repository variable `RELEASE_BUILDS_ENABLED` = `true` (Settings → Secrets and variables → Actions → Variables), so a tag push or a manual run only shows skipped jobs. There are no Apple or Google developer accounts yet, so only the parts that need none are usable today.

| Job | What it does | Needs |
|-----|--------------|-------|
| `verify` | tag = pubspec version (`v0.9.0` ⇔ `version: 0.9.0+N`), `flutter analyze`, `flutter test` | nothing |
| `android` | `flutter build apk` + `appbundle`, JDK 17, files named `treniday-<version>-b<build>.apk/.aab` | upload keystore (free to create, below). Without it the build is signed with the **debug** key: artifacts end in `-debug-signed`, and a tag run refuses to continue |
| `ios` | no secrets: `flutter build ios --no-codesign` (proves the app and the widget extension compile; the result cannot be installed). With the App Store Connect API key: a signed IPA | the Apple Developer Program (paid) |
| `release` | on a tag only: a **draft** GitHub Release with the `.apk`, `.aab` and `.ipa` (not the unsigned iOS zip) | the jobs above |

Triggers: a `v*` tag, or "Run workflow" by hand (artifacts only, no release).

**Android signing.** `android/app/build.gradle.kts` signs the release build with the keystore named in `android/key.properties` (git-ignored) and falls back to the debug key when the file is missing, so `flutter run --release` is unchanged. CI writes the file from secrets. To create the keystore (no account needed; keep a backup — with Google Play App Signing it becomes the *upload key*, and losing it means a reset request to Google):

```
keytool -genkeypair -v -keystore treniday-upload.jks -alias treniday -keyalg RSA -keysize 2048 -validity 10000
```

Secrets: `ANDROID_KEYSTORE_BASE64` (PowerShell: `[Convert]::ToBase64String([IO.File]::ReadAllBytes("treniday-upload.jks"))`), `ANDROID_STORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`. Avoid backslashes in the passwords: they end up in a `.properties` file.

**iOS signing (when the paid account exists).** Register the bundle ids `com.pupptmstr.treniday` and `com.pupptmstr.treniday.TreniDayWidget`, the App Group `group.com.pupptmstr.treniday` and the HealthKit capability; create an App Store Connect API key (role Admin or App Manager). Secrets: `APPSTORE_API_KEY_BASE64` (the `.p8` file, base64), `APPSTORE_KEY_ID`, `APPSTORE_ISSUER_ID`; variable `APPLE_TEAM_ID` (overrides the `DEVELOPMENT_TEAM` that is committed in `project.pbxproj`). `xcodebuild -allowProvisioningUpdates` with that key creates the profiles for both targets, so no certificate or profile is stored. **That step was written without an account and never run.**

**Not in the workflow:** uploading to the stores. Google Play needs a Play Console account (one-time fee) and a service-account key; TestFlight needs the same App Store Connect API key. Add the upload jobs once the accounts exist. The listing texts are in the fastlane layout (`fastlane deliver` / `fastlane supply` upload them) and the store forms' answers are in [specs/store-listing.md](../specs/store-listing.md), with the native settings to change before the first upload.

**What was verified (2026-10-06):** `actionlint` passes; the naming, tag check and `key.properties` snippets were run locally; the Gradle signing was built with a real `flutter build apk --release` with and without a keystore. Not verified: anything that only runs on GitHub (the runners, `gh release create`, artifact upload), and the signed iOS path.

**To release:** bump `version:` in `pubspec.yaml`, commit, `git tag v0.9.0 && git push --tags`, review the draft release, publish. macOS runners are free for a public repository (a private one would bill them at 10×).

**An Android build break found on the way:** the `home_widget` plugin declares `androidx.glance:glance-appwidget:1.+`, a dynamic range that began to resolve to `1.3.0-alpha02` (needs compileSdk 37 and AGP 9.1), so every Android build failed in `checkReleaseAarMetadata`. `android/build.gradle.kts` pinned Glance to 1.1.1 until `home_widget` 0.9.2 pinned it itself; the force was removed in 0.9.2 (2026-10-09, a local `flutter build apk --debug` passes without it).
