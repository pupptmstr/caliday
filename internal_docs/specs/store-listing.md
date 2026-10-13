# Store listings — App Store and Google Play (2026-10-13)

> Part of the project notes — the index is [internal_docs/README.md](../README.md).

**The goal (owner):** have both listings ready before the developer accounts exist, so that once they do, only the upload is left. **State:** the texts, the forms' answers and the screenshot plan are ready for the owner's review; German and Spanish are drafts for the native proofreading (like the app's and the site's). Some native settings must change before the first upload — § [Before the first upload](#before-the-first-upload).

## What is in the repository

```
fastlane/metadata/
├── en-US/ ru/ de-DE/ es-ES/          App Store, one folder per language (fastlane deliver)
│   name, subtitle, promotional_text, description, keywords, release_notes,
│   support_url, marketing_url, privacy_url (.txt)
├── copyright.txt, primary_category.txt
├── review_information/notes.txt       the notes for App Review (English)
└── android/en-US/ ru-RU/ de-DE/ es-ES/   Google Play (fastlane supply)
    title, short_description, full_description (.txt), changelogs/default.txt
```

- **The limits are checked by `python3 tools/store/check_listing.py`** — run it after every edit. It counts the App Store keywords in UTF-8 bytes (App Store Connect does: 100 bytes hold about 50 Cyrillic letters), and it also checks the owner's rules below, the keyword rules (no spaces around commas, more than two characters, no word already in the name or subtitle), that each store's text names only its own platform, and that no file has a trailing newline (deliver strips the files, supply sends them as they are).
- **Upload** (once the accounts exist, from the repository root):
  `fastlane deliver --app_identifier com.pupptmstr.treniday --skip_binary_upload --skip_screenshots` (an App Store Connect API key, the same as the release CI's) and
  `fastlane supply --package_name com.pupptmstr.treniday --metadata_path fastlane/metadata/android --skip_upload_apk --skip_upload_aab` (a Play service-account key). Neither needs a Fastfile.
- **Release notes:** App Store Connect has no "What's New" for an app's first version; deliver skips `release_notes.txt` then by itself. From 1.0.1 on, the files hold the version's notes (the "What's new" text of the ARB files, shortened). On Google Play `changelogs/default.txt` is used for any version code without a `changelogs/<versionCode>.txt` (≤ 500 characters).
- **Store locales:** App Store `en-US`, `ru`, `de-DE`, `es-ES`; Play `en-US`, `ru-RU`, `de-DE`, `es-ES`. English is the primary language of both listings. Latin American Spanish (`es-MX`, Play `es-419`) can take a copy of the Spanish folder later.

## The listing

| | App Store | Google Play |
|---|---|---|
| Name / title (≤ 30) | TreniDay: Home Workouts · TreniDay: тренировки дома · TreniDay: Workout zu Hause · TreniDay: Ejercicio en casa | the same |
| Subtitle (≤ 30) / short description (≤ 80) | Calisthenics, yoga, stretching · Калистеника, йога, растяжка · Calisthenics, Yoga, Dehnen · Calistenia, yoga, estiramiento | "Bodyweight home workouts that feel like a game, with Goro the gorilla." and its translations |
| Category | Health & Fitness (`HEALTH_AND_FITNESS`); no secondary | Health & Fitness; tags: home workout, bodyweight training, yoga, stretching (the closest Play offers) |
| Price | Free, no in-app purchases | Free, no in-app products, no ads |
| Marketing URL / website | `https://pupptmstr.github.io/treniday/` (`ru/`, `de/`, `es/` per language) | the same |
| Support URL | the same page + `#faq` — its last question gives the email (Apple: the support URL must lead to contact information); added in this branch | contact email `kurnyakov.petr@gmail.com` (Play shows it publicly) |
| Privacy policy | `https://pupptmstr.github.io/treniday/PRIVACY_POLICY` (English only, every language) | the same; it must be the policy Health Connect shows too |
| Terms | `…/TERMS_OF_USE` — linked from the description (no EULA field needed: the standard Apple EULA applies) | linked from the description |
| Copyright | `2026 TreniDay` — the owner may put their name instead | — |

**Rules the texts keep** (owner): workouts named by volume (Short / Standard / Full), never by minutes — the time is only "an honest estimate of today's plan"; "free", "no ads", "no tracking", never "free forever"; Goro is the face (first line of every text), the course hosts and Skala appear by name; everything stays on the device. **Rules of the stores:** no price words in a name, subtitle, title or keywords (Apple 2.3.7, Play's metadata policy — so "free" and "no ads" are only in the descriptions and the promotional text); the iOS texts never name Android, Google or Health Connect, the Play texts never name the iPhone, Apple Health or the lock screen (Apple 2.3.10); no competitors' names in the keywords; the HealthKit use is said in the description (Apple 2.5.1). Numbers that grow with updates are rounded down ("over 150 exercises"); 45 achievements, six ranks and five courses are exact today — update them with the app.

## App Store Connect

### App Privacy → "Data Not Collected"

Apple counts data as *collected* when it is transmitted off the device. TreniDay transmits nothing, so the answer to "Do you or your third-party partners collect data from this app?" is **No**, and the product page shows "Data Not Collected". Checked against the code on 2026-10-13:

| What | Where it lives | Leaves the device? |
|---|---|---|
| Name (optional), progress, workouts, settings, own courses | Hive boxes in the app's sandbox | No |
| Apple Health: a workout (Traditional Strength Training, its start, end and an energy estimate) is written; the body weight is read | `core/services/health_service.dart`, called from `workout_provider.dart` after a workout, only when the user turned it on; the weight is read at that moment for the calorie estimate and not stored | No — HealthKit is on the device |
| Widgets | the App Group's `UserDefaults` (`home_widget`), read by the widget extension | No |
| Reminders | local notifications (`flutter_local_notifications`), no push token | No |
| Links | `about_screen.dart`: `mailto:`, the privacy policy and the terms, opened in Mail / Safari | Only what the user opens |
| Network code | none in `lib/` (no `http`, sockets or `*.network` loaders); `http` in `pubspec.lock` comes with `lottie` for network animations the app does not use — every animation is an asset | — |
| SDKs | no analytics, crash reporting, ads or attribution SDKs (`pubspec.yaml`) | — |

Tracking (ATT): **No** — no `NSUserTrackingUsageDescription`, no IDFA.

### Age rating questionnaire (the 2025 version)

| Section | Item | Answer |
|---|---|---|
| In-app controls | Parental controls; Age assurance | No; No |
| Capabilities | Unrestricted web access | No (links open Safari; there is no browser in the app) |
| | User-generated content; Social media; Messaging and chat | No; No; No (own courses stay on the device) |
| | Advertising | No |
| Mature themes | Profanity or crude humor; Horror / fear; Alcohol, tobacco or drugs | None; None; None |
| Medical or wellness | Medical or treatment information | None (exercise programmes, no diagnosis or treatment) |
| | Health or wellness topics | **Yes** — exercise recommendations and a calorie estimate |
| Sexuality or nudity | all three | None |
| Violence | cartoon / fantasy, realistic, prolonged, guns | None (Skala the bull only judges a challenge) |
| Chance-based | Gambling; Simulated gambling; Contests; Loot boxes | No; None; None (challenges and ranks are the user's own goals, nobody else competes); No |

**Result: 9+** — "Health or wellness topics" alone puts an app at 9+ in the new system (4+ in the old one). Made for kids: No.

### Export compliance

TreniDay contains no encryption of its own and makes no network connections; only the operating system's encryption is present. Answer "None of the algorithms mentioned above" / "No", and set **`ITSAppUsesNonExemptEncryption` = `false`** in `ios/Runner/Info.plist` (not there yet — § Before the first upload) so App Store Connect stops asking for every build. No documentation or French declaration is needed.

### Other App Store Connect answers

- **Content rights:** the app contains no third-party content (the animations, characters and sounds are made by the project's own generators).
- **App Review information:** sign-in required — No; the notes are `fastlane/metadata/review_information/notes.txt` (no account, where the Health switch is, what is written and read, the hands-free workout, the widgets); contact name, phone and email — the owner fills them in (deliver uploads only the notes).
- **HealthKit:** the capability and `Runner.entitlements` are in place; Health is off by default and opt-in in the onboarding and Settings → Health; the description says what is saved; nothing goes to iCloud. The purpose strings must be in English and localized first (§ Before the first upload).
- **EU Digital Services Act:** App Store Connect asks every developer for a trader status before the app can appear in the EU. A free app with no monetisation may declare "not a trader"; a trader's address, phone and email are shown on the product page. The owner's choice.
- **Availability:** all countries and regions (the owner may restrict). **Pricing:** Free.

## Google Play Console

### Data safety

- "Does your app collect or share any of the required user data types?" — **No.** Play's definitions: *collect* = transmitted off the device (nothing is); data processed only on the device need not be disclosed (the body weight read for the calorie estimate). Writing the workout to Health Connect is a transfer to another app on the device, which Play counts as *sharing* unless it follows a specific user action or a prominent disclosure with consent — here the user turns on "Record workouts" in Settings → Health and grants the Health Connect permissions in the system dialog, so it is exempt. The listing then shows "No data collected" and "No data shared with third parties".
- If the reviewer disagrees, the conservative answer is: Health and fitness → Fitness info → *shared*, purpose "App functionality", optional, user-initiated; nothing collected.
- With "No", the questions on encryption in transit and data deletion are not asked. There are no accounts, so the account-deletion requirement does not apply ("My app does not allow users to create an account").

### Health apps declaration and Health Connect

App content → **Health apps**: health features — **Activity and fitness** (nothing else). Then a justification per Health Connect data type, exactly the three the manifest declares:

- **Exercise (write)** — `WRITE_EXERCISE`: "TreniDay is a home workout app. When the user finishes a workout, and only if they turned on 'Record workouts' in Settings → Health, the app writes one exercise session (strength training) with its start and end time to Health Connect, so that their bodyweight workouts appear with the rest of their activity. Nothing is read back, and nothing leaves the device."
- **Total calories burned (write)** — `WRITE_TOTAL_CALORIES_BURNED`: "With the same exercise session the app writes an estimate of the energy it burned (MET 5.5 × body weight × duration), so the workout counts toward the user's daily energy in Health Connect. Written only when 'Record workouts' is on."
- **Weight (read)** — `READ_WEIGHT`: "Only if the user also turns on 'Read body weight', the app reads the most recent weight of the last 90 days at the end of a workout to make that calorie estimate more accurate (70 kg is used otherwise). The value is used for that one calculation and is not stored or sent anywhere."

Requirements to keep: request no other data types; the privacy policy in the Play listing is the one Health Connect shows; when the user opens TreniDay's privacy policy from Health Connect the app must show it (§ Before the first upload — today the permission-usage intent only opens Home). Re-submit the declaration whenever a data type is added or dropped.

### Content rating (IARC questionnaire)

Category: the one for utility / productivity / other apps (not Game: the game elements serve the workouts). Violence, fear, sexuality, language, controlled substances, crude humour, gambling: **No** to all. Users interact or exchange content: **No**. Shares the user's location: **No**. Digital purchases: **No**. Unrestricted internet access: **No**. Expected: IARC 3+, PEGI 3, USK 0, ESRB Everyone.

### Other App content answers

| Form | Answer |
|---|---|
| Privacy policy | `https://pupptmstr.github.io/treniday/PRIVACY_POLICY` |
| App access | All functionality is available without special access (no login) |
| Ads | No, the app contains no ads |
| Target audience | 13–15, 16–17, 18 and over — not under 13, as the privacy policy says (§ 6). "Could the store listing unintentionally appeal to children?" — cartoon animals make this a judgment call: answer No and explain that it is a fitness programme for teens and adults; if Google decides otherwise, the Families policy is easy to meet (no ads, no data) but the privacy policy would need a children's section |
| News app; Government app; Financial features | No; No; None |
| Advertising ID | No. Before the first upload check the merged manifest of the release build (`bundletool dump manifest --bundle app-release.aab \| grep AD_ID`) — no plugin should add `com.google.android.gms.permission.AD_ID` |
| Exact alarms | must not be declared: see § Before the first upload |

**Testing first:** a new personal Play account must run a closed test with at least 12 testers for 14 days before production access (STATUS § Waiting for the owner).

## Before the first upload

Native settings, not app logic — one follow-up branch, after the owner's decisions:

1. **iOS Health purpose strings are Russian only** (`NSHealthShareUsageDescription`, `NSHealthUpdateUsageDescription` in `Info.plist`). App Review reads them on an English device; they need English as the base and an `InfoPlist.strings` per app language (the widget gallery texts already follow the system language the same way).
2. **`ITSAppUsesNonExemptEncryption` = `false`** in `ios/Runner/Info.plist` (§ Export compliance).
3. **Privacy manifest** (`PrivacyInfo.xcprivacy`) for the app and the widget extension: the extension reads the App Group's `UserDefaults` (`WidgetState.swift`), a required-reason API — reason `1C8F.1`; no tracking, no collected data types. Without it App Store Connect answers the upload with ITMS-91053. The plugins bring their own manifests; Xcode's archive → "Generate Privacy Report" shows the whole app.
4. **Android: drop `USE_EXACT_ALARM`.** Play allows it only for alarm-clock and calendar apps. `NotificationService` already falls back to inexact alarms when exact ones are not allowed, and `SCHEDULE_EXACT_ALARM` can stay (denied by default on Android 14+, so reminders become inexact — fine for a morning reminder).
5. **Android: show the privacy policy from Health Connect.** The `ViewPermissionUsageActivity` alias (Android 14+) opens Home; Android 13 and lower need the `androidx.health.ACTION_SHOW_PERMISSIONS_RATIONALE` intent filter too. Both should lead to the privacy policy (a deep link that opens it).
6. **iPad — the owner decides.** The project builds for iPhone and iPad (`TARGETED_DEVICE_FAMILY = "1,2"`). Checked 2026-10-13 in the iPad Pro 13-inch simulator: the app runs full screen with the phone layout stretched to the whole width (the onboarding's button runs from edge to edge). An app that supports iPad needs 13-inch iPad screenshots and is reviewed on an iPad, and **a later version cannot drop iPad support, while one can add it** — so the safe path for 1.0 is iPhone only (`TARGETED_DEVICE_FAMILY = 1`; iPads still run it in the iPhone window), with iPad support later together with a wide layout (a centred column like the web build's `_WebFrame`). If the owner keeps iPad for 1.0, that layout comes first and the screenshot plan gets the iPad set.

## Screenshot plan

**Sizes.** App Store: iPhone 6.9" **1320 × 2868** portrait (the iPhone 17 Pro Max simulator; App Store Connect scales the set down for the smaller iPhones), up to 10, PNG or JPEG without transparency; iPad 13" 2064 × 2752 only if iPad stays (§ above). Google Play: phone screenshots 2–8, PNG or JPEG, the long side at most twice the short one — **1080 × 1920** (the emulator's 1080 × 2400 is 20:9 and too long, so the framed images are composed at 9:16); plus the **feature graphic 1024 × 500** (the same art as the site's og cards, `tools/site/make_og.py` with another size) and the **icon 512 × 512** (`assets/icon/icon.png` scaled down). Tablet screenshots are optional on Play.

**What they look like.** Each image: the caption on top in two short lines on the brand-blue gradient (`#4DA6FF` → `#1A5FA8`, the Challenge one on Skala's dark red `#5C1A1A`), the real screen below in a plain rounded frame — the style of the site's first screen. Light theme except the workout (dark on purpose — it shows the animation best) and the Challenge. Status bar at 9:41 with full bars (`xcrun simctl status_bar <device> override --time 9:41 --batteryState charged --batteryLevel 100 --cellularBars 4 --wifiBars 3`; Android: SystemUI demo mode). The same eight in every language, the app switched to that language in Settings.

| # | Screen and state | en | ru | de | es |
|---|---|---|---|---|---|
| 1 | **Home** before the day's workout: Goro happy, his line, the 12-day streak, the plan unfolded on the button | Home workouts that feel like a game | Домашние тренировки, которые затягивают, как игра | Heimtraining, das sich wie ein Spiel anfühlt | Entrenar en casa como en un juego |
| 2 | **Workout**: a timed hold running (Plank), Goro's animation, the ring | Goro shows every move — hands-free | Горо показывает каждое движение — экран можно не трогать | Goro zeigt jede Bewegung — ganz ohne Tippen | Goro te muestra cada movimiento, sin tocar la pantalla |
| 3 | **Branch Journey** of Push at stage 4: the ladder from the wall push-up up to the handstand push-up | From a wall push-up to a handstand | От отжиманий от стены до стойки на руках | Vom Wand-Liegestütz zum Handstand | De la flexión en la pared a la parada de manos |
| 4 | **Courses** tab: the five courses with their hosts | Five courses, five hosts | Пять курсов, пять ведущих | Fünf Kurse, fünf Gastgeber | Cinco cursos, cinco anfitriones |
| 5 | **Challenge** with Skala: the norm and his look | Pass Skala's challenge, unlock the next stage | Пройди испытание Скалы — и вперёд, на новый этап | Schaff Skalas Challenge, und die nächste Stufe wartet | Supera el reto de Skala y sube de etapa |
| 6 | **Summary** after a workout: SP, the streak flame, a new achievement | Streaks, ranks and 45 achievements | Серии, ранги и 45 достижений | Serien, Ränge und 45 Erfolge | Rachas, rangos y 45 logros |
| 7 | **Widgets**: iOS — the home screen with Today (medium) and Goro, plus the lock screen; Android — the home screen with Today (4×2) and Goro | Goro on your Home Screen (Play: home screen) | Горо на экране «Домой» (Play: на главном экране) | Goro auf dem Home-Bildschirm (Play: Startbildschirm) | Goro en tu pantalla de inicio |
| 8 | **Calendar** with a month of workouts (the heatmap) | No ads. No account. Your progress stays with you. | Без рекламы и регистрации. Прогресс остаётся у тебя. | Ohne Werbung, ohne Konto. Dein Fortschritt bleibt bei dir. | Sin anuncios ni cuenta. Tu progreso se queda contigo. |

No "free" in the images (both stores frown on price claims in the graphics); no minutes anywhere — the plan on Home shows the app's own "≈ N min" estimate, which is the real thing and allowed.

**How to make them.** (A debug build: the developer options exist only there, and `main.dart` hides the debug banner.)
1. Build and install: `flutter build ios --simulator --debug`, install on the **iPhone 17 Pro Max** simulator (`xcrun simctl install`); Android: `flutter build apk --debug` on the `Medium_Phone_API_37.0` emulator.
2. Onboarding: language, no name (the greeting stays neutral), Calisthenics, the push-up test with a middle answer; notifications allowed, Health skipped.
3. Settings → the developer options: streak 12, last workout yesterday, SP ≈ 2400 (Athlete), two freezes; Push at stage 4 with reps and sets mid-way; "Add workout on date…" for about 20 days of the last month (the calendar heatmap); Pull at the challenge point for screenshot 5.
4. Screens 1, 3, 4 and 8 as they are; 2: start the workout and take the shot during a hold; 5: Home → the open challenge; 6: finish a Short workout; 7: add the widgets on the simulator's home and lock screens (see `reference/platform.md` § Home-screen widgets).
5. Raw shots: `xcrun simctl io booted screenshot <n>.png` (1320 × 2868 on the Pro Max), `adb exec-out screencap -p > <n>.png`.
6. Compose the captions and frames with a small script (headless Chrome, like `tools/characters/export_widget_art.py`) into `fastlane/screenshots/<locale>/` (deliver) and `fastlane/metadata/android/<locale>/images/phoneScreenshots/` (supply) — not written yet; then upload without `--skip_screenshots`.
7. Switch the language in Settings and repeat 4–6 (the seeded state stays).

**Not done yet:** the screenshots themselves, the compose script, the feature graphic.

## Upload checklist (once the accounts exist)

1. The native follow-up of § Before the first upload, merged; the iPad decision taken.
2. App Store Connect: create the app (bundle id `com.pupptmstr.treniday`, SKU `treniday`, primary language English (U.S.)); App Privacy, age rating, DSA status, pricing and availability as above.
3. `fastlane deliver` (texts) → screenshots → the first build from the release CI (TestFlight) → submit with the review notes.
4. Play Console: create the app (default language en-US, App, Free), App content forms as above, `fastlane supply` (texts) → images → the closed test with 12 testers for 14 days → production.
5. Replace the "coming soon" store links on the site with the real ones (the Apple badge only once the app is live).
