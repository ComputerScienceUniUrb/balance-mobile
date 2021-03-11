
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
    _audioCache.load("light_pop_bigdsc.mp3");
    _audioCache.load("finish_bigdsc.mp3");
  }

  Future<void> measuring() async{
    _playing = await _audioCache.play("light_pop_bigdsc.mp3");
    return null;
  }

  Future<void> finish() async{
    _playing = await _audioCache.play("finish_bigdsc.mp3");
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