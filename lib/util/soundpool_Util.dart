import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui' as ui;

import 'package:ima2_habeesjobs/net/api.dart';

import 'package:ima2_habeesjobs/service/ser_base.dart';
import 'package:ima2_habeesjobs/util/datetime.dart';
import 'package:ima2_habeesjobs/util/language.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_update/flutter_app_update.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';
import 'package:image/image.dart' as img;
import 'package:lpinyin/lpinyin.dart';
import 'package:provider/src/provider.dart';
import 'package:soundpool/soundpool.dart';

class SoundpoolUtil {
  static Soundpool soundpool = Soundpool(streamType: StreamType.notification);

  static Future<void> playSound() async {
    int soundId = await rootBundle
        .load('assets/images/test1.mp3')
        .then(((ByteData soundDate) {
      return soundpool.load(soundDate);
    }));
    soundpool.setVolume(volume: 0.5);
    await soundpool.play(soundId).then((value) => {

    });
  }

  static Future<void> playSoundTurn() async {
    int soundId = await rootBundle
        .load('assets/images/test1.mp3')
        .then(((ByteData soundDate) {
      return soundpool.load(soundDate);
    }));
    soundpool.setVolume(volume: 0.5);
    await soundpool.play(soundId).then((value) {
      playSoundTurn();
    });
  }

}


class SoundpoolUtil2 {
  static Soundpool soundpool = Soundpool(streamType: StreamType.notification);

  static Future<void> playSound() async {
    int soundId = await rootBundle
        .load('assets/images/test1.mp3')
        .then(((ByteData soundDate) {
      return soundpool.load(soundDate);
    }));
    soundpool.setVolume(volume: 0.5);
    await soundpool.play(soundId).then((value) => {

    });
  }

  static Future<void> playSoundTurn() async {
    int soundId = await rootBundle
        .load('assets/images/test1.mp3')
        .then(((ByteData soundDate) {
      return soundpool.load(soundDate);
    }));
    soundpool.setVolume(volume: 0.5);
    await soundpool.play(soundId).then((value) {
      playSoundTurn();
    });
  }

}