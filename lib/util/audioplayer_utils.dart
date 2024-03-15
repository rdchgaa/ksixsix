

import 'package:audioplayers/audioplayers.dart';

class AudioPlayerUtilBackGround {
  static AudioPlayer audioPlayer = AudioPlayer();
  static Future<void> stopSound() async {
    // audioCache.clearAll();
    audioPlayer.pause(); // 暂停播放
    // audioPlayer.resume(); // 恢复播放
    audioPlayer.stop(); // 停止播放
    audioPlayer.release();
    audioPlayer.dispose();
  }
  static Future<void> playSound() async {
    audioPlayer.setReleaseMode(ReleaseMode.loop); // 设置循环模式
    audioPlayer.play(AssetSource('images/mp3_xinzhishouweizhe.mp3'));
  }

}


class AudioPlayerUtilFapai {
  static AudioPlayer audioPlayer = AudioPlayer();
  static Future<void> stopSound() async {
    audioPlayer.stop(); // 停止播放
    audioPlayer.release();
    audioPlayer.dispose();
  }
  static Future<void> playSound() async {
    audioPlayer.setVolume(1);
    audioPlayer.play(AssetSource('images/mp3_fapai.mp3'));
  }

}


class AudioPlayerUtilZuoqiu {
  static AudioPlayer audioPlayer = AudioPlayer();
  static Future<void> stopSound() async {
    audioPlayer.stop(); // 停止播放
    audioPlayer.release();
    audioPlayer.dispose();
  }
  static Future<void> playSound() async {
    audioPlayer.setVolume(1);
    audioPlayer.play(AssetSource('images/mp3_zuoqiu.mp3'));
  }

}

class AudioPlayerUtilTaikong {
  static AudioPlayer audioPlayer = AudioPlayer();
  static Future<void> stopSound() async {
    audioPlayer.stop(); // 停止播放
    audioPlayer.release();
    audioPlayer.dispose();
  }
  static Future<void> playSound() async {
    audioPlayer.setVolume(1);
    audioPlayer.play(AssetSource('images/mp3_taikong.mp3'));
  }

}


class AudioPlayerUtilKeji {
  static AudioPlayer audioPlayer = AudioPlayer();
  static Future<void> stopSound() async {
    audioPlayer.stop(); // 停止播放
    audioPlayer.release();
    audioPlayer.dispose();
  }
  static Future<void> playSound() async {
    audioPlayer.setVolume(1);
    audioPlayer.play(AssetSource('images/mp3_keji.mp3'));
  }
}

class AudioPlayerUtilJinshu {
  static AudioPlayer audioPlayer = AudioPlayer();
  static Future<void> stopSound() async {
    audioPlayer.stop(); // 停止播放
    audioPlayer.release();
    audioPlayer.dispose();
  }
  static Future<void> playSound() async {
    audioPlayer.setVolume(1);
    audioPlayer.play(AssetSource('images/mp3_jinshu.mp3'));
  }
}

class AudioPlayerUtilDalian {
  static AudioPlayer audioPlayer = AudioPlayer();
  static Future<void> stopSound() async {
    audioPlayer.stop(); // 停止播放
    audioPlayer.release();
    audioPlayer.dispose();
  }
  static Future<void> playSound() async {
    audioPlayer.setVolume(1);
    audioPlayer.play(AssetSource('images/mp3_dalian.mp3'));
  }
}


class AudioPlayerUtilChe {
  static AudioPlayer audioPlayer = AudioPlayer();
  static Future<void> stopSound() async {
    audioPlayer.stop(); // 停止播放
    audioPlayer.release();
    audioPlayer.dispose();
  }
  static Future<void> playSound() async {
    audioPlayer.setVolume(1);
    audioPlayer.play(AssetSource('images/mp3_che.mp3'));
  }
}

class AudioPlayerUtilBoli {
  static AudioPlayer audioPlayer = AudioPlayer();
  static Future<void> stopSound() async {
    audioPlayer.stop(); // 停止播放
    audioPlayer.release();
    audioPlayer.dispose();
  }
  static Future<void> playSound() async {
    audioPlayer.setVolume(1);
    audioPlayer.play(AssetSource('images/mp3_boli.mp3'));
  }
}