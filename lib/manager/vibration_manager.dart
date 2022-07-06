
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class VibrationManager {
  static const _longVibrationTime = 800;

  final AudioCache _audioCache;
  AudioPlayer _playing;

  VibrationManager():
      _audioCache = AudioCache(
        prefix: "sounds/",
        respectSilence: true
      ) {
    _audioCache.load("finish_bigdsc.mp3");
  }

  Future<void> finish() {
    _audioCache.play("finish_bigdsc.mp3");
    return null;
  }

  void playSingle() {
    Vibration.vibrate(duration: _longVibrationTime);
  }

  void cancel() {
    Vibration.cancel();
    _playing?.stop();
    _playing = null;
  }
}