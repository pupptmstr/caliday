/// The cue player of the web build. Off the web [SoundService] plays the cues
/// with audioplayers, so nothing here is ever called.
class WebCuePlayer {
  WebCuePlayer._();
  static final WebCuePlayer instance = WebCuePlayer._();

  void attach() {}

  void preload(Iterable<String> assetKeys) {}

  void play(String assetKey) {}
}
