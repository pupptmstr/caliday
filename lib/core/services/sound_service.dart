import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

/// Plays short audio feedback and triggers haptic patterns during workouts.
///
/// Singleton — call [configure] whenever settings change.
/// All play methods are fire-and-forget: errors are silently swallowed so that
/// missing asset files (e.g. before the user places them) never crash the app.
class SoundService {
  SoundService._();
  static final SoundService instance = SoundService._();

  bool _soundEnabled = true;
  bool _hapticEnabled = true;

  final AudioPlayer _tickPlayer = AudioPlayer();
  final AudioPlayer _dingPlayer = AudioPlayer();
  final AudioPlayer _popPlayer = AudioPlayer();
  final AudioPlayer _completePlayer = AudioPlayer();

  /// Update sound/haptic preferences. Call from [SettingsNotifier] on change.
  void configure({required bool soundEnabled, required bool hapticEnabled}) {
    _soundEnabled = soundEnabled;
    _hapticEnabled = hapticEnabled;
  }

  /// Short tick — last 3 seconds of rest countdown.
  Future<void> tick() async {
    if (_hapticEnabled) unawaited(HapticFeedback.lightImpact());
    if (_soundEnabled) await _play(_tickPlayer, 'sounds/tick.mp3');
  }

  /// Ding — rest ends, next exercise begins.
  Future<void> ding() async {
    if (_hapticEnabled) unawaited(HapticFeedback.heavyImpact());
    if (_soundEnabled) await _play(_dingPlayer, 'sounds/ding.mp3');
  }

  /// Pop — set confirmed by the user.
  Future<void> pop() async {
    if (_hapticEnabled) unawaited(HapticFeedback.mediumImpact());
    if (_soundEnabled) await _play(_popPlayer, 'sounds/pop.mp3');
  }

  /// Complete — entire workout finished.
  Future<void> complete() async {
    if (_soundEnabled) unawaited(_play(_completePlayer, 'sounds/complete.mp3'));
    if (_hapticEnabled) {
      HapticFeedback.heavyImpact();
      await Future<void>.delayed(const Duration(milliseconds: 150));
      HapticFeedback.heavyImpact();
      await Future<void>.delayed(const Duration(milliseconds: 150));
      HapticFeedback.heavyImpact();
    }
  }

  Future<void> _play(AudioPlayer player, String asset) async {
    try {
      await player.stop();
      await player.play(AssetSource(asset));
    } catch (_) {
      // Asset missing or playback error — fail silently.
    }
  }
}
