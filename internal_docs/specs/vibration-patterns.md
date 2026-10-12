# Vibration patterns of our own — open idea (2026-10-12)

> Part of the project notes — the index is [internal_docs/README.md](../README.md).

**Where it came from:** with the sounds of 0.9.6 the owner asked what the vibration does, whether it can be changed and whether the web vibrates.

**Today:** every cue has a haptic (`CueHaptic`: light / medium / heavy / selection / three heavy), following its own switch in any sound mode. Flutter's `HapticFeedback` has only these presets; on the web the engine maps them to `navigator.vibrate` (10 / 20 / 30 ms), which only Android Chrome supports.

**The idea:** a pattern per cue (length, strength, rhythm) — Core Haptics on iOS, vibration effects on Android — through a package (to be chosen and checked with Context7), with the same "all / key only / off" logic as the sounds.

**Declined, do not propose again:** haptics in Safari on iPhone through the hidden `<input type="checkbox" switch>` trick — since iOS 26.5 the switch ticks only under a real finger tap, so the timer-driven cues could never vibrate there.
