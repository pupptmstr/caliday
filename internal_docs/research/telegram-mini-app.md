# Telegram Mini App + bot — parked idea

> Part of the project notes — the index is [internal_docs/README.md](../README.md).

## Telegram Mini App + bot — parked idea (researched 2026-10-07)

> **Parked.** The owner asked to keep this as a thought on the side and not to consider it seriously for now. Nothing here is planned or scheduled; the research is kept so that it is not done twice. Do not propose it as a next step unless the owner brings it up.

### Concept
Open the existing web build (`https://pupptmstr.github.io/treniday/app/`) as a **Telegram Mini App**, and let a **bot** send the reminders that the native app schedules locally. The owner's questions: can the app also be a Telegram bot, with notifications sent by the bot and everything else opening as a Mini App? **Yes, in two parts of very different cost:** the Mini App is cheap (the web build already runs the whole app), the bot reminders need a server, which the app has deliberately never had.

### What the documentation says (core.telegram.org, read 2026-10-07; Bot API 10.1 of June 2026 was the latest)
- **A Mini App is a web page in Telegram's WebView** (iOS, Android, desktop, web), registered with @BotFather (menu button, "Main Mini App" with a Launch button on the bot profile, or a direct link `t.me/<bot>/<short_name>?startapp=<param>&mode=compact|fullscreen`). The page loads `https://telegram.org/js/telegram-web-app.js` and gets `window.Telegram.WebApp`. GitHub Pages already serves the app over HTTPS.
- **`startapp` is limited to 64 base64url characters** (api/links). Our compact friend payload (`FriendQrCodec` v2) is about 40 characters before the name, which leaves room for a name of roughly 18 Latin or 9 Cyrillic letters — so a friend link works for short names only; longer needs a server-side short code or a name-less format. (Estimate, to be measured.)
- **Identity:** `initData` carries the user (id, username, language, Premium flag…) signed with an HMAC-SHA-256 keyed by the bot token. It **must be validated on a server**; `initDataUnsafe` on the client is for personalisation only.
- **Storage:** CloudStorage (Bot API 6.9: 1024 items per user, a value of 0–4096 characters, synced across the user's devices), DeviceStorage (9.0: 5 MB per user), SecureStorage (9.0: 10 items). **Not one of them can be read by the bot's server**, so reminders cannot be driven from them. Hive on the web is IndexedDB, which the WebView may drop; CloudStorage is the sensible backup.
- **UI hooks the web build lacks:** `HapticFeedback` (6.1), `BackButton` / `MainButton`, `safeAreaInset` / `contentSafeAreaInset` and `requestFullscreen` (8.0), `enableClosingConfirmation`, `themeParams`, `showScanQrPopup` (6.4; a native scanner instead of the web camera), `openTelegramLink`, `switchInlineQuery`, `shareToStory`, `addToHomeScreen`. `disableVerticalSwipes` (7.7, per the community docs) is needed because a swipe down collapses the Mini App — a problem for a scrolling Flutter canvas.
- **Bots cannot write first:** a user has to press Start before the bot may message them (otherwise `403 Forbidden: bot can't initiate conversation with a user`). Limits: about one message per second to one chat, about 30 per second in bulk. A bot has **no scheduler of its own**, and Telegram gives it **no timezone or local time** of the user (the Mini App can read the zone from the browser and send it).
- **Digital goods inside Telegram must be paid with Stars (XTR)**; a bot has to answer `pre_checkout_query` within 10 s and deliver only after `successful_payment`. That fits the "Support the author" idea, and again needs a server.
- A Dart wrapper exists, `dartway_telegram` 0.3.0 (published October 2026, 132 downloads, 0 likes): it wraps only safe-area, platform, user id, fullscreen / vertical swipes / expand. Too thin and too young to depend on; a small own bridge with `dart:js_interop` (check Context7 before writing it) for haptics, CloudStorage, theme, back button, scan and share is the plan.

### What the app already gives and what it costs (measured)
- The web build runs workouts, progression, SP, streaks, achievements, library, search, custom routines, sound, friends by QR. Already guarded with `kIsWeb`: no BLE, notifications, Health, widget (see `internal_docs/reference/platform.md` § Web Build).
- **First load is about 4.2 MB compressed** (`main.dart.js` 1.27 MB + `canvaskit.wasm` 2.9 MB), animations load lazily. Acceptable on Wi-Fi, to be checked on a mobile network and a low-end Android.
- `_WebFrame` (a 480 px column on wide windows) must switch off inside Telegram, whose viewport is already phone-sized.

### The decisions this needs from the owner
1. **Two separate worlds.** The native app's data (Hive on the phone) and the Mini App's data (IndexedDB / CloudStorage inside Telegram) do not sync. Joining them needs accounts and a server. Recommended: accept two worlds for now; the Mini App is a second *channel*.
2. **Reminders need a small opt-in server** (the app has "no backend" as a principle). What it would hold per user: the chat id, the time zone, the language and the schedule below; the Privacy Policy and Terms (`docs/`) must say so. Recommended design: **the client computes the schedule, the server only fires it.** The Dart `NotificationPlanner` already turns the profile and `now` into `PlannedNotification`s; the Mini App uploads that list (authenticated by `initData`) every time it would call `scheduleAll()` today (a finished workout, a settings change), and the server sends the due ones. The rules (streak at risk, evening reminder cancelled by a workout, rank at risk) stay in one place, in Dart and under test, not copied into a second language.
3. **Where the server lives.** A Cloudflare Worker with D1 and a Cron Trigger fits "free": Workers Free is 100,000 requests a day with a 10 ms CPU limit per invocation, 5 Cron Triggers, D1 5 GB / 5 million reads / 100,000 writes a day (Cloudflare docs, page of 2026-10-02). **The catch: 50 subrequests per invocation on Free**, and each `sendMessage` is one, so a single minute can notify about 50 users; enough for a beta, beyond it the paid plan or spreading the sends over several runs. Alternatives not looked at: a small VPS, Supabase, Firebase.
4. **Storage accounts are not needed for this channel.** A Mini App needs no Apple or Google account, which are what currently blocks the v1.0 release; it can reach users before the stores do (discovery without marketing is the open question).

### Technical Tasks (proposed order)
| # | Task |
|---|------|
| 0 | **Spike, no code:** make a test bot with @BotFather, set its menu button to the Pages URL, open it in Telegram on an iPhone and an Android. Look at: load time, text input and the keyboard (name field, routine builder, search), scrolling and the swipe-down collapse, sound (autoplay), the camera, whether data survives closing the Mini App. Answers every "unverified" below before any code is written |
| 1 | Mini App shell: the JS bridge (`ready`, `expand`, `disableVerticalSwipes`, safe area, theme, haptics, back button), no `_WebFrame` inside Telegram, CloudStorage backup of the Hive state (values are limited to 4096 characters: chunk or shard by month), `showScanQrPopup` for friends, a `startapp` friend link for short names |
| 2 | Bot and server: webhook (`/start` as the opt-in, `/stop`), `POST /schedule` with `initData` validation, the Cron Trigger that fires due messages, the Privacy Policy and Terms updated, the settings screen of the Mini App (reminders on / off, time) |
| 3 | Optional: Stars for "Support the author" (needs the same server), listing in the Mini App directory |

### Unverified (do not assume)
Flutter web text input and keyboard inside Telegram's WebView; audio autoplay there; whether the WebView keeps IndexedDB between sessions; behaviour on a low-end Android; the real length of a friend link; whether 50 messages a minute is enough for the first users; Telegram's current rules for Mini Apps (the terms were read through a summary only; read the original before launch).

### When to tackle
Not planned (parked by the owner, 2026-10-07). If it is ever picked up, start with the spike (task 0): an hour, no code, and it answers every item under "Unverified" before anything is built.

Sources: <https://core.telegram.org/bots/webapps>, <https://core.telegram.org/api/links>, <https://core.telegram.org/bots/faq>, <https://core.telegram.org/bots/payments-stars>, <https://developers.cloudflare.com/workers/platform/limits/>, <https://developers.cloudflare.com/workers/platform/pricing/>, <https://pub.dev/packages/dartway_telegram>.
