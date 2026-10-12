import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;

/// Plays the workout cues in the browser through one Web Audio context.
///
/// audioplayers plays each cue through an `<audio>` element of its own (with
/// an AudioContext each) and makes the element anew after every play. iOS
/// Safari lets such an element sound only when it starts inside a tap, so on
/// an iPhone every cue the workout's timer plays (the ticks, "go", "switch
/// sides", "rest is over") stayed silent and only the tapped ones (Pause,
/// Skip) were heard. Here every cue is decoded once into a buffer and played
/// on a single context: the first tap anywhere in the app unlocks it, a later
/// tap resumes it if the browser suspended it, and from then on the timer can
/// play cues at will — at once, and over each other if they meet.
///
/// Web Audio on iOS follows the silent switch and mixes with the user's music
/// (the "ambient" audio session).
class WebCuePlayer {
  WebCuePlayer._();
  static final WebCuePlayer instance = WebCuePlayer._();

  web.AudioContext? _context;
  final Map<String, Future<web.AudioBuffer?>> _buffers = {};
  bool _attached = false;

  /// Starts listening for the user's taps, which unlock the audio. Call it
  /// early (the app does it when the settings load), so the tap that starts a
  /// workout already counts.
  void attach() {
    if (_attached) return;
    _attached = true;
    final listener = _unlock.toJS;
    final options = web.AddEventListenerOptions(capture: true, passive: true);
    for (final type in const ['pointerdown', 'touchend', 'click', 'keydown']) {
      web.document.addEventListener(type, listener, options);
    }
  }

  /// Decodes the cues ahead, so the first tick of a workout is not late.
  void preload(Iterable<String> assetKeys) {
    for (final key in assetKeys) {
      unawaited(_buffer(key));
    }
  }

  /// Plays the cue at [assetKey] (a key of the asset bundle). Errors are
  /// swallowed: a sound can never break a workout.
  void play(String assetKey) => unawaited(_play(assetKey));

  web.AudioContext get _ctx => _context ??= web.AudioContext();

  /// Runs inside the user's gesture, synchronously: a resume and a silent
  /// sample started there are what iOS takes as the page's right to sound.
  void _unlock(web.Event _) {
    final context = _ctx;
    if (context.state == 'running') return;
    context.resume().toDart.ignore();
    final silence = context.createBufferSource()
      ..buffer = context.createBuffer(1, 1, 22050);
    silence.connect(context.destination);
    silence.start();
  }

  Future<void> _play(String assetKey) async {
    final buffer = await _buffer(assetKey);
    if (buffer == null) return;
    final context = _ctx;
    // Chrome resumes after any earlier tap on the page; iOS only in a tap,
    // where _unlock has done it already.
    if (context.state != 'running') context.resume().toDart.ignore();
    final source = context.createBufferSource()..buffer = buffer;
    source.connect(context.destination);
    source.start();
  }

  Future<web.AudioBuffer?> _buffer(String assetKey) =>
      _buffers[assetKey] ??= _decode(assetKey);

  Future<web.AudioBuffer?> _decode(String assetKey) async {
    try {
      final data = await rootBundle.load(assetKey);
      // decodeAudioData takes the buffer over (detaches it): give it a copy.
      final bytes = Uint8List.fromList(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
      return await _ctx.decodeAudioData(bytes.buffer.toJS).toDart;
    } catch (_) {
      // Try anew next time.
      unawaited(_buffers.remove(assetKey));
      return null;
    }
  }
}
