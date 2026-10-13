# Progress export and import, merged — idea (owner, 2026-10-13)

> Part of the project notes — the index is [internal_docs/README.md](../README.md).

**The wish:** the progress is saved to a file that the user can export from the app and open in the app on another device — when moving to a new phone, or from the web version to the mobile app. **Importing merges** the file into what the device already has (owner: "exactly a merge"), never replaces it: someone who trained on the web and on the phone ends up with both.

**Today:** everything lives in seven Hive boxes on the device ([data-hive.md § Hive boxes](../reference/data-hive.md)): the profile, skill progress, the workout log, achievements, own routines, branches and courses. Nothing leaves the device; the web version keeps its data in the browser (IndexedDB of `pupptmstr.github.io`). An iPhone restored from a backup or Android's Auto Backup bring the files along, but neither covers web ↔ app, iOS ↔ Android or a phone set up as new.

## Flow

- **Settings → "Your data":** "Save progress to a file" and "Add progress from a file".
- **Export:** the whole state as one file (`treniday-progress-<date>.json`) — the share sheet on iOS / Android (save to Files, send to yourself), a download in the browser.
- **Import:** pick the file → the app shows what the merge will change — "+12 workouts, +340 SP, rank Athlete → Champion, streak 9 → 14 days, 3 new achievements, Push moves to stage 5, 2 own branches" → confirm → merge → the new achievements are shown as earned.
- **Both devices equal:** merge A into B, then export from B and merge into A. Merging is idempotent, so a file imported twice, or a round trip A → B → A, adds nothing the second time.

## Merge rules (proposed; the open points are marked)

| Data | Rule |
|------|------|
| **Workout log** | Union. A workout is identified by its start (`WorkoutLog.date` to the millisecond) with its course and duration, so the same workout coming back is not added twice. Every log keeps the SP it earned. |
| **SP and rank** | SP only comes from workouts, and each log stores `spEarned`: SP = this device's SP + the SP of the logs that are new here (not Σ of all logs — older data or the debug screen's logs may not add up). The rank follows from SP (`RankExtension.fromSP`); the decay from the last workout of the merged log. |
| **Two "first workouts" on one day** | Each device gave its first workout of the day full SP. **Open (proposal: keep both as earned — nobody loses points).** The day counts once for the streak. |
| **Streak and freezes** | Recomputed by replaying the merged training days through `StreakService` (the first real workout of each day, freezes used and earned as the rules give them), never below either device's own current or longest streak. `longestStreak` = the largest of the replay and both stored values. |
| **Skill progress** | Per branch the one that is further along: stage first, then the step within the stage in the order `ProgressionService` takes them (amount → sets → rest → challenge) — a pure comparison function. `lastProgressedOn` = the later of the two, so a branch that moved today on either device does not move again today. |
| **Achievements** | Union, the earliest date of each; then the achievement checks run on the merged state (combined totals can unlock new ones). |
| **Own routines, branches, courses** | Union by id (ids are microsecond timestamps, unique across devices). The same id on both: this device's copy stays (`lastRunAt` = the later). Look-alike copies made separately on two devices stay as two; the user deletes one. |
| **Settings and profile** | This device's settings stay (theme, language, reminders, sounds, haptics, Health, pull-up bar, goal, workout size). The name comes from the file only if this device has none. Active courses: the union, so a course trained on the other device shows up; the selected course stays. `lastSeenReleaseVersion`: the newer. |
| **Health** | Imported workouts are not written to Apple Health / Health Connect. **Open:** offer it for workouts that came from the web (which has no Health)? |

## Technical notes

- A versioned JSON format of our own (`formatVersion`, `appVersion`, `exportedAt`, then each box), written by explicit codecs per model — not the Hive binary files, so the format survives Hive field changes and works across platforms. Workout days stay calendar days: the day of a log is derived with `calendar_days.dart` in the device's time zone, so the export stores the local date and time as recorded.
- The merge is a pure function `merge(local, imported, now) → (merged, summary)` with tests: round trip export → import → equal; idempotence (merge twice = merge once); same-day workouts on both sides; a streak joined across the two devices' days; skill progress ahead on either side; achievements unlocked only by the combined totals; own content with the same and different ids.
- Import refuses a file from a newer app version ("update the app first") and an unknown `formatVersion`; it validates everything before writing, and writes all boxes in one step with the old state kept until the write succeeds. After it: the widget snapshot, `scheduleAll()` for the notifications, the providers invalidated.
- Packages to check with Context7: the share sheet (`share_plus`), picking a file (`file_picker`), saving in the browser (a download through `package:web`, or a package).
- The privacy policy gets a line: the file holds the user's progress and goes wherever the user sends it.

**Done when:** the owner trains on the web and on a phone, exports from the web, adds the file on the phone and sees one history with both workouts, the SP of both, one streak over both devices' days, the further stage of each branch and every achievement — and adding the same file again changes nothing.
