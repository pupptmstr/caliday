# Progress export and import — idea (owner, 2026-10-13)

> Part of the project notes — the index is [internal_docs/README.md](../README.md).

**The wish:** the progress is saved to a file that the user can export from the app and open in the app on another device — when moving to a new phone, or from the web version to the mobile app.

**Today:** everything lives in seven Hive boxes on the device ([data-hive.md § Hive boxes](../reference/data-hive.md)): the profile, skill progress, the workout log, achievements, own routines, branches and courses. Nothing leaves the device, and the web version keeps its data in the browser (IndexedDB of `pupptmstr.github.io`). Only two moves work already, and only partly: an iPhone restored from an iCloud / Finder backup brings the app's files, and Android's Auto Backup may restore them — neither covers web ↔ app, iOS ↔ Android or a phone set up as new.

**Options / design (open for the owner):**
- **Where:** Settings → a "Your data" section: "Save progress to a file" and "Load progress from a file".
- **Export:** one file (`treniday-progress-<date>.json`), handed to the share sheet on iOS / Android (save to Files, send to yourself) and downloaded in the browser.
- **Import:** pick the file → show what it holds (name, rank, SP, streak, workouts, date of the export) → confirm → it **replaces** the progress on this device. Merging two progresses is far harder (two streaks, two logs of the same days); replace-only first is the proposal — the owner decides.
- **"Saved to a file" automatically?** A periodic backup file on the device does not help a move by itself (it stays on the old phone) unless it goes to iCloud Drive / Google Drive — more work and permissions. Proposal: manual export first, a reminder to export later if wanted.

**Technical notes:**
- A versioned JSON format of our own (`formatVersion`, `appVersion`, `exportedAt`, then each box), written by explicit codecs per model — not the Hive binary files, so the format survives Hive field changes and works across platforms. The codecs are pure functions with round-trip tests (export → import → equal boxes).
- Import refuses a file from a newer format, validates before touching anything, and writes all boxes in one go (keep a copy of the old data until the write succeeds). After import: recompute what derives from the data (streak, rank decay, the widget snapshot, notifications via `scheduleAll()`), invalidate the providers.
- Dates: workout days are calendar days; store them as `yyyy-mm-dd`, not instants, so a move across time zones keeps the days (`calendar_days.dart`).
- Packages to check with Context7: the share sheet (`share_plus`), picking a file (`file_picker`), saving in the browser (a download link through `package:web`, or a package).
- What is not exported: Health data (it stays in Apple Health / Health Connect), notification permissions, the widget state.
- The privacy policy should mention that the file holds the user's progress and goes wherever the user sends it.

**Done when:** the owner exports the progress from the web version, opens the file in the app on a phone and sees the same rank, SP, streak, history and achievements.
