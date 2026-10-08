# CaliDay — Developer Notes

A living document. Contains current status, active feature specs in progress, and change history.
**Stable decisions and architecture → `internal_docs/ARCHITECTURE.md`**

---

## Current Status

**Version:** v0.9.0 (Morning Routine, merged into `main` 2026-10-08). Yoga is in progress on `session/2026-10-08-yoga` as **0.9.1** (the course and Miso are in the app; 13 animations to do): the owner keeps the version at 0.9.x until they call it 1.0 (2026-10-08).
**Next priority:** v1.0 release. What still stands in the way:
- Friends has never been tested on two real phones (checklist below).
- iOS: the HealthKit capability has to be added by hand in Xcode (Runner → Signing & Capabilities).
- Content for v1.0: additional courses (see the ARCHITECTURE.md backlog).
- Store accounts (Apple Developer Program, Google Play Console): the release CI is drafted but disabled until they exist ("Release builds (CI)" below).

The owner's plan for the **big features after that** (2026-10-07), in his order: German and Spanish translations → additional courses → a course configurator with many more exercises. See Active Specs § Roadmap.

| Layer | Status |
|-------|--------|
| Data models + Hive | ✅ |
| ExerciseCatalog (20 branches — Calisthenics, Healthy Body, Evening Stretch, Morning Routine, Yoga) | ✅ |
| Repositories (User, SkillProgress, Workout, Achievement, Friend, CustomRoutine) | ✅ |
| Domain services | ✅ |
| Navigation (GoRouter + bottom nav) | ✅ |
| Onboarding (8 steps, incl. course selection) | ✅ |
| Home / Library / Profile / Settings | ✅ |
| Workout / Summary | ✅ |
| BranchJourney / Achievements / About / DevOptions | ✅ |
| Notifications (5 types: morning, evening, streak at risk, streak lost, rank at risk) | ✅ |
| Dark theme | ✅ |
| Goro (6 expressions) + Skala | ✅ |
| Lottie animations (118 of 133 exercises; 90/90 hip mobility and the pigeon pose intentionally have none, 13 Yoga stages still to draw) | ✅/⚠️ |
| Sound + haptics | ✅ |
| Home Screen Widget (iOS + Android) | ✅ |
| Health Integration (iOS + Android) | ✅ |
| Friends (BLE + QR, v0.4; not yet tested on real devices) | ✅/⚠️ |
| Exercise Library (search + tag filter) | ✅ |
| Custom Workouts (Quick Routine + Saved Routines) | ✅ |
| Multi-Course system (Calisthenics, Healthy Body, Evening Stretch, Morning Routine, Yoga) | ✅ |
| L10n (RU, EN, DE, ES; German and Spanish are drafts awaiting native proofreading) | ✅/⚠️ |
| Web build (PWA on GitHub Pages, IndexedDB) | ✅ |
| Workout calendar, interactive stats, rank decay (v0.8) | ✅ |
| Tests (`flutter test`, 550+: services, catalog integrity, Hive repositories, ARB, notification plan, QR / BLE payloads, router, workflows) | ✅ |
| CI (`ci.yml`: l10n drift, analyze, test, debug Android build on every push / PR; green on GitHub, checked 2026-10-08 on PRs #1 and #2 and their merges) | ✅ |

---

## Active Specs (ideas in progress)

### Release builds (CI) — drafted, disabled

`.github/workflows/release.yml` builds the release files. It is **off**: every job needs the repository variable `RELEASE_BUILDS_ENABLED` = `true` (Settings → Secrets and variables → Actions → Variables), so a tag push or a manual run only shows skipped jobs. There are no Apple or Google developer accounts yet, so only the parts that need none are usable today.

| Job | What it does | Needs |
|-----|--------------|-------|
| `verify` | tag = pubspec version (`v0.9.0` ⇔ `version: 0.9.0+N`), `flutter analyze`, `flutter test` | nothing |
| `android` | `flutter build apk` + `appbundle`, JDK 17, files named `caliday-<version>-b<build>.apk/.aab` | upload keystore (free to create, below). Without it the build is signed with the **debug** key: artifacts end in `-debug-signed`, and a tag run refuses to continue |
| `ios` | no secrets: `flutter build ios --no-codesign` (proves the app and the widget extension compile; the result cannot be installed). With the App Store Connect API key: a signed IPA | the Apple Developer Program (paid) |
| `release` | on a tag only: a **draft** GitHub Release with the `.apk`, `.aab` and `.ipa` (not the unsigned iOS zip) | the jobs above |

Triggers: a `v*` tag, or "Run workflow" by hand (artifacts only, no release).

**Android signing.** `android/app/build.gradle.kts` signs the release build with the keystore named in `android/key.properties` (git-ignored) and falls back to the debug key when the file is missing, so `flutter run --release` is unchanged. CI writes the file from secrets. To create the keystore (no account needed; keep a backup — with Google Play App Signing it becomes the *upload key*, and losing it means a reset request to Google):

```
keytool -genkeypair -v -keystore caliday-upload.jks -alias caliday -keyalg RSA -keysize 2048 -validity 10000
```

Secrets: `ANDROID_KEYSTORE_BASE64` (PowerShell: `[Convert]::ToBase64String([IO.File]::ReadAllBytes("caliday-upload.jks"))`), `ANDROID_STORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`. Avoid backslashes in the passwords: they end up in a `.properties` file.

**iOS signing (when the paid account exists).** Register the bundle ids `com.pupptmstr.caliday` and `com.pupptmstr.caliday.CaliDayWidget`, the App Group `group.com.pupptmstr.caliday` and the HealthKit capability; create an App Store Connect API key (role Admin or App Manager). Secrets: `APPSTORE_API_KEY_BASE64` (the `.p8` file, base64), `APPSTORE_KEY_ID`, `APPSTORE_ISSUER_ID`; variable `APPLE_TEAM_ID` (overrides the `DEVELOPMENT_TEAM` that is committed in `project.pbxproj`). `xcodebuild -allowProvisioningUpdates` with that key creates the profiles for both targets, so no certificate or profile is stored. **That step was written without an account and never run.**

**Not in the workflow:** uploading to the stores. Google Play needs a Play Console account (one-time fee) and a service-account key; TestFlight needs the same App Store Connect API key. Add the upload jobs once the accounts exist.

**What was verified (2026-10-06):** `actionlint` passes; the naming, tag check and `key.properties` snippets were run locally; the Gradle signing was built with a real `flutter build apk --release` with and without a keystore. Not verified: anything that only runs on GitHub (the runners, `gh release create`, artifact upload), and the signed iOS path.

**To release:** bump `version:` in `pubspec.yaml`, commit, `git tag v0.9.0 && git push --tags`, review the draft release, publish. macOS runners are free for a public repository (a private one would bill them at 10×).

**An Android build break found on the way:** the `home_widget` plugin declares `androidx.glance:glance-appwidget:1.+`, a dynamic range that began to resolve to `1.3.0-alpha02` (needs compileSdk 37 and AGP 9.1), so every Android build failed in `checkReleaseAarMetadata`. `android/build.gradle.kts` now pins Glance to 1.1.1. Watch for a `home_widget` release that stops using the range.

---

### v0.4 — Friends — нужно протестировать на реальных устройствах

Фича реализована, но **не тестировалась на физических устройствах**. Требует проверки вдвоём (два телефона).

#### Чеклист тестирования

**QR (iOS + Android):**

Проверено владельцем 2026-10-06 на **веб-версии**: телефон (браузер) сканировал QR с экрана компьютера (localhost) — отсканировалось, друг добавился, карточка открылась, удаление сработало. Нативные приложения iOS и Android этим не проверены, поэтому пункты ниже остаются открытыми; отмечено, что подтверждено на вебе.
- [ ] Открыть экран Friends → появляется QR-код своего профиля (веб ✅)
- [ ] Сканировать QR другого человека → диалог подтверждения показывает имя + SP + streak (веб ✅)
- [ ] Подтвердить → друг появляется в списке (веб ✅)
- [ ] Повторно сканировать того же человека → обновляет данные (не дублирует)
- [ ] Открыть карточку друга → показывает ранг, ветки, дату синхронизации (веб ✅)
- [ ] Удалить друга → исчезает из списка (веб ✅)
- [ ] Невалидный QR → показывает snackbar с ошибкой (не крашится)
- [ ] Новый компактный QR (формат 2, 49×49 модулей) сканируется с экрана телефона на телефон (iOS и Android)
- [ ] Системная камера: QR друга открывает приложение на экране Friends (раньше любая ссылка `caliday://` вела на тренировку); нужно проверить на устройстве

**BLE — сканирование (требует двух устройств):**
- [ ] iOS → iOS: обнаружение работает
- [ ] Android → Android: обнаружение работает
- [ ] iOS → Android: обнаружение работает (и наоборот)
- [ ] BLE выключен → секция "Nearby" показывает сообщение "Bluetooth выключен"
- [ ] Кнопка Refresh → запускает повторное сканирование
- [ ] Tile "Connect" → читает профиль по GATT и добавляет друга (snackbar «добавлен» / «обновлён»); если GATT недоступен или JSON битый — открывается QR-сканер (fallback)
- [ ] Свой экран Friends рекламирует устройство (advertising) — второй телефон видит его в секции Nearby

**BLE — разрешения:**
- [ ] Android: при первом открытии Friends появляется запрос `BLUETOOTH_SCAN` + `BLUETOOTH_CONNECT`
- [ ] iOS: при первом открытии появляется запрос `NSBluetoothAlwaysUsageDescription`
- [ ] Отказ от разрешений → приложение не крашится, показывает "Bluetooth выключен"

**Специфично для iOS:**
- [ ] BLE-сканирование работает на iOS 14+ (минимальная поддерживаемая версия)
- [ ] QR-сканер запрашивает разрешение камеры при первом использовании

**Специфично для Android:**
- [ ] BLE-разрешения правильно запрашиваются на Android 12+ (API 31+) через `BLUETOOTH_SCAN` (neverForLocation)
- [ ] На Android 11 и ниже — legacy разрешения `BLUETOOTH` + `BLUETOOTH_ADMIN` работают

#### Известные ограничения
- BLE advertising и GATT-сервер реализованы, но тоже **не проверялись на реальных устройствах** — это часть чеклиста выше.
- На вебе BLE нет вовсе (секции скрыты), остаётся только QR.
- На вебе единственный путь добавить друга — QR, и он требует доступ к камере в браузере; при блокировке экран сканера теперь объясняет, что делать (см. запись в Change History). Если камеры нет вовсе, друг может отсканировать **твой** QR.
- QR теперь компактный (формат 2): обычный профиль ≈ 66 символов, версия 8, 49×49 модулей (было 93×93). Сборки до формата 2 новый QR прочитать не могут; новые читают оба формата. Сканирование нового кода телефон → телефон не проверялось.

---

---

### ? — Repository housekeeping questions

- ~~Root `_config.yml`~~ (`theme: minima`, added 2026-04-09 for Markdown rendering on Pages) — **removed 2026-10-07, it never had an effect.** The Pages workflow builds `./docs` with `actions/jekyll-build-pages`, and Jekyll reads its config from the source folder (`docs/`, which has none). The live legal pages are rendered by GitHub Pages' default theme (Primer: `container-lg … markdown-body`, a `<h1>` link to the repository), not minima, which settles it without a test deploy. If a theme is ever wanted, the file belongs in `docs/_config.yml`.
- ~~`linux/`, `windows/`, `macos/`~~ (10 / 18 / 30 tracked files, 484 KB). **Looked at on 2026-10-07 and found to hold nothing of the project's own:** every hand-written file is byte-identical to what `flutter create --platforms=linux,windows,macos` makes with the same Flutter (so the folders can be brought back with that one command); the only differences are the generated plugin files (`generated_plugin_registrant.*`, `generated_plugins.cmake`, `GeneratedPluginRegistrant.swift`) and, for macOS, the CocoaPods integration (`Podfile`, `Podfile.lock`, the `xcconfig` includes, the `Pods` entries of `project.pbxproj` and the workspace). Nothing refers to them: no CI job builds a desktop target (`release.yml` uses a `macos-latest` runner only for the iOS build), `flutter_launcher_icons` makes no desktop icons, no document mentions them (the macOS icons are the Flutter default). The app could not ship there anyway: `health` and `home_widget` have no desktop implementation. Their only cost is noise: `pub get` rewrites the generated plugin files. The owner's earlier rule was to delete them only if they are empty, so they were left; with this finding the owner decided to remove them. **Removed 2026-10-07** together with their three entries in `.metadata`; `flutter create --platforms=linux,windows,macos .` brings them back. `pub get` no longer rewrites anything outside `pubspec.lock`. The removal left the git-ignored files on disk (`macos/Flutter/ephemeral/*`, empty `linux/flutter`, `windows/flutter`), which showed up as untracked folders; they were deleted from the working copy the same day.

---

### Telegram Mini App + bot — parked idea (researched 2026-10-07)

> **Parked.** The owner asked to keep this as a thought on the side and not to consider it seriously for now. Nothing here is planned or scheduled; the research is kept so that it is not done twice. Do not propose it as a next step unless the owner brings it up.

#### Concept
Open the existing web build (`https://pupptmstr.github.io/caliday/app/`) as a **Telegram Mini App**, and let a **bot** send the reminders that the native app schedules locally. The owner's questions: can the app also be a Telegram bot, with notifications sent by the bot and everything else opening as a Mini App? **Yes, in two parts of very different cost:** the Mini App is cheap (the web build already runs the whole app), the bot reminders need a server, which the app has deliberately never had.

#### What the documentation says (core.telegram.org, read 2026-10-07; Bot API 10.1 of June 2026 was the latest)
- **A Mini App is a web page in Telegram's WebView** (iOS, Android, desktop, web), registered with @BotFather (menu button, "Main Mini App" with a Launch button on the bot profile, or a direct link `t.me/<bot>/<short_name>?startapp=<param>&mode=compact|fullscreen`). The page loads `https://telegram.org/js/telegram-web-app.js` and gets `window.Telegram.WebApp`. GitHub Pages already serves the app over HTTPS.
- **`startapp` is limited to 64 base64url characters** (api/links). Our compact friend payload (`FriendQrCodec` v2) is about 40 characters before the name, which leaves room for a name of roughly 18 Latin or 9 Cyrillic letters — so a friend link works for short names only; longer needs a server-side short code or a name-less format. (Estimate, to be measured.)
- **Identity:** `initData` carries the user (id, username, language, Premium flag…) signed with an HMAC-SHA-256 keyed by the bot token. It **must be validated on a server**; `initDataUnsafe` on the client is for personalisation only.
- **Storage:** CloudStorage (Bot API 6.9: 1024 items per user, a value of 0–4096 characters, synced across the user's devices), DeviceStorage (9.0: 5 MB per user), SecureStorage (9.0: 10 items). **Not one of them can be read by the bot's server**, so reminders cannot be driven from them. Hive on the web is IndexedDB, which the WebView may drop; CloudStorage is the sensible backup.
- **UI hooks the web build lacks:** `HapticFeedback` (6.1), `BackButton` / `MainButton`, `safeAreaInset` / `contentSafeAreaInset` and `requestFullscreen` (8.0), `enableClosingConfirmation`, `themeParams`, `showScanQrPopup` (6.4; a native scanner instead of the web camera), `openTelegramLink`, `switchInlineQuery`, `shareToStory`, `addToHomeScreen`. `disableVerticalSwipes` (7.7, per the community docs) is needed because a swipe down collapses the Mini App — a problem for a scrolling Flutter canvas.
- **Bots cannot write first:** a user has to press Start before the bot may message them (otherwise `403 Forbidden: bot can't initiate conversation with a user`). Limits: about one message per second to one chat, about 30 per second in bulk. A bot has **no scheduler of its own**, and Telegram gives it **no timezone or local time** of the user (the Mini App can read the zone from the browser and send it).
- **Digital goods inside Telegram must be paid with Stars (XTR)**; a bot has to answer `pre_checkout_query` within 10 s and deliver only after `successful_payment`. That fits the "Support the author" idea, and again needs a server.
- A Dart wrapper exists, `dartway_telegram` 0.3.0 (published October 2026, 132 downloads, 0 likes): it wraps only safe-area, platform, user id, fullscreen / vertical swipes / expand. Too thin and too young to depend on; a small own bridge with `dart:js_interop` (check Context7 before writing it) for haptics, CloudStorage, theme, back button, scan and share is the plan.

#### What the app already gives and what it costs (measured)
- The web build runs workouts, progression, SP, streaks, achievements, library, search, custom routines, sound, friends by QR. Already guarded with `kIsWeb`: no BLE, notifications, Health, widget (see ARCHITECTURE § Web Build).
- **First load is about 4.2 MB compressed** (`main.dart.js` 1.27 MB + `canvaskit.wasm` 2.9 MB), animations load lazily. Acceptable on Wi-Fi, to be checked on a mobile network and a low-end Android.
- `_WebFrame` (a 480 px column on wide windows) must switch off inside Telegram, whose viewport is already phone-sized.

#### The decisions this needs from the owner
1. **Two separate worlds.** The native app's data (Hive on the phone) and the Mini App's data (IndexedDB / CloudStorage inside Telegram) do not sync. Joining them needs accounts and a server. Recommended: accept two worlds for now; the Mini App is a second *channel*.
2. **Reminders need a small opt-in server** (the app has "no backend" as a principle). What it would hold per user: the chat id, the time zone, the language and the schedule below; the Privacy Policy and Terms (`docs/`) must say so. Recommended design: **the client computes the schedule, the server only fires it.** The Dart `NotificationPlanner` already turns the profile and `now` into `PlannedNotification`s; the Mini App uploads that list (authenticated by `initData`) every time it would call `scheduleAll()` today (a finished workout, a settings change), and the server sends the due ones. The rules (streak at risk, evening reminder cancelled by a workout, rank at risk) stay in one place, in Dart and under test, not copied into a second language.
3. **Where the server lives.** A Cloudflare Worker with D1 and a Cron Trigger fits "free": Workers Free is 100,000 requests a day with a 10 ms CPU limit per invocation, 5 Cron Triggers, D1 5 GB / 5 million reads / 100,000 writes a day (Cloudflare docs, page of 2026-10-02). **The catch: 50 subrequests per invocation on Free**, and each `sendMessage` is one, so a single minute can notify about 50 users; enough for a beta, beyond it the paid plan or spreading the sends over several runs. Alternatives not looked at: a small VPS, Supabase, Firebase.
4. **Storage accounts are not needed for this channel.** A Mini App needs no Apple or Google account, which are what currently blocks the v1.0 release; it can reach users before the stores do (discovery without marketing is the open question).

#### Technical Tasks (proposed order)
| # | Task |
|---|------|
| 0 | **Spike, no code:** make a test bot with @BotFather, set its menu button to the Pages URL, open it in Telegram on an iPhone and an Android. Look at: load time, text input and the keyboard (name field, routine builder, search), scrolling and the swipe-down collapse, sound (autoplay), the camera, whether data survives closing the Mini App. Answers every "unverified" below before any code is written |
| 1 | Mini App shell: the JS bridge (`ready`, `expand`, `disableVerticalSwipes`, safe area, theme, haptics, back button), no `_WebFrame` inside Telegram, CloudStorage backup of the Hive state (values are limited to 4096 characters: chunk or shard by month), `showScanQrPopup` for friends, a `startapp` friend link for short names |
| 2 | Bot and server: webhook (`/start` as the opt-in, `/stop`), `POST /schedule` with `initData` validation, the Cron Trigger that fires due messages, the Privacy Policy and Terms updated, the settings screen of the Mini App (reminders on / off, time) |
| 3 | Optional: Stars for "Support the author" (needs the same server), listing in the Mini App directory |

#### Unverified (do not assume)
Flutter web text input and keyboard inside Telegram's WebView; audio autoplay there; whether the WebView keeps IndexedDB between sessions; behaviour on a low-end Android; the real length of a friend link; whether 50 messages a minute is enough for the first users; Telegram's current rules for Mini Apps (the terms were read through a summary only; read the original before launch).

#### When to tackle
Not planned (parked by the owner, 2026-10-07). If it is ever picked up, start with the spike (task 0): an hour, no code, and it answers every item under "Unverified" before anything is built.

Sources: <https://core.telegram.org/bots/webapps>, <https://core.telegram.org/api/links>, <https://core.telegram.org/bots/faq>, <https://core.telegram.org/bots/payments-stars>, <https://developers.cloudflare.com/workers/platform/limits/>, <https://developers.cloudflare.com/workers/platform/pricing/>, <https://pub.dev/packages/dartway_telegram>.

---

### Roadmap — the big features (owner's plan, 2026-10-07)

The owner's order: **(1) German and Spanish translations (done as drafts, 0.8.16), (2) additional courses, (3) a configurator for the user's own courses, with many more exercises and branches added before it so that building a course is easy.** This records what is known and decided so that it is not looked up again.

#### 1. German and Spanish
- **Part 1, the code, is done (2026-10-07, 0.8.16):** nothing assumes two languages any more. The UI languages are one list, `appLanguages` (`core/l10n/app_languages.dart`); the settings dialog, the onboarding menu, the system-language default (`LocaleNotifier`), the notification texts and the widget's rank names all follow it, the last two through the ARB files (`l10nFor`). The tests check every ARB file against the template and run their "every language" checks over all of them (`test/helpers/all_translations.dart`). Tried with a copy of `app_en.arb` as `app_de.arb`: exactly two tests failed, the missing line in `appLanguages` and the "What's new" entries left in English. See the Change History entry.
- **Part 2, the texts, is in as drafts (2026-10-07, also 0.8.16, at the owner's request):** `l10n/app_de.arb` and `app_es.arb`, all 562 messages each, written by Claude. **The owner will have native speakers proofread them**; until then the wording is provisional. Choices a proofreader should know: informal address (du / tú, like the Russian ты); German keeps the calisthenics anglicisms the community uses (Challenge, Skills, Plank, Pistol Squat, Dragon Flag, Crunches) and "Serie / Serienschutz" for streak / freeze; Spanish is neutral rather than Spain-only where it could be ("acuéstate", "parada de manos"), with "racha / protector de racha / reto / etapa"; the rank names follow the Russian ones (Anfänger, Amateur, Sportler, Athlet, Meister, Legende / Principiante, Aficionado, Deportista, Atleta, Maestro, Leyenda); counted messages are plurals even where the English one is not ("1 Freund", "1 vez"). Adding a message from now on means writing it in all four files.
- **Not translated yet:** the legal pages in `docs/` and the store listings.
- **Still assuming Russian on purpose:** a profile without a language (`UserProfile.locale == null`, older profiles) gets Russian notifications and shows "Русский" in Settings (`SettingsState.locale`), as before; a new profile always stores its language. `l10n.yaml` `preferred-supported-locales: en, ru` only orders the locale resolution and needs no change.
- **Checked on a 375 px screen (web):** German — the onboarding, Home, the Courses tab, Profile, Settings; Spanish — Settings, Home, Profile, the workout screen and its quit dialog. Nothing overflowed and the console showed no layout errors; the long rank names ("Principiante") shrink inside their chip. The segmented controls fit in both; only the Russian "Системная" breaks mid-word (an older problem, not about the new languages).
- ~~The native home screen widget is not localized~~ — fixed in 0.8.18 (Change History).

#### Decisions on courses (owner, 2026-10-07)
- **A course stays what it is: a set of branches with staged progression.** No second kind of course (a "routine" with its own progression) and no day-by-day programme. Every new course is made of branches.
- **Yoga** = branches of progressively harder poses (a ladder, like Balance).
- **Morning routine / evening stretch** = branches too; their progression is mostly "more reps / longer holds", which the in-stage progression already does. Not seen as a problem.
- **More branches come before the builder, including branches that belong to no course.** They are there to be picked in the builder (and shown in the exercise library).
- **The custom course builder offers two things:** (a) a course from a set of *existing* branches; (b) *a branch of one's own*: the user picks exercises, puts them in order (each one is a stage) and the app runs the usual progression through them.
- **Exercises and whole branches may be shared between courses (owner, 2026-10-08).** A new course reuses what fits: an existing exercise (as its own stage id with the same animation, as `evening_back_s1_cat_cow`), an existing warm-up or cool-down, or a whole existing branch in `CourseCatalog.branchesFor` (progress is per branch, so it is shared, as Flex is in Calisthenics and Healthy Body). The "no stage repeats another branch" principle of Evening Stretch and Morning Routine was never the owner's rule and is dropped.
- **Friends stop carrying the progress of every branch**, so that a new branch never breaks the friend QR / BLE exchange (then: no branch progress at all, 0.8.19).

#### 2a. Friends without branch progress — done (0.8.19)
The owner chose to drop branch progress from the friend exchange altogether (rather than freeze a list of eight): QR format 3, see the Change History entry and ARCHITECTURE § QR Profile Exchange. A new branch no longer touches the friend format.

#### 2b. New courses: Yoga, Morning Routine, Evening Stretch
- Each is a `CourseId` value (appended: the Hive enum keeps its indices) and a list in `CourseCatalog.branchesFor`; the onboarding course cards and the Library pills already loop over the courses.
- **Content first, per course:** which branches, how many stages, which exercises per stage (existing ones reused where they fit: Flex / Posture / Neck for the stretches; new poses for Yoga), start / target reps, sets, rest and the challenge norms. To be designed with the owner course by course.
- **Costs of a new branch** (unchanged): a value in the `BranchId` Hive enum, its stages, a warm-up and cool-downs, tags, achievements (`<branch>_complete`), ARB texts in all four languages, a Lottie animation per exercise (the `tools/lottie` rigs; some poses do not read in a side view, see the pigeon and 90/90 decisions), the onboarding start stage.
- ~~Two courses on one day~~ — settled and done in 0.8.19: progression is per branch and per day, in any workout (the owner's rule), SP and the streak unchanged. See ARCHITECTURE § Primary vs Bonus Workout.

#### 2b-1. Evening Stretch — the first new course, content agreed (owner, 2026-10-08)
- **Concept:** a calm stretch before sleep. Everything on the floor, nothing needed but a towel and a wall, slow, and every workout ends lying down. Host: **Luna** the owl (see § Course hosts).
- ~~**No pose repeats a progression stage of Flex, Posture or Neck**~~ (a principle of this course's draft, not a rule; dropped 2026-10-08, see § Decisions on courses), so that a user of Calisthenics or Healthy Body does not meet the same exercises twice. Only the cat-cow animation and the neck rolls are reused. (An earlier estimate, "built almost entirely from existing exercises", held only with such repeats.)
- **Four branches** (the owner asked for four: with three, as in Healthy Body today, the Standard size — 3 skills — and the Full size — all — give the same workout). ↔ = held on each side (§ Per-side holds); times are per side.

| Branch | # | Exercise | Grows within the stage | Challenge to enter | Animation |
|--------|---|----------|------------------------|--------------------|-----------|
| **Back** (Спина) | 1 | Cat-Cow | 5→12 reps | — | reuses `cooldown_cat_cow.json` |
| | 2 | Child's Pose | 20→60 s | 30 s | new, side |
| | 3 | Supine Twist ↔ | 20→60 s | 30 s | new, top view (`topview.py`) |
| | 4 | Sphinx | 20→60 s | 45 s | new, side |
| | 5 | Cobra | 30→90 s | 45 s | new, side |
| **Hips** (Бёдра) | 1 | Knees to Chest | 20→60 s | — | new, side |
| | 2 | Reclined Figure Four ↔ | 20→60 s | 30 s | new, top view |
| | 3 | Happy Baby | 20→60 s | 30 s | new, side |
| | 4 | Butterfly | 20→60 s | 45 s | new, ⚠️ seated front view |
| | 5 | Frog | 30→90 s | 45 s | new, ⚠️ view unclear — fallback: Lizard |
| **Folds** (Наклоны; "Ноги" is the Legs branch) | 1 | Legs Up the Wall | 30→90 s | — | new, side (wall prop) |
| | 2 | Lying Hamstring Stretch, with a towel ↔ | 20→60 s | 30 s | new, side |
| | 3 | Head-to-Knee Fold ↔ | 20→60 s | 45 s | new, side |
| | 4 | Straddle Fold | 30→90 s | 45 s | new, ⚠️ seated front view |
| **Shoulders** (Плечи) | 1 | Self-Hug | 20→60 s | — | new, seated front view |
| | 2 | Overhead Triceps Stretch ↔ | 20→60 s | 30 s | new, seated front view |
| | 3 | Eagle Arms ↔ | 20→60 s | 30 s | new, ⚠️ seated front view |
| | 4 | Puppy Pose | 30→90 s | 45 s | new, side |
| | 5 | Cow Face Arms ↔ | 20→60 s | 45 s | new, ⚠️ seated front view (or from behind) |

- The Shoulders branch leaves out what exists already: hands clasped behind the back (the Push cool-down, `neck_s2_chest_opener`), the doorway stretch, the lat stretch at the wall.
- **Common to every stage:** sets 1→2, rest 15→10 s (as Posture / Neck), `spBase` 1.
- **Warm-up** of every branch: `warmup_neck_rolls` (reused). **Cool-down** of every branch: a new stage-0 exercise **Lying Relaxation** (shavasana), 60 s; the generator de-duplicates cool-downs, so each evening workout ends with it once.
- **Onboarding:** all four branches start at stage 1, no calibration question.
- **Bonus workout:** no supplementary block in this course — implemented in 0.8.20 (`CourseCatalog.addsSupplementary`), **confirmed by the owner 2026-10-08**. The pool is strength work (Russian twists, side plank, calf raises), out of place before sleep. Today `generateDailyForCourse` adds it to every non-primary workout.
- **Identifiers** (proposed): `CourseId.eveningStretch`; four `BranchId` values appended to the enum. They are Hive enum values and the keys of `SkillProgress` and of the `<branch>_complete` achievements, so their names cannot change later — choose them once (e.g. `eveningBack`, `eveningHips`, `eveningFolds`, `eveningShoulders`).
- **Costs:** 19 new exercises (18 stages + Lying Relaxation), each a name, a description and a tip in four languages, tags, and a Lottie animation; 4 branches, 1 course, 4 branch achievements, the course card with Luna.
- **Rig work first:** a **seated front view** in `tools/lottie/frontview.py` (it draws standing poses only today) is needed by about seven animations (butterfly, straddle, the four arm stretches, maybe the frog). Build it and check that the ⚠️ poses read before drawing the rest; a pose that does not read is replaced, not shipped without an animation.
- **Order of work:** (1) per-side holds — done, 0.8.20; (2) — **done, 0.8.20 (Change History)** — the course, its branches and exercises **without animations** (the app already shows an exercise without one, as 90/90 and the pigeon) and their texts in four languages; (3) Luna and the host slot; (4) the animations, branch by branch — **done, 0.8.20, all 19 approved by the owner**. Users should see the course only once the animations are in — the web build is public, so either it lands in one go or it stays behind a debug-only switch until then (to decide at implementation).

#### 2b-2. Morning Routine — the second new course, content agreed (owner, 2026-10-08)
- **Concept:** wake the body up — the opposite of Evening Stretch (calm holds lying down). Host: **Aurora** the lark (§ Course hosts). Course name: Morning Routine / Утренняя зарядка / Morgenroutine / Rutina matutina (to settle with the texts).
- **Principles:** everything **standing** (next to the bed, in pyjamas, no mat, no lying down — hands go to the floor only in the top stages); **quiet, no jumps** (the household and the neighbours may still be asleep); **dynamic** — mobility moves are counted in reps, the cardio is timed (hands-free through the get-ready countdown). An alternating move counts each side as one rep (`perSide` stays for timed holds only).
- ~~**No stage repeats a progression stage of another branch**~~ (Flex, Posture, Neck, Evening, Calisthenics; a principle of this course's draft, not a rule; dropped 2026-10-08, see § Decisions on courses). Accepted by the owner as different enough: the side lunge (the Legs lunge goes forward), the standing knee hug (Evening's knees to chest is lying), plank to downward dog (the Balance cool-down is a static hold), step jacks (jumping jacks is a warm-up, not a stage).
- **Branch names differ from the Evening ones** (Спина, Бёдра, Плечи) so that the Library and later the builder do not show two "Плечи".

| Branch | # | Exercise | Grows within the stage | Challenge to enter | Animation |
|--------|---|----------|------------------------|--------------------|-----------|
| **Spine** (Позвоночник) | 1 | Standing Side Bend | 6→16 reps | — | front |
| | 2 | Torso Twist | 10→24 reps | 12 | ⚠️ front, faked torso turn |
| | 3 | Good Morning (hands behind the head, hinge with a flat back) | 8→20 reps | 8 | side |
| | 4 | Roll-Down (vertebra by vertebra) | 3→8 reps | 4 | side (three-part spine) |
| | 5 | Windmill | 6→16 reps | 8 | ⚠️ front, fold + turn |
| **Joints** (Суставы) | 1 | Knee Circles | 8→20 reps | — | ⚠️ front |
| | 2 | Open the Gate (knee up and out) | 6→16 reps | 8 | front |
| | 3 | Standing Knee Hug, up on the toes | 6→16 reps | 8 | side |
| | 4 | Side Lunge | 6→16 reps | 8 | front |
| | 5 | Cossack Squat | 4→12 reps | 6 | front |
| **Arms** (Руки) | 1 | Arm Swings (hug yourself, open wide) | 10→24 reps | — | front |
| | 2 | Y Raises (leaning forward from the hips) | 8→20 reps | 10 | side |
| | 3 | Cactus Arms (elbows at 90°, rotate the shoulders) | 8→20 reps | 10 | front |
| | 4 | Inchworm (walk the hands out to a plank and back) | 3→8 reps | 4 | side |
| | 5 | Plank to Downward Dog | 4→10 reps | 5 | side |
| **Energy** (Бодрость) | 1 | Step Jacks (jumping jacks without the jump: step out, arms up) | 20→60 s | — | front |
| | 2 | Butt Kicks on the spot, soft | 20→45 s | 30 | side |
| | 3 | Standing Cross Crunch (elbow to the opposite knee) | 20→45 s | 30 | front |
| | 4 | Speed Skater without the hop | 20→45 s | 30 | ⚠️ front |
| | 5 | Slow Mountain Climbers | 20→45 s | 30 | side |

- The owner replaced shadow boxing (first proposed for Energy 1): most people do not know what it is or how to do it.
- **Common to every stage:** sets 1→2, rest 15→10 s, `spBase` 1 (as Evening Stretch).
- **Warm-up** of every branch: a new stage-0 **Morning Stretch-Up** (reach up on the toes, 5 reps). **Cool-down** of every branch: a new stage-0 **Shake-Out** (shake the arms and legs loose, 20 s) — an upbeat end, "ready for the day". The generator de-duplicates both.
- **Branch order in the workout:** unchanged — the daily rotation of `generateDailyForCourse` (owner, 2026-10-08; playing the branches in course order was offered and declined).
- **Bonus workout:** adds the two supplementary exercises like every course but Evening Stretch (owner, 2026-10-08) — `CourseCatalog.addsSupplementary` needs no change.
- **Onboarding:** all four branches start at stage 1, no calibration question.
- **Identifiers** (Hive enum values, cannot be renamed later): `CourseId.morningRoutine` (HiveField 3); `BranchId.morningSpine`, `morningJoints`, `morningArms`, `morningEnergy` (HiveFields 12–15, appended). Exercise ids `morning_<branch>_s<N>_<name>`, `warmup_morning_stretch_up`, `cooldown_shake_out`; achievements `morning_<branch>_complete` (and `all_complete` needs them).
- **Costs:** 21 new exercises (20 stages + warm-up + cool-down), each a name, a description and a tip in four languages, tags and a Lottie animation; 4 branches, 1 course, 4 branch achievements, Aurora (six faces + idle + cheer, `tools/characters/gen_hosts.py`).
- **Order of work:** (1) the four ⚠️ animations drafted first in the rig (torso twist, windmill, knee circles, speed skater) — **done, approved by the owner 2026-10-08, in `assets/`**; (2) the course, branches and exercises, texts in four languages, version 0.9.0 — **done (Change History)**; (3) Aurora — **done, approved by the owner 2026-10-08**; (4) the other 18 animations — **done, approved by the owner 2026-10-08 (the cross crunch redrawn once), in `assets/`**. The branch `0.9.0` is merged only when all of it is in.

#### 2b-3. Yoga — the third new course (owner, 2026-10-08; in the app since 0.9.1, 13 animations to do)
- **Concept:** a ladder of harder and harder poses (the owner's 2026-10-07 decision), holds mostly, one-sided ones held on each side (§ Per-side holds). Host: **Miso** the cat. Version **0.9.1** on `session/2026-10-08-yoga` (the owner keeps 0.9.x until 1.0).
- **Reuse is allowed (owner, 2026-10-08):** exercises and whole branches may be shared with other courses (§ Decisions on courses). Yoga takes the existing **Balance** branch of Calisthenics as it is (crow, handstands; progress shared) and reuses the sphinx (Evening Stretch), the downward dog hold (`cooldown_downward_dog`), plank to dog (Morning Routine), the cat-cow (warm-up) and the lying relaxation (cool-down).
- **The branches** (agreed 2026-10-08; ↔ = on each side; the numbers are in ARCHITECTURE § Exercise Catalog):

| Branch | Stages |
|--------|--------|
| **Standing** (Стойки), new | chair → warrior I ↔ → warrior II ↔ → triangle ↔ → extended side angle ↔ |
| **Equilibrium** (Равновесие), new | tree ↔ → eagle ↔ → warrior III ↔ → dancer ↔ → half moon ↔ |
| **Backbends** (Прогибы), new | sphinx (reused) → locust → bridge hold → bow → camel → wheel |
| **Flow** (Поток), new | downward dog hold (reused) → plank to dog (reused) → half sun salutation → sun salutation A → B, counted in rounds |
| **Balance** (Баланс), shared with Calisthenics | single-leg stand → one-arm plank → crow prep → crow → wall handstand → free handstand |

- **Decided (owner, 2026-10-08):** the Balance branch is in; every stage as Morning Routine (sets 1→2, rest 15→10 s, `spBase` 1); the bonus workout adds the supplementary block; every new branch starts at stage 1 in the onboarding. Warm-up cat-cow, cool-down lying relaxation (both reused; Balance keeps its own wrist circles / downward dog).
- **The one-leg branch is called «Равновесие»** (owner, 2026-10-08), so the course has one «Баланс» (the shared branch); a separate branch rather than the one-leg poses at the end of Standing. Names elsewhere (drafts for the proofreaders): Equilibrium / Gleichgewicht / Estabilidad (the Spanish Balance is already «Equilibrio»). Hive name `yogaOneLeg`.
- **The camel keeps the hands on the lower back** (owner, 2026-10-08, after the stand showed both versions).
- **Order of work** (as the other courses): (1) the risky animations drafted first — eagle, half moon, camel, wheel, sun salutation A — **done 2026-10-08, in `assets/`** (the owner chose the camel version and raised nothing on the other four); (2) the course, branches and exercises with texts in four languages (0.9.1) — **done (Change History)**; (3) Miso — **done, approved by the owner 2026-10-08, in the app**; (4) the other 13 animations: chair, warrior I and II, triangle, side angle, tree, warrior III, dancer, locust, bridge, bow, half sun salutation, Sun Salutation B. The branch is merged when all of it is in.
- **Draft findings:** Goro's arms reach the heels in the camel only with the chest level behind him, which reads as a bow. The wheel is low (the torso is long next to the limbs) and starts with the hands by the shoulders rather than by the ears, or the feet could not stay planted.

#### Per-side holds — done (0.8.20)
Implemented as decided; see ARCHITECTURE § Timed exercises (Holds on each side) and the Change History entry.

#### Course hosts — decided (owner, 2026-10-08); Raffi and Luna done in 0.8.20, Aurora in 0.9.0, Miso in 0.9.1
- **Every course gets its own host character.** Calisthenics — **Goro** (gorilla); Healthy Body — **Raffi** (giraffe: neck and posture); Evening Stretch — **Luna** (owl); Morning Routine — **Aurora** (lark: "жаворонок / сова", early bird / night owl, Lerche / Eule, alondra / búho); Yoga — **Miso** (cat). Names chosen by the owner; they read the same in RU / EN / DE / ES (Луна, Аврора, Мисо, Раффи).
- **Goro stays the coach:** the Home hero, the notifications, and he performs **every** exercise animation — no animation is redrawn for a host. **Skala stays the judge** of every course's challenge.
- **A host is static SVG art in 2–3 poses**, like Skala, in Goro's flat style (BRAND.md), drawn in-house.
- **Where a host appears:** the Home hero (with Goro's six moods) and the Profile header while its course is active (owner, 2026-10-08 — first planned as Goro's), the course cards (onboarding, Library), the summary of a workout of that course; not yet the achievements. Goro keeps the icon, the onboarding welcome, notifications, the home-screen widget and About.
- **Order:** Luna with Evening Stretch, Raffi at the same time (the slot is built once); Aurora and Miso with their courses.
- **Skala is redrawn** — done in 0.8.20 (`tools/characters/gen_skala.py`, BRAND.md § Skala).
- **Bruno** (the bear demonstrator) is dropped in that role: stage previews on the Branch Journey screen can play Goro's existing animations. **Rex** (the streak monkey) is deferred — on Home it would compete with Goro, whose angry face already warns about the streak.

#### 2c. More branches, also outside any course
- A branch can exist without a course: it is in the catalog and the exercise library, and the builder offers it. Nothing creates its `SkillProgress` until it is used (the onboarding only starts the branches of the chosen courses), so progress starts at stage 1 on first use.
- Same costs as above, per branch. The catalog grows in four languages from now on.

#### 3. The course builder (after 2c)
- **(a) A course from existing branches:** the user picks branches (from courses and outside them) and names the course. Progress stays per branch, shared with the built-in courses, as Flex is today.
- **(b) A branch of one's own:** the user picks exercises, orders them; each becomes a stage, and the usual progression runs through them (reps → sets → rest → challenge to the next one). The parameters come from each exercise (its start / target reps, sets, rest); stage-0 exercises (warm-ups, the supplementary pool) have no challenge norm, so one has to be derived (for example the next exercise's start reps) — to be designed.
- **What it touches:** `CourseId` and `BranchId` are Hive enums with fixed values and cannot hold user-made courses or branches, so both need a string identity and stored models beside `CustomRoutine` (typeId 11; the next free typeIds are 12 and 13), a migration of `UserProfile.activeCourseIds` (enum indices today), and `SkillProgress` keyed by that string (it is keyed by `branch.name` already, so a `custom_<id>` key fits the box). Readers of a course / branch: the onboarding, the Library tab, `homeDataProvider`, the generator (`generateDailyForCourse` takes a list of branches), the achievements, the friend exchange (custom branches are not shared, see 2a).

### "Support the Author" Button — idea

IAP via StoreKit 2 (iOS) and Google Play Billing (Android).
Package: `in_app_purchase` (official Flutter).

Products (consumable):
- `tip_small` — ~99₽ / $0.99
- `tip_medium` — ~249₽ / $2.99
- `tip_large` — ~499₽ / $4.99

Placement: Settings → About.
To be tackled after the first real release.

#### ⚠️ Tax / Legal Prerequisite (Germany)

Before implementing, the author must resolve the legal/tax setup for receiving income.
Key points for Germany (discussed 2026-03-23, not a substitute for professional advice):

- **Gewerbe registration** — file Gewerbeanmeldung at local Ordnungsamt (~€26).
  Finanzamt will send a tax questionnaire (Fragebogen zur steuerlichen Erfassung) → get Steuernummer.
- **Kleinunternehmerregelung** — if annual revenue < €25 000, no VAT obligations.
  Apple/Google already act as marketplace facilitators and remit EU VAT themselves.
- **Income tax (Einkommensteuer)** — profit (revenue − expenses) added to personal income.
  Tax-free up to ~€12 000/year (Grundfreibetrag), then progressive 14–45%.
  Filed annually via Einkommensteuererklärung (deadline: July 31 of following year).
- **Gewerbesteuer** — only applies above ~€24 500 profit/year; unlikely at launch.
- **Deductible expenses**: Apple/Google developer fees, hardware, courses, Steuerberater fees.
- **Recommendation**: consult a Steuerberater before publishing paid features.

---

### Lottie Animations — status per branch (2026-10-08)

111 files in `assets/animations/`. Yoga (0.9.1): 5 of 18 new ones (`gen_yoga.py`: half moon, eagle, camel, wheel, Sun Salutation A; three stages reuse the sphinx, the downward dog and plank to dog). Morning Routine (0.9.0): all 22 (`gen_morning.py`). Evening Stretch (0.8.20): all 19 (`gen_evening.py`; the cat-cow reuses `cooldown_cat_cow`). Complete: Push (7), Core (7 + alt), Pull (6), Legs (5), Balance (6), Flex (5 of 6), Supplementary pool (9, one reuses `warmup_wrist_circles`), Posture (5 of 6: three generated, dead bug and kneeling lunge reuse `supp_dead_bug` / `flex_s1_hip_flexor_stretch`), Neck (6, all generated), warmups (7/7), cooldowns (6/6). `flex_s3_hip_9090` and `posture_s6_pigeon_pose` deliberately have no animation (not readable in the formats we draw).

Nothing planned is missing. `cooldown_cat_cow` was replaced by a generated one (2026-10-06).

The Flex, supplementary, Posture and Neck sets and the cat-cow are generated by `tools/lottie` (see ARCHITECTURE.md § Lottie Animation Tooling). Review of the oldest designer files (owner request, done 2026-10-06): the audit found no technical defects (no jumps, closed loops) but weak spots. Redrawn: Pull (6 files, `gen_pull.py`), Push s4–s7 (`gen_push.py`, `pushup.py`), `cooldown_quad_stretch`. Fixed in place: `cooldown_downward_dog` (head), `core_s5_l_sit` (arm colour) via `patch_old.py`; movement added to `bal_s1`, `bal_s3`, `bal_s4`, `bal_s6` via `enliven.py`. Kept as they were: `push_s1..s3` and the other Push files, `pull_s1_australian`, `cooldown_lat_stretch`, planks and the other holds, Legs. Not redrawn on purpose: the dog (Goro's limbs are too short for a V) and the crow (unreadable in the rig).

---


## Change History

### 2026-10-08 — Miso, the Yoga host (0.9.1)

**What was done:** step (3) of § Roadmap 2b-3. `tools/characters/gen_hosts.py` draws Miso like the other hosts: six faces, an idle and a cheer pose (`assets/hosts/miso_*`). A ginger tabby on a calm teal tile, a collar in Goro's blue with a gold bell; the ears droop when sad or asleep, flatten sideways when stern, perk up when excited. The idle pose sits in lotus on a yoga mat in Goro's blue with the paws on the knees; the cheer pose raises both paws overhead, eyes closed happily. `CourseId.yoga` now maps to Miso (Home, Profile, course cards, summary); a line in the 0.9.1 "What's new" in four languages. The other hosts regenerate unchanged. A stand (Artifact) showed the six faces at 200 px and the poses at 100 / 120 / 48 px beside Luna, Aurora and Raffi; the owner approved it (2026-10-08). The Yoga animation stand was rebuilt from `assets/` (the five approved files under their exercise ids, the camel variant with the hands to the heels gone). The branch is pushed to GitHub.

**Key issues and solutions:** the first cheer pose drew the raised legs from the shoulders straight up: they ran behind the head and only the paw tips showed above it. Drawn over the head they wrapped it like a hood and covered the ears. They are now behind the head with the elbows out wide (a teal gap between arm and head) in a shade darker than the fur, and the paws are drawn over the head where they meet above the ears.

**New / modified files:** `tools/characters/gen_hosts.py`, `assets/hosts/miso_*.svg` (8), `lib/data/models/enums.dart`, `l10n/*.arb` (`releaseNotes091`, + generated), BRAND.md, the design concept, ARCHITECTURE.md, DEV_NOTES.md.

---

### 2026-10-08 — Yoga: the course in the app (0.9.1+31)

**What was done:** step (2) of § Roadmap 2b-3, with the owner's answers: the one-leg branch is a separate «Равновесие», the camel keeps the hands on the lower back. `CourseId.yoga` (HiveField 4) with `BranchId.yogaStanding` / `yogaOneLeg` / `yogaBackbends` / `yogaFlow` (HiveFields 16–19, appended) and the Calisthenics `BranchId.balance` in its list; 21 stage exercises, three of them reused under their own ids (the sphinx, the downward dog, plank to dog: same animation, `ExerciseL10n` points at the original texts); warm-up cat-cow, cool-down lying relaxation; names / descriptions / tips in four languages, tags, four `yoga_*_complete` achievements (`all_complete` now needs them too). The five approved animations are in `assets/animations/` under the exercise ids. The onboarding offers the course and starts its four new branches at stage 1 (Balance is saved for everyone already). The generator now always puts the lying relaxation last: a Yoga day that starts with Balance had the downward dog after it. Version 0.9.1+31 with a "What's new" entry in four languages. 968 tests (frozen enum lists, the Yoga plan: the shared Balance, the cat-cow first and the relaxation last, three sizes differ, the bonus block; its achievements); analyze clean. Checked in the web build at 375 px: the Yoga card in the onboarding (Goro until Miso), the five branches in the Courses tab (Balance last, «Стойка на одной ноге»), today's workout opening with the cat-cow, a search for «Приветствие» (Sun Salutation A playing, the other two with the placeholder), its detail sheet; no console errors.

**Key issues and solutions:** as with the other courses, the catalog entries, ARB keys, `ExerciseL10n` lookups and tags came from one throwaway content table, so the ids and the four languages cannot drift; the reused stages copy their English source texts from the originals. The Spanish Balance branch is already «Equilibrio», so the new one is «Estabilidad». The animation files were renamed from the draft names to the exercise ids; the camel generator lost its heel-reaching variant (the approved file regenerates identically).

**Modified files:** `enums.dart` (+ `enums.g.dart` by hand), `exercise_catalog.dart`, `exercise_tags_catalog.dart`, `course_catalog.dart`, `achievement_catalog.dart`, `achievement_l10n.dart`, `exercise_l10n.dart`, `achievement_service.dart`, `workout_generator_service.dart`, `skill_progress_repository.dart`, `onboarding_provider.dart`, `onboarding_screen.dart`, `developer_options_screen.dart`, `release_notes_catalog.dart`, `pubspec.yaml`, `l10n/*.arb` (+ generated `app_localizations*.dart`), `assets/animations/` (5 new), `tools/lottie/gen_yoga.py`, `tools/lottie/build_preview.py`; tests: `enums_test`, `user_and_achievement_repository_test`, `achievement_service_test`, `workout_generator_service_test`; ARCHITECTURE.md, DEV_NOTES.md, `tz_designer.md`.

---

### 2026-10-08 — Yoga: the plan, and drafts of the five risky poses

**What was done:** branch `session/2026-10-08-yoga` from the merged `main` (0.9.0+30; 887 tests, analyze clean; CI and the web deploy green on GitHub). With the owner: Yoga is next, as 0.9.1 (the version stays 0.9.x until the owner calls it 1.0); courses may share exercises and whole branches — the "no stage repeats another branch" line of the Evening Stretch and Morning Routine plans was a draft principle, not the owner's rule, and is struck through; Yoga includes the Calisthenics Balance branch. The branch plan is in § Roadmap 2b-3. `tools/lottie/gen_yoga.py` drafts the five poses the rig might not manage: the half moon and the eagle (front views: the torso tips sideways in the picture plane; the wrapping shin has a copy under the standing shin, cross-faded once across), the camel (two versions), the wheel and sun salutation A (side views on the three-part spine). The sun salutation is a list of key poses given as parameters (hip, spine, head, arms relative to the chest, how planted the hands are, the ankles) that every frame interpolates and re-plants by IK, so the hands stay on the floor from the first fold to the last and the feet step without sliding. All pass `check_anim.py`. `build_preview.py --preset yoga --dir build/yoga_drafts` is the stand, published as an Artifact for the owner's review; nothing is in `assets/` yet. Stale lines fixed: 0.9.0 "in progress", CI "first run not yet seen", the animation count.

**Key issues and solutions:** the first camel (hands to the heels, chest -84°) read as a forward bow: Goro's arms reach the heels only with the chest level behind him; the hands-on-the-lower-back version reads as a backbend and is proposed, the other kept on the stand for comparison. The first wheel kept the hands by the ears and the feet planted, which Goro's long torso cannot do (the chord from hip to shoulder shrinks by ~30 px as the spine arches): the hands start by the shoulders, the shoulder is the anchor (the hips rise first, a bridge, then the chest), and every frame stays within reach (0.5 px at most). Blending whole poses between stand and fold dragged the torso centre through a squat; the keys now interpolate the hip joint and the angles. The arms of the swan dive stay in line with the torso (an angle relative to the chest) until they plant. A key-time check found a lunge whose back foot was out of reach; the hips were moved. To look at frames without a player, `tools/lottie/frame_sheet.py` draws still frames as SVG (the `lottie-sheets` server in `.claude/launch.json` serves `build/`); Python on Windows needs `PYTHONUTF8=1` for `build_preview.py` (the template is UTF-8).

**New / modified files:** `tools/lottie/gen_yoga.py` (new), `tools/lottie/frame_sheet.py` (new), `tools/lottie/build_preview.py` (`yoga` preset), `.claude/launch.json` (`lottie-sheets`), CLAUDE.md, ARCHITECTURE.md, DEV_NOTES.md.

---

### 2026-10-08 — Morning Routine: all 22 animations in the app (0.9.0)

**What was done:** the owner approved the 18 drafts but the standing cross crunch: "the elbow stretches a lot". It placed the elbow at the knee, so the upper arm grew about 40 % and the forearm, still reaching the back of the head, more than three times. Redrawn so that no arm segment is ever longer than it is: the elbow comes forward and down in front of the chest along the chord between its rest and its knee position (the upper arm foreshortens towards the camera, the path bowed a little outwards so it does not spin round the shoulder), the forearm reaches back towards the head as far as it can (the fist comes off the head to the chin), and the torso crunches harder (shorter, leaning, the head dropping) while the knee comes higher and across. A check of the layer scales confirms it: the arm segments never exceed their natural size. All 22 files are in `assets/animations/` and every Morning Routine exercise has its `animationPath`; the four approved earlier regenerate byte for byte. A throwaway test parsed all 22 with the `lottie` package; 887 tests. The stand shows the final set. Checked in the web build: an Energy challenge plays the stretch-up and the step jacks (with the hands-free countdown), Skala on top; the quit dialog opens (an earlier try where the ✕ did nothing was the browser's phone-size emulation, not the app); no console errors.

**Modified files:** `assets/animations/` (18 new), `lib/data/static/exercise_catalog.dart`, `tools/lottie/gen_morning.py`, `tools/lottie/build_preview.py`, ARCHITECTURE.md, DEV_NOTES.md, `tz_designer.md`.

---

### 2026-10-08 — Morning Routine: the other 18 animation drafts

**What was done:** step (4) of § Roadmap 2b-2, drafts. `gen_morning.py` now draws every Morning Routine exercise. Front views (11): the stretch-up, side bend, open the gate, side lunge, Cossack squat, arm swings (the arm on top alternates through layer copies), Y raises (the hinge shown by a shorter torso and a lower head), cactus arms (the forearm turns towards the camera), step jacks, the standing cross crunch (the head over the fists: hands behind the head), the shake-out. Side views (7): the good morning (elbows forward at the chin), the roll-down (three-part spine, the head last on the way up), the knee hug (up on the toes), butt kicks, mountain climbers, plank to downward dog and the inchworm. All pass `check_anim.py`; each was looked at frame by frame. The stand (`build_preview.py --preset morning`, all 22) is published for the owner's review; nothing new is in `assets/` yet.

**Key issues and solutions:** an arm sweeping 150–170° in 14 frames moved its hand 23–34 px a frame; the arms are driven by angle, with sweeps of 20+ frames. The cactus forearm flipped 90° where its projection passes through zero length; it now swings a little outwards on the way. The crunching elbow turned the short way and flipped mid-move; it always turns round the outside. The first plank-to-dog turned the legs the wrong way (the hips sank to the floor) and the first inchworm sagged into a crawl mid-walk; both now move the hips on an arc of leg length round the planted feet, the inchworm keeping them high early. Goro's short legs make the dog's V steep on the leg side (the legs nearly vertical); flagged to the owner. A raised leg in front of the body merged with it; the near leg is drawn lighter (`LEG_LIGHT`), as in Evening Stretch. The 19 / 21 / 17 counts of earlier entries were wrong (every branch has 5 stages: 20 stages, 22 exercises); fixed throughout.

**Modified files:** `tools/lottie/gen_morning.py`, `tools/lottie/build_preview.py` (cards for all 22), ARCHITECTURE.md, DEV_NOTES.md, `tz_designer.md`.

---

### 2026-10-08 — Aurora, the Morning Routine host (0.9.0)

**What was done:** step (3) of § Roadmap 2b-2. `tools/characters/gen_hosts.py` draws Aurora the lark like Luna and Raffi: six faces, an idle and a cheer pose (`assets/hosts/aurora_*`). A warm sandy lark with a tall crest and a streaked cream breast on a sunrise tile; she wears a sports headband in Goro's blue. The crest perks up when excited and lies flat when sad or asleep; she sings at dawn, so the excited face and the cheer pose open the beak with musical notes instead of sparkles. `CourseId.morningRoutine` now maps to her (Home, Profile, course cards, summary). A line in the 0.9.0 "What's new". The owner approved the drafts (an Artifact stand at 200 / 120 / 100 / 48 px beside Luna and Raffi). 869 tests (every host file decodes, every course has all its host files).

**Key issues and solutions:** the first draft, built on Luna's template with a pale face patch round the eyes, read as an owl; a brown head with pale cheeks and throat only, a taller crest and a slimmer body read as a songbird. Sun rays on the tile read as stray marks round the bird and were dropped; the right-hand clouds moved down so the raised wing of the cheer pose does not end in them. Luna's and Raffi's files regenerate unchanged.

**New / modified files:** `tools/characters/gen_hosts.py`, `assets/hosts/aurora_*.svg` (8), `lib/data/models/enums.dart`, `l10n/*.arb` (`releaseNotes090`), BRAND.md, the design concept, ARCHITECTURE.md.

---

### 2026-10-08 — Morning Routine: the course in the app (0.9.0+30)

**What was done:** step (2) of § Roadmap 2b-2. The owner approved the four risky animations; they are in `assets/animations/`. `CourseId.morningRoutine` (HiveField 3) with `BranchId.morningSpine` / `morningJoints` / `morningArms` / `morningEnergy` (HiveFields 12–15, appended), 20 stage exercises, the `warmup_morning_stretch_up` warm-up and the `cooldown_shake_out` cool-down of every branch, names / descriptions / tips in four languages, tags, four `morning_*_complete` achievements (`all_complete` now needs them too). The onboarding and the Library offer the course; the onboarding starts its branches at stage 1 (the Evening Stretch block became a loop over both courses). The bonus workout keeps the supplementary block. Until Aurora is drawn the course shows Goro's art. Version 0.9.0+30 with a "What's new" entry in four languages. 861 tests (the frozen enum lists, the Morning Routine plan: stretch-up first, shake-out last, Standard ≠ Full, two supplementary exercises in a bonus workout; its achievements). Checked in the web build at 375 px: the course sheet, the four branches in the Library, a search for «Мельница», a workout (stretch-up → side bends → rest → knee circles playing its animation); no console errors.

**Key issues and solutions:** as with Evening Stretch, the catalog, the ARB keys, the `ExerciseL10n` lookups and the tags were written by one throwaway script from a single content table (scratchpad), so ids, keys and the four languages cannot drift. Texts avoid gendered forms where Russian or Spanish would force one ("можно начинать день", "con energía").

**Modified files:** `enums.dart` (+ `enums.g.dart`), `exercise_catalog.dart`, `exercise_tags_catalog.dart`, `course_catalog.dart`, `achievement_catalog.dart`, `achievement_l10n.dart`, `exercise_l10n.dart`, `achievement_service.dart`, `skill_progress_repository.dart`, `onboarding_provider.dart`, `onboarding_screen.dart`, `developer_options_screen.dart`, `release_notes_catalog.dart`, `pubspec.yaml`, `l10n/*.arb` (+ generated `app_localizations*.dart`), `assets/animations/` (4 new); tests: `enums_test`, `user_and_achievement_repository_test`, `achievement_service_test`, `workout_generator_service_test`.

---

### 2026-10-08 — Morning Routine: the four risky animations drafted

**What was done:** step (1) of § Roadmap 2b-2. `tools/lottie/gen_morning.py` draws the four poses marked ⚠️, all front views: the torso twist (hips square, the arms swing round the torso — one across the belly, one behind the back — the torso narrows, its chest patch slides to the turning side, the head turns), the windmill (the arms turn like sails from a T to a vertical line, one hand at the opposite foot, the torso folds towards the camera behind the head, the crown shows), knee circles (feet together, hands just above the knees, the knees circle twice each way), the speed skater without the hop (a step out, the weight over a bent leg, the other foot behind it, the opposite arm across). All pass `check_anim.py`. Published as an Artifact stand (`build_preview.py --preset morning`) for the owner's review; nothing is in `assets/` yet.

**Key issues and solutions:** the first twist (fists at the chest, a 42° turn) barely changed from the front; arms that wrap round the torso, one drawn behind it, read as a turn. The windmill's hand swept 23–34 px a frame (the checker's limit is 22): the arms are now driven by angle, not IK targets (a target just short of full length bent the elbow ~13° and flipped it), and a fold takes 22 frames. In the skater the back foot must pass behind the standing leg on both sides: the left leg has copies under the right one, swapped while the feet are apart. `frontview.Animation` got `shapes_fn`; regenerating every generated animation gives the committed files unchanged (the Flex files differ only in number formatting, as on `main`).

**New / modified files:** `tools/lottie/gen_morning.py` (new), `tools/lottie/frontview.py` (`shapes_fn`), `tools/lottie/build_preview.py` (`morning` preset), ARCHITECTURE.md, CLAUDE.md.

---

### 2026-10-08 — Morning Routine: the content agreed; stale lines fixed

**What was done:** branch `0.9.0` cut from `main` after the Evening Stretch merge (787 tests, analyze clean). With the owner: Morning Routine is the next course — four standing, quiet branches (Spine, Joints, Arms, Energy), 20 stages, a stretch-up warm-up and a shake-out cool-down, Aurora as host; the branch order keeps the daily rotation; the bonus workout keeps the supplementary block. Shadow boxing was replaced by step jacks (the owner: few people know how to shadow-box). Written into Active Specs § Roadmap 2b-2 and the backlog. Also fixed stale lines: the Evening Stretch catalog heading ("no animations yet"), the backlog ("the host Luna open"; "the native widget's texts" — localized since 0.8.18), the animation count (88 of 90). No code changed.

**Modified files:** `DEV_NOTES.md`, `ARCHITECTURE.md`.

---

### 2026-10-08 — The active course's host on Home and in the Profile (0.8.20)

**What was done:** the owner found Goro on Home odd for an Evening Stretch user and asked that the host of the active course be the face there and in the Profile. Luna and Raffi got Goro's six moods (happy, sad, angry → a stern, worried look, sleeping, excited, supportive) and an idle pose; the separate portraits became the happy faces. `GoroExpression.assetFor(course)` picks the Home face (the mood logic is unchanged), `CourseId.hostIdle` the Profile art. Switching the course in the Library switches the face. Goro stays on the icon, the onboarding welcome, notifications, the widget and About. Checked in the web build: Luna on Home and in the Profile with Evening Stretch active, Goro after switching to Calisthenics. 787 tests (every host has all six faces, an idle and a cheer pose).

---

### 2026-10-08 — Luna and Raffi, the course hosts (0.8.20)

**What was done:** drew the hosts of Evening Stretch (Luna the owl) and Healthy Body (Raffi the giraffe) with a new script, `tools/characters/gen_hosts.py` → `assets/hosts/` (a portrait and a cheering pose each, Goro's flat style, the headband blue as a scarf / neck band). `CourseId.hostPortrait` / `hostCheer` map every course to its art (Goro's existing files for Calisthenics). The portraits replace the emoji on the onboarding course cards (`OptionCard.leading`) and sit on the course tiles of the Library's course sheet; the workout summary shows the host of the workout's course (`WorkoutState.courseIdIndex`, passed to `/summary`; a custom routine gets Goro). "What's new" 0.8.20 got a line. Tests: every host SVG decodes, every course's host files exist (775 in all). Checked in the web build: the course sheet with Goro, Raffi and Luna. The summary with Luna was not seen live (the preview server had been stopped by the app); the code path is the one Goro already used.

**Also:** the owner confirmed that an Evening Stretch bonus workout adds no supplementary exercises.

**Key issues and solutions:** Luna's half-closed lids read as bored (flat edge) and then as angry (sagging edge); open round eyes read friendly. Raffi's neck base with a spot showed over the body; the neck is drawn under it.

**New / modified files:** `tools/characters/gen_hosts.py`, `assets/hosts/*`, `pubspec.yaml`, `enums.dart`, `option_card.dart`, `onboarding_screen.dart`, `library_screen.dart`, `workout_provider.dart`, `workout_screen.dart`, `summary_screen.dart`, `test/data/character_svgs_test.dart`, `l10n/*.arb`, BRAND.md, the design concept, ARCHITECTURE.md.

---

### 2026-10-08 — The Evening Stretch animations in the app (0.8.20)

**What was done:** the owner approved all 19 drafts (after one round of fixes: figure four proportions, the frog from above, lighter legs in knees to chest and happy baby, the twisting leg over the other one). `gen_evening.py` wrote them to `assets/animations/` and every Evening Stretch exercise plus `cooldown_lying_relaxation` now has its `animationPath`. The catalog-integrity tests (every file has an exercise and the reverse) pass; 770 tests in all. Checked in the web build: a Back challenge with the new Skala on top, the cat-cow and the child's pose playing.

**Modified files:** `assets/animations/` (19 new), `lib/data/static/exercise_catalog.dart`, BRAND.md, ARCHITECTURE.md, the design concept, `tz_designer.md`.

---

### 2026-10-08 — A seated front view in the Lottie rig; all 19 Evening Stretch drafts

**What was done:** `tools/lottie/frontview.py` learned to sit on the floor (cross-legged, butterfly, straddle), to fold towards the camera with the face turning into the crown of the head, to draw Goro from behind, and to swing arms by their joints (ARCHITECTURE § Lottie Animation Tooling). `tools/lottie/gen_evening.py` makes the six seated poses of Evening Stretch: butterfly, straddle fold, self-hug, overhead triceps, eagle arms, cow face arms (from behind). All pass `check_anim.py` and the Flutter lottie parser; the old front-view files (Neck, Posture, Pull) regenerate byte-identical. Then the other 13: side views (relaxation, knees to chest, happy baby, legs up the wall, the towel stretch, child's pose, sphinx, cobra, puppy, head-to-knee), top views (supine twist, figure four) and the frog from the front. `build_preview.py --preset evening` is the stand of all 19. **The drafts are not in `assets/` yet:** they wait for the owner's look, as every batch before.

**Key issues and solutions:** linear wrist paths swept the forearm through the elbow (60–90° per frame); `swing_arm` rotates it instead. Goro's short arms cannot put an elbow far above the head: the triceps elbow stops at the headband, readable enough. The defaults of the new parameters had to stay ints (`0`, not `-0.0` / `100.0`) to keep the old files byte-identical. The figure four did not read in profile (a knot of dark legs) nor from above with the knee pulled to the chest (it lies on the torso); from above with the knees below the torso the crossed shin and the opened knee draw the "4". Goro's arms cannot reach the supporting thigh there, so they rest and the stretch is the opening knee. Joint angles interpolated naively went the long way round (280° instead of 80°): `lerp_angles` takes the short way. Planted IK picked an elbow under the floor for the cobra start (hand right under the shoulder): the hands now start by the chest, as in the real set-up. **Owner's review (2026-10-08):** the figure four stretched its legs strangely → top-view segments kept to real lengths (the crossed shin 66 px, the ankle travels on a curve); the frog head-on was unclear → redrawn from above, face down (the back and the crown seen, knees wide, forearms ahead; `TopViewAnimation(shapes_fn=...)` with the back-view shapes of `frontview.py`); knees to chest and happy baby: the legs in a lighter tone (`LEG_LIGHT` via `Spec(tint=)`) so they stand out from the torso; supine twist: the moving leg is drawn over the straight one (`TWIST_ORDER`).

---

### 2026-10-08 — Evening Stretch: the course without its animations (0.8.20)

**What was done:** the first new course, as agreed (Active Specs § Roadmap 2b-1): `CourseId.eveningStretch` (HiveField 2) with four new branches `eveningBack` / `eveningHips` / `eveningFolds` / `eveningShoulders` (`BranchId` HiveFields 8–11, appended), 18 stage exercises and the `cooldown_lying_relaxation` cool-down, names / descriptions / tips in four languages, tags, four `evening_*_complete` achievements, warm-up = neck rolls, cool-down = lying relaxation for every branch. Onboarding and the Library offer the course (🦉 on the onboarding card until Luna is drawn); the onboarding starts its branches at stage 1, and an untrained branch defaults to its stage-1 exercise's start values. A bonus workout of this course adds no supplementary exercises (`CourseCatalog.addsSupplementary`). Only the cat-cow has an animation (reused); the course stays on the session branch until the animations are in. The onboarding line "start with one or take both" became "…or pick several" in four languages. Checked in the web build at 375 px: the course sheet, the four branches in the Library, the Back journey, a workout (neck rolls → cat-cow → knees to chest without animation → "Next: Lying Relaxation · 60 sec").

**Modified files:** `enums.dart` (+ `enums.g.dart` by build_runner), `exercise_catalog.dart`, `exercise_tags_catalog.dart`, `course_catalog.dart`, `achievement_catalog.dart`, `achievement_l10n.dart`, `exercise_l10n.dart`, `achievement_service.dart`, `workout_generator_service.dart`, `skill_progress_repository.dart`, `onboarding_provider.dart`, `onboarding_screen.dart`, `developer_options_screen.dart` (`_maxStage` now reads `stageCount`), `l10n/*.arb` (≈ 75 messages each, `releaseNotes0820` line); tests: `enums_test` (the frozen enum lists grow at the end), `user_and_achievement_repository_test`, `workout_generator_service_test` (warm-up / cool-down / no supplementary / Standard ≠ Full), `achievement_service_test`.

**Key issues and solutions:** the catalog, the ARB keys and the `ExerciseL10n` lookups were written by one throwaway script from a single content table, so the ids, keys and four languages cannot drift (the catalog-integrity tests check names, descriptions and tips in every language and the tags). `all_complete` (secret) now also needs the four evening branches.

---

### 2026-10-08 — Skala redrawn as a real bull (0.8.20)

**What was done:** the owner found Skala a recoloured Goro. Both poses are redrawn from scratch by a script, `tools/characters/gen_skala.py` (writes `assets/skala/*.svg`): ivory crescent horns from the sides of a broad flat head, a curly forelock, ears out sideways, small stern eyes, a wide light muzzle with the gold ring, the head sunk between the shoulders, hoof caps on the fists, a warmer brown-black coat. Checked as rendered by flutter_svg itself (a throwaway test drew both to PNG) and at the 140 px the challenge screen uses. A new test decodes every character SVG. Line added to the 0.8.20 "What's new" (one version per branch).

**New / modified files:** `tools/characters/gen_skala.py`, `assets/skala/skala_neutral.svg`, `assets/skala/skala_approve.svg`, `test/data/character_svgs_test.dart`, `l10n/*.arb` (`releaseNotes0820`), BRAND.md, the design concept, ARCHITECTURE.md.

**Key issues and solutions:** the first thumbs-up had one digit rising from the middle of the fist and could be read as a rude gesture; the thumb now rises from the outer side with the curled fingers drawn in front (written into BRAND.md as a rule for every character).

---

### 2026-10-08 — Holds on each side (0.8.20+29)

**What was done:** a one-sided timed hold (`Exercise.perSide`) now runs on both sides in one set: side 1 → a 5 s "switch sides" countdown → side 2 → the rest, hands-free like the get-ready countdown (Pause works in it, Stop on side 1 moves on to side 2). The amounts are per side; the result keeps the weaker side, so a set and a challenge pass only when both sides reach the target; SP counts both sides; the time estimate counts both holds and the switch. The screen shows "Set 1 of 3 · side 2 of 2", plays a pop when a side ends, and "N sec each side" is shown on the rest screen, in the Branch Journey params and in the challenge norm. Eleven existing exercises got the flag (hip flexor stretches, 90/90, neck tilts, kneeling lunge, pigeon, single-leg stand, one-arm plank, three cool-downs, side plank). The neck-tilt text said "hold 5 s, return, alternate" in every language; it now describes one held side, then the other. Checked in the web build at 375 px (pigeon, neck tilts: both sides, the switch countdown, the rest label). "What's new" entry in four languages.

**New / modified files:**
- `lib/data/models/exercise.dart` — `perSide`, `holdsPerSet`
- `lib/domain/models/workout_plan.dart` — `kPrepSwitchSideSec`, `prepSecFor(..., side:)`, the estimate
- `lib/features/workout/providers/workout_provider.dart` — `sideIndex`, `firstSideSec`, `isLastSide`, `isSwitchingSides`; `confirmSet` switches sides
- `lib/features/workout/screens/workout_screen.dart` — side in the set line, "switch sides" ring label and hint, pop, per-side amounts on the rest screen
- `lib/domain/services/sp_service.dart` — both sides count
- `lib/features/home/screens/branch_journey_screen.dart`, `lib/features/library/screens/library_screen.dart` — per-side params / norm
- `lib/data/static/exercise_catalog.dart`, `supplementary_exercise_catalog.dart` — the flags
- `l10n/*.arb` — 6 new messages, the neck-tilt description, `releaseNotes0820`
- tests: `workout_timer_test.dart` (the side sequence, Stop on side 1, pause in the switch, the weaker side, the estimate equals the ticks of runs with per-side holds), `workout_plan_test.dart`, `sp_service_test.dart`, `exercise_catalog_integrity_test.dart` (only timed holds are per side); `release_notes_catalog_test.dart` no longer lists the newest versions by hand

**Key issues and solutions:**
- The targets of the flagged exercises were kept and became per side (the decision on file), so a workout with them takes longer — e.g. the hip flexor stretch at its target is now 3 × (60 + 5 + 60) s. If that is too long, halve the targets; nothing else depends on them.
- The test helpers picked "the first timed exercise" of the catalog; they now pick the first one that is *not* per side, so a new flag cannot silently change what they test.

---

### 2026-10-08 — Evening Stretch, per-side holds and the course hosts decided

**What was done:** with the owner: Evening Stretch is the first new course, four branches (Back, Hips, Folds, Shoulders; 18 stages + a Lying Relaxation cool-down, none repeating a Flex / Posture / Neck stage); one-sided holds get a hands-free "switch sides" step; every course gets a host character (Raffi the giraffe, Luna the owl, Aurora the lark, Miso the cat; Goro keeps Home and every animation); Skala is to be redrawn as a real bull; Bruno is dropped as a demonstrator, Rex deferred. Written into Active Specs § Roadmap (2b-1, Per-side holds, Course hosts), the backlog, BRAND.md and the design concept. Open: no supplementary block in the evening bonus workout (proposed, to confirm). No code changed.

**Modified files:** `DEV_NOTES.md`, `ARCHITECTURE.md` (backlog rows), `design-system/caliday/BRAND.md`, `internal_docs/design-concept/caliday_design_concept.md`.

---

### 2026-10-07 — Each branch progresses once a day in any workout; friends without branch progress (0.8.19+28)

**What was done:** two owner decisions taken while discussing courses.

- **Progression per branch and per day.** Before, only the first workout of the day advanced progression, whatever its course, so a morning course and an afternoon course could not both progress. Now a branch moves on at most once per calendar day, on the first *successful* set of its current stage that day, in any workout (primary, bonus, daily plan or custom routine); SP and the streak keep their rules (the first workout of the day: full SP ×1.5 and the streak; the others ½ SP). `ProgressionService.applyDailyResult(…, now:)` holds the gate (pure; `applyResult` stays the bare step, which the existing tests drive many times in one "day"); the day is `SkillProgress.lastProgressedOn` (new HiveField 6, nullable, no migration; the adapter edited by hand like the others), compared by calendar day (`calendarDaysBetween`, DST-safe). `_finishWorkout` calls it for every exercise of a branch instead of `if (isPrimary) applyResult`. The summary's bonus line said "progression already saved", now "each branch moves on once a day" (four languages).
- **A bug closed by the same gate:** `applyResult` never checked the exercise's stage, so a custom routine with an exercise of a lower (or another) stage moved the branch's current stage by that exercise's targets. Such an exercise no longer counts.
- **Friends no longer receive branch progress.** QR format 3 = format 2 without the 4 stage bytes; format 2 and 1 are still read (a real format 2 code from 0.8.18 is a test fixture, and format 3 is checked to be exactly its bytes without the stage field); `stages` is no longer put into the profile map (QR and BLE), `FriendProfile.fromQrJson` ignores it, the friend sheet lost its branch chips; the Hive field `branchStages` stays, empty. The typical code shrank from 66 characters / QR version 8 to 61 / 7. Builds before 0.8.19 cannot read format 3 (the app is not in the stores yet; the web build updates itself).
- Tests: the daily gate (first success moves and marks the day; a second workout the same day does not; the next day does; a failed set does not use the day up; two branches the same day both move; another stage never counts; nothing while the Challenge waits; calendar days across midnight and both Berlin DST changes), the new Hive field across a restart, the friend formats. Two mutations of the gate (no day check, no stage check) each fail the tests. Not covered by a test: `_finishWorkout` itself (it touches Hive, notifications and Health; the change there is the one call).
- Left as it was, noted for later: `ProgressionService.applyRegression` (the documented rollback after 3+ skipped days) is never called anywhere.

**Modified files:** `skill_progress.dart` (+ `.g.dart`), `progression_service.dart`, `workout_provider.dart`, `friend_qr_codec.dart`, `friend_profile.dart`, `ble_profile_codec.dart`, `friends_screen.dart`, `friend_detail_bottom_sheet.dart`, `l10n/app_{en,ru,de,es}.arb` (+ generated), `release_notes_catalog.dart`, `pubspec.yaml`, tests (`progression_service_test`, `skill_progress_repository_test`, `friend_qr_codec_test`, `ble_profile_codec_test`, `friend_qr_payload_test`, `release_notes_catalog_test`), `ARCHITECTURE.md`, `DEV_NOTES.md`.

---

### 2026-10-07 — The owner's decisions on courses recorded

**What was done:** the owner settled what a course is: it stays a set of branches with staged progression (Yoga = harder and harder poses, the morning / evening routines = branches whose reps grow); more branches come before the builder, also outside any course; the builder offers a course from existing branches or a branch of one's own (own exercises in order, progression through them); friends stop carrying every branch's progress. Written into Active Specs § Roadmap (2a–2c, 3) with what each step touches; the first step is 2a, a frozen list of shared branches, because a ninth `BranchId` would silently change the QR format 2 under the same version byte. One question is left open there: only the first workout of a day progresses, whatever its course. No code changed.

**Modified files:** `ARCHITECTURE.md` (backlog rows), `DEV_NOTES.md`.

---

### 2026-10-07 — The home screen widget in the app's language (0.8.18+27)

**What was done:** the medium widget's "done" label was hard-coded Russian on both platforms («Готово» in `CaliDayWidget.swift` and `caliday_widget_medium_layout.xml`), and so was the iOS gallery description; every user saw it, English ones included.

- **The app hands over every text.** Native string resources were not used on purpose: they follow the system language, while the app has its own language setting. `WidgetService.texts(rank, locale)` (pure, tested) gives `rankName` and the new `doneLabel` (ARB `widgetDoneLabel`: Done / Готово / Erledigt / Hecho); `update` now takes `rank` and `locale` instead of a ready rank name, and the Swift entry and the Android medium receiver read `doneLabel` (the layout's TextView got the id `widget_done_label` and an empty default). Until the app writes the label (data left by an older version) the check mark is shown alone.
- **The iOS gallery description** is shown before the app has ever run, so it cannot come from the app: `galleryDescription()` holds one line per app language and picks by `Locale.preferredLanguages` (English otherwise). Its German and Spanish lines are drafts like the rest. The Xcode previews and the placeholder entry no longer carry Russian sample texts.
- **A language change now reaches the widget and the notifications at once:** both take their texts when they are written, so after switching the language in Settings they stayed in the old one until the next start or workout. `setLocale` calls `WidgetService.updateTexts` and `NotificationService.scheduleAll`.
- Tests (`widget_service_test`): the texts in every language and the English fallback; **the contract between the sides** — the Swift and Kotlin sources read every key `texts()` writes; no Russian in the Android layouts; in Swift, Russian only on the `ru` line of the gallery table, which has exactly the codes of `appLanguages`. Three mutations (Russian back in the layout, a language missing from the Swift table, a renamed key in Swift) each fail it.
- **Verified:** `flutter build apk --debug` builds (Kotlin and the layout compile). **Not verified: the iOS widget was not compiled** — there is no Xcode on this Windows machine and no CI job builds iOS while `release.yml` is disabled. The Swift change is small (one entry field, one `if`, one function), but it needs a build in Xcode before a release.

**Modified files:** `widget_service.dart`, `main.dart`, `workout_provider.dart`, `settings_provider.dart`, `ios/CaliDayWidget/CaliDayWidget.swift`, `CaliDayWidgetMediumReceiver.kt`, `caliday_widget_medium_layout.xml`, `l10n/app_{en,ru,de,es}.arb` (+ generated), `release_notes_catalog.dart`, `pubspec.yaml`, `widget_service_test.dart`, `release_notes_catalog_test.dart`, `ARCHITECTURE.md`, `DEV_NOTES.md`.

---

### 2026-10-07 — Numbers agree with their words in every language (0.8.17+26)

**What was done:** the owner asked to fix the counted messages that had no plural. A scan of every message with an `int` placeholder found more than the four Russian ones:

- **Russian:** «1 друзей» (`profileFriendsCount`), «1 / 21 упражнений» (`customWorkoutExerciseCount`), «потренировался 5 раза» (`summaryBonusCount`, shown from the second workout of the day), «стрик 1 / 3 дней» (`friendsScanConfirmBody`).
- **English, German and Spanish — the most visible one:** 60 of the stages start with **one set** (`startSets: 1`), so the branch journey read "5 reps × 1 sets" ("1 Sätze", "1 series"); five start at 1 rep, and the hardest challenge norms are 1 rep ("Goal: 1 reps"). `branchJourneyParams(Timed)`, `homeChallengeNormReps` and `historyDetailReps` are plurals now; "1 friend", "1 exercise", "1 time" in English too. Russian and German use the abbreviations «повт.» / «подх.» / «Wdh.», which need no plural.
- **The rest screen's "Next: … • 1 reps"** glued a number to a separate unit word (`workoutUnitReps`), which cannot agree with the number. The unit message is gone; the amount and its unit are one message now: `workoutAmountReps(n)` for reps, the existing `durationSec(n)` for timed exercises, and `workoutNextExercise(name, amount)` / `workoutNextSet(setNum, amount)` take that text (the placeholders changed type in all four ARB files).
- Tests: `plural_test` checks the Russian forms (1 / 2–4 / 5–20 / 21) and the English singulars of all of them, and its every-language check ("a counted message carries its number") now covers the nine new plurals.

**Modified files:** `l10n/app_{en,ru,de,es}.arb` (+ generated), `workout_screen.dart`, `release_notes_catalog.dart`, `pubspec.yaml`, `plural_test.dart`, `release_notes_catalog_test.dart`, `ARCHITECTURE.md`, `DEV_NOTES.md`.

---

### 2026-10-07 — The code takes any number of languages; German and Spanish drafts (0.8.16+25)

**What was done:** step 1 of the German / Spanish plan (Roadmap § 1): the places that assumed exactly Russian and English were found and made to follow one list of languages, without adding a language. Also removed the `linux/`, `macos/`, `windows/` folders that `pub get` had left behind after their removal (only ignored generated files, `macos/Flutter/ephemeral/*`, and empty directories), and committed `.claude/launch.json` (the `flutter run -d web-server` configuration the in-app browser preview starts).

- **One list of languages:** `appLanguages` in the new `core/l10n/app_languages.dart` (code, the language's name in itself, flag), with `supportedLanguageCode` (a supported code or English), `appLanguageOf` and `l10nFor` (the `AppLocalizations` of a code without a BuildContext, through the generated `lookupAppLocalizations`). `LocaleNotifier` uses it for the system language (before: `ru` → `ru`, anything else `en`).
- **Notification texts moved into the ARB files** (`notificationMorningTitle` … `notificationRankAtRiskBody`): the hand-written ru / en table of `NotificationPlanner` is gone, and so is its Cyrillic exception. `NotificationPlanner.textsFor(locale)` returns the `AppLocalizations`; no language → Russian (as before), an unknown one → English (before: Russian; it now matches what the UI shows). **A Russian bug fixed on the way:** the streak-lost text said "Твой стрик 21 дней пропал"; it is now a plural ("21 день", "3 дня", "12 дней"). The debug buttons of `NotificationService` read the same messages.
- **The widget's rank names** come from the ARB files too (`rank.localizedName(l10nFor(locale))`), so the second hand-written table and its Cyrillic exception are gone.
- **Pickers:** the Settings dialog lists `appLanguages` (its title is now the localized "App language" instead of the bilingual "Язык / Language"); the subtitle is the language's own name. The onboarding RU / EN buttons became **one chip with the current code and a menu** of all languages: four buttons would have run into the progress dots (measured: 2 buttons take ~78 px of the 375 px width, 4 would take ~160 and reach the dots in the middle). Seen in the browser with two fake extra languages (Deutsch, Español): the menu, the dialog, switching to English and back to Russian.
- **Tests now cover every language:** `arb_consistency_test` reads every `l10n/app_*.arb` and compares it with the template (and with `AppLocalizations.supportedLocales`); the exercise-text, workout-size, release-note and notification tests loop over `test/helpers/all_translations.dart`; `plural_test` checks in every language that a counted message carries its number; new `app_languages_test` (the list equals the ARB files, names and flags, the fallback). **Proved with a fake `app_de.arb`** (a copy of the English one): exactly two failures, the missing `appLanguages` line and the release notes left in English; removed again (and its generated file, which `gen-l10n` does not delete).
- **`no_hardcoded_text_test` failed on Windows before this change:** `Directory.listSync` gives `lib\core\...`, which matched no allow-list entry (`lib/...`), so every allowed file was reported; CI runs on Linux and never saw it. The scan now turns `\` into `/`. The allow-list lost the widget, the notification table and the onboarding codes "RU" / "EN", and gained the language list.
- **A test that broke with every version bump:** `whats_new_screen_test` expected "seen 0.8.13" to leave two NEW tags (0.8.15 and 0.8.14). It now takes the third newest entry of the catalog. **The guard that forces release notes is a different test and is unchanged:** `release_notes_catalog_test` fails while the newest entry is not the `pubspec.yaml` version. Checked by removing the 0.8.16 entry: the catalog test failed, while the old screen test passed (it never caught a forgotten note) and, with the note back, failed (it fired on a note that *was* written).
- **German and Spanish, in the same version at the owner's request:** `app_de.arb` / `app_es.arb` (562 messages each, drafts for native proofreading, see Roadmap § 1), two lines in `appLanguages`, the 0.8.16 "What's new" text now announces them in all four languages. iOS now declares its languages: `CFBundleLocalizations` (ru, en, de, es) in `ios/Runner/Info.plist` was missing entirely, so iOS treated the app as English-only in its per-app language setting and the App Store; `app_languages_test` keeps the list equal to `appLanguages`. All tests pass with four languages (the "every language" tests now run on de and es too); the screens were checked in the browser (Roadmap § 1).

**New files:** `lib/core/l10n/app_languages.dart`, `l10n/app_de.arb`, `l10n/app_es.arb` (+ generated `app_localizations_de.dart` / `_es.dart`), `test/core/app_languages_test.dart`, `test/helpers/all_translations.dart`, `.claude/launch.json`.
**Modified files:** `locale_provider.dart`, `notification_planner.dart`, `notification_service.dart`, `widget_service.dart`, `settings_screen.dart`, `onboarding_screen.dart`, `release_notes_catalog.dart` (0.8.16 entry), `l10n/app_en.arb`, `l10n/app_ru.arb` (+ generated), `ios/Runner/Info.plist`, `pubspec.yaml`; tests: `arb_consistency_test`, `plural_test`, `no_hardcoded_text_test`, `widget_service_test`, `enums_test`, `exercise_catalog_integrity_test`, `release_notes_catalog_test`, `notification_planner_test`, `whats_new_screen_test`; `ARCHITECTURE.md`, `DEV_NOTES.md`.

---

### 2026-10-07 — "What's new" under a bell in the profile; the "built with" line is gone (0.8.15+24)

**What was done:** two things the owner asked for. (1) The About screen no longer lists the technologies it is built with (a technical line of no interest to the user): the block, its ARB key `aboutBuiltWith` and the `_notProse` exception of the English guard are removed. (2) A way to tell users what changes with each update: a **bell in the Profile app bar** (next to the settings gear) opens `/whats-new`, the history of the versions, newest first, each with its date and a list of changes in the user's words, with a NEW tag on what the user has not seen.

- **The bell shows a dot while an entry is unopened.** `UserProfile.lastSeenReleaseVersion` (new HiveField 26, nullable, no migration; the adapter was regenerated) holds the newest version the user opened; `hasUnseenReleaseNotesProvider` compares it with the catalog (versions as numbers, 0.8.10 > 0.8.9). Opening the screen saves the newest version after the first frame, and the NEW tags of that visit stay until it is closed. A user who is already installed sees everything as new once; a new user is set to the current version when onboarding completes, so the bell lights up for the next update only.
- **Content** is `ReleaseNotesCatalog` (`data/static/release_notes_catalog.dart`): `ReleaseNote(version, date, text: (l10n) => …)`, the text an ARB string `releaseNotes<version without dots>`, one change per line. Six entries were written, 0.8.10 to 0.8.15 (the work of this stretch, in the user's words). The Russian ones address the user as "ты", like the rest of the UI.
- **So that it stays up to date:** `test/data/release_notes_catalog_test.dart` fails while the newest entry is not the `pubspec.yaml` version, and the step is written into the `implement-feature` (Step 6) and `pre-commit` (Step 0.5) skills. A commit that bumps no version needs no entry.
- **What it is not:** the app has no backend, so the bell lists what the installed build contains; it does not say that a newer version exists in a store. That would need a network check (for example the GitHub Releases API), which the "all data is local" principle has so far avoided. Not done.
- Tests: the catalog (the pubspec version, order and uniqueness, both languages, `compareVersions`, `unseenSince`), the provider on a real Hive (the dot, saved across a reopen, never lowered), the screen (tags, marking, Russian) and the bell (dot on and off, tap opens it) as widget tests, the profile field in the Hive roundtrip, and a new user after `completeOnboarding`. Eleven mutations (versions compared as text; everything unseen; the pubspec version; not saved; a lower version saved; the tags vanishing on open; not marked on open; a new user getting the dot; the bell's dot always on / never on; the bell opening nothing) each fail a test. **Two of my first mutation runs were worthless** (the suite was already red, once because the new onboarding test needed `TestWidgetsFlutterBinding`, once because zsh did not split a variable of paths); both were redone from a verified green baseline.
- Checked in the browser (Russian): the bell next to the gear, the screen with its cards and NEW tags, the shorter About screen. Not seen on screen: the dot itself (the test profile had already opened the notes and a reset was avoided); the widget test covers it.

**New files:** `lib/data/static/release_notes_catalog.dart`, `lib/features/profile/providers/whats_new_provider.dart`, `lib/features/profile/screens/whats_new_screen.dart`, `lib/features/profile/widgets/whats_new_bell.dart`, and the tests above.
**Modified files:** `user_profile.dart` (+ `.g.dart`), `onboarding_provider.dart`, `profile_screen.dart`, `app_router.dart`, `about_screen.dart`, `l10n/app_en.arb`, `l10n/app_ru.arb` (+ generated), `no_hardcoded_text_test.dart`, `ARCHITECTURE.md`, `DEV_NOTES.md`, `pubspec.yaml`, and the two skills.

---

### 2026-10-07 — Telegram Mini App + bot researched and parked

**What was done:** the owner asked whether the app could also be a Telegram bot (reminders sent by the bot, everything else a Mini App). The Telegram and Cloudflare documentation was read and the live web build measured (first load about 4.2 MB compressed). Result, in Active Specs § Telegram Mini App + bot: the Mini App is cheap because the web build already runs the app; the bot reminders need a small opt-in server, which the "no backend" principle has so far excluded (the bot cannot read any Mini App storage, cannot message first, has no scheduler and no time zone of the user); `startapp` is limited to 64 characters, so a friend link fits short names only; a Mini App needs no Apple or Google account. A design is sketched (the client computes the schedule from `NotificationPlanner`, the server only fires it) together with a list of what is unverified. **The owner then parked it as a thought on the side;** the row in the backlog says 💡 parked, and no code was written.

**Modified files:** `ARCHITECTURE.md` (a backlog row), `DEV_NOTES.md`.

---

### 2026-10-07 — A guard against hard-coded English too

**What was done:** the Cyrillic guard (`no_hardcoded_text_test.dart`) could not see English, and the first hard-coded English found in this work (the "All" chip of the routine builder) shows that it is the likelier leak. English cannot be told from code by scanning the whole source, so the new check looks only at the places where text is shown.

- **What it reads:** the first argument of `Text(` / `Text.rich(` and the value of `label:`, `labelText:`, `title:`, `subtitle:`, `hintText:`, `helperText:`, `errorText:`, `tooltip:`, `semanticsLabel:`, `message:`. From that expression it takes the string literals that are shown themselves — alone, in a ternary (`cond ? l10n.a : 'Again'`) or after a `+` — and skips those inside the arguments of a call (`DateFormat('d MMMM')`, `l10n.f('x')`), which are data. A small tokenizer reads the expression (nested quotes inside `${...}`, grouping brackets against call brackets).
- A literal is a hit when, after removing interpolations and the words that are the same in every language (`CaliDay`, `SP`, `dBm`, `RU`, `EN`), a word of two letters or more is left. `lib/data/` is not scanned: the exercise catalog holds the source text (`name`, `description`, `techniqueTip`), and the screens read it through `ExerciseL10n`; only the library search reads `Exercise.name`. The technologies line of the About screen is listed as no prose. Allowed files: the debug screen and the settings screen (the language picker names each language in itself), each with its reason; a test fails when an allowed file stops needing it.
- **The real code was clean:** the scan found nothing outside those two files, so this adds a fence, not a fix.
- **The first version was blind to ternaries:** it only read a literal right after `Text(`; a mutation with `: 'Again'` in the Again button survived, and the scan was rewritten to read the whole expression. A test now checks the scan on probe snippets that must and must not be found, so a scan that matches nothing cannot pass. Five mutations on real files (a plain literal, one after `label:`, one in a ternary, a changed brand name, "points" instead of "SP") each fail it.
- Limit: a literal passed as a call argument is not seen (`Text(items.map((e) => 'x $e').join())`), and neither is English in a variable that is then shown. Review still has to look at those.

**Modified files:** `test/l10n/no_hardcoded_text_test.dart`, `ARCHITECTURE.md`, `DEV_NOTES.md`. No app code changed, so no version bump.

---

### 2026-10-07 — The estimate on the "Again" button too (0.8.14+23)

**What was done:** the owner asked for the same "(≈ N min)" on the bonus button, corrected for the user's pace like the main one.

- The reason it was left out was real: a bonus workout adds two random supplementary exercises when it starts, so the estimate from Home would not have been of the workout that runs. Fix: the pick is **seeded**, not random. `generateDailyForCourse` takes an optional `Random`; `buildDailyPlan` passes `Random(supplementarySeed(today, number of workouts already done today))`. Home and the workout screen build the plan independently and get the same two exercises; once another workout is logged the count changes and the next bonus workout gets a different pair. Nothing is cached, so there is no stale plan after midnight.
- A visible side effect: leaving a bonus workout without finishing it and tapping "Again" again gives the same two supplementary exercises (it used to be a new random pair). It changes after a workout is finished.
- Home: "Ещё раз (≈ N мин)" / "Again (≈ N min)" (`homeWorkoutAgainEstimate`), at the user's pace (`workoutPaceProvider`), same one-line form as "Today's workout".
- Tests: the generator test (the same seed gives the same plan, other seeds give other pairs, the seed follows the day and the number of workouts, a primary workout ignores the random) and `test/features/workout/daily_plan_test.dart` (new), which uses the real repositories: for the day's own workout, for the first bonus workout and for four more, the plan Home builds and the plan `WorkoutNotifier` runs have the same exercises and the same estimate. Four mutations (no seed; the workout screen building its own random plan; a seed that ignores the count; a generator that ignores the given random) each make a test fail.

**Modified files:** `lib/domain/services/workout_generator_service.dart`, `lib/features/workout/providers/workout_provider.dart`, `lib/features/home/screens/home_screen.dart`, `l10n/app_en.arb`, `l10n/app_ru.arb` (+ generated), `test/domain/services/workout_generator_service_test.dart`, `test/features/workout/daily_plan_test.dart` (new), `ARCHITECTURE.md`, `DEV_NOTES.md`.

---

### 2026-10-07 — The time estimate learns the user's pace (0.8.13+22)

**What was done:** "≈ 9 min" on the Home button was a fixed guess (3 s per rep, no pauses, no skipped rests). It now corrects itself from the user's own finished workouts.

- **The logs could not be used as they were:** a `WorkoutLog` has the real `durationSec` but not the sets and rests of its plan, so a past workout cannot be re-estimated. `WorkoutLog` got **HiveField 9, `estimatedDurationSec`** (nullable, so old logs read as null, no migration; the adapter was regenerated with `build_runner` and only that file changed): `_finishWorkout` stores the plan's *raw* estimate. The pace therefore starts from the first workouts after this update.
- `WorkoutPace` (`domain/services/workout_pace.dart`, pure): the factor is the median of real / estimated over the newest 7 workouts that have both numbers, 1.0 until 3 exist, clamped to 0.6–1.6. Median, not mean, because one workout with a phone call in the middle should not matter; the clamp keeps a bad run of workouts from making "≈ 9 min" absurd. `WorkoutPlan.estimatedMinutesAt(pace)` scales and rounds; `workoutPaceProvider` (rebuilt with `homeDataProvider`, which a finished workout invalidates) feeds the Home button.
- **A choice that was not obvious:** one factor on the whole estimate, not a "seconds per rep" fitted separately. The timed parts of a plan are exact by construction, so only the reps and the overhead drift, but a per-rep fit would need the number of reps and the rests stored too and is noisy for workouts with few reps; the single factor is cheap, explainable and good enough for a figure rounded to minutes. If it proves too coarse, store the split (fixed part, reps count) in the log instead.
- Known limit, written in ARCHITECTURE: the stored ratios belong to the formula of their day; changing `kSecondsPerRep` or the countdowns makes the figure off for up to seven workouts.
- The debug state dump prints `Pace: x1.00 from N workouts (needs 3)`.
- Tests: `workout_pace_test.dart` (new, 8 cases: too few workouts, the ratio, median against an outlier, an even count, the clamp, only the newest 7 in any input order, logs without an estimate or a time are skipped) — eight mutations of `WorkoutPace` each make one fail; `workout_plan_test.dart` (`estimatedMinutesAt`); `workout_repository_test.dart` (the field survives closing and reopening the box, and a log without it reads as null).
- Not done: showing the user that the figure is personal; a fit of the pace per rep.

**Modified files:** `lib/data/models/workout_log.dart` (+ `.g.dart`), `lib/domain/services/workout_pace.dart` (new), `lib/domain/models/workout_plan.dart`, `lib/features/workout/providers/workout_provider.dart`, `lib/features/home/screens/home_screen.dart`, `lib/features/settings/screens/developer_options_screen.dart`, the tests above, `ARCHITECTURE.md`, `DEV_NOTES.md`, `pubspec.yaml`.

---

### 2026-10-07 — "≈ N min" on the Home button, a notification without a promise (0.8.12+21)

**What was done:** the follow-up to "workout size": the time the app can honestly say is an estimate of the actual plan, so Home now shows it, and the notification stopped promising one.

- `WorkoutPlan.estimatedDurationSec` was a stub ("30 s a set") that nothing showed. It now follows the workout screen: the hold plus the get-ready countdown for a timed set, `kSecondsPerRep` = 3 s per rep for a reps set, the rest after every set except the last of the workout. `estimatedMinutes` rounds to whole minutes (at least 1). The get-ready constants and `prepSecFor` moved from the workout provider into `workout_plan.dart` so both use the same numbers.
- **The estimate is tested against the real thing:** for timed-only plans `estimatedDurationSec` equals the number of ticks the actual `WorkoutNotifier` takes (the test steps it up to the last hold). Reps cannot be tested that way (the user taps Done), so they stay a guess; the "≈" says so. Seven mutations of the formula each make a test fail.
- `buildDailyPlan(Ref)` is the daily branch of `WorkoutNotifier._buildPlan`, now shared; `todayPlanProvider` (autoDispose, watches `homeDataProvider`) builds it for Home. `setWorkoutSize` now invalidates `homeDataProvider` (the pull-up bar setter already did), so changing the size updates the estimate without a restart: checked in the browser, "Full" ≈ 9 min became "Short" ≈ 4 min.
- Home: the gradient button reads "Тренировка дня (≈ 9 мин)" / "Today's workout (≈ 9 min)" on one line, centered, at the size of the label (`homeWorkoutStartEstimate`; the first version put it as a small second line, which made the button lopsided), only while the day's own workout is open. After it, the "Again" (bonus) button shows nothing: that plan has random supplementary exercises, so an estimate from Home would not be of the workout that starts.
- Evening notification: "Займёт всего 10 минут" / "It only takes 10 minutes" → "Даже короткая тренировка засчитается" / "Even a short workout counts" (it is true: any primary workout with real work counts for the streak). A notification is written long before the workout, so it cannot carry the estimate; a test fails if any notification text contains "N min". The design document's example text was updated the same way.
- Tests: `test/domain/models/workout_plan_test.dart` (new), the run-vs-estimate group in `workout_timer_test.dart`, "a bigger size takes longer" (both courses, 12 days) in the generator test, `notification_planner_test.dart`, and `test/features/onboarding/onboarding_state_test.dart` (new: every onboarding choice survives the hand-written `withHasPullUpBar` copy, the size is needed to continue).
- Not done: calibrating the pace from the user's own finished workouts (`WorkoutLog.durationSec` is there); the general "5–15 minutes" wording in the design document and ARCHITECTURE.

**Modified files:** `lib/domain/models/workout_plan.dart`, `lib/features/workout/providers/workout_provider.dart`, `lib/features/workout/screens/workout_screen.dart`, `lib/features/home/screens/home_screen.dart`, `lib/features/settings/providers/settings_provider.dart`, `lib/domain/services/notification_planner.dart`, `l10n/app_en.arb`, `l10n/app_ru.arb` (+ generated), the tests above, `ARCHITECTURE.md`, `CaliDay_Design_Document.md`, `DEV_NOTES.md`, `pubspec.yaml`.

---

### 2026-10-07 — Workout size replaces "5 / 10 / 15 minutes" (0.8.11+20)

**What was done:** the owner noticed that the 5 / 10 / 15 minute choice in onboarding and Settings does not match the real time and misleads. It never was a duration: the number only picks how many skill branches the day covers (2 / 3 / all). Measured with the real generator (3 s per rep, the rests of the progression, the new 10 s get-ready): about 6 / 8–9 / 15 min at the start for Calisthenics, but about 10 / 15 / 29 min with 12×3 reps and 60 s rests, and in Healthy Body (3 branches) "10" and "15" are the same workout.

- The owner chose names by volume, not time: **Short / Standard / Full** ("Короткая / Стандартная / Полная") with the descriptions "2 skills", "3 skills", "All your skills". Onboarding asks "How big should your workout be?"; Settings has "Workout size" with a full-width segmented control (the 5 / 10 / 15 chips were too narrow for words), the same widget as the theme choice.
- `WorkoutSize` (`enums.dart`): `short(5)`, `standard(10)`, `full(15)`, `fromCode`, localized name and description. **The stored value did not change**: `preferredWorkoutMinutes` still holds 5 / 10 / 15, so no migration and old profiles read correctly; `WorkoutMinutes` (onboarding) and the 5 / 10 / 15 chips are gone, `OnboardingState.workoutMinutes` is `workoutSize`, `SettingsState.preferredWorkoutMinutes` is `workoutSize`, `setWorkoutMinutes` is `setWorkoutSize`. The generator keeps its `preferredMinutes` parameter; its doc now says it is a size code.
- Strings: `minutesLabel`, `minutesFiveDesc`, `minutesTenDesc`, `minutesFifteenDesc`, `settingsWorkoutDuration*` removed; `workoutSizeShort / Standard / Full`, `workoutSize…Desc`, `settingsWorkoutSize…` added; `onboardingQ3` reworded. `_SettingsTile.trailing` became optional.
- Tests: `enums_test.dart` pins the stored codes (a changed code would silently re-size every saved profile), `fromCode`, the names in both languages, and that no name carries a "N min" promise; `workout_generator_service_test.dart` checks that any stored code 0..30 acts as its `WorkoutSize`. Checked in the browser in both languages.
- **Left alone, same kind of claim:** the evening notification says "Займёт всего 10 минут" / "Just 5 minutes" in `notification_planner.dart`, and `ARCHITECTURE.md` / the design document still describe a session as "5–15 minutes" in general terms. `WorkoutPlan.estimatedDurationSec` exists (~30 s a set plus rests) but is not shown anywhere; an honest estimate on the Home button would be the real fix for "how long will it take", and is not done.

**Modified files:** `lib/data/models/enums.dart`, `lib/features/onboarding/providers/onboarding_provider.dart`, `lib/features/onboarding/screens/onboarding_screen.dart`, `lib/features/settings/providers/settings_provider.dart`, `lib/features/settings/screens/settings_screen.dart`, `lib/domain/services/workout_generator_service.dart` (doc only), `l10n/app_en.arb`, `l10n/app_ru.arb` (+ generated), `test/data/enums_test.dart`, `test/domain/services/workout_generator_service_test.dart`, `ARCHITECTURE.md`, `CaliDay_Design_Document.md`, `DEV_NOTES.md`, `pubspec.yaml`.

---

### 2026-10-07 — Hard-coded UI strings moved to l10n

**What was done:** the owner asked to fix every place like the two Russian strings found in the exercise library ("Сбросить" and the "упражнение / упражнения / упражнений" label). A scan of `lib/` found these, all in the code, not in the ARB files, so they stayed Russian (or English) in the other language:

- `exercise_library_screen.dart`: the reset link → `exerciseLibraryReset`; the result count → `exerciseLibraryCount` (a real ICU plural: the hand-written function said "21 упражнений" and "22 упражнений", the plural gives "21 упражнение", "22 упражнения"). The number and the noun are one `Text` now, so the number is no longer bold on its own.
- `workout_calendar_screen.dart`: the weekday header ("Пн … Вс") now comes from `intl` for the app locale, Monday first (`calendarWeekdayHeaders`, tested); the legend → `calendarLegendOneWorkout`, `calendarLegendManyWorkouts`, `calendarLegendFreeze`. The English calendar showed Russian weekdays and legend.
- `custom_routine_builder_screen.dart`: the "All" filter chip (English in the Russian UI) → `exerciseTagFilterAll`.
- Dead Russian text removed: the `description` fields and the `label` getter of `PushupCount` / `WorkoutMinutes` in `onboarding_provider.dart` (the screen reads the l10n extensions) and `Rank.displayName` in `enums.dart` (only the debug screen used it, now `localizedName`; its test went with it).
- **Left on purpose** (listed in the allow-list of the new guard test with the reason): the debug screen and the debug test notification, the rank names of the home screen widget (they mirror the ARB, pinned by a test), the notification texts (their own ru / en table), and the language picker (each language is named in itself). "SP" and "CaliDay" are the same in both languages.
- **Guard:** `test/l10n/no_hardcoded_text_test.dart` fails on Cyrillic outside comments in any `lib/` file that is not on the allow-list, and on an allow-list entry that no longer has any. It cannot see hard-coded English text; that still needs a look in review. Mutations checked: a Russian literal put back in the library screen, a stale allow-list entry, the calendar header hard-coded again — each fails a test.

**Modified files:** `l10n/app_en.arb`, `l10n/app_ru.arb` (+ generated), the four screens above, `onboarding_provider.dart`, `enums.dart`, `developer_options_screen.dart`, `test/l10n/plural_test.dart`, `test/l10n/no_hardcoded_text_test.dart` (new), `test/features/profile/calendar_weekday_headers_test.dart` (new), `test/data/enums_test.dart`, `ARCHITECTURE.md`, `DEV_NOTES.md`.

---

### 2026-10-07 — Exercise library search works in every language

**What was done:** the search in `/library/exercises` compared the query with `Exercise.name`, the English name from the catalog, so typing "планка" found nothing. It now looks at the name in **every supported language** (`AppLocalizations.supportedLocales` + `lookupAppLocalizations` + `ExerciseL10n.name`), whichever language the app is in: "plank" works in the Russian UI and "планка" in the English one. A new language added to `l10n.yaml` is searched without touching this code.

- The catalog's own English name is still matched as well: five of them differ from what the screen shows ("Single-Leg Stand" / "One-Leg Stand", "Downward-Facing Dog" / "Downward Dog", ...), and a search that worked before should not stop working.
- "ё" is folded to "е" on both sides: 11 Russian names have it ("Мёртвый жук", "Подъёмы ног лёжа") and phone keyboards make the dots a chore, so "мертвый жук" has to find "Мёртвый жук".
- The query is trimmed (a trailing space from autocomplete used to give an empty list; spaces only now means no query).
- Tests: `test/features/library/exercise_library_search_test.dart` (9), including one that searches every library exercise by its own name in every supported language. Six mutations (old behaviour, only one of the two languages, no "ё" folding, no trim, no catalog name) each make a test fail. Checked in the browser (Russian UI): "мертвый жук" → "Мёртвый жук", "plank" → "Планка" and "Планка на одной руке".
- **Seen on the way:** two hard-coded Russian strings in `exercise_library_screen.dart` ("Сбросить" and the count label); fixed in the next entry together with the other places of this kind.
- **Not a bug, noted for the next person:** red "Unable to load asset: assets/animations/…" cards in the library grid appeared while the dev server (`flutter run -d web-server`) was stopped but its page stayed open in the browser pane; the app is already loaded, only the lazily fetched Lottie files fail. With the server up all 65 files are served with their exact sizes and every card draws.

**Modified files:** `lib/features/library/providers/exercise_library_provider.dart`, `test/features/library/exercise_library_search_test.dart` (new), `ARCHITECTURE.md`, `DEV_NOTES.md`.

---

### 2026-10-07 — A get-ready countdown replaces the Start button (0.8.10+19)

**What was done:** the owner's follow-up to the Start button (entry below): a tap between the rest and the hold breaks a hands-free workout. Now a timed exercise gets a short **get-ready countdown** after the rest, the hold starts by itself when it ends, and **Pause** stops the countdown for someone who needs to read or take position; **Continue** resumes it from where it stopped. The Start button is gone.

- State (`workout_provider.dart`): `timerStarted` / `startTimer()` are replaced by `prepSec`, `prepPaused`, `pausePrep()` and `resumePrep()`; `tick()` counts `prepSec` down (frozen while paused) and the hold begins when it reaches 0. Derived: `isGettingReady`, `isHolding`, `runningCountdownSec`. `prepSecFor(planned, setIndex)` with `kPrepNewExerciseSec` = 10 and `kPrepNextSetSec` = 5. Every place that begins a set sets `prepSec` and clears `prepPaused` (the same five routes the Start button had: first exercise, rest between sets, rest between exercises, no-rest next set, no-rest next exercise).
- **Decisions the owner did not spell out** (all easy to change): 10 s for a new exercise but 5 s for the next set of the same one (the position is already known); reps exercises get **no** countdown (nothing counts down there and Done needs a tap anyway); the first exercise of a workout gets one; Continue resumes the *remaining* countdown rather than starting the hold at once (as asked); the button is called **Pause**, not "Stop", because Stop already means "end the hold early".
- Sound: the last-seconds tick now follows `runningCountdownSec` (rest, countdown or hold; silent while paused), and a **ding** plays when the countdown turns into the hold, because someone already in a plank is not looking at the screen.
- Screen: the ring shows the countdown with the label "get ready" (`secondary`), grey and "paused" while paused, and goes back to `primary` with "sec" for the hold; one `_TimedDisplay` draws all three. The button swaps Pause (outlined — the countdown is the normal path) → Continue → Stop, all 56 px, so the ring and the button do not move (checked in the browser). The hint under the description changes with the state and disappears when the hold starts. Strings: `workoutStart` and `workoutTimedHint` are gone, `workoutGetReady`, `workoutPaused`, `workoutPause`, `workoutPrepHint`, `workoutPrepPausedHint` are new; Continue reuses `workoutContinue`.
- Checked by running it (`flutter run -d web-server`, in-app browser, Russian): the countdown runs 10 → hold; Pause freezes the number for as long as it stays paused; Continue picks it up; the hold starts by itself with a full length; Stop moves on; a reps exercise after it shows no countdown; no console errors. Not checked: the sounds (the web build was muted), light theme, a real device.
- Tests: `test/features/workout/workout_timer_test.dart` rewritten (19). Fifteen mutations of the notifier were tried: 13 make a test fail; two survive and are harmless — `resumePrep` without its "is paused" check (it would set the value it already has) and the `prepPaused: false` in `_endRest`'s same-exercise branch (a pause cannot exist during a rest, and entering the rest already clears it; kept so each route into a set sets all the countdown fields). One real gap was found and closed on the way: nothing checked that a pause is cleared on the no-rest hand-overs.
- Known quirk: the screen's one-second ticker is not restarted by Continue, so the first second after it can be shorter than a second. The rest countdown has the same property.
- **Not done:** a setting to change the length or turn the countdown off; a "start now" button to skip the wait; a countdown for reps exercises.

**Modified files:** `lib/features/workout/providers/workout_provider.dart`, `lib/features/workout/screens/workout_screen.dart`, `l10n/app_en.arb`, `l10n/app_ru.arb` (+ generated), `test/features/workout/workout_timer_test.dart`, `ARCHITECTURE.md`, `DEV_NOTES.md`, `pubspec.yaml`.

---

### 2026-10-06 — Timed exercises wait for a Start button (0.8.9+18)

**What was done:** the owner's complaint: when a timed exercise (plank, dead hang, a stretch) began, the countdown started at once, before there was time to read what to do. The hold now waits.

- `WorkoutState.timerStarted` (false whenever a timed exercise begins) and `WorkoutNotifier.startTimer()`; `tick()` only counts the hold down once started. The button reads **Start** (play icon) and turns into **Stop** (stop icon) after the tap; the full hold still confirms the set by itself. A short hint under the tip says the timer starts on Start and disappears after the tap; it sits in the scrolling text, not next to the ring, so nothing jumps when the timer starts (checked in the browser: the ring and the button stay put). The last-seconds tick sound is silenced while waiting.
- Every route into a timed exercise is covered: the first exercise, after a rest between sets, after a rest between exercises, after a set with no rest (warmups and cooldowns), and the skipped rest. The no-rest branch had a latent flaw: the next set of a timed exercise kept the old `timerSec`; it is reset to a full hold now.
- The "Stop" and the new "Start" labels lost their emoji (`⏹`, `▶`) for Material icons: on the web the stop square drew as an orange emoji while the play triangle drew as a flat glyph, and BRAND.md forbids emoji as UI icons.
- Tests: `test/features/workout/workout_timer_test.dart` (13, the first ones for `WorkoutNotifier`; they run against a custom plan, so no Hive). Five mutations each make a test fail: tick ignoring `timerStarted`, rest or no-rest transitions keeping the flag, `startTimer` accepting reps exercises or working during a rest.
- **Not done:** a "get ready" countdown after Start (3-2-1) so the first seconds of a hold are not spent getting into position; and an option to turn the Start button off.

**Modified files:** `lib/features/workout/providers/workout_provider.dart`, `lib/features/workout/screens/workout_screen.dart`, `l10n/app_en.arb`, `l10n/app_ru.arb` (+ generated), `test/features/workout/workout_timer_test.dart` (new), `ARCHITECTURE.md`, `DEV_NOTES.md`, `pubspec.yaml`.

---

### 2026-10-06 — The web deploy waits for the tests

**What was done:** `web.yml` (deploy to Pages) ran in parallel with `ci.yml` and did not look at its result, so a push with failing tests was still published. It now has a `test` job (`flutter test`, parallel to `build`) and `deploy` needs `[build, test]`. Analyze and the Android build stay in `ci.yml` and do not gate the deploy; a manual "Run workflow" is gated too. `test/repo/workflows_test.dart` checks the dependency (it fails with `deploy` needing `build` only, checked); `actionlint` passes. Not seen yet: a run on GitHub. No app code changed, so no version bump.

**Modified files:** `.github/workflows/web.yml`, `test/repo/workflows_test.dart`, `ARCHITECTURE.md`, `DEV_NOTES.md`.

---

### 2026-10-06 — CI, compact QR, plugin logic extracted and tested (0.8.8+17)

**What was done:** the owner asked for the regular CI, a lighter QR, tests for the plugin-bound logic, and to drop the web-notifications idea.

- **CI (`.github/workflows/ci.yml`)**: on every push to `main` and every pull request — `flutter gen-l10n` must leave `lib/l10n` unchanged (generated files are committed), `flutter analyze`, `flutter test`, and `flutter build apk --debug`. The build job is the one that would have caught the Glance break below. Checked: `actionlint`, the drift check run locally, a clean local debug build, and the build fails when the Glance pin is removed. **Not seen yet: the first run on GitHub** (the l10n drift check runs on Linux; compare with the local result if it fails). `test/repo/workflows_test.dart` keeps the three workflows honest (one Flutter version, release stays disabled and tag-only, ci.yml keeps its steps).
- **Web notifications removed from every document** (backlog row, spec, README, the caveat): the owner decided there is no point in them.
- **Compact QR (format 2).** The owner asked how to make it lighter: almost all of the weight was encoding, not data. The payload is now binary instead of JSON-in-base64 — the 32-hex id as 16 bytes, three numbers as varints, rank as a byte, the eight branch stages as nibbles (4 bytes), the name as UTF-8 — and no visible field was dropped. Typical profile: 314 → 66 characters, QR version 19 → 8 (93×93 → 49×49 modules) at error correction H; a 13-character Cyrillic name 342 → 94 (v20 → v9); the 30-character maximum 390 → 141 (v21 → v12). Codes of the first format are still read, and still written when the compact one cannot hold the data (odd id, empty name). **Builds from before this one cannot read a new code**; the new code has not been scanned phone-to-phone yet (checklist). Layout: ARCHITECTURE § QR Profile Exchange; code: `lib/data/models/friend_qr_codec.dart`.
- **`NotificationPlanner` extracted** from `NotificationService` (what to schedule and when, as a pure function of the profile and a `tz.TZDateTime now`); the service now only talks to the plugin. **A DST bug fell out of it:** "tomorrow" for a repeating reminder was `scheduled.add(Duration(days: 1))`, which on a `TZDateTime` is 24 absolute hours, so on a DST change it lands an hour off (planned on the evening before 2026-03-29: 10:00 instead of 09:00; before 2026-10-25: 08:00) and stays there, because a repeating notification takes its time of day from its first date. It is now the next calendar date on the wall clock. `notification_planner_test.dart` (37 tests) covers the flags, times, the Berlin DST dates, four other zones, both one-off alerts and the texts; with the old `+ 24 h` back in, three tests fail (checked).
- **Other plugin-bound logic pulled out and tested**, the wrapper left thin: `WorkoutEnergy` (kcal and which weight sample to use; a weight outside 20–400 kg, NaN or zero now falls back to 70 kg instead of producing 0 kcal; the 90-day window uses `addCalendarDays`), `appRedirect` (router), `BleProfileCodec` (the GATT bytes; a worst-case profile is under the 512-byte limit), and a test that `WidgetService.rankLabel` says what the ARB files say.
- **Two router behaviour changes, found while writing the tests:** before onboarding is done every deep link now goes to `/onboarding` (it used to jump to the workout without a profile), and `caliday://friend…` — a friend's QR opened by the system camera, the scheme is registered on both platforms — opens the friends screen instead of starting a workout. Any other `caliday://` link still opens the workout. The friend link does not add the friend by itself (that would be a new feature); the code is still scanned in the app. Not tried on a device.
- Tests: 439 → 551 (all pass), `flutter analyze` clean. Mutation checks, each making a test fail: the old `+ 24 h` tomorrow, the MET divisor, the negative-duration clamp, "newest sample wins", the weight filter, the widget's "Athlete" label, the friend deep link, the onboarding gate, the BLE decoder's error handling.

**Modified files:** `.github/workflows/ci.yml`, `lib/core/router/app_redirect.dart`, `lib/domain/services/notification_planner.dart`, `lib/domain/services/workout_energy.dart`, `lib/data/models/friend_qr_codec.dart`, `lib/data/models/ble_profile_codec.dart` (all new); `lib/core/router/app_router.dart`, `lib/core/services/{notification,health,ble}_service.dart`, `lib/data/models/friend_profile.dart`, `lib/features/workout/providers/workout_provider.dart`, `README.md`, `ARCHITECTURE.md`, `DEV_NOTES.md`, `pubspec.yaml`; tests under `test/` (`repo/`, `core/`, `data/`, `domain/services/`, `features/friends/`).

---

### 2026-10-06 — Release CI drafted (disabled), Android build fixed

**What was done:** the owner asked for a CI for release builds, kept disabled (no Apple or Google developer accounts yet). Details, secrets and the enabling checklist: Active Specs → "Release builds (CI)".

- `.github/workflows/release.yml`: `verify` → `android` + `ios` → draft GitHub Release on a `v*` tag. Off unless the repository variable `RELEASE_BUILDS_ENABLED` is `true`. Works without accounts as far as possible (analyze + test, APK / AAB signed with your own keystore, an unsigned iOS compile check); the signed IPA step is written but never run.
- `android/app/build.gradle.kts`: release signing from `android/key.properties`, falling back to the debug key when it is missing (what the file did before).
- **The Android build was already broken.** `home_widget 0.9.1` asks for `androidx.glance:glance-appwidget:1.+`; that range started to resolve to `1.3.0-alpha02`, which needs compileSdk 37 and AGP 9.1, so `flutter build apk --release` failed in `checkReleaseAarMetadata`. The build is not reproducible while a dependency carries a dynamic range; `android/build.gradle.kts` pins Glance to 1.1.1.
- **`cupertino_icons` restored.** The cleanup earlier today removed it as unused: nothing in our code references `CupertinoIcons`, but Flutter's Cupertino widgets do (the Android build warned "Expected to find fonts for ... CupertinoIcons"). The app only uses `CupertinoDatePicker`, which draws no icons, so nothing was visibly wrong, but a Cupertino widget with an icon added later would show empty squares.

**How it was checked:** `actionlint` (it found a real YAML error in my first draft: an unquoted `: ` inside `run:`); the shell snippets run locally; `flutter build apk --release` without `key.properties` (signed `CN=Android Debug`, checked with `apksigner`) and with a throwaway keystore (signed with that key). Not checked: anything that runs only on GitHub, and the iOS signed step.

**Modified files:** `.github/workflows/release.yml` (new), `android/app/build.gradle.kts`, `android/build.gradle.kts`, `pubspec.yaml` / `pubspec.lock` (`cupertino_icons` back; 0.8.7+16), `ARCHITECTURE.md`, `DEV_NOTES.md`.

---

### 2026-10-06 — Friends: the QR scanner explains camera errors (web), retry works

**What was done:** the owner scanned a friend's QR in the web version on localhost and got "an error over the QR frame". Reproduced: the browser blocked the camera (`NotAllowedError`), and the screen showed a black box with a tiny English technical line inside the green frame, no explanation and no way to retry.

- `QrScanScreen` now passes an `errorBuilder` (`ScannerErrorView`): a localized title and hint by error code (permission denied — with a browser or a system-settings hint, no camera, anything else), a **Try again** button, and the raw browser / OS message in small text for bug reports. The green frame moved to `overlayBuilder`, so it is only drawn while the camera preview is visible.
- **Retry on the web needed a workaround:** in mobile_scanner 7.2.0 the web `start()` creates its barcode reader before asking for the camera and keeps it when that fails, so a second `start()` answers `controllerAlreadyInitialized` ("already running"), and `controller.stop()` does nothing on a controller that never ran. `_retry` resets the platform (`MobileScannerPlatform.instance.stop()`) on the web first. The success path (camera allowed after a retry) could not be exercised here: the in-app browser blocks the camera.
- QR building and parsing moved from the two screens into `FriendProfile.buildQrPayload` / `tryParseQrPayload` (parse failures return null) so the whole path is unit-tested; `FriendRepository` gets its first tests (field-by-field round trip through the Hive adapter).
- Tests: `friend_qr_payload_test.dart` (round trip, UTF-8 names, base64 padding, nine kinds of bad input), `scanner_error_view_test.dart` (the first widget tests: each error code, web vs app hint, retry callback, Russian), `friend_repository_test.dart`.

**The same report, second half (a screenshot of "My profile"):** "Unable to load asset: AssetManifest.bin.json" painted across the middle of the QR code. That is the app icon in the centre of the code (`Image.asset`) failing to load — the page had lost its dev server, so the asset request failed — and Flutter draws such an error where the image should be, over the code. With the server running the sheet is fine (checked). The icon is decoration, so it now lives in `FriendQrCard` with an `errorBuilder` that leaves a failed icon out; `friend_qr_card_test.dart` uses a bundle that cannot load anything (it fails without the `errorBuilder`, checked).

**Found (resolved by the compact format, see the 2026-10-06 entry "CI, compact QR …" above):** the QR code is dense (the owner then scanned it from a PC monitor with a phone browser without any trouble, so this is not urgent; the risk is a small phone screen or a poor camera). A typical profile is ~315–340 characters; with error correction H (the screen uses it because of the logo in the middle) that is QR version 19–20, 93–97 modules a side, about 2 px per module at the 200 px it is drawn at (≈0.3 mm on a phone screen). That is hard to scan from a screen even when the camera works. Error correction M would give version 11–13 (61–69 modules); shorter JSON keys and dropping the 32-hex id's redundancy would shrink it further. `friend_qr_payload_test.dart` only guards the payload length (< 360). Needs a decision, and a real-device check of any change.

**Modified files:** `lib/features/friends/screens/qr_scan_screen.dart`, `friends_screen.dart`, `lib/features/friends/widgets/scanner_error_view.dart` and `friend_qr_card.dart` (new), `lib/data/models/friend_profile.dart`, `l10n/app_en.arb`, `l10n/app_ru.arb` (+ generated), `pubspec.yaml` (0.8.5+14).

---

### 2026-10-06 — Challenge norms for the final stages, start load aligned with the catalog

**What was done:** the two open game-design items from the entry below were decided by the owner and applied.

- **Challenge norms** (`challengeTargetReps`, the norm for entering the stage): handstand push-up 1, dragon flag 1, one-arm pull-up 1, pistol squat 1, free handstand 5 s, pike stretch 30 s. Until now the Challenge into these six passed with any result (`completedReps >= 0`) and the progress screens showed a norm of 0. The integrity test now requires a norm for every stage from 2 up; the allow-list is gone.
- **Starting load:** the owner chose "the lower one" — the lower *load* (fewer reps, more rest). That is the `SkillProgressRepository` default in all four cases, so the catalog was aligned to it: core s1 crunches 5 reps / 60 s rest (was 8 / 45), pull s1 rest 90 s (was 60), legs s1 squat 8 reps (was 10), balance s1 rest 60 s (was 30). Effects: a new user's load is unchanged; the stage-1 floor of `applyRegression` and the start values of custom routines are now lower. The repository test checks equality with the catalog again.

**Modified files:** `lib/data/static/exercise_catalog.dart`, `test/data/exercise_catalog_integrity_test.dart`, `test/data/repositories/skill_progress_repository_test.dart`, `ARCHITECTURE.md`, `DEV_NOTES.md`, `pubspec.yaml` (0.8.4+13).

**Not changed:** the desktop folders (`linux/ windows/ macos/`) are not empty, so they stay (rule from the owner).

---

### 2026-10-06 — Tests, two more bugs, dead-file cleanup, documents brought in line with the code

**What was done:** `test/` held one placeholder. It now has 400+ tests (domain services, catalog integrity, Hive repositories, ARB files) and the tests found two crashes and two data gaps. Then everything that nothing referenced was removed, and every document was checked against the code.

**Bugs found by the tests and fixed:**
- **`flex_complete` had no catalog entry.** `AchievementService` awards it when Flex reaches the last stage, and `achievements_screen.dart` did `AchievementCatalog.byId(id)!` for every earned id, so the screen would have thrown as soon as someone finished Flex. Added the achievement (🧘, EN / RU texts, `AchievementL10n`); the screen now skips earned ids the catalog does not know. A test checks both directions: every awardable id is in the catalog and every catalog achievement can be earned.
- **`SkillProgressRepository.runMigrations` threw a `HiveError`.** It copied a record from a course-scoped key (`calisthenics_push`, written by the v1.5 layout) to the bare key with `put(bareKey, get(scopedKey))`; `SkillProgress` is a `HiveObject` and Hive refuses to store one instance under two keys. `main()` awaits it unguarded, so such a user would crash on every launch. It now stores a copy.

**Found, documented, not changed (need a decision) — both decided and applied in the entry above:**
- `challengeTargetReps` is 0 for the six hardest final stages, so the Challenge into them passes with any result. Proposed values are in Active Specs ("Challenge norms"); the test allow-lists the six ids explicitly.
- The default progress of core, pull, legs and balance differs from the stage-1 start in the catalog (Active Specs).

**Cleanup (each item was checked for references first):**
- Deleted: `progress_screen.dart` (no route, no import), `lib/generated/assets.dart` (imported nowhere, stale; its removal ended the last three analyzer infos), v1 SVGs `goro_face` / `goro_flex` / `goro_idle`, `assets/sounds/.gitkeep`, ten SVG duplicates in `internal_docs/caliday_design_v1_1/`, 18 unused ARB messages, the unused `notificationServiceProvider`, the placeholder `test/widget_test.dart`. (The `cupertino_icons` dependency was removed here too and **restored** in the release-CI entry: Flutter's Cupertino widgets reference its font, and the Android build warned about it.) `goro_notification.svg` moved to `internal_docs/design-concept/`. `.claude/settings.local.json` is git-ignored.
- `flutter analyze`: **no issues**.
- Not touched, left as questions (Active Specs → housekeeping): root `_config.yml` (settled and removed 2026-10-07), the `linux/ windows/ macos/` folders (looked at and removed 2026-10-07, see there).

**Documents corrected against the code:**
- `ARCHITECTURE.md`: the `lib/` tree, Hive fields of `WorkoutLog`, box names and types (`user_profile`, `Box<DateTime>`), service signatures (`AchievementService`, `WorkoutGeneratorService`, `SPService`), `WorkoutState`, widget keys, Android permissions, achievement count (29), a new Testing section.
- `README.md`: 8 branches / 2 courses, Posture and Neck tables, notifications, project structure, rank decay, roadmap in the 0.x scheme.
- `CLAUDE.md`, the three skills: build_runner comment, new rules (day math, web guards, tests), the missing `ui-ux-pro-max` skill removed.
- `DEV_NOTES.md`: status table and next priorities; the implemented Privacy Policy spec removed; the Friends spec no longer says BLE advertising / GATT are missing.
- Design documents: stale paths (`docs/caliday_design_v1_1`), asset status, Liquid Glass (dropped from plans in 2026-04), tooltips (done), the profile layout, the icon policy in `MASTER.md`; the February 2026 design document got a status banner and **[now]** notes.
- `docs/PRIVACY_POLICY.md`, `docs/TERMS_OF_USE.md` (public, linked from the app): the web version added, a wrong cross-reference fixed (Friends is Section 5 of the policy, not 4), dates set to 2026-10-06. **The owner should read these before they are pushed.**

**Key issues and solutions:**
- Rank names: the enum values follow the Russian names, so `Rank.sportsman` is "Athlete" and `Rank.athlete` is "Champion" in English. A first pass of this documentation work "corrected" the English "Athlete / Champion" to "Sportsman / Athlete", which was wrong; reverted, the mapping is now in ARCHITECTURE.md and pinned by `test/data/enums_test.dart`.
- Hive in tests: `Hive.init(tempDir)` on the Dart VM works; `test/helpers/hive_test_env.dart` opens the same adapters and boxes as `main()` and can `reopen()` to prove a field survives the adapter.
- Mutation check: temporarily changing the first-workout bonus (1.5 → 1.4) and the rep step (2 → 3) made 7 tests fail; both were restored.

---

### 2026-10-06 — Bug fixes: DST day math (streak, heatmap, calendar), streak-lost alert, plurals

**What was done:** Fixed the bugs recorded as "known, not fixed" in the sync entry below, plus three more found while doing it. The common cause of most of them: day arithmetic on local `DateTime`s, which is wrong across a DST change (a local day is 23 / 25 h long). Everything is now in `lib/core/utils/calendar_days.dart` (`calendarDaysBetween`, `addCalendarDays`).

**Fixed:**
- **StreakService, spring DST (serious):** training on Sunday 2026-03-29 (23 h) and Monday 03-30 gave `daysSince == 0` → the `else` branch reset a 5-day streak to 1 (test: expected 6, got 1). A one-day gap across the change read as consecutive, so the freeze was not used. `daysSinceLastWorkout` / `displayStreak` had the same off-by-one.
- **CompactHeatmap (found, not in the earlier list):** `today.subtract(Duration(days: …))` put the grid dates at 23:00 (spring) / 01:00 (autumn) instead of midnight, and cells are matched by date-only keys → **every week before a DST change was blank** for ~12 weeks after each change. The grid is now `CompactHeatmap.weekGrid(today)` (static, tested). Workout calendar: the freeze-gap day (`date − 1`) moved one day on the day after the spring change.
- **Streak-lost notification (3 defects):** (1) `scheduleAll()` → `cancelAll()` wiped it on every cold start / settings change; (2) it fired the morning after the workout, although the streak survives that whole day (and the 22:00 "work out before midnight or your streak ends" alert follows the same evening, contradicting it); (3) it ignored `notificationsEnabled`. Now: fires at reminder time + 30 min on `StreakService.streakLostDate` (last workout + 2 days, + 3 with a freeze — mirrors `applyWorkout`), only if streak ≥ 2 and notifications are on, skipped when that moment has passed, re-created by `scheduleAll()`.
- **"1 дней" on Home** and "21 дней" in the rank-decay warning: ICU plurals (`homeStreakDays`, `rankDecayWarning`) for RU (one / few / many) and EN. `homeDays` removed.
- **Dev options:** "last workout" now offers 14 / 21 / 35 / 59 days (debug only), so the decayed-rank UI can be reproduced.

**New files:**
- `lib/core/utils/calendar_days.dart`
- Tests (34 new, 51 in total): `test/core/utils/calendar_days_test.dart`, `test/domain/services/streak_service_test.dart`, `test/features/profile/compact_heatmap_test.dart`, `test/l10n/plural_test.dart`. The DST cases fail on the old code; they use Europe/Berlin dates and pass trivially on a machine in a zone without DST.

**Modified files:**
- `lib/domain/services/streak_service.dart` (+ `streakLostDate`, `now` parameter), `rank_decay_service.dart` (uses the helper), `lib/core/services/notification_service.dart` (`scheduleStreakLost`, `scheduleAll`; `_nextDayAt` removed), `lib/features/profile/widgets/compact_heatmap.dart`, `lib/features/profile/screens/workout_calendar_screen.dart`, `lib/features/settings/screens/developer_options_screen.dart`, `lib/features/home/screens/home_screen.dart`, `l10n/app_en.arb`, `l10n/app_ru.arb` (+ generated `lib/l10n/*`), `internal_docs/ARCHITECTURE.md` (utils folder, StreakService, notification table: ID 5 is `rank_risk`, not `rest_timer`), `pubspec.yaml` (0.8.2+11).

**Verified in the browser (debug web build, 375 px):** "1 день" / "0 дней" chip; dev options → rank «Атлет» (enum `athlete`, "Champion" in English) + 21 days → amber "Спортсмен" chip, rank sheet "Ты не тренировался 21 день — ранг снижен…"; first workout after the gap → summary banner "Ранг восстановлен!", streak restarted at 1.

**Not verified:** notification scheduling itself on a device (plugin-bound; only the date decision, `streakLostDate`, is unit-tested); the freeze markers in the calendar; the heatmap inside a DST window in the UI (today is outside it; the grid function is unit-tested).

**Key issues and solutions:**
- Rule for new code: never `DateTime.difference(...).inDays` or `subtract/add(Duration(days: n))` on local dates — use the helpers (see ARCHITECTURE § StreakService).
- After manually setting the rank in dev options, finishing a workout recalculates it from SP (`SPService.applyToProfile`), so the rank can drop back to the SP-earned one — expected, not a bug.

---

### 2026-10-06 — Sync with origin: merge + review of the unpushed v0.8 commits

**What was done:** Merged `origin/main` (8 commits: web build, Flex / supplementary / Posture / Neck animations, redrawn Pull / Push files, `tools/lottie`) into the three unpushed local commits (interactive stats + calendar heatmap, freeze indicators, rank decay). Conflicts were only in `ARCHITECTURE.md` / `DEV_NOTES.md` (both sides had added entries, both kept). The local commits were then reviewed and run: `flutter analyze` (0 errors / warnings; 3 infos in generated `assets.dart`), `flutter test`, the release web build exactly as CI runs it, and the debug web build in the in-app browser at 375 px — onboarding → a full workout → summary → Home chips (streak → calendar, SP → history sheet, rank → rank sheet) → calendar + day sheet → Profile heatmap. No app errors in the console.

**Fixed:**
- **Merge-induced:** `NotificationService.scheduleRankAtRisk` (local) had no `kIsWeb` guard, unlike the schedulers origin guarded; on web it would reach `tz.local` with the timezone database never loaded after every workout. Guarded.
- **Merge-induced:** CI pinned Flutter `3.41.3` but the v0.8 `pubspec.lock` was resolved against `3.41.9` (`matcher 0.12.19`, `test_api 0.7.10`). Workflow pin and ARCHITECTURE bumped to `3.41.9`.
- **Rank-at-risk alert was wiped on every app start:** `scheduleAll()` begins with `cancelAll()` and only re-created morning / evening / streak-threat, and it runs on every cold start and on every notification setting change. It now re-creates rank-at-risk.
- **Off-by-one day across DST:** `RankDecayService.daysSinceLastWorkout` subtracted two local midnights and truncated with `inDays`; across the spring change that is 23 h, so 14 days read as 13 and 21 as 20 (warning and first rank drop a day late). Now UTC dates. `scheduleRankAtRisk` reuses the service instead of its own copy.
- **Home stat chips overflowed by 11 px at 375 px width** (RU "Новичок"): `Text` with `overflow: ellipsis` in an unconstrained `Row`. Pre-existing (same layout before v0.8); now `Flexible` + `FittedBox(scaleDown)`.

**New files:**
- `test/domain/services/rank_decay_service_test.dart` — 16 tests (tier thresholds, rank floor, warning / decayed windows, day counting incl. both DST changes). The two DST cases fail on the old formula. Until now `test/` held only a placeholder.

**Modified files:**
- `lib/core/services/notification_service.dart`, `lib/domain/services/rank_decay_service.dart`, `lib/features/home/screens/home_screen.dart`, `.github/workflows/web.yml`, `internal_docs/ARCHITECTURE.md`

**Restored:** the "GitHub Actions CI/CD — release artifacts" spec (Active Specs) that was sitting uncommitted in the working tree; it covers the Android / iOS builds, the web deploy already exists in `web.yml`. The other uncommitted work (older Flex s1 / s2 files, their `animationPath`, a regenerated `lib/generated/assets.dart`) was superseded by origin's generated Flex animations and dropped.

**Key issues and solutions:**
- Git Bash rewrites an argument that starts with `/` into a Windows path: `flutter build web --base-href /caliday/app/` failed with `C:/Program Files/Git/caliday/app/`. Run it from PowerShell (or with `MSYS_NO_PATHCONV=1`).
- The Flutter web debug build needs the `flt-semantics-placeholder` ("Enable accessibility") clicked before a browser driver can see the widgets; after switching to a phone viewport reload the page, otherwise the canvas stays at the old size.

**Known, not fixed (pre-existing, outside the v0.8 diff):**
- ~~`StreakService` uses the same local-midnight `difference().inDays` pattern~~ — fixed in the entry above (it was worse than a day off: it reset the streak).
- ~~`scheduleStreakLost` is also wiped by `scheduleAll()`'s `cancelAll()`~~ — fixed in the entry above (together with two more defects).
- `lib/generated/assets.dart` is imported nowhere and already stale (44 of 65 animations).
- ~~Home shows "1 дней"~~ — fixed in the entry above.
- Not exercised at runtime: the decayed-rank UI (amber chip / warning), the rank-restored banner and the freeze markers in the calendar. Dev options can only set "last workout" 0–3 days ago, so a ≥ 21-day gap cannot be produced from the UI; the decay maths is covered by the unit tests.

---

### 2026-10-06 — Review of the oldest designer animations, part 2: Push variations, cooldowns, holds

**What was done:** Second batch of the owner-requested review of the original designer files (the Pull batch is the entry below). The owner disliked the front-view diamond / wide / archer push-ups and especially the handstand push-up (inconsistent with `push_s1..s3`, not pretty), so those four were redrawn; the other candidates from the audit were fixed in the least invasive way that works. Everything was compared before / after on stands and approved by the owner; checked in lottie-web, with the Flutter `lottie` parser (all 65 files) and the jump / loop-seam check.

- `push_s4_diamond_pushup`, `push_s5_wide_pushup`, `push_s6_archer_pushup` (48 / 48 / 96f) — **side view in the style of `push_s3`** (new mini rig `pushup.py` that reuses the original file's shapes and proportions), the hand placement is shown by a top-down inset in the corner (diamond between the hands / hands wide / one hand far out). Wide: the upper arms shorten as the elbows flare towards the viewer, the forearms stay vertical. Archer: the near arm works, then the far arm (the other one is a straight foreshortened line)
- `push_s7_handstand_pushup` (48f) — side view, **back to the wall**: the heels rest on the wall behind Goro, the body is one inverted line leaning a little to the wall, the head hangs on the same line with the face away from the wall and goes down ahead of the hands almost to the floor. (The first draft was belly-to-wall, with the face turned into the wall and the head at a right angle to the body; the owner called it unnatural.)
- `cooldown_quad_stretch` (48f) — redrawn (the held foot was a blue chevron): standing on the far leg, the near heel pulled to the glute, the hand holds the ankle; the stretched leg keeps the original highlight blue (new `Spec(tint=...)`); arms drawn 18 % longer because Goro's arm (80 px) cannot reach his own heel
- `cooldown_downward_dog` — the designer's drawing patched (`patch_old.py`): the head moved along the torso towards the feet so the arm, which stays over the head, no longer hides the face
- `core_s5_l_sit` — patched: arms and fists were a dark blue found nowhere else, now the normal arm colour
- `bal_s1_one_leg_stand`, `bal_s6_free_hs`, `bal_s3_crow_prep`, `bal_s4_crow_pose` — movement added with `enliven.py` (the drawing is kept): a sway about the contact point (standing foot / hands). One-leg stand and free handstand wobble (the brief for block F says "light sway is normal" for the handstand), crow prep rocks forward over the hands until the heels start to lift, the crow wobbles lightly. Before, they moved 2–4 px

**New files:**
- `tools/lottie/pushup.py` — push-up rig (shapes copied from `push_s3_full_pushup.json`, straight body line ankle → shoulder, two-bone IK arms, foreshortening, flip for an inverted body)
- `tools/lottie/gen_push.py` — source of the four push-ups
- `tools/lottie/enliven.py` — sway / rock about a contact point for nearly still files
- `tools/lottie/patch_old.py` — targeted fixes of designer files (dog head, L-sit arm colour); absolute values, so idempotent

**Modified files:**
- `assets/animations/push_s4..s7_*.json`, `cooldown_quad_stretch.json`, `cooldown_downward_dog.json`, `core_s5_l_sit.json`, `bal_s1_one_leg_stand.json`, `bal_s3_crow_prep.json`, `bal_s4_crow_pose.json`, `bal_s6_free_hs.json` — replaced (same names)
- `tools/lottie/gen_cooldown.py` — `cooldown_quad_stretch` (+ `STRETCH_BLUE`); `tools/lottie/goro_rig.py` — `Spec(tint=...)`, `rbar()` / `oval()` props; `tools/lottie/build_preview.py` — `push` and `refresh` presets
- `internal_docs/ARCHITECTURE.md`, `internal_docs/tz_designer.md`, `design-system/caliday/BRAND.md`, `README.md`, `CLAUDE.md` — status and tooling notes

**Key issues and solutions:**
- The first audit of the Push front views from thumbnails was wrong about their readability, but the owner's eye was right about consistency: front-view foreshortened push-ups next to profile `push_s1..s3` look like a different set. Profile + inset keeps one look; the variations that a side view cannot show (hand width) live in the inset, so the diamond is nearly identical to a plain push-up in the main view.
- Reusing the original shapes (`pushup.py`) instead of the paper-doll rig matters: the push-up body is a long slim rect (130 × 50) with thick arms (24 / 20 px), unlike the rig's torso (100 × 56) and arms (16 px).
- Handstand: the head must continue the body line (neck neutral) and face away from the wall; with the wall on the left and Goro facing right the head is a vertical flip (scale y −100), not a 180° turn (that would make it face left). The head hangs ahead of the hands so it does not sit on the arms.
- Wide push-up elbows: the upper arm passes through an edge-on moment (projected length about 0), where its rotation jumps by 50–70° in a frame while it moves 1.5 px (`check_anim.py` flags it). The shortest drawn length is clamped to 9 px, so it is a small blob there, not a flickering sliver. Known and intended.
- Goro's limbs are too short for some poses: a downward dog with a real V (the hips can rise only about 10 px above the shoulders when the feet and hands are on the floor, because the leg is 84 px and the arm 80 px), a crow (the rigid 100 px torso cannot fold between 80 px arms and 84 px legs; a try with the three-part spine gave an unreadable lump), a quad stretch (the hand cannot reach the heel). The designer's drawings of the dog and the crow were kept and fixed / animated instead; the quad stretch got longer arms.
- The designer's own "breathing" is a rigid 2–4 px bob of the whole figure including hands and feet, so amplifying it would float the contacts; `enliven.py` rotates every figure layer about the contact point instead (zero in the first frame, rounded to 0.01, so repeated runs settle on the same file).
- Not touched on purpose: planks, `cooldown_shoulder_stretch`, `cooldown_hip_flexor`, `bal_s2`, `bal_s5` and the Legs / Push s1–s3 files: holds against the floor or a wall cannot move much and the drawings read well.

---

### 2026-10-06 — Pull branch Lottie animations redrawn (review of the oldest files, part 1)

**What was done:** First batch of the owner-requested review of the original designer animations (42 files). The audit found the files technically clean (no jumps, closed loops) but with real defects in Pull: the pull-up never got the chin over the bar (head rose only 36 px, below the bar, although "chin above the bar" is the brief's accent), `pull_s2` / `pull_s3` / `pull_s6` shared one motion (the negative was the pull-up shifted in phase, the one-arm was the same rise), `pull_s4` had blue sleeves covering the face, and `warmup_dead_hang` moved 2 px. Six files were redrawn with `tools/lottie/gen_pull.py`; `pull_s1_australian` and `cooldown_lat_stretch` were kept. Compared before/after on a stand, approved by the owner. Checked in lottie-web, with the Flutter `lottie` parser (all 65 files) and the jump / loop-seam check.

- `pull_s3_pullup` (48f) — front; hang, pull until the chin is above the bar (the head stretches up, the bar crosses the neck), pause, lower
- `pull_s2_negative` (72f) — front; starts at the top, lowers over about 3 s, then a quick step-up (knees tuck) for the next rep
- `pull_s4_close_grip` (48f) — **side view** (as in the brief): bar seen end-on right under the chin, elbows tucked, an inset in the corner shows the narrow grip (two fists side by side)
- `pull_s5_archer` (96f) — front, wide grip; one arm pulls and bends, the other stays straight along the bar, the body shifts to the working side; then the other side
- `pull_s6_one_arm` (60f) — front; one hand over its shoulder, the free arm hangs along the body, the torso stays square
- `warmup_dead_hang` (60f) — front; passive hang (shoulders up by the ears) → shoulders pull down and the grip wakes up (active hang) → relax; small leg swing

**New files:**
- `tools/lottie/gen_pull.py` — source of truth for the six files

**Modified files:**
- `assets/animations/pull_s2_negative.json`, `pull_s3_pullup.json`, `pull_s4_close_grip.json`, `pull_s5_archer.json`, `pull_s6_one_arm.json`, `warmup_dead_hang.json` — replaced (same names)
- `tools/lottie/frontview.py` — `style='paper'` (dark arms and fists like the original files instead of blue sleeves), `arm_len` for longer arms (85 px, the old length), `Animation(props_index=..., floor=False)` to put a prop between figure layers (the bar over the head but under the fists) and to omit the floor
- `tools/lottie/goro_rig.py` — `disc()` prop (a bar seen end-on)
- `tools/lottie/build_preview.py` — `pull` preset
- `internal_docs/ARCHITECTURE.md`, `internal_docs/tz_designer.md`, `design-system/caliday/BRAND.md`, `README.md`, `CLAUDE.md` — status and tooling notes

**Key issues and solutions:**
- Goro's arms (85 px with the longer setting) are short next to his wide torso and tall head, so at the top of a pull-up the elbows end up near hand level ("wings") whatever the bend direction. A wider grip (54 px instead of 42) and a lower shoulder at the top plus lifting the head (neck extension) gives the chin over the bar with elbows lower; the wings look is a known limitation.
- The bar must be in front of the athlete's neck (the athlete faces it) but under the fists, hence the layer order with `props_index=2`.
- Elbow IK flipped between its two solutions when the shoulder-to-hand distance shrank (53° in one frame in the one-arm and close-grip drafts): keep the hand above the working shoulder and give the bend a fixed outward / downward direction.
- Profile close grip: the bar disc was hidden entirely behind the fist (same centre), so it is drawn larger than the fist; the arms must be drawn over the head, otherwise they disappear behind it; inset layers are listed inner-first because the first layer is on top.
- The brief (`tz_designer.md` block D) lists side view for `pull_s2`, `pull_s3`, `pull_s6` and `warmup_dead_hang`, but the originals (accepted by the owner) are front views and so are the redrawn ones; only `pull_s4_close_grip` is a side view, as in the brief.
- The first audit judged the Push front views unreadable from small thumbnails; at full size they convey the hand positions well, so Push is left as is. Remaining candidates from the audit are listed in "Idea" under Lottie status.

---

### 2026-10-06 — cat-cow cooldown replacement (`cooldown_cat_cow.json`)

**What was done:** Replaced the old `cooldown_cat_cow.json` (user feedback: looks bad; 36 frames, the torso hardly bent) with a generated animation (60 frames, `gen_cooldown.py`). Side view on all fours with the hands and knees planted: the cow hollows the back (belly down, chest and tailbone up, chin up), the cat rounds it (chin and tailbone tucked). Same file name, so the catalog and the Core / Flex / Neck cooldowns pick it up without code changes. Checked in lottie-web, with the Flutter `lottie` parser (all 65 files) and the per-frame jump / loop-seam check.

**New files:**
- `tools/lottie/gen_cooldown.py` — source of truth for the file

**Modified files:**
- `assets/animations/cooldown_cat_cow.json` — replaced
- `tools/lottie/goro_rig.py` — optional three-part spine: layers `sp_chest` / `sp_mid` / `sp_pelvis` instead of `body`, pose key `spine = (s1, s2)` bends the mid part and the pelvis about two hinges; `joint_of` follows it (output of all existing generators unchanged)
- `tools/lottie/build_preview.py` — `cooldown` preset
- `internal_docs/ARCHITECTURE.md`, `internal_docs/tz_designer.md`, `design-system/caliday/BRAND.md`, `README.md`, `CLAUDE.md` — status and tooling notes

**Key issues and solutions:**
- A rigid torso or a single waist hinge cannot arch; three parts give a rounded / hollow back. The bend is a single parameter (total turning `delta` spread over the three parts by their position along the spine), and for every `delta` the slope of the chord is solved so the shoulders keep the height the straight arms give them (hands planted, hip joint pinned above the knees): the shoulders then slide back only 10–15 px, within reach of the hands.
- Head tilt has to be an absolute angle (chin up in the cow, down in the cat): relative to the chest it pointed the wrong way in the cow.
- The far hip is 6 px higher than the near one (`hip_f` vs `hip_n`), so its knee target is "below its own hip" instead of the floor; the near knee is pinned to the floor.
- Known limitations: the curve is three facets, not a smooth arc; the cow is milder than the cat.

---

### 2026-10-06 — Neck branch Lottie animations (block J, 6/6)

**What was done:** Animated the Neck branch of the Healthy Body course: `warmup_neck_rolls` and `neck_s1`–`neck_s5`, all generated with `tools/lottie` (`gen_neck.py`) and wired into the catalog. Four are front views on `frontview.py`, two are side views on `goro_rig.py`. Frames checked in lottie-web, every file through the Flutter `lottie` parser (a throwaway `flutter test` over all 65 files), plus the per-frame jump / loop-seam check.

- `warmup_neck_rolls` (48f) — front; the head rolls in half circles from shoulder to shoulder through the chest (tilt ±26°, chin tucks in the middle), never backwards
- `neck_s1_neck_tilt` (72f) — front; ear to the shoulder (30°), hold, the opposite shoulder sinks, back to centre, other side
- `neck_s3_shoulder_roll` (72f) — front; one big circle forward, then one backward (shoulders up, in, down, out)
- `neck_s5_doorway_stretch` (60f) — front; Goro in a door frame (two posts + lintel), forearms on the posts, leaning through the door = torso and head grow towards the camera while the hands stay planted
- `neck_s2_chest_opener` (60f) — side; hands behind the back, straight arms swing back, shoulders move back on the torso, chest forward, chin up
- `neck_s4_wall_angel` (60f) — side; back, head and arms against a wall, the arm is a vertical bar that slides from the "goal post" position to overhead (upper arm foreshortened by `sin φ`)

**New files:**
- `assets/animations/warmup_neck_rolls.json`, `neck_s1_neck_tilt.json`, `neck_s2_chest_opener.json`, `neck_s3_shoulder_roll.json`, `neck_s4_wall_angel.json`, `neck_s5_doorway_stretch.json` (50–70 KB)
- `tools/lottie/gen_neck.py` — source of truth for the six files

**Modified files:**
- `lib/data/static/exercise_catalog.dart` — `animationPath` for all six Neck entries
- `tools/lottie/frontview.py` — head squash (`head_scale`), shoulder caps (`ORDER_CAPS`: round caps at the shoulder joints so shrugs / circles read), `figure()` accepts an explicit elbow
- `tools/lottie/goro_rig.py` — `hold_ramp` / `sampled` helpers (moved here from `gen_posture.py`), static props (`bar`, `door_post`, `Spec(props=...)`) in the colours of the original wall / post; output of every existing generator is unchanged
- `tools/lottie/gen_posture.py` — uses the shared helpers; `tools/lottie/build_preview.py` — `neck` preset
- `internal_docs/ARCHITECTURE.md`, `internal_docs/tz_designer.md`, `design-system/caliday/BRAND.md`, `README.md`, `CLAUDE.md` — status and tooling notes

**Key issues and solutions:**
- Shoulder circles hardly read at first: the sleeves only slid a few pixels beside the torso. Round shoulder caps (same colour as the sleeves) plus a bigger amplitude (13 px up, 6 px in/out) made the shoulders visible as shoulders.
- The doorway stretch in profile did not work (the forearm on the post either covered the face or hid behind the head, and the upper arm cannot be longer than 44 px in projection, which fixes how far the body can stand from the post). It is a front view instead, as in the brief: the door frame plus "goal post" arms is unmistakable, and the lean through the door is shown by the chest and head growing towards the camera (+12 %) while the hands stay on the posts. The lean cue is subtle.
- Wall angel in profile is a vertical bar sliding up the wall: the W → Y transition, the defining feature, is a frontal-plane movement and cannot be shown from the side. It reads as "arm goes up along the wall" and is the weakest of the six; the owner accepted it. Same for the chest opener: the clasped hands are one arm swinging back.
- The arms in the wall angel / chest opener are drawn above the head (`ARMS_ABOVE_HEAD`), in the doorway the head is above the arms.

---

### 2026-10-06 — Posture branch Lottie animations (block I, 5/6)

**What was done:** Animated the Posture branch of the Healthy Body course. Three new files are generated with `tools/lottie`; `posture_s2_dead_bug` points at the existing `supp_dead_bug.json` and `posture_s5_kneeling_lunge` at `flex_s1_hip_flexor_stretch.json` (same exercises, owner approved the reuse). `posture_s6_pigeon_pose` deliberately has no animation (owner decision, see below). Frames checked in lottie-web, every file through the Flutter `lottie` parser (a throwaway `flutter test` over all 59 files), plus a per-frame jump / loop-seam check.

- `posture_s1_pelvic_tilt` (60f) — lying, knees bent, feet planted. The torso is split at the waist: at rest the lower back is arched (a gap under the waist), then it presses flat while the pelvis rolls and the tailbone curls up; hold; release
- `posture_s3_glute_bridge` (60f) — lying, feet planted; the torso swings about its shoulder end until shoulder–hip–knee are in one line, shin vertical, a small extra squeeze at the top, then down
- `posture_s4_hip_march` (48f) — **front view** (new rig `frontview.py`): standing, hands on the hips; the knee rises towards the camera to hip height (thigh foreshortens to a stub, a lighter knee cap grows in front of the torso, the foot leaves the floor), then the other side

**New files:**
- `assets/animations/posture_s1_pelvic_tilt.json`, `posture_s3_glute_bridge.json`, `posture_s4_hip_march.json` (54–68 KB)
- `tools/lottie/gen_posture.py` — source of truth for the three files
- `tools/lottie/frontview.py` — front-view rig: standing Goro facing the camera (head/torso/blue sleeves of `warmup_wrist_circles` at 0.6 like `topview.py`, plus standing legs); parts placed by their end points, every frame solved independently from a pose function (`figure(...)`), so planted limbs never drift
- `tools/lottie/check_anim.py` — jump (position/rotation per frame) and loop-seam checker for generated files

**Modified files:**
- `lib/data/static/exercise_catalog.dart` — `animationPath` for Posture stages 1–5
- `tools/lottie/goro_rig.py` — optional split torso (`torso_u` + `pelvis` layers instead of `body`, pose key `pel` = pelvis rotation about the waist, `joint_of` follows it); output of all existing generators is unchanged
- `tools/lottie/build_preview.py` — `posture` preset, `--dir` to preview a draft folder
- `internal_docs/ARCHITECTURE.md`, `internal_docs/tz_designer.md`, `design-system/caliday/BRAND.md`, `README.md`, `CLAUDE.md` — status and tooling notes

**Key issues and solutions:**
- Lying poses: Goro's torso is 56 px thick and the hip joint sat 36 px above the floor, so bent legs came out as nearly horizontal thighs. Lowering the hip joints in lying poses (`hip_n=-6`, `hip_f=-12`: towards the back) gives a knee about 48 px above the floor with a visible thigh rise.
- A rigid torso cannot show a lumbar arch. Splitting it at the waist (pelvis hinge, upper part tilted about its head-end corner) closes the gap between the back and the floor in the tilt; the pelvic tilt is subtle by nature (about 7 px of movement), so the arch is exaggerated a bit.
- Glute bridge: the hips travel about 30 px towards the head as the torso swings, so the foot position has to be chosen for the *top* pose (shin vertical) and the legs re-solved with IK on every sampled frame (`sampled()` computes the pose exactly every 2 frames); interpolating between two end poses made the feet slide. The head is counter-rotated so it stays flat on the floor.
- Front view: the original front assets have no visible eyes (the eye shapes are listed below the face in the group, so the face covers them); kept as is. Hands on the hips read well with blue sleeves; the raised knee reads from the light knee cap in front of the lower torso and the lifted foot.
- **Pigeon pose: no animation.** In profile the defining feature (the shin across the body) points at or away from the camera: three profile variants (hips on the floor, hips held up with a long back leg, deeper fold) looked like a crawling animal, and a front view (shin as a horizontal bar) turned into a seated blob. Owner decision: leave it without animation, like 90/90 (the app shows the placeholder icon). If it comes back, the likely route is a new oblique/top rig, not more tricks in profile.
- Committed Flex JSON files are numerically identical to what the current rig generates but not byte-identical (formatting only); they were not regenerated.

---

### 2026-10-06 — Supplementary pool Lottie animations (9/9)

**What was done:** Animated the nine supplementary exercises (block H). Eight are new, generated with `tools/lottie`; `supp_wrist_circles` points at the existing front-view `warmup_wrist_circles.json` (same exercise). Checked frame by frame in lottie-web, every file with the Flutter `lottie` parser (a throwaway `flutter test` over all 56 files), plus a per-frame jump check.

- `supp_oblique_crunch` (48f) — **top view** (see below): lying on the back, fists on the temples, the torso turns about the hips and shortens as it lifts, the leading elbow goes over the top (up along the head) and then crosses the chest towards the opposite knee; the legs stay put; the leading side alternates
- `supp_russian_twists` (48f) — V-sit; the twist is faked with opposite shoulder shifts, a widening torso and arms that cross behind the torso on the far side
- `supp_side_plank` (48f) — forearm side plank held in one line, hips breathing, top arm up
- `supp_standing_calf_raise` / `supp_single_leg_calf_raise` (48f) — slow rise on the ball of the foot; the single-leg one has the free leg bent behind and hands on hips
- `supp_dead_bug` (60f) — arms to the ceiling, knees at 90°; the near arm goes overhead while the far leg extends, then the other diagonal
- `supp_bird_dog` (64f) — all fours; opposite arm and leg extend in line with the back, then swap
- `supp_neck_isometrics` (64f) — standing; palm presses the forehead, temple and back of the head in turn, the hand travels over the head between positions

**Modified files:**
- `assets/animations/supp_*.json` — 8 new files (22–60 KB)
- `lib/data/static/supplementary_exercise_catalog.dart` — `animationPath` for all nine
- `tools/lottie/gen_supp.py` — new pose lists; `tools/lottie/topview.py` — top-down rig for the oblique crunch; `goro_rig.py` — shoulder offsets (`sh_n`/`sh_f`), torso width (`sc_torso`), alias layers with opacity `fade`, `align()`, shared `mk`/`plant`/`head_pos`; `gen_flex.py` uses the shared helpers (Flex files regenerate byte-identical)
- `tools/lottie/build_preview.py`, `preview_template.html` — presets (`flex`, `supp`) with their own titles
- `internal_docs/ARCHITECTURE.md`, `internal_docs/tz_designer.md`, `design-system/caliday/BRAND.md` — status and tooling notes

**Key issues and solutions:**
- A limb's FK angles from IK can differ from the neighbouring pose by 360°, so interpolation spun the arm the long way (neck isometrics: 105°/frame). `align()` now picks the short way; a leg extending from a tabletop had the same problem (dead bug dipped through the floor).
- Bird dog: the reaching arm lines up with the head in profile and vanished behind it; arms are drawn above the head for it (and for dead bug / neck isometrics).
- Elbows and the twist of the torso hardly exist in a pure side view. The first oblique crunch (profile) tangled the arms and the owner found it unreadable, so it was redrawn from above with a separate rig (`topview.py`): head up in the frame, face to the camera, like the front-view asset. Lighter thighs and knee caps are what make the raised knees read from above. Review fixes: the arms are drawn above the head (they sank behind it before), the legs do not move, and the elbow path was reworked twice: interpolating FK angles made the elbow swing a half circle round the bottom and the hands drift off the head. Now the elbow is interpolated in the frame of the shoulder->temple line (fraction along it, signed distance from it) between the two IK end poses, so it travels over the top (along the line, the arm foreshortens as it rises towards the camera) and the fist stays exactly on the temple.

---

### 2026-10-06 — Flex branch Lottie animations (5/6)

**What was done:** Added the missing Flex animations (five; 90/90 was dropped, see below) and wired them into the catalog. Instead of hand-editing keyframes, built a small Goro puppet rig (FK/IK → Lottie JSON) that reproduces the structure of the existing files, and described each animation as a list of key poses. Verified frame-by-frame in lottie-web (headless Chrome contact sheets) and in the real app (Flutter `lottie` renderer, web build): library cards and the exercise detail sheet play all of them, no console errors.

- `flex_s1_hip_flexor_stretch` (48f) — half-kneeling lunge, hips sink forward over the planted back knee while the arms sweep from the hips to overhead
- `flex_s2_worlds_greatest_stretch` (60f) — runner's lunge, both hands down, near arm sweeps up to the ceiling with the head following
- `flex_s4_thoracic_bridge` (66f) — seated → reverse tabletop → near arm sweeps up over the chest
- `flex_s5_deep_squat_hold` (48f) — held deep squat, hands in prayer position, slow sink/lift breathing rhythm
- `flex_s6_pike_stretch` (48f) — seated tall → fold forward from the hips, hands to the toes

**Modified files:**
- `assets/animations/flex_s1, s2, s4, s5, s6_*.json` — new (50–65 KB each, same range as existing files)
- `lib/data/static/exercise_catalog.dart` — `animationPath` for the five Flex exercises
- `tools/lottie/goro_rig.py`, `tools/lottie/gen_flex.py` — new generator (source of truth for the Flex files)
- `tools/lottie/build_preview.py`, `tools/lottie/preview_template.html` — preview stand (all animations playing, scrubber, key-frame strip, size modes)
- `internal_docs/ARCHITECTURE.md`, `design-system/caliday/BRAND.md` — animation status + tooling notes

**Key issues and solutions:**
- Same-coloured limbs merge into the torso in seated/folded poses, so legs need to stick out past the torso (hip offsets per pose).
- 90/90 was drawn (foreshortened shins, near parts dipping into the floor strip, a side switch) but still read as a seated blob; the owner decided it does not suit this animation format, so `flex_s3_hip_9090` has no animation (placeholder icon in the app). The tz_designer brief allows replacing/skipping a pose that looks unnatural.
- First version of the World's Greatest Stretch bent the back knee the wrong way (IK `bend` pointed up). Back/kneeling legs must bend towards the floor: `bend=(0, 1)`. The leg was also too bent; now almost straight like a real runner's lunge.
- IK targets keep feet/hands planted while the torso moves; switching a limb between planted and swinging goes through `ik_to_fk` so the interpolation is by angle (the arm sweeps through the front, not the back).
- Per-frame jump check (position/rotation deltas between consecutive frames) caught a too-fast arm sweep in the bridge (retimed) and, during the 90/90 attempt, a 210° shin flip.
- Library search only matches the English exercise name (`e.name`), so searching in Russian finds nothing. Pre-existing, not changed here.

---

### 2026-10-06 — Web build (PWA on GitHub Pages)

**What was done:** The app now builds for the web and is deployed to `https://pupptmstr.github.io/caliday/app/` by GitHub Actions. Data is stored locally in the browser (Hive CE uses IndexedDB on web — no code changes needed for storage). Native-only features (notifications, Health, Home Screen Widget, BLE, orientation lock) are skipped/hidden with `kIsWeb`; QR friend exchange works (camera via mobile_scanner web). On wide windows the app is shown as a centred phone-width column. Verified locally with Flutter 3.41.3: onboarding → full daily workout → summary → reload keeps streak/SP/achievements; no console errors.

**Modified files:**
- `lib/main.dart` — skip orientation lock and the post-frame native init (notifications, Health, widget, app links) on web; `_WebFrame` via `MaterialApp.router(builder:)`
- `lib/core/services/notification_service.dart` — `init`, `scheduleAll`, `scheduleStreakLost` are no-ops on web (avoids loading the tz database)
- `lib/core/services/widget_service.dart` — `update` no-op on web
- `lib/features/settings/screens/settings_screen.dart` — Health, Notifications sections and BLE "discoverable" tile hidden on web
- `lib/features/friends/screens/friends_screen.dart` — no BLE scan/advertising and no NEARBY section on web
- `lib/features/onboarding/providers/onboarding_provider.dart`, `screens/onboarding_screen.dart` — `lastStep = kIsWeb ? 5 : 7`; Health + Reminder pages omitted on web
- `web/index.html`, `web/manifest.json`, `web/favicon.png`, `web/icons/*` — CaliDay name/colors/icons, splash until `flutter-first-frame`, `navigator.storage.persist()`
- `pubspec.yaml` — `flutter_launcher_icons.web` enabled (generated with a web-only config so mobile icons were not touched)
- `.github/workflows/web.yml` — new: Flutter web build + Jekyll build of `docs/` → single Pages artifact → deploy

**Key issues and solutions:**
- Pages was a legacy branch build from `/docs` (privacy policy/terms URLs are used in the app and store listings). An Actions deploy replaces the whole site, so the workflow renders `docs/` with `actions/jekyll-build-pages` (same engine as the legacy build) and puts the app under `/app/`. Pages source must be switched to "GitHub Actions" once.
- `jekyll-build-pages` runs in Docker and leaves root-owned output → the site is assembled in a fresh `_site/` instead of copying the app into Jekyll's output.
- A newer Flutter (3.47) rewrites `pubspec.lock` (SDK-pinned `matcher`/`test_api`/`meta`) and `analysis_options.yaml`; the lock matches Flutter 3.41.1–3.41.3, so CI pins `3.41.3`.
- `flutter_local_notifications` 21 already returns early on web for most calls, but `NotificationService.init()` would still load the full timezone database after every workout — guarded explicitly.

---

### 2026-05-02 — Rank decay system + unified rank info sheet

**What was done:** Implemented display-only rank decay for inactive users: rank gradually drops after 21 days of inactivity (thresholds: 21/35/45/53/59 days), with a 14-day warning notification. A 14-day "rank at risk" notification is scheduled after every workout. The same `showRankInfoSheet` widget is now used on both Home and Profile screens (removed the duplicate inline implementation from `home_screen.dart`). Rank is restored on the next workout with a `_RankRestoredBanner` on the summary screen.

**New files:**
- `lib/domain/services/rank_decay_service.dart` — `RankDecayService`: decay tiers, `effectiveRank()`, `isWarning()`, `isDecayed()`, `daysSinceLastWorkout()`
- `lib/features/profile/widgets/rank_info_sheet.dart` — shared `showRankInfoSheet()` bottom sheet used by both Home and Profile

**Modified files:**
- `l10n/app_ru.arb` + `l10n/app_en.arb` — added `rankDecayWarning(days)`, `summaryRankRestoredTitle`, `summaryRankRestoredBody`
- `lib/core/services/notification_service.dart` — added `_idRankAtRisk = 5`, rank-at-risk strings, `scheduleRankAtRisk()`, `debugShowRankAtRisk()`
- `lib/features/home/providers/home_provider.dart` — added `effectiveRank` and `daysSinceLastWorkout` to `HomeData`
- `lib/features/profile/providers/profile_provider.dart` — added `effectiveRank` and `daysSinceLastWorkout` to `ProfileData`
- `lib/features/workout/providers/workout_provider.dart` — detect pre-workout decay, add `rankRestored` to `WorkoutState`, schedule rank-at-risk after workout
- `lib/features/workout/screens/workout_screen.dart` — pass `rankRestored` in summary extras
- `lib/features/workout/screens/summary_screen.dart` — added `_RankRestoredBanner` (amber, shown when rank was decayed before workout)
- `lib/features/home/screens/home_screen.dart` — removed duplicate `_showRankInfoSheet`; use shared widget; show `effectiveRank` with amber color when decayed
- `lib/features/profile/screens/profile_screen.dart` — use shared `showRankInfoSheet`; `_RankCard` displays `effectiveRank` with amber warning icon when decayed

**Key issues and solutions:**
- Rank decay cannot be stored in Hive because `SPService.applyToProfile()` always recalculates rank from SP on every workout, overwriting any stored decay. Solution: display-only decay using `RankDecayService.effectiveRank()` — same pattern as `displayStreakProvider`. `UserProfile.rank` always holds the earned (SP-based) rank; the displayed rank is computed on the fly.
- Both `HomeData` and `ProfileData` needed `effectiveRank`+`daysSinceLastWorkout` since decay must be consistent across tabs without additional Hive reads.

---

### 2026-05-02 — Interactive home stats + Workout Calendar with Heatmap

**What was done:** Made Home screen stat chips (streak/SP/rank) tappable. Streak opens the new `/calendar` screen; SP opens a recent-workout history bottom sheet; Rank opens a rank-info sheet. Implemented `WorkoutCalendarScreen` — a monthly heatmap grid with month navigation and day-detail bottom sheet. Added `CompactHeatmap` widget (GitHub-style 13×7 grid) to the Profile screen, replacing the flat workout list. Extracted `WorkoutLogTile` and `ExerciseTagChip` to shared widgets reused across Profile, Calendar, and Home. Also bumped several package constraints (`go_router`, `home_widget`, `lottie`, `build_runner`) and upgraded Flutter SDK from 3.41.2 → 3.41.9 (Dart 3.11.5).

**New files:**
- `lib/features/profile/widgets/workout_log_tile.dart` — `WorkoutLogTile`, `ExerciseTagChip`, `_InfoChip` extracted from profile_screen
- `lib/features/profile/widgets/compact_heatmap.dart` — GitHub-style 13-week heatmap widget
- `lib/features/profile/screens/workout_calendar_screen.dart` — `/calendar` screen: monthly grid + day-detail sheet

**Modified files:**
- `lib/features/profile/screens/profile_screen.dart` — history section replaced with CompactHeatmap + "Open →" + last 5 tiles
- `lib/features/home/screens/home_screen.dart` — `_HeroStat` gains `onTap`; streak→calendar, SP→history sheet, rank→rank-info sheet
- `lib/core/router/app_router.dart` — added `/calendar` route
- `lib/data/repositories/workout_repository.dart` — added `getAllForDate(date)` and `getInRange(from, to)` methods
- `l10n/app_ru.arb` + `l10n/app_en.arb` — added `calendarTitle`, `calendarSeeAll`, `calendarNoWorkoutsOnDay`
- `pubspec.yaml` — bumped `go_router ^17.2.3`, `home_widget ^0.9.1`, `lottie ^3.3.3`, `build_runner ^2.15.0`

**Key issues and solutions:**
- `package_info_plus` v9→v10 upgrade blocked: `health ^13.3.1` → `device_info_plus ^12` → `win32 ^5` conflicts with `package_info_plus >=10` which requires `win32 ^6`. Kept at `^9.0.1` until health ecosystem catches up.
- `profile_screen.dart` edits cascaded into corruption (merged `_WorkoutLogTile` into `_AchievementBadgeRow`). Fix: full `Write` tool rewrite combining clean sections.
- `workout_log_tile.dart` missing `ExerciseTag`/`SetType`: these live in `enums.dart`, not `exercise_tags_catalog.dart`. Fix: added the import.
- Compact heatmap uses Monday-aligned weeks (today's `currentMonday - 12*7`) to match the 13-week GitHub-style layout.

---

### 2026-04-22 — Versioning rework + backlog cleanup + new ideas from user feedback

**What was done:** Downgraded all version numbers by one major (v1.x → v0.x) to reflect pre-release state; v1.0 is now the target for first public release with additional courses. Removed Liquid Glass design overhaul from plans entirely. Added two new ideas from user feedback: interactive home screen stat chips (streak/SP/rank → calendar/history/rank info) and cat-cow animation replacement request for designer.

**Modified files:**
- `pubspec.yaml` — version `1.7.0+8` → `0.7.0+8`
- `internal_docs/ARCHITECTURE.md` — backlog renumbered v0.1–v0.7; Liquid Glass removed; added interactive home stats (📐 designed), workout calendar (💡 idea), cat-cow replacement (🔒 designer)
- `internal_docs/DEV_NOTES.md` — current version updated to v0.7; Liquid Glass spec removed; specs added for interactive home stats and cat-cow replacement

---

### 2026-04-20 — Add app logo to QR code center

**What was done:** Added Goro app icon (blue background, 42×42) to the center of the friend QR code via `Stack` overlay. Switched error correction to level H (30%) to ensure reliable scanning despite the overlay.

**Modified files:**
- `lib/features/friends/screens/friends_screen.dart` — replaced `embeddedImage` param with `Stack` + `Image.asset` + `ClipRRect(borderRadius: 8)`
- `pubspec.yaml` — added `assets/icon/` to flutter assets list

**Key issues and solutions:**
- `QrImageView.embeddedImage` silently fails — it draws through a custom painter that can't resolve async `AssetImage` at paint time. Fix: overlay via `Stack` with `Image.asset` (loaded by Flutter's widget layer, not painter).
- `assets/icon/` was only referenced by `flutter_launcher_icons` config, not registered as a Flutter asset → "Asset not found" at runtime. Fix: add `- assets/icon/` to `flutter.assets` in pubspec.yaml.

### 2026-04-09 — Update docs and skills to reflect Riverpod 3.x + Hive CE architecture

**What was done:** Updated all project documentation and agent skills to reflect the completed Riverpod 3.x + Hive CE migration. Removed stale references to `legacy.dart`, `StateProvider`, `StateNotifier`, `StateNotifierProvider`, and `_ref` throughout ARCHITECTURE.md. Updated README.md and About screen tech stack strings. Fixed path references (`docs/` → `internal_docs/`) in document-idea and pre-commit skill files.

**Modified files:**
- `internal_docs/ARCHITECTURE.md` — removed `legacy.dart` mention from tech stack; updated locale_provider comment, FriendsNotifier section, RouterNotifier section, Key Patterns section, workout flow comment to use Riverpod 3.x provider types
- `README.md` — Tech Stack table: "Riverpod" → "Riverpod 3.x", "Hive" → "Hive CE"
- `lib/features/settings/screens/about_screen.dart` — tech stack string updated to "Flutter · Riverpod 3 · Hive CE · go_router"
- `.claude/skills/document-idea/SKILL.md` — `docs/ARCHITECTURE.md` + `docs/DEV_NOTES.md` → `internal_docs/`
- `.claude/skills/pre-commit/SKILL.md` — `docs/DEV_NOTES.md` + `docs/ARCHITECTURE.md` → `internal_docs/` (done in previous session)

---

### 2026-04-09 — Migrate all legacy Riverpod providers to modern API (Notifier/NotifierProvider)

**What was done:** Removed all `StateProvider` and `StateNotifier` usage (moved to `legacy.dart` in Riverpod 3.x) — migrated to `Notifier<T>`/`NotifierProvider`. All 6 `StateProvider` instances replaced with minimal `Notifier<T>` classes exposing a `set()` method. All 6 `StateNotifier` classes migrated to `Notifier<T>` (initial state moved to `build()`, `_ref` field removed in favour of built-in `ref`). Updated 19 call sites in 8 screen files (`.notifier.state =` → `.notifier.set()`). Removed all `legacy.dart` imports. `flutter analyze` clean.

**Modified files:**
- `lib/core/providers/locale_provider.dart` — `StateProvider<String>` → `LocaleNotifier extends Notifier<String>`
- `lib/core/providers/theme_provider.dart` — `StateProvider<ThemeMode>` → `ThemeNotifier extends Notifier<ThemeMode>`
- `lib/core/router/app_router.dart` — `StateProvider<bool>` → `OnboardingGateNotifier extends Notifier<bool>`
- `lib/features/home/providers/home_provider.dart` — `StateProvider<CourseId>` → `ActiveCourseNotifier`
- `lib/features/workout/providers/workout_provider.dart` — 2 `StateProvider` + `WorkoutNotifier extends StateNotifier` → all modern
- `lib/features/onboarding/providers/onboarding_provider.dart` — `OnboardingNotifier extends StateNotifier` → `Notifier`
- `lib/features/settings/providers/settings_provider.dart` — `SettingsNotifier extends StateNotifier` → `Notifier`
- `lib/features/friends/providers/friends_provider.dart` — `FriendsNotifier extends StateNotifier` → `Notifier`
- `lib/features/library/providers/exercise_library_provider.dart` — `ExerciseLibraryNotifier extends StateNotifier` → `Notifier`
- `lib/data/repositories/custom_routine_repository.dart` — `CustomRoutinesNotifier extends StateNotifier` → `Notifier`
- 8 screen files — `.notifier.state =` → `.notifier.set()`

**Key issues and solutions:**
- `StateNotifier` constructor took initial state via `super()`; `Notifier` uses `build()` instead. For `SettingsNotifier` which took `UserRepository` as a constructor arg, `build()` now calls `ref.read(userRepositoryProvider)` directly — the `_userRepo` field was removed.
- For `StateProvider<T>` there is no direct 1-to-1 replacement; the minimal idiomatic approach is a `Notifier<T>` with a `set(T value) => state = value` method.

---

### 2026-04-09 — Migrate hive → hive_ce; upgrade flutter_riverpod to 3.x

**What was done:** Replaced `hive`/`hive_flutter`/`hive_generator` with `hive_ce`/`hive_ce_flutter`/`hive_ce_generator` (Hive Community Edition — active fork, same box format, zero data migration). This unblocked `build_runner` (bumped to `^2.13.1`) and `flutter_riverpod` (bumped to `^3.0.1`). For Riverpod 3.x, added `import 'package:flutter_riverpod/legacy.dart'` to 10 files that use `StateProvider`/`StateNotifierProvider` (moved to legacy module in 3.x). Regenerated all `.g.dart` adapter files with hive_ce_generator. `flutter analyze` clean (3 infos in generated file only).

**Modified files:**
- `pubspec.yaml` — hive→hive_ce, hive_flutter→hive_ce_flutter, hive_generator→hive_ce_generator, build_runner `^2.4.13`→`^2.13.1`, flutter_riverpod `^2.6.1`→`^3.0.1`
- All 15 Dart files with Hive imports — updated package path to `hive_ce`/`hive_ce_flutter`
- `lib/data/repositories/custom_routine_repository.dart`, `workout_provider.dart`, `home_provider.dart`, `app_router.dart`, `exercise_library_provider.dart`, `onboarding_provider.dart`, `settings_provider.dart`, `friends_provider.dart`, `theme_provider.dart`, `locale_provider.dart` — added `legacy.dart` import
- All `.g.dart` adapter files — regenerated by hive_ce_generator
- `.claude/skills/implement-feature/SKILL.md` — added mandatory Context7 research step (Step 2) and library checklist

**Key issues and solutions:**
- Original `hive_generator ^2.0.1` required `analyzer >=4.6.0 <7.0.0`, blocking `build_runner ^2.4.14+` and `flutter_riverpod 3.x`. `hive_ce_generator ^1.11.1` uses `analyzer ^10.0.0` — fully unblocked.
- Isar was considered as migration target but rejected: Isar uses native Rust library `libisar.so` which is not 16KB page-aligned → rejected by Google Play for Android 15+. hive_ce is pure Dart — unaffected.
- `hive_ce` reads original Hive box files without migration (same format).
- Riverpod 3.x: `StateProvider`, `StateNotifierProvider`, `ChangeNotifierProvider` moved to `legacy.dart`. Minimal migration — add one import line per affected file. In 3 files `legacy.dart` fully supersedes `flutter_riverpod.dart` (only legacy providers used), so the main import was removed.

---

### 2026-04-09 — Dependency upgrades: 11 packages to latest major versions

**What was done:** Updated all upgradeable packages to their latest versions. Fixed breaking API changes in `flutter_local_notifications` 21.x (all methods switched to named parameters, `UILocalNotificationDateInterpretation` removed) and `flutter_blue_plus` 2.x (`connect()` now requires `license: License.free`). Updated iOS CocoaPods.

**Modified files:**
- `pubspec.yaml` — bumped 11 direct dependencies to latest major versions
- `lib/core/services/notification_service.dart` — migrated to flutter_local_notifications 21.x API (named params for `initialize`, `show`, `cancel`, `zonedSchedule`)
- `lib/core/services/ble_service.dart` — added `license: License.free` to `device.connect()` call
- `ios/Podfile.lock` — updated by pod install

**Key issues and solutions:**
- `flutter_riverpod` cannot be upgraded to 3.x: `hive_generator ^2.0.1` requires `analyzer >=4.6.0 <7.0.0`, which conflicts with `riverpod 3.x` dependency chain via `test`. Stays at 2.6.1 until Hive ecosystem is replaced.
- `build_runner` stays at 2.4.13 for the same reason.
- `flutter_blue_plus` 2.x introduced commercial licensing: free tier requires `License.free` passed to `connect()`.
- `flutter_local_notifications` 21.x: all plugin methods switched from positional to named parameters; iOS-only `UILocalNotificationDateInterpretation` enum removed entirely.

---

### 2026-04-09 — Reorganize docs folders: public→docs/, internal→internal_docs/

**What was done:** Renamed `docs/` → `internal_docs/` and `public_docs/` → `docs/` so GitHub Pages can serve public documents from `/docs/` on the `main` branch. Updated all cross-references in README, CLAUDE.md, ARCHITECTURE.md, DEV_NOTES.md, and memory.

**Modified files:**
- `internal_docs/` — renamed from `docs/`
- `docs/` — renamed from `public_docs/`
- `README.md`, `CLAUDE.md` — updated doc links

---

### 2026-04-09 — Legal documents: Privacy Policy + Terms of Use

**What was done:** Created `docs/` folder (public documents) with Privacy Policy and Terms of Use. Both documents are English-only. Privacy Policy covers local-only data model, Health integration, Friends (peer-to-peer BLE/QR), camera, Bluetooth, notifications, and no-analytics stance. Terms of Use includes medical disclaimer, personal license, no-warranty clause, and governing law (Republic of Armenia).

**New files:**
- `docs/PRIVACY_POLICY.md` — App Store / Play Store privacy policy (English)
- `docs/TERMS_OF_USE.md` — Terms of Use incl. medical disclaimer (English)

---

### 2026-04-09 — Docs and metadata refresh (v1.7)

**What was done:** Updated README.md to reflect v1.7 feature set; bumped `pubspec.yaml` version to `1.7.0+8`; audited and corrected ARCHITECTURE.md (Balance/warmup/cooldown tables, backlog ordering); updated DEV_NOTES.md current status and Lottie section; updated `internal_docs/tz_designer.md` to v2.0 marking Block F complete.

**Modified files:**
- `README.md` — full rewrite: all 6 branches, Exercise Library, Custom Workouts, Friends, correct tech stack
- `pubspec.yaml` — version `1.4.0+5` → `1.7.0+8`
- `internal_docs/ARCHITECTURE.md` — Balance table ✅, warmup/cooldown tables ✅, backlog reordered by version
- `internal_docs/DEV_NOTES.md` — current status v1.4→v1.7, Lottie status updated
- `internal_docs/tz_designer.md` — v2.0: Block F marked done, priorities reordered

---

### 2026-04-09 — New warmup/cooldown animations + exercise catalog translated to English

**What was done:** Wired `warmup_wrist_circles.json` and `cooldown_downward_dog.json` into the exercise catalog. Translated all Russian `name`/`description`/`techniqueTip` fields in `exercise_catalog.dart` to English — the catalog is now fully English (UI strings go through `ExerciseL10n` / ARB files, so this had no visible effect on the UI).

**Modified files:**
- `lib/data/static/exercise_catalog.dart` — `animationPath` added to warmupWristCircles and cooldownDownwardDog; all Russian fields translated to English
- `lib/generated/assets.dart` — `cooldownDownwardDog` and `warmupWristCircles` entries added
- `lib/data/models/exercise.dart` — doc comments updated to clarify English-source convention

---

### 2026-04-08 — Balance branch animations wired up

**What was done:** Added `animationPath` to all 6 Balance progression exercises. Lottie files `bal_s1_one_leg_stand.json` through `bal_s6_free_hs.json` are now displayed in the workout screen.

**Modified files:**
- `lib/data/static/exercise_catalog.dart` — `animationPath` added to balS1–balS6

---

### 2026-04-07 — Workout history card: colored exercise tags

**What was done:** Improved `_WorkoutLogTile` in `profile_screen.dart`. The card now shows a summary row of up to 4 colored muscle/type tags for the whole workout (collected from all exercises). The detail sheet shows 1–2 colored tag chips under each exercise name. Meta-tags (floorOnly, requiresBar, beginner) are filtered out. Added `_ExerciseTagChip` widget; imported `ExerciseTagsCatalog`.

**Modified files:**
- `lib/features/profile/screens/profile_screen.dart`

---

### 2026-04-07 — Documentation: full exercise/animation audit

**What was done:** Full audit of exercise catalog vs. animation files. Updated all three docs:
- `internal_docs/ARCHITECTURE.md` — added Lottie column to all branch tables; added Flex branch table (was missing); added Warmup, Cooldown, and Supplementary pool tables; fixed Legs backlog note (5/5 not 4/5); added Balance/Flex/Posture/Neck backlog entries.
- `internal_docs/DEV_NOTES.md` — updated animation status summary; replaced stale "waiting for designer" section with accurate status.
- `internal_docs/tz_designer.md` — bumped to v1.9; added Block I (Posture, 6 files) and Block J (Neck, 6 files); fixed Block F count from 9 → 8 (removed nonexistent `cooldown_wrist_stretch`).

**Animation status:** 35 files done (Push 7, Core 7+alt, Pull 6, Legs 5, Warmups 5, Cooldowns 5). Missing: Balance(8), Flex(6), Posture(6), Neck(6), Supplementary(9) = 35 still needed.

---

### 2026-04-07 — Custom Workouts UX polish: streak fix, swipe-to-delete, routine detail sheet, home sheet with saved routines

**What was done:** Multiple UX fixes and improvements to Custom Workouts. Fixed a critical bug where custom workouts blocked the primary workout and prevented streak growth. Redesigned routine cards with swipe-to-delete and a detail bottom sheet. Home screen custom workout button now shows saved routines when available.

**Modified files:**
- `lib/features/workout/providers/workout_provider.dart` — removed forced `isPrimary = false` for custom workouts; first workout of the day is now always primary regardless of type
- `lib/features/home/providers/home_provider.dart` — `hasWorkoutToday` now uses `hasPrimaryWorkoutToday()` so custom workouts don't falsely show the "Done" state
- `lib/core/providers/goro_expression_provider.dart` — same fix: Goro expression based on primary workout only
- `lib/features/home/screens/home_screen.dart` — SafeArea fix for bottom buttons overflow; `_HomeCustomSheet` now shows saved routines list when available, Quick Routine option at bottom; extracted `_QuickRoutineTagPicker` widget
- `lib/features/library/screens/library_screen.dart` — `_RoutineCard` redesigned: `Dismissible` swipe-to-delete, tap opens `_RoutineDetailSheet` (exercise list with tags + edit/delete icons + start button), long press removed; header replaced two pill buttons with single `+` circle button opening `_AddRoutineSheet`
- `lib/features/library/screens/custom_routine_builder_screen.dart` — Save button now always active when exercises selected; if name empty, focuses name field and shows snackbar
- `l10n/app_en.arb`, `l10n/app_ru.arb` — added `customWorkoutNameRequired`, `customWorkoutEdit`, `customWorkoutConfirmStart`, `customWorkoutBuilderDesc`
- `internal_docs/ARCHITECTURE.md` — added custom course builder to v2.x backlog

**Key issues and solutions:**
- Custom workout streak bug: `isPrimary` was forced to `false` for all custom workouts, but `hasWorkoutToday()` checked for ANY workout → user was locked out of primary workout after a custom session. Fix: `isPrimary = !hasPrimaryWorkoutToday()` universally (first workout of day wins, regardless of type).
- `_HomeCustomSheet` is inside a `showModalBottomSheet` builder without a Navigator context for `context.push` — resolved by capturing the outer `context` and `ref` in closures before entering the builder.

---

### 2026-04-07 — Custom Workouts: full exercise catalog + auto warmup/cooldown

**What was done:** Added warmup, cooldown and supplementary exercises to the exercise catalog and builder. Introduced `ExerciseTag.warmup` / `ExerciseTag.cooldown` tags. Quick Routine now always auto-prepends a warmup and appends a cooldown. Builder shows all exercise types and offers an auto-add dialog when the routine has no warmup/cooldown.

**Modified files:**
- `lib/data/models/enums.dart` — added `ExerciseTag.warmup`, `ExerciseTag.cooldown` with colors (#FF9F0A, #5E5CE6) and l10n
- `lib/data/static/exercise_tags_catalog.dart` — added tags for 7 warmups, 6 cooldowns, 9 supplementary exercises
- `lib/data/static/exercise_catalog.dart` — `libraryAll` now includes `...warmups` and `...cooldowns`
- `lib/domain/services/workout_generator_service.dart` — added supplementary fallback in `fromExerciseIds`; added `hasWarmupAndCooldown()` and `addGenericWarmupCooldown()` static helpers
- `lib/features/library/screens/custom_routine_builder_screen.dart` — builder now uses `libraryAll + SupplementaryExerciseCatalog.all`; `_startNow`/`_save` show dialog if no warmup/cooldown
- `lib/features/library/screens/library_screen.dart` — Quick Routine filters out warmup/cooldown from tag results, always auto-adds them
- `lib/features/home/screens/home_screen.dart` — same Quick Routine fix
- `l10n/app_en.arb`, `l10n/app_ru.arb` — 2 new tag keys + 4 dialog keys

**Key issues and solutions:**
- Quick Routine uses tag-based exercise selection, but warmup/cooldown exercises now also carry their respective tags → filtering them out before shuffling, then always auto-prepending/appending. Avoids the edge case where a user taps "Stretch" and gets 5 cooldowns in a row.
- `fromExerciseIds` search order: `ExerciseCatalog.byId` (const `all` list) → `libraryAll` (non-const, covers warmup/cooldown) → `SupplementaryExerciseCatalog.all`. Warmup/cooldown were not in `all` before this change, so the fallback was necessary.

---

### 2026-04-07 — v1.7 Custom Workouts

**What was done:** Implemented full Custom Workouts feature. Users can build named routines from any exercises in the catalog, save them to Hive, and run them anytime. Quick Routine allows tapping a focus tag to get an auto-selected 4–6 exercise set immediately. Both flows run as bonus workouts (isPrimary = false, ×0.5 SP, no progression). Secondary "Custom Workout" button added to HomeScreen. "My Routines" section added to LibraryScreen above the Exercise Catalog button.

**New files:**
- `lib/data/models/custom_routine.dart` — `CustomRoutine` Hive model (typeId=11), fields id/name/exerciseIds/createdAt/lastRunAt
- `lib/data/models/custom_routine.g.dart` — generated Hive adapter
- `lib/data/repositories/custom_routine_repository.dart` — `CustomRoutineRepository` + `CustomRoutinesNotifier` (StateNotifier) + `customRoutinesProvider`
- `lib/features/library/screens/custom_routine_builder_screen.dart` — routine builder with exercise checklist, tag filter chips, Save + Start Now buttons

**Modified files:**
- `lib/main.dart` — registered `CustomRoutineAdapter`, opened `custom_routines` Hive box
- `lib/domain/services/workout_generator_service.dart` — added `fromExerciseIds(List<String> ids) → WorkoutPlan`
- `lib/features/workout/providers/workout_provider.dart` — added `customWorkoutPlanProvider`, integrated into `_buildPlan` and `_finishWorkout`; custom workouts always use `isPrimary = false` and `courseIdIndex = null`
- `lib/core/router/app_router.dart` — `/library/routine-builder` nested route
- `lib/features/library/screens/library_screen.dart` — `_MyRoutinesSection` with `_RoutineCard`, `_QuickRoutineSheet`; imports for new providers
- `lib/features/home/screens/home_screen.dart` — `_CustomWorkoutButton` + `_HomeCustomSheet` (tag picker)
- `l10n/app_en.arb`, `l10n/app_ru.arb` — 15 new keys (`customWorkout*`)
- `lib/features/friends/screens/friends_screen.dart` — fixed pre-existing parse error: `?action` (null-aware element syntax)

**Key issues and solutions:**
- `customWorkoutPlanProvider` must be read (not watched) in `_finishWorkout` because the notifier auto-disposes the workout screen after completion — reading it before resetting correctly captures the "was this a custom workout?" flag.
- `fromExerciseIds` uses `ExerciseCatalog.byId` with fallback to `libraryAll` because `byId` searches `all` (a `const` list) which doesn't include `coreS4FlutterKicks`.
- hive_generator rejected Dart 3.8 `?action` null-aware element syntax (valid in the analyzer, but the hive_generator's parser is older) — had to temporarily use `if (action != null) action!` for the build, then revert.

---

### 2026-04-07 — Exercise Library: colored tag chips

**What was done:** Added `ExerciseTag.color` getter to `ExerciseTagExtension` (in `enums.dart`). Applied tag colors consistently: FilterChips in the filter row now show each tag's color (tinted background + colored border + white text when selected); `_TagChip` in the detail sheet now uses colored tinted background + border + colored text. Removed the duplicate `_tagColor()` method from `_TagDots`.

**Modified files:**
- `lib/data/models/enums.dart` — added `Color get color` to `ExerciseTagExtension`
- `lib/features/library/screens/exercise_library_screen.dart` — FilterChip uses `tag.color`; removed `_tagColor()` method
- `lib/features/library/widgets/exercise_detail_sheet.dart` — `_TagChip` uses `tag.color`; removed `scheme` param

---

### 2026-04-07 — v1.6 Exercise Library (Tags + Search)

**What was done:** Implemented the full Exercise Library feature. A searchable, filterable catalog of all progression exercises, accessible via a gradient button at the bottom of the Library tab. Exercises display with Lottie animations, branch badges, and tag chips. Tapping an exercise opens a detail sheet with animation, technique tip, and semantic tags.

**New files:**
- `lib/data/static/exercise_tags_catalog.dart` — static map of exercise ID → `List<ExerciseTag>` (kept separate from exercise_catalog.dart to avoid touching 1500-line file)
- `lib/features/library/providers/exercise_library_provider.dart` — `ExerciseLibraryNotifier` (search + tag filter, autoDispose)
- `lib/features/library/widgets/exercise_detail_sheet.dart` — `ExerciseDetailSheet` bottom sheet with Lottie animation, tags, tip
- `lib/features/library/screens/exercise_library_screen.dart` — 2-column grid with search field + horizontally scrollable FilterChip row

**Modified files:**
- `lib/data/models/enums.dart` — added `ExerciseTag` enum (17 values) + `ExerciseTagExtension.localizedName`
- `lib/data/models/exercise.dart` — added `tags: List<ExerciseTag>` field (default `const []`)
- `lib/data/static/exercise_catalog.dart` — added `libraryAll` getter (all progression exercises incl. `coreS4FlutterKicks`)
- `lib/l10n/app_localizations*.dart` — 23 new keys (library UI + 17 tag names)
- `lib/core/router/app_router.dart` — `/library/exercises` nested route
- `lib/features/library/screens/library_screen.dart` — gradient "Exercise Catalog" button at the bottom

**Key issues and solutions:**
- Tags are NOT stored in `exercise_catalog.dart` inline — would require editing 50+ const Exercise declarations. Instead a separate `ExerciseTagsCatalog` maps exercise IDs to tag lists. The `Exercise.tags` field exists but defaults to `const []`; the library uses `ExerciseTagsCatalog.forId(id)` for filtering.
- `coreS4FlutterKicks` is not in `ExerciseCatalog.all` (it's an alternative, not a main progression entry) — added explicit `libraryAll` getter that includes it.
- Tag filter uses AND logic: all selected tags must be present.
- **l10n Edit tool bug**: The Edit tool reports success when editing large l10n files (>2000 lines) but does NOT write changes to disk. Workaround: use Python `python3 -c` or a heredoc script to do string replacement (`content.replace(old, new)` + `open(path, 'w')`). This affected `app_localizations.dart`, `app_localizations_ru.dart`, and `app_localizations_en.dart`.

### 2026-04-07 — Fix: branch progress is shared across courses

**What was done:** Fixed a bug where branches that appear in multiple courses (e.g., Flex in Calisthenics and Healthy Body) showed independent progress instead of shared progress. Branches represent physical skills and their progress must be global.

**Modified files:**
- `lib/data/repositories/skill_progress_repository.dart` — removed `course` param from all methods; key is now `branch.name` only; migration converts legacy course-scoped keys back to bare keys
- `lib/main.dart` — updated migration call from `migrateToCourseScopedKeys` to `runMigrations`
- `lib/domain/services/workout_generator_service.dart` — removed `course:` param from `getProgress`
- `lib/features/home/providers/home_provider.dart` — removed `course:` param from `getProgress`
- `lib/features/library/screens/library_screen.dart` — removed `course:` param from `getProgress`
- `lib/features/workout/providers/workout_provider.dart` — removed `course:` params from `getProgress` / `saveProgress`
- `lib/features/onboarding/providers/onboarding_provider.dart` — removed `course:` params from `saveProgress`

**Key issues and solutions:** The previous multi-course implementation (v1.5) introduced course-scoped Hive keys (`calisthenics_flex`, `healthyBody_flex`) which caused the same branch to show different progress in different courses. The correct model: branches are physical skills, so `SkillProgress` is keyed by branch name only. `runMigrations()` handles both old bare keys (pre-v1.5) and course-scoped keys (v1.5) — converging everything to bare keys.

### 2026-04-06 — Multi-Course System v1.5 (Calisthenics + Healthy Body)

**What was done:** Implemented the full multi-course system. Added `CourseId` enum (typeId 10), `posture` and `neck` BranchId values (HiveField 6/7), course-scoped SkillProgress keys (`${courseId}_${branchId}`), Library tab replacing Progress tab, updated onboarding with course selection, and new exercise catalog entries for posture (6 stages) and neck (5 stages) branches.

**New files:**
- `lib/data/static/course_catalog.dart` — `CourseCatalog.branchesFor(CourseId)`
- `lib/features/library/screens/library_screen.dart` — Library tab: course pills, branch progress cards, challenge cards

**Modified files:**
- `lib/data/models/enums.dart` — `CourseId` enum + `CourseIdExtension`; `BranchId` gains `posture`/`neck` values; `BranchIdExtension` updated for all 8 branches
- `lib/data/models/enums.g.dart` — manually updated: BranchIdAdapter cases 6/7; new CourseIdAdapter (typeId 10)
- `lib/data/models/user_profile.dart` — `@HiveField(24) activeCourseIds`, `@HiveField(25) activeCourseIndex`; computed `enrolledCourses`, `activeCourse`, `branchesForCourse()`
- `lib/data/models/user_profile.g.dart` — manually updated writeByte 20→22; fields 24/25 added
- `lib/data/models/workout_log.dart` — `@HiveField(6) courseIdIndex`
- `lib/data/models/workout_log.g.dart` — manually updated writeByte 6→7; field 6 added
- `lib/data/repositories/skill_progress_repository.dart` — course-scoped key `_key(branch, course)`; all methods accept `{CourseId course}`; `migrateToCourseScopedKeys()`
- `lib/data/static/exercise_catalog.dart` — posture (6) + neck (5) exercises + `warmupNeckRolls`; updated `progressionFor`, `warmupFor`, `cooldownsFor`
- `lib/domain/services/workout_generator_service.dart` — `generateDailyForCourse()` method
- `lib/features/home/providers/home_provider.dart` — `activeCourseProvider`; `HomeData` includes `activeCourse`
- `lib/features/workout/providers/workout_provider.dart` — reads `activeCourseProvider`, calls `generateDailyForCourse`, saves `courseIdIndex` in WorkoutLog
- `lib/features/onboarding/providers/onboarding_provider.dart` — replaced `FitnessGoal` with `selectedCourseIds`; added course-scoped init
- `lib/features/onboarding/screens/onboarding_screen.dart` — `_CourseStep` replaces `_GoalStep`
- `lib/core/router/app_router.dart` — `/library` route + `navLibrary` label replaces `/progress`
- `lib/core/extensions/exercise_l10n.dart` — posture/neck exercise keys added
- `l10n/app_ru.arb` + `l10n/app_en.arb` — all new keys: navLibrary, libraryTitle, courseNameCalisthenics/healthyBody, onboardingQ4Courses, homeBranchPosture/Neck, all posture/neck exercise keys
- `lib/main.dart` — `CourseIdAdapter` registration; `migrateToCourseScopedKeys()` call
- `lib/domain/services/achievement_service.dart` — posture/neck branch cases added (no-op)
- `lib/features/settings/screens/developer_options_screen.dart` — posture/neck in branch switch expressions

**Key issues and solutions:**
- **SkillProgress key migration:** old keys were bare branch names (`"push"`); new keys are course-scoped (`"calisthenics_push"`). Migration runs at startup (idempotent: skips already-migrated keys). Flex is special — mapped to `"calisthenics_flex"` since it's part of the Calisthenics course.
- **exercise_l10n.dart vs ARB key mismatch:** The previous session wrote `exercise_l10n.dart` with exercise IDs based on the catalog (`posture_s2_dead_bug` → `exercisePostureS2DeadBugName`), but I initially added wrong ARB keys (`exercisePostureS2GluteRaiseName`). Fixed by aligning ARB keys to match catalog IDs.
- **`homeDataProvider` undefined:** `workout_provider.dart` imported only `activeCourseProvider` via `show`. Fixed by adding `homeDataProvider` to the `show` clause.
- **CourseIdAdapter registration:** `CourseId` is a new Hive type (typeId 10) — must be registered before any box is opened. Added to `main.dart` adapter chain.

### 2026-04-06 — Lottie animations: Legs warmup/cooldown accessories (Block E complete)

**What was done:** Integrated 4 new Lottie animations for Legs branch accessories: `warmup_leg_swings`, `warmup_hip_circles`, `cooldown_quad_stretch`, `cooldown_hip_flexor`. Added `warmupHipCircles` and `cooldownHipFlexor` as new exercises in the catalog; added `animationPath` to existing `warmupLegSwings` and `cooldownQuadStretch`. Updated warmup/cooldown routing: Legs now uses `warmupHipCircles` as its warmup (Flex keeps `warmupLegSwings`), and gets two cooldowns `[cooldownQuadStretch, cooldownHipFlexor]`. Updated designer TZ to v1.8 — Block E fully closed, Block F (Balance) is next priority.

**New files:**
- `assets/animations/warmup_leg_swings.json` — leg swings warmup animation
- `assets/animations/warmup_hip_circles.json` — hip circles warmup animation
- `assets/animations/cooldown_quad_stretch.json` — quad stretch cooldown animation
- `assets/animations/cooldown_hip_flexor.json` — hip flexor stretch cooldown animation

**Modified files:**
- `lib/data/static/exercise_catalog.dart` — added `warmupHipCircles` + `cooldownHipFlexor` exercises; added `animationPath` to `warmupLegSwings` + `cooldownQuadStretch`; updated `warmupFor(legs)` → `warmupHipCircles`; updated `cooldownsFor(legs)` → two cooldowns
- `lib/generated/assets.dart` — already registered (auto)
- `internal_docs/tz_designer.md` — bumped to v1.8, Block E marked complete, Block F set as first priority

---

### 2026-04-05 — Lottie animations: Legs s5 (pistol free) + updated existing animation files

**What was done:** Added `legs_s5_pistol_free.json` animation for the free pistol squat (Legs Stage 5) and wired it to `legsS5Pistol` in the exercise catalog. Also updated content of several previously stubbed animation files: `core_s6_dragon_flag`, `legs_s1–s3`, and all six Pull branch animations (`pull_s1–s6`).

**New files:**
- `assets/animations/legs_s5_pistol_free.json` — free pistol squat animation (Legs S5)

**Modified files:**
- `lib/data/static/exercise_catalog.dart` — added `animationPath` to `legsS5Pistol`
- `lib/generated/assets.dart` — registered `legs_s5_pistol_free` asset
- `assets/animations/core_s6_dragon_flag.json` — updated animation content
- `assets/animations/legs_s1_squat.json`, `legs_s2_lunge.json`, `legs_s3_bulgarian.json` — updated animation content
- `assets/animations/pull_s1_australian.json` through `pull_s6_one_arm.json` — updated animation content

---

### 2026-04-04 — Legs branch Lottie animations (s1–s4) + version bump to 1.4.0 + spacing tweak

**What was done:** Added Lottie animation files for Legs branch stages 1–4 (squat, lunge, bulgarian split squat, assisted pistol squat). Updated `pubspec.yaml` version to `1.4.0+5` and set a proper app description. Also increased spacing between the exercise animation and the "set X of Y" label in the workout screen.

**New files:**
- `assets/animations/legs_s1_squat.json`
- `assets/animations/legs_s2_lunge.json`
- `assets/animations/legs_s3_bulgarian.json`
- `assets/animations/legs_s4_pistol.json`

**Modified files:**
- `lib/data/static/exercise_catalog.dart` — added `animationPath` to `legsS1Squat`, `legsS2Lunge`, `legsS3Bulgarian`, `legsS4AssistedPistol`
- `lib/generated/assets.dart` — added `legsS1Squat`, `legsS2Lunge`, `legsS3Bulgarian`, `legsS4Pistol` entries
- `pubspec.yaml` — version `1.1.0+2` → `1.4.0+5`, updated description
- `lib/features/workout/screens/workout_screen.dart` — added `SizedBox(height: 16)` between Lottie animation and set indicator label

**Key issues and solutions:** `legs_s4_pistol.json` is named after the exercise shape (pistol squat), not the exact exercise id (`legs_s4_assisted_pistol`). This is intentional — the animation shows the pistol movement pattern used in both the assisted and full versions.

---

### 2026-03-28 — Lottie animations: cooldown_lat_stretch + core_s4_flutter_kicks

**What was done:** Added animationPath to `cooldownLatStretch` and `coreS4FlutterKicks`. Blocks B and D are now fully covered with Lottie animations. Updated designer TZ to v1.6 reflecting closed blocks.

**New files:**
- `assets/animations/cooldown_lat_stretch.json` — cooldown animation for Pull branch
- `assets/animations/core_s4_flutter_kicks.json` — flutter kicks (Core S4 equipment-free alternative)

**Modified files:**
- `lib/data/static/exercise_catalog.dart` — added animationPath to cooldownLatStretch and coreS4FlutterKicks
- `internal_docs/tz_designer.md` — updated to v1.6: blocks B and D marked complete, next priority is E (Legs)

### 2026-03-27 — Core S4 equipment-free alternative + streak real-work fix

**What was done:** Added flutter kicks (`core_s4_flutter_kicks`) as an equipment-free alternative for Core S4 (hanging leg raises require a pull-up bar). Users without a bar now get flutter kicks instead. Also fixed streak logic: streak no longer increments for warmup-only or all-zero-reps workouts — at least one real exercise (stage > 0, reps > 0 or duration > 0) is required.

**Modified files:**
- `lib/data/static/exercise_catalog.dart` — added `coreS4FlutterKicks`, `requiresEquipment: true` on `coreS4HangingLegRaise`, added `equipmentFreeForStage()` method
- `lib/domain/services/workout_generator_service.dart` — added `hasPullUpBar` param to `generateDaily`; picks equipment-free alternative when user has no bar
- `lib/features/workout/providers/workout_provider.dart` — passes `hasPullUpBar` to generator; added `_hasRealWork()` guard before `streakService.applyWorkout()`

**Key issues and solutions:**
- Flutter kicks are at stage 4 but easier than hanging leg raises. Compensated by higher rep counts (start 10, target 25 vs 3→10 for hanging). `SkillProgress.currentReps` still tracks progression normally since the alternative shares the same stage slot — no Hive changes needed.
- `equipmentFreeForStage()` method keeps the generator logic simple: returns alternative only for the specific branch+stage pair, null otherwise. Easy to extend for future equipment alternatives.

### 2026-03-27 — Pull branch + warmup_dead_hang Lottie animations

**What was done:** Added animationPath to all 6 Pull branch exercises (s1–s6) and warmup_dead_hang. Pull branch now has full Lottie coverage. Animation JSON files were provided by the designer and registered in generated/assets.dart.

**Modified files:**
- `lib/data/static/exercise_catalog.dart` — added animationPath to pullS1Australian, pullS2Negative, pullS3Pullup, pullS4CloseGrip, pullS5Archer, pullS6OneArm, warmupDeadHang

**New files:**
- `assets/animations/pull_s1_australian.json`
- `assets/animations/pull_s2_negative.json`
- `assets/animations/pull_s3_pullup.json`
- `assets/animations/pull_s4_close_grip.json`
- `assets/animations/pull_s5_archer.json`
- `assets/animations/pull_s6_one_arm.json`
- `assets/animations/warmup_dead_hang.json`

---

### 2026-03-26 — Core branch Lottie animations s4–s6

**What was done:** Added animationPath to Core branch exercises s4 (Hanging Leg Raise), s5 (L-sit), and s6 (Dragon Flag). All 6 Core stages now have Lottie animations. Animation JSON files were already present in assets/animations/.

**Modified files:**
- `lib/data/static/exercise_catalog.dart` — added animationPath to coreS4HangingLegRaise, coreS5LSit, coreS6DragonFlag

---

### 2026-03-23 — BLE Peripheral + GATT Server for Friends

**What was done:** Implemented full BLE Peripheral role so that a device running CaliDay advertises itself and serves its profile over GATT, enabling other nearby users to add friends without QR scanning. The "Connect" button on Nearby tiles now attempts a GATT read first and falls back to QR only if the remote has no GATT server.

**New files:** none

**Modified files:**
- `pubspec.yaml` — added `ble_peripheral: ^2.4.0`
- `lib/core/services/ble_service.dart` — replaced stubs: `startAdvertising(profileJson, displayName)` initializes `BlePeripheral`, registers service UUID + READ characteristic, sets read callback, starts advertising; `stopAdvertising()` stops and clears services; `readProfileJson` now returns `Map<String,dynamic>` (decoded JSON) instead of `{'_raw':…}`
- `lib/data/models/friend_profile.dart` — added `fromBleJson()` factory (alias for `fromQrJson`, same JSON structure)
- `lib/features/friends/screens/friends_screen.dart` — `initState` calls `_startAdvertising()`; `dispose` calls `stopAdvertising()`; Nearby tile "Connect" calls `_connectViaBle()` which tries GATT, adds friend on success, falls back to QR on failure; `_buildQrPayload` refactored to use shared `_buildProfileJson()`

**Key issues and solutions:**
- `ble_peripheral` name conflict: the package exports a class also named `BleService`. Resolved by importing the package with prefix `blep` (`import 'package:ble_peripheral/ble_peripheral.dart' as blep`).
- Published version is `2.4.0`, not `0.3.x` as listed in DEV_NOTES — version constraint updated accordingly.
- `ReadRequestCallback` in v2.x is synchronous: `ReadRequestResult? Function(String deviceId, String characteristicId, int offset, Uint8List? value)` — no `async` allowed in the callback.

---

### 2026-03-23 — Fix scheduled notifications (Android) + Core Lottie animations s1–s3

**What was done:** Fixed scheduled notifications never firing on Android by adding missing `flutter_local_notifications` receivers to AndroidManifest. Added `USE_EXACT_ALARM` permission. Integrated Lottie animations for Core branch stages 1–3.

**Modified files:**
- `android/app/src/main/AndroidManifest.xml` — added `ScheduledNotificationReceiver`, `ScheduledNotificationBootReceiver`, `ActionBroadcastReceiver`; added `USE_EXACT_ALARM` permission
- `lib/data/static/exercise_catalog.dart` — added `animationPath` to `coreS1Crunches`, `coreS2Plank`, `coreS3LyingLegRaise`

**New files:**
- `assets/animations/core_s1_crunches.json` — Lottie animation for Core s1
- `assets/animations/core_s2_plank.json` — Lottie animation for Core s2
- `assets/animations/core_s3_lying_leg_raise.json` — Lottie animation for Core s3

**Key issues and solutions:** In `flutter_local_notifications` v17+, the plugin stopped auto-merging its BroadcastReceivers into the app manifest. Without `ScheduledNotificationReceiver`, AlarmManager fired alarms into the void — no notification was ever shown. Instant (test) notifications worked fine because they bypass AlarmManager entirely. Fixed by explicitly declaring all three receivers in the app's `AndroidManifest.xml`. Also added `USE_EXACT_ALARM` (auto-granted on Android 13+) alongside `SCHEDULE_EXACT_ALARM` so exact alarms work without requiring manual user action in system settings.

### 2026-03-23 — Flexibility branch + Supplementary pool + Profile stat tooltips

**What was done:** Added a new BranchId.flex (Flexibility & Mobility, 6 stages of timed/reps stretching), a supplementary exercise pool injected into bonus workouts (2 random picks), and tappable stat chips on the Profile screen that show bottom-sheet explanations.

**New files:**
- `lib/data/static/supplementary_exercise_catalog.dart` — 9 supplementary exercises (obliques, calves, neck, wrists, core stability)

**Modified files:**
- `lib/data/models/enums.dart` — added `BranchId.flex` (@HiveField 5), updated all BranchIdExtension switches
- `lib/data/models/user_profile.dart` — added `BranchId.flex` to `activeBranches`
- `lib/data/static/exercise_catalog.dart` — 6 flex exercises + flexProgression list + updated progressionFor/forStage/warmupFor/cooldownsFor/all
- `lib/core/extensions/exercise_l10n.dart` — added flex + supp exercise ID mappings
- `lib/domain/services/workout_generator_service.dart` — added `isPrimary` param; bonus workouts get 2 random supp exercises
- `lib/features/workout/providers/workout_provider.dart` — `_buildPlan` computes `isPrimary` from repo and passes to generator
- `lib/features/profile/screens/profile_screen.dart` — `_StatCell` and `_RankCard` now accept `onTap`; `_showStatSheet` helper added
- `lib/data/repositories/skill_progress_repository.dart` — added `BranchId.flex` default progress
- `lib/domain/services/achievement_service.dart` — added `BranchId.flex` switch case
- `lib/features/settings/screens/developer_options_screen.dart` — added flex to `_maxStage` / `_branchLabel`
- `l10n/app_en.arb`, `l10n/app_ru.arb` — flex branch name, 6 flex exercises, 9 supp exercises, 5 tooltip strings

**Key issues and solutions:**
- `activeBranches` in `UserProfile` lists branches explicitly — flex was missing, so the branch never appeared in Progress tab. Fixed by adding `BranchId.flex` to the list.
- `_` used as builder parameter name and then referenced in `Theme.of(_)` fails in Dart 3 (discard identifier). Fixed by renaming to `sheetCtx`.
- `build_runner` reported error in `friends_screen.dart:283` (`?action` syntax) — pre-existing bug unrelated to this session; Hive adapter for `BranchId.flex` was still generated correctly.

---

### 2026-03-23 — Onboarding redesign + bugfixes

**What was done:** Replaced the useless "fitness frequency" step with a name input step and a Health integration opt-in step. Fixed a `TextEditingController` use-after-dispose crash in the settings name editor. Fixed a 1.2px RenderFlex overflow in the Home hero stats row.

**Modified files:**
- `lib/features/onboarding/providers/onboarding_provider.dart` — removed `FitnessFrequency` enum and state field; added `displayName` (String) and `healthEnabled` (bool); `lastStep` 6→7; `completeOnboarding` now saves `displayName` + requests Health permissions when opted in
- `lib/features/onboarding/screens/onboarding_screen.dart` — replaced `_FrequencyStep` with `_NameStep` (TextField, step 1) and `_HealthStep` (opt-in step, step 6); updated `_StepScaffold` with optional `body` subtitle; removed `FitnessFrequencyL10n` extension; updated reminder step to `onboardingQ7`
- `l10n/app_en.arb` / `l10n/app_ru.arb` — added `onboardingQ1Hint`, `onboardingQ1Body`, `onboardingQ6Health`, `onboardingHealthBody/Enable/EnableDesc/Skip/SkipDesc`, `onboardingQ7`; removed unused `onboardingQ1` (frequency)
- `lib/features/settings/screens/settings_screen.dart` — removed `controller.dispose()` after `showDialog` in `_showNameEditor` to prevent use-after-dispose crash during closing animation
- `lib/features/home/screens/home_screen.dart` — wrapped each `_HeroStat` in `Expanded` to fix 1.2px overflow on narrow screens

**Key issues and solutions:**
- `TextEditingController` disposed while dialog closing animation was still running → removed explicit `dispose()` call; inline controllers created for one-off dialogs are GC'd when they go out of scope.
- `fitnessFrequency` was collected in onboarding but never written to `UserProfile` → removed entirely.

### 2026-03-23 — Design polish (AppTheme, Home hero zone, Profile stats) + fix mobile_scanner Xcode 26 build

**What was done:** Added `AppTheme` brand token class; redesigned Home screen with gradient hero zone and energetic CTA button; updated Profile stats with orange streak cell and larger display numbers; upgraded `mobile_scanner` 5.x→7.x to fix iOS simulator build failure on Xcode 26.

**New files:**
- `lib/core/theme/app_theme.dart` — brand color tokens, shadow helpers, gradient constants, `ThemeData` factory for light/dark

**Modified files:**
- `lib/main.dart` — replaced inline `ThemeData` with `AppTheme.light` / `AppTheme.dark`
- `lib/features/home/screens/home_screen.dart` — gradient `_HeroZone`, redesigned stat chips, green done-banner, gradient CTA button
- `lib/features/profile/screens/profile_screen.dart` — `_RankCard` with gradient bg; `_StatCell` with 26sp display numbers and orange streak highlight
- `pubspec.yaml` — `mobile_scanner: ^5.2.3` → `^7.2.0`
- `ios/Podfile` — removed obsolete `EXCLUDED_ARCHS[sdk=iphonesimulator*]` workaround
- `ios/Podfile.lock` — updated after pod install

**Key issues and solutions:**
- `CardTheme` vs `CardThemeData`: Flutter renamed the type; using `CardTheme` in `ThemeData.cardTheme` caused a type error → fixed with `CardThemeData`.
- Xcode 26 simulator build failure: `MLImage.framework` (pulled in by `mobile_scanner 5.x` → `GoogleMLKit`) ships only iOS-device arm64 slices; Xcode 26 treats `EXCLUDED_ARCHS` arm64 exclusion as a hard violation. Upgrading to `mobile_scanner 7.x` dropped the `GoogleMLKit` dependency entirely — `MLImage` is no longer in the pod graph, build failure resolved.

### 2026-03-23 — Docs: tax note for IAP feature + English-only convention

**What was done:** Added a tax/legal prerequisite block to the "Support the Author" IAP spec (Germany: Gewerbe, Kleinunternehmerregelung, Einkommensteuer). Updated skills and backlog with a warning to resolve this before implementing the feature. Established English-only rule for all project documentation.

**Modified files:**
- `internal_docs/DEV_NOTES.md` — added Tax / Legal Prerequisite section under "Support the Author"
- `internal_docs/ARCHITECTURE.md` — added ⚠️ note to IAP backlog entry
- `.claude/skills/implement-feature/SKILL.md` — added English-only rule
- `.claude/skills/document-idea/SKILL.md` — added English-only rule

### 2026-03-22 — v1.4 Friends feature (QR + BLE)

**What was done:** Implemented full Friends feature — QR code profile sharing, QR scanning, BLE device discovery, friends list with detail view, friends count in Profile, display name + BLE discoverability in Settings. No server required; all data is local and exchanged peer-to-peer in person.

**New files:**
- `lib/data/models/friend_profile.dart` — `FriendProfile` HiveObject (typeId=9), `fromQrJson` factory
- `lib/data/models/friend_profile.g.dart` — generated Hive adapter
- `lib/data/repositories/friend_repository.dart` — Hive box `'friends'`, keyed by friend.id
- `lib/core/services/ble_service.dart` — BLE Central: scan, GATT read; advertising is a stub (TODO: platform channel)
- `lib/features/friends/providers/friends_provider.dart` — `FriendsNotifier`, `friendsCountProvider`
- `lib/features/friends/screens/friends_screen.dart` — main screen: QR button, BLE nearby, friends list
- `lib/features/friends/screens/qr_scan_screen.dart` — camera QR scanner with confirmation dialog
- `lib/features/friends/widgets/friend_detail_bottom_sheet.dart` — stats + delete confirmation

**Modified files:**
- `pubspec.yaml` — `qr_flutter ^4.1.0`, `mobile_scanner ^5.2.3`, `flutter_blue_plus ^1.35.3`
- `lib/data/models/user_profile.dart` — `@HiveField(23) bool? bleDiscoverable` (peerId @17 and displayName @18 were already present)
- `lib/data/models/user_profile.g.dart` — adapter regenerated
- `lib/features/settings/providers/settings_provider.dart` — `displayName`, `bleDiscoverable` fields + setters
- `lib/features/settings/screens/settings_screen.dart` — FRIENDS section (display name editor + discoverable toggle)
- `lib/features/profile/screens/profile_screen.dart` — Friends section with count and navigation
- `lib/core/router/app_router.dart` — `/friends` route
- `lib/main.dart` — `FriendProfileAdapter` registered, `'friends'` box opened
- `l10n/app_en.arb`, `l10n/app_ru.arb` — 32 new strings for Friends + Settings FRIENDS section
- `ios/Runner/Info.plist` — `NSBluetoothAlwaysUsageDescription`, `NSCameraUsageDescription`
- `android/app/src/main/AndroidManifest.xml` — BLE + CAMERA permissions

**Key issues and solutions:**
1. **BLE advertising not possible via flutter_blue_plus** — the package is Central-only (scanner + GATT client). Peripheral role (advertising) requires a dedicated package or a native platform channel. Advertising is stubbed as empty methods with a TODO comment.
2. **`use_build_context_synchronously`** — after `await addOrUpdate()` in `_openScanner()`, context could be stale. Fixed by capturing `ScaffoldMessenger.of(context)` and `context.l10n` into local variables before the first await.
3. **`advName` vs deprecated `localName`** — `flutter_blue_plus` deprecated `advertisementData.localName`; use `advName` instead.

---

### 2026-03-22 — iOS Widget Extension + bug fixes + doc translations

**What was done:** Registered CaliDayWidget as a proper Xcode target (it existed as Swift code but was never linked to the project). Fixed two state refresh bugs on the home screen. Translated two Russian docs to English.

**New files:**
- `ios/CaliDayWidget/CaliDayWidget.entitlements` — App Group entitlement for the widget
- `ios/CaliDayWidget/Info.plist` — explicit plist (auto-generation failed on simulator)
- `ios/add_widget_target.rb` — one-time script: added CaliDayWidget target via xcodeproj gem
- `ios/fix_widget_*.rb` — follow-up fix scripts (product name, paths, phase order, plist)

**Modified files:**
- `ios/Runner.xcodeproj/project.pbxproj` — CaliDayWidget target added: sources, assets, embed phase, target dependency
- `ios/Runner/Runner.entitlements` — removed `com.apple.developer.healthkit.access` (empty array caused "Personal team does not support Verifiable Health Records" error)
- `ios/CaliDayWidget/CaliDayWidget.swift` — iOS 14 compatibility: `containerBackground` wrapped in `@available`, `#Preview` → `PreviewProvider`, `Date.now` → `Date()`, dark color passed to `containerBackground` to remove white system border
- `lib/features/settings/providers/settings_provider.dart` — `setHasPullUpBar` now invalidates `homeDataProvider` (Pull branch appeared only after restart)
- `lib/features/workout/providers/workout_provider.dart` — added `_ref.invalidate(displayStreakProvider)` before other invalidations (streak showed stale value after workout because `goroExpressionProvider` kept `displayStreakProvider` alive)
- `internal_docs/CaliDay_Design_Document.md` — translated to English
- `internal_docs/design-concept/caliday_design_concept.md` — translated to English; corrected outdated note about GoroExpressionProvider (it IS integrated)

**Key issues and solutions:**
1. **Build cycle** (`Cycle inside Runner`): "Embed Foundation Extensions" phase was placed after CocoaPods' "Thin Binary" script. Thin Binary scans the entire `Runner.app` including PlugIns, creating a circular dependency. Fix: moved embed phase to index 0 (before all script phases).
2. **`ios/ios/` doubled path**: xcodeproj script created the file group with path `ios/CaliDayWidget` but the project is already inside `ios/`, so Xcode resolved it as `ios/ios/...`. Fixed by stripping the `ios/` prefix from the group path.
3. **`Invalid placeholder attributes`** on simulator: auto-generated Info.plist (`GENERATE_INFOPLIST_FILE = YES`) produced a plist missing `CFBundleExecutable`. Fixed by switching to an explicit `Info.plist` with all required keys including `CFBundleExecutable = $(EXECUTABLE_NAME)`.
4. **Stale streak after workout**: `displayStreakProvider` is `Provider.autoDispose` but stays alive because `goroExpressionProvider` watches it. When `homeDataProvider` was invalidated and re-read, `ref.read(displayStreakProvider)` returned the cached old value. Fix: invalidate `displayStreakProvider` first, then `homeDataProvider`.
5. **White border on widget (iOS 17+)**: Was using `.containerBackground(.fill.tertiary, for: .widget)` — system tertiary fill shows as white. Fix: pass `widgetBackground` (our dark color) directly to `containerBackground`.

---

### 2026-03-22 — iOS HealthKit fix: entitlement + wrong activity type

**Fixed two bugs that silently prevented Health data from being written on iOS.**

**Modified files:**
- `ios/Runner/Runner.entitlements` — created; added `com.apple.developer.healthkit` entitlement + App Group
- `ios/Runner.xcodeproj/project.pbxproj` — added `CODE_SIGN_ENTITLEMENTS = Runner/Runner.entitlements` to all 3 build configs (Debug/Profile/Release)
- `ios/Podfile` — uncommented and set `platform :ios, '14.0'` (health package requires iOS 14+)
- `lib/core/services/health_service.dart` — changed `STRENGTH_TRAINING` → `TRADITIONAL_STRENGTH_TRAINING`

**Key issues and solutions:**
1. **Missing entitlement** — `HealthKit` permission dialog never appeared because the app lacked `com.apple.developer.healthkit` entitlement. The entitlements file didn't exist at all; created it and linked via `CODE_SIGN_ENTITLEMENTS` in pbxproj.
2. **Wrong activity type** — `HealthWorkoutActivityType.STRENGTH_TRAINING` is Android-only in health 12.x. On iOS it throws `HealthException("not supported on iOS")` which was silently caught by `catch (_) { return false; }`. Fix: use `TRADITIONAL_STRENGTH_TRAINING` (`HKWorkoutActivityTypeTraditionalStrengthTraining`).

---

### 2026-03-21 — English-first migration + documentation restructure

**Made English the primary language across all project docs and app localization.**

**What was done:**
- `l10n.yaml`: `template-arb-file` changed to `app_en.arb`, `preferred-supported-locales` changed to `[en, ru]`
- `l10n/app_en.arb`: rewritten as full template with all `@key` metadata blocks (14 placeholder blocks previously only in `app_ru.arb`)
- `README.md`: rewritten in English, updated to reflect v1.3 feature state
- `CLAUDE.md`: translated to English
- `internal_docs/ARCHITECTURE.md`, `internal_docs/DEV_NOTES.md`: translated to English
- `.claude/skills/pre-commit/`, `implement-feature/`, `document-idea/`: skills translated to English, moved from `.claude/commands/` to `.claude/skills/` (Anthropic Agent Skills standard)

**Documentation structure split:**
- `internal_docs/ARCHITECTURE.md` — stable architecture reference (tech stack, Hive typeIds, service APIs, navigation, design system, code style, feature backlog)
- `internal_docs/DEV_NOTES.md` — living notes: current status, active feature specs, session history

**Key technical note:** `app_en.arb` is now the l10n template. Russian ARB (`app_ru.arb`) has 6 untranslated strings (new exercises added in session 31) that fall back to English in Russian locale — intentional.

**Modified files:** `l10n.yaml`, `l10n/app_en.arb`, `README.md`, `CLAUDE.md`, `internal_docs/ARCHITECTURE.md`, `internal_docs/DEV_NOTES.md`, `.claude/skills/*/SKILL.md`

---

### 2026-03-05 — session 39 (Health Integration: HealthKit / Health Connect)

**Implemented integration with Apple Health (iOS) and Google Health Connect (Android).**
After a workout is completed, CaliDay writes a strength training session + calories (MET formula).
Opt-in via Settings → HEALTH.

**New files:**
- `lib/core/services/health_service.dart` — `HealthService` singleton

**Modified files:**
- `pubspec.yaml` — `health: ^12.0.0`
- `lib/data/models/user_profile.dart` — `@HiveField(21) healthWorkoutsEnabled`, `@HiveField(22) healthWeightEnabled`
- `lib/data/models/user_profile.g.dart` — adapter updated
- `lib/features/settings/providers/settings_provider.dart` — new fields + setters
- `lib/features/settings/screens/settings_screen.dart` — HEALTH section
- `lib/features/workout/providers/workout_provider.dart` — `healthSaved: bool` + HealthService call
- `lib/features/workout/screens/workout_screen.dart` — `healthSaved` in extras
- `lib/features/workout/screens/summary_screen.dart` — `_HealthSavedBadge`
- `lib/main.dart` — `HealthService.instance.configure()` in postFrameCallback
- `ios/Runner/Info.plist` — NSHealth*UsageDescription
- `android/app/src/main/AndroidManifest.xml` — Health Connect permissions, queries, activity-alias
- `android/app/build.gradle.kts` — `minSdk = 26`
- `android/app/src/main/kotlin/.../MainActivity.kt` — `FlutterActivity` → `FlutterFragmentActivity`
- `l10n/app_ru.arb`, `l10n/app_en.arb` — 6 new strings

**Key issues:**
- `MainActivity` must extend `FlutterFragmentActivity` (→`ComponentActivity`), otherwise `HealthPlugin.onAttachedToActivity` crashes with `ClassCastException`
- `configure()` is wrapped in `.timeout(5s)` — without the timeout it hangs on the splash screen on subsequent launches
- `activity-alias` with `HEALTH_PERMISSIONS` is required for the Health Connect permissions dialog
- iOS: the HealthKit capability must be added manually in Xcode

---

### 2026-03-05 — session 38b (Medium 4×2 widget)

**Added a second widget: 4×2. Layout: Goro on the left + streak + SP + status on the right.**

**New files:**
- `android/.../res/xml/caliday_widget_medium_info.xml`
- `android/.../res/layout/caliday_widget_medium_layout.xml`
- `android/.../kotlin/.../CaliDayWidgetMediumReceiver.kt`

**Modified files:**
- `android/.../AndroidManifest.xml` — medium receiver
- `lib/core/services/widget_service.dart` — `_androidNameMedium`, `update()` calls both widgets, `rankLabel()` helper
- `ios/CaliDayWidget/CaliDayWidget.swift` — `CaliDaySmallView`, `CaliDayMediumView`, dispatcher by `@Environment(\.widgetFamily)`

**Issue:** `HomeWidget.updateWidget(androidName: qualifiedName)` was adding packageName twice → `ClassNotFoundException`. Fix: use `qualifiedAndroidName:` instead of `androidName:`.

---

### 2026-03-05 — session 38 (Android widget: Glance → AppWidgetProvider)

**Fixed Android widget runtime crash. Glance → classic AppWidgetProvider + RemoteViews.**

**Problem:** `NoSuchMethodError: No static method provideContent(GlanceAppWidget, Function0, Continuation)`.
**Cause:** Flutter does not include the Compose Compiler Plugin (`buildFeatures.compose = false`), so the lambda is generated as `Function0` instead of `Function2<Composer, Int, Unit>`.
**Fix:** `AppWidgetProvider` + XML layout — does not require Compose.

Additional fixes:
- `GoException: no routes for location: caliday://workout/` → guard in RouterNotifier redirect
- `GoError: There is nothing to pop` → `context.canPop() ? context.pop() : context.go('/home')`

---

### 2026-03-05 — session 37 (Home Screen Widget: Flutter + Android + iOS)

**Implemented Home Screen Widget Small (2×2): Goro (idle/flex) + streak + SP. Tap → `caliday://workout`.**

**New dependencies:** `home_widget: ^0.9.0`, `app_links: ^6.4.1`

**New files:**
- `lib/core/services/widget_service.dart`
- `android/.../CaliDayWidgetReceiver.kt`
- `android/.../res/xml/caliday_widget_info.xml`
- `android/.../res/layout/caliday_widget_layout.xml`
- `android/.../res/drawable/ic_widget_fire.xml`, `ic_widget_bolt.xml`
- `ios/CaliDayWidget/CaliDayWidget.swift`
- PNG assets: goro_idle/flex in drawable-* and iOS xcassets

**Modified files:**
- `pubspec.yaml` — `home_widget`, `app_links`
- `lib/main.dart` — WidgetService.init() + AppLinks deep link stream
- `lib/features/workout/providers/workout_provider.dart` — WidgetService.update() after workout
- `android/.../AndroidManifest.xml` — deep link intent-filter, widget receiver
- `ios/Runner/Info.plist` — CFBundleURLTypes scheme `caliday`

iOS: requires manual setup in Xcode (Widget Extension target + App Group).

---

### 2026-03-04 — session 36 (info banner on Progress + emoji → Material Icons replacement)

**1.** Hint card at the top of the Progress tab: branches are optional.
**2.** Replaced emoji with Material Icons throughout the UI. `BranchId.icon` getter added to `enums.dart`.

**Modified files:** `l10n/app_ru.arb`, `l10n/app_en.arb`, `lib/data/models/enums.dart`,
`home_screen.dart`, `progress_screen.dart`, `branch_journey_screen.dart`,
`profile_screen.dart`, `achievements_screen.dart`, `summary_screen.dart`,
`workout_screen.dart`, `settings_screen.dart`

---

### 2026-03-04 — session 35 (Android haptics, timer, history, Home redesign)

**1. Haptics fix** — `VIBRATE` permission in AndroidManifest.

**2. Timer** — increased to 5 seconds (was 3). Tick when `timerSec ∈ [2..6]`, also for timed exercises.

**3. Workout history** — tiles became tappable; modal bottom sheet with details (exercises, reps).

**4. Home redesign** — `StatefulShellRoute.indexedStack`, 3 tabs: Workout / Progress / Profile.
Created `progress_screen.dart`. Home simplified to a hero block with Goro.

**Issue:** `profileDataProvider` (autoDispose) was not being invalidated with `indexedStack` — all tabs stay alive.
Fix: `_ref.invalidate(profileDataProvider)` added to `_finishWorkout()`.

**Modified files:**
- `android/.../AndroidManifest.xml` — VIBRATE
- `lib/features/workout/screens/workout_screen.dart`
- `lib/core/services/sound_service.dart`
- `lib/features/profile/screens/profile_screen.dart`
- `lib/core/router/app_router.dart` — StatefulShellRoute.indexedStack
- `lib/features/home/screens/progress_screen.dart` (new)
- `lib/features/home/screens/home_screen.dart`
- `lib/features/workout/providers/workout_provider.dart`
- `l10n/app_ru.arb`, `l10n/app_en.arb`

---

### 2026-03-03 — session 31 (Lottie animations for Push + progression refactor)

**Integrated Lottie animations for all 7 Push stages.**

**Push catalog aligned with assets:**
- Stage 5: Archer Pushup → **Wide Pushup** (`push_s5_wide_pushup`)
- Stage 6: One-Arm Pushup → **Archer Pushup** (`push_s6_archer_pushup`)

**New dependencies:** `lottie: ^3.3.2`
**New assets:** `assets/animations/` (7 JSON files)
**Model field:** `Exercise.animationPath: String?`

**Modified files:**
- `pubspec.yaml`, `lib/data/models/exercise.dart`
- `lib/data/static/exercise_catalog.dart` — Push s5/s6 + animationPath
- `lib/core/extensions/exercise_l10n.dart` — new IDs
- `l10n/app_ru.arb`, `l10n/app_en.arb`
- `lib/features/workout/screens/workout_screen.dart` — Lottie widget

---

### Early Sessions (summary, before session 30)

**Sessions 18-30** — implemented as part of v1.1 and v1.2:
- Achievements (27 total): `AchievementRepository`, `AchievementService`, `achievement_catalog.dart`, `AchievementsScreen`
- Bonus workouts: `WorkoutLog.isPrimary`, `@HiveField(5)`
- Dark theme: `themeProvider`, `UserProfile.themeModeName (@HiveField(14))`
- Goro expressions: `GoroExpressionProvider`, 6 SVG, `AnimatedSwitcher` on Home
- Skala (bull) on Challenge: `skala_neutral/approve.svg`, `_SkalaDisplay`, background `#5C1A1A`
- Challenge redesign: `challengeBranchProvider`, `generateChallenge()`, fail/success split
- Forced Challenge from BranchJourney: button on the current stage
- New branches: Pull (requiresEquipment), Legs, Balance; `activeBranches` computed getter
- Onboarding step 5 (pull-up bar), Settings: Pull branch toggle
- `displayStreakProvider` — computed on the fly without mutating Hive
- Streak loss notification (ID 4)
- Sound + haptics: `SoundService` singleton, `audioplayers ^6.1.0`, 4 assets
- `DeveloperOptionsScreen` (`/dev-options`, debug-only `kDebugMode`)
- `AboutScreen` (`/about`): `url_launcher ^6.3.0`, Goro idle v2
- `BranchJourneyScreen` (`/branch/:branchId`): stage timeline
- Android release build: `keep.xml` + `proguard-rules.pro` + `postFrameCallback` init
- Streak freezes: earned every 7 days, auto-spent on missing 1 day, cap=3
- L10n (RU + EN): ~145 keys
- `StatefulShellRoute.indexedStack`: bottom nav with 3 tabs