

import 'package:audioplayers/audioplayers.dart';

class AudioPlayerUtilBackGround {
  static AudioPlayer audioPlayer = AudioPlayer();
  static Future<void> stopSound() async {
    // audioCache.clearAll();
    // audioPlayer.pause(); // 暂停播放
    // audioPlayer.resume(); // 恢复播放
    audioPlayer.stop(); // 停止播放
    audioPlayer.release();
    audioPlayer.dispose();
  }
  static Future<void> playSound() async {
    audioPlayer.setReleaseMode(ReleaseMode.loop); // 设置循环模式
    audioPlayer.play(AssetSource('images/doudizhu3.mp3'));
  }

}

class AudioPlayerUtilFapai {
  static AudioPlayer audioPlayer = AudioPlayer();
  static Future<void> stopSound() async {
    // audioCache.clearAll();
    // audioPlayer.pause(); // 暂停播放
    // audioPlayer.resume(); // 恢复播放
    audioPlayer.stop(); // 停止播放
    audioPlayer.release();
    audioPlayer.dispose();
  }
  static Future<void> playSound() async {
    // audioPlayer.setReleaseMode(ReleaseMode.loop); // 设置循环模式
    audioPlayer.play(AssetSource('images/fapai.mp3'));
  }

}

