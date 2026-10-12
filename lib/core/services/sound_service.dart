import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../data/models/enums.dart';
import 'web_cue_player.dart';

/// How a cue feels in the hand when haptics are on.
enum CueHaptic { none, selection, light, medium, heavy, triple }

/// A sound of the workout and its summary: one WAV in `assets/sounds`,
/// synthesised by `tools/sounds/gen_sounds.py` (listen with
/// `tools/sounds/build_preview.py`). Which moment plays which cue is decided
/// in `features/workout/workout_cues.dart`.
enum SoundCue {
  start('start', key: false, haptic: CueHaptic.medium),
  challengeStart('challenge_start', key: false, haptic: CueHaptic.heavy),
  tick('tick', key: false, haptic: CueHaptic.light),
  tickLast('tick_last', key: true, haptic: CueHaptic.medium),
  go('go', key: true, haptic: CueHaptic.heavy),
  holdHalf('hold_half', key: false, haptic: CueHaptic.light),
  tickHold('tick_hold', key: false, haptic: CueHaptic.light),
  switchSides('switch_sides', key: true, haptic: CueHaptic.medium),
  setDone('set_done', key: true, haptic: CueHaptic.medium),
  restOver('rest_over', key: true, haptic: CueHaptic.heavy),
  nextExercise('next_exercise', key: true, haptic: CueHaptic.heavy),
  skip('skip', key: false, haptic: CueHaptic.selection),
  pause('pause', key: false, haptic: CueHaptic.selection),
  resume('resume', key: false, haptic: CueHaptic.selection),
  complete('complete', key: true, haptic: CueHaptic.triple),
  challengePassed('challenge_passed', key: true, haptic: CueHaptic.triple),
  challengeFailed('challenge_failed', key: true, haptic: CueHaptic.medium),
  stageUp('stage_up', key: false, haptic: CueHaptic.light),
  achievement('achievement', key: false, haptic: CueHaptic.light),
  freezeEarned('freeze_earned', key: false, haptic: CueHaptic.light),
  freezeUsed('freeze_used', key: false, haptic: CueHaptic.light);

  const SoundCue(this.file, {required this.key, required this.haptic});

  /// The file name in `assets/sounds`, without `.wav`.
  final String file;

  /// Played in [SoundMode.key] too: what a user lying on the floor, not
  /// looking at the screen, needs to know — the hold starts and ends, the
  /// sides switch, the next set or exercise begins, the workout is over.
  final bool key;

  final CueHaptic haptic;

  /// The path [AssetSource] takes (relative to `assets/`).
  String get asset => 'sounds/$file.wav';

  /// The key of the file in the asset bundle (what the web build loads).
  String get bundleKey => 'assets/$asset';

  /// Whether [mode] plays this cue's sound (haptics follow their own switch).
  bool soundsIn(SoundMode mode) => switch (mode) {
        SoundMode.all => true,
        SoundMode.key => key,
        SoundMode.off => false,
      };
}

/// Plays the workout cues and their haptics.
///
/// Singleton — call [configure] whenever settings change. Playing is
/// fire-and-forget: errors are swallowed so a sound can never break a workout.
/// The web build plays the sounds through [WebCuePlayer] (Web Audio): iOS
/// Safari silenced audioplayers' cues that the timer starts.
class SoundService {
  SoundService._();
  static final SoundService instance = SoundService._();

  SoundMode _mode = SoundMode.all;
  bool _hapticEnabled = true;

  /// One player per cue, created on first use (or by [preload]).
  final Map<SoundCue, Future<AudioPlayer>> _players = {};

  /// Cues play over the user's music instead of taking the audio focus: with
  /// the default context a tick paused the music on Android and interrupted it
  /// on iOS. Web ignores audio contexts.
  static final AudioContext _mixWithMusic = AudioContextConfig(
    focus: AudioContextConfigFocus.mixWithOthers,
  ).build();

  /// Update sound/haptic preferences. Call from `SettingsNotifier` on change.
  void configure({required SoundMode mode, required bool hapticEnabled}) {
    _mode = mode;
    _hapticEnabled = hapticEnabled;
    if (kIsWeb) WebCuePlayer.instance.attach();
  }

  /// Gets every cue ready, so the first tick of a workout is not late.
  void preload() {
    if (_mode == SoundMode.off) return;
    if (kIsWeb) {
      WebCuePlayer.instance.preload([
        for (final cue in SoundCue.values)
          if (cue.soundsIn(_mode)) cue.bundleKey,
      ]);
      return;
    }
    for (final cue in SoundCue.values) {
      if (cue.soundsIn(_mode)) unawaited(_player(cue).then((_) {}, onError: (_) {}));
    }
  }

  /// Plays [cue]: its haptic when haptics are on, its sound when the sound
  /// mode includes it.
  Future<void> play(SoundCue cue) async {
    if (_hapticEnabled) unawaited(_haptic(cue.haptic));
    if (!cue.soundsIn(_mode)) return;
    if (kIsWeb) {
      WebCuePlayer.instance.play(cue.bundleKey);
      return;
    }
    try {
      final player = await _player(cue);
      // play() restarts a finished cue by itself; stop() first would reset
      // Android's MediaPlayer (~100–200 ms late).
      await player.play(AssetSource(cue.asset));
    } catch (_) {
      // Asset missing or playback error — fail silently, try anew next time.
      unawaited(_players.remove(cue)?.then((p) => p.dispose(), onError: (_) {}));
    }
  }

  /// A light tap for the rep counter's − / +: no sound (owner, 2026-10-12).
  void tap() {
    if (_hapticEnabled) unawaited(HapticFeedback.selectionClick());
  }

  Future<AudioPlayer> _player(SoundCue cue) => _players[cue] ??= _create(cue);

  Future<AudioPlayer> _create(SoundCue cue) async {
    final player = AudioPlayer();
    await player.setAudioContext(_mixWithMusic);
    await player.setSource(AssetSource(cue.asset));
    return player;
  }

  static Future<void> _haptic(CueHaptic haptic) async {
    switch (haptic) {
      case CueHaptic.none:
        return;
      case CueHaptic.selection:
        await HapticFeedback.selectionClick();
      case CueHaptic.light:
        await HapticFeedback.lightImpact();
      case CueHaptic.medium:
        await HapticFeedback.mediumImpact();
      case CueHaptic.heavy:
        await HapticFeedback.heavyImpact();
      case CueHaptic.triple:
        for (var i = 0; i < 3; i++) {
          if (i > 0) await Future<void>.delayed(const Duration(milliseconds: 150));
          await HapticFeedback.heavyImpact();
        }
    }
  }
}
