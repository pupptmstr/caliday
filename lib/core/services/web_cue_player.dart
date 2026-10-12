// The web build plays the workout cues through the Web Audio API
// (web_cue_player_web.dart); elsewhere SoundService keeps audioplayers and
// this is a stub that does nothing.
export 'web_cue_player_stub.dart'
    if (dart.library.js_interop) 'web_cue_player_web.dart';
