import 'dart:async';

import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';


class SoundpoolUtilBackGround3 {
  static bool _isPlayed = true;
  static Soundpool soundpool = Soundpool(streamType: StreamType.notification);

  static Future<void> stopSound() async {
    await soundpool.release();
    _isPlayed = false;
  }

  static Future<void> playSound() async {
    int soundId = await rootBundle
        .load('assets/images/doudizhu3.mp3')
        .then(((ByteData soundDate) {
      return soundpool.load(soundDate);
    }));
    soundpool.setVolume(volume: 0.5);
    _isPlayed=true;
    await soundpool.play(soundId).then((value) => {

    });
  }

  static Future<void> playSoundTurn() async {
    //文件86秒
    int soundId = await rootBundle
        .load('assets/images/doudizhu3.mp3')
        .then(((ByteData soundDate) {
      return soundpool.load(soundDate);
    }));
    soundpool.setVolume(volume: 0.5);
    _isPlayed=true;
    await soundpool.play(soundId).then((value) {
      // playSoundTurn();
    });
    Future.delayed(Duration(seconds: 10),() async{
      await stopSound();
      if(_isPlayed==true){
        playSoundTurn();
      }
    });
  }

}

class SoundpoolUtilFapai {
  static bool _isPlayed = true;
  static Soundpool soundpool = Soundpool(streamType: StreamType.notification);

  static Future<void> stopSound() async {
    soundpool.release();
    _isPlayed = false;
  }

  static Future<void> playSound() async {
    int soundId = await rootBundle
        .load('assets/images/fapai.mp3')
        .then(((ByteData soundDate) {
      return soundpool.load(soundDate);
    }));
    soundpool.setVolume(volume: 0.9);
    _isPlayed=true;
    await soundpool.play(soundId).then((value) => {

    });
  }

  static Future<void> playSoundTurn() async {
    //文件33秒
    int soundId = await rootBundle
        .load('assets/images/fapai.mp3')
        .then(((ByteData soundDate) {
      return soundpool.load(soundDate);
    }));
    soundpool.setVolume(volume: 0.5);
    _isPlayed=true;
    await soundpool.play(soundId).then((value) {
      // playSoundTurn();
    });
    Future.delayed(Duration(seconds: 40),(){
      if(_isPlayed==true){
        playSoundTurn();
      }
    });
  }

}