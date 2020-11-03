
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class VibrationManager {
  static const _vibrationPattern = [0, 300, 700, 300, 700, 300, 700, 300, 700, 300, 700, 300, 700];
  static const _longVibrationTime = 800;
  final AudioCache _audioCache;
  AudioPlayer _playing;

  VibrationManager():
      _audioCache = AudioCache(
        prefix: "sounds/",
        respectSilence: true
      ) {
    _audioCache.load("light_pop.mp3");
  }

  Future<void> playPattern() async{
    _playing = await _audioCache.play("light_pop.mp3");
    Vibration.vibrate(pattern: _vibrationPattern);
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