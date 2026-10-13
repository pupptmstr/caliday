# Decisions — why things are the way they are

> Part of the project notes — the index is [internal_docs/README.md](../README.md). One short record per decision: what, why, since when. The details live in the reference files and the changelog.

### Everything stays on the device (from the start)
No backend, no account, no analytics, free, no ads. The data is Hive (IndexedDB on the web). **Why:** privacy and zero running cost. **So:** "What's new" lists what the installed build contains, not newer store versions; Friends had to be peer-to-peer and was removed (below); the Telegram bot idea needs a server and is parked.

### Hive typeIds and fields never change (from the start)
A typeId or a field number, once released, is never reused or renumbered; retired ones are listed as retired. New enum values are appended. **Why:** stored boxes on users' devices must keep loading. — [data-hive.md](../reference/data-hive.md)

### Day arithmetic only through `calendar_days.dart` (2026-10-06)
**Why:** a local day is 23 or 25 hours on a DST change; `difference().inDays` and `Duration(days: n)` broke the streak, the heatmap and the calendar. Tests pin Berlin's DST dates.

### No promises of minutes (owner, 2026-10-07)
Workouts are Short / Standard / Full by volume; the only time shown is "≈ N min" estimated from the real plan at the user's pace; notifications promise no duration (a test). **Why:** "5 / 10 / 15 minutes" never matched the real time, which doubles as the user progresses.

### The workout is hands-free (owner, 2026-10-07)
Timed holds start after a get-ready countdown, sides switch by themselves, Pause is opt-in, every moment has a sound. **Why:** the user in position is not looking at the screen.

### A branch moves on once a day, in any workout (owner, 2026-10-07)
**Why:** two courses on one day must both progress; a branch shared by courses is one skill and moves once. SP and the streak keep "first workout of the day" rules.

### Courses share branches; own courses beside the Hive enums (owner, 2026-10-08 / 10-09)
A course is a set of branches with staged progression; courses may share exercises and whole branches. Own courses and branches are runtime types (`Branch`, `Course`) next to the enums. **Why:** no migration, and the built-in path keeps its data byte for byte.

### Goro is the face of the app, the hosts are the faces of their courses (owner, 2026-10-08)
The active course's host leads Home, the Profile and the summary; Goro keeps the icon, the onboarding welcome, notifications, the widgets, About and performs every exercise animation; Skala judges every challenge. **Why:** each course gets a character; the app keeps one.

### Every text comes from the ARB files — the widgets too (2026-10-07)
Native string resources follow the system language, the app has its own; so the app hands every text to the widgets. Only the widget-gallery names, shown before the app has run, are native (a table per language). Guards: no Cyrillic and no English literals in shown text outside an allow-list.

### Animations and characters are generated in code (owner, 2026-10-06)
"You are the designer": `tools/lottie`, `tools/characters`, `tools/sounds`. Edit the scripts, not the generated files. **Why:** the designer files have no source; scripts keep the style and can be redrawn.

### Friends removed (owner, 2026-10-11)
**Why:** without a server a one-off QR / Bluetooth swap of a snapshot added little and cost a lot (untested BLE, camera and Bluetooth permissions, a package with a licence ping). typeId 9 and UserProfile fields 17 / 23 are retired; the name the onboarding asks is used for the greeting instead.

### One branch per session, one version per branch, squash merges (owner, 2026-10-08 / 10-10)
Each session works on `session/<date>-<topic>` from `main`; the version is bumped once, with the first change the user sees; `main` gets one squash commit per branch when the owner says it is done (a ruleset enforces PRs, squash and green CI). **Why:** one "What's new" entry per batch of work, and `main` (which deploys the web build) only gets finished work.

### Project notes: a folder by topic, a changelog by version, English (owner, 2026-10-12)
**Why:** two files of 1100 and 2300 lines were hard to read for the owner and heavy to load at the start of every session. The session-by-session history was condensed; the original stays in git history.

### Desktop folders removed (2026-10-07)
`linux/`, `macos/`, `windows/` were an untouched `flutter create` template; `health` and `home_widget` have no desktop side anyway. `flutter create --platforms=… .` brings them back.

### Parked or declined, not to be proposed again
The Telegram Mini App + bot (owner, 2026-10-07: a thought on the side); iPhone Safari haptics through the hidden switch-checkbox (owner, 2026-10-12); the 90/90 and pigeon in profile view (unreadable — both were later drawn from other views); vibration patterns of our own per cue and Rex the streak monkey (owner, 2026-10-13: not worth it); a visit counter on the site, even a cookie-free one (owner, 2026-10-13: Google Search Console is the only view of the site's popularity — the site says "No tracking"); a redirect page from the old `/caliday/` address (owner, 2026-10-13).

### Web cues follow the iPhone's silent switch (owner, 2026-10-12)
In the browser the cues play through Web Audio, which on iOS keeps quiet with the silent switch on and mixes with the user's music. The other way (an audio session of type "playback") would sound through the switch but stop the music. **Why:** the owner chose to keep it so when the web sounds were fixed (0.9.8).

### The site speaks the app's languages and says "free", not "free forever" (owner, 2026-10-12)
Every language of the app has its page (`site/strings/<code>.json`); the site lists what the app is today — free, no ads, no account, no tracking — and makes no promise about the future.

### The source is open to read, all rights reserved (owner, 2026-10-12)
The repository is public, but `LICENSE` grants no right to use, copy, modify or distribute the code or the art without written permission — the same as the Terms of Use § 2. **Why:** the owner wants the project visible and the policies as written; an open-source license (GPL-3.0 was considered) would contradict the Terms.

### The app is called TreniDay (owner, 2026-10-13)
CaliDay became **TreniDay** ("treni", colloquial Russian for training sessions, and "day": a workout every day), written with a capital D; Goro stays the face. Renamed everywhere at once: the display name, the Dart package, the bundle / application ids, the App Group, the `treniday://` scheme, the widget kinds, the site, the legal pages, the notes and the repository. **Why:** the `caliday` domains are taken, and CALIDAY is filed as a US trademark in class 41 (fitness training belongs there) by another company; TreniDay was free everywhere it was checked. The ids changed too because nothing is in a store yet — after the first release they could not. — [specs/done/new-name.md](../specs/done/new-name.md)
