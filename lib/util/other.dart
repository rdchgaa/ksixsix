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
import 'package:url_launcher/url_launcher.dart';

int getOsType() {
  if (Platform.isAndroid) {
    return 1;
  } else if (Platform.isIOS) {
    return 2;
  } else if (Platform.isWindows) {
    return 3;
  } else if (Platform.isMacOS) {
    return 5;
  }
  return 0;
}

String getTextPinyin(String initials) {
  initials = PinyinHelper.getShortPinyin(initials);
  if (initials?.isNotEmpty ?? false) {
    var temp = initials.substring(0, 1).toUpperCase();
    if (1 > 'A'.compareTo(temp) && -1 < 'Z'.compareTo(temp)) {
      return temp;
    }
  }
  return "#";
}

String getOnlineText(BuildContext context, bool isOnline, DateTime time) {
  if (true == isOnline) {
    return Languages.of(context).onlineText;
  }
  if (null == time || 0 == time.millisecondsSinceEpoch) {
    return Languages.of(context).notOnlineText;
  }
  return context.read<SerBase>().toLocalTime(time)?.format("yyyy/MM/dd HH:mm") ?? "";
}

Future<void> hideTextInput() async {
  await SystemChannels.textInput.invokeMethod('TextInput.hide');
}

Future<void> showTextInput() async {
  await SystemChannels.textInput.invokeMethod('TextInput.show');
}

Future<ui.Image> thumbnail(ui.Image image, {double width = 400, double height = 400}) async {
  if (image.width <= width && image.height <= height) {
    return image;
  }
  var temp = (width / image.width) < (height / image.height) ? (width / image.width) : (height / image.height);
  width = temp * image.width;
  height = temp * image.height;

  var recorder = ui.PictureRecorder();
  var canvas = ui.Canvas(recorder, ui.Rect.fromLTRB(0, 0, width, height));

  canvas.translate(width / 2, height / 2);
  canvas.scale(temp);
  canvas.drawImage(image, ui.Offset(-image.width / 2, -image.height / 2), ui.Paint());

  ui.Picture picture = recorder.endRecording();
  return picture.toImage(width.toInt(), height.toInt());
}

class DecodeParam {
  final List<int> image;
  final SendPort sendPort;
  final int quality;
  final int width;
  final int height;

  DecodeParam(
    this.image,
    this.width,
    this.height,
    this.sendPort,
    this.quality,
  );
}

void decodeIsolate(DecodeParam param) {
  var image = img.Image.fromBytes(param.width, param.height, param.image, format: img.Format.rgba);
  param.sendPort.send(img.encodeJpg(image, quality: param.quality));
}

Future<List<int>> encodeJpg(ui.Image image, {int quality = 80}) async {
  var receivePort = ReceivePort();
  var data = (await image.toByteData()).buffer.asUint8List();
  await Isolate.spawn<DecodeParam>(decodeIsolate, DecodeParam(data, image.width, image.height, receivePort.sendPort, quality));
  return await receivePort.first as List<int>;
}

Future<ui.Image> loadImage(BuildContext context, ImageProvider _image) {
  final ImageStream stream = _image.resolve(createLocalImageConfiguration(context));
  var listener;
  var completer = Completer<ui.Image>.sync();
  listener = ImageStreamListener((image, synchronousCall) {
    stream.removeListener(listener);
    completer.complete(image.image);
  }, onError: (exception, stackTrace) {
    stream.removeListener(listener);
    completer.completeError(exception, stackTrace);
  });
  stream.addListener(listener);
  return completer.future;
}

bool isPc(BuildContext context) {
  return 680 < MediaQuery.of(context).size.width;
}

onVersionUpdate(BuildContext context) async {
  // var version = await Api().version.appGetNewVersionInfo(AppGetNewVersionInfoReq());
  // if (null == version) {
  //   showToast(context, Languages.of(context).versionTips);
  //   return;
  // }
  // var value = await FlutterAppUpdate.checkVersion(
  //   context,
  //   name: version.info.name,
  //   code: version.info.maxCode,
  //   minCode: version.info.minCode,
  //   content: version.info.content,
  //   url: version.info.fileUrl,
  // );

  // if (true == value) {
  //   return;
  // } else if (false == value) {
    showToast(context, Languages.of(context).versionTips);
  // }
}

String formatContactTime(BuildContext context, DateTime dateTime) {
  if (null == dateTime) {
    return "";
  }
  var now = DateTime.now();

  if (dateTime.isToDay(now)) {
    return dateTime.format(Languages.of(context).pageChatTime);
  }
  return dateTime.format(Languages.of(context).pageChatDate);
}



String genderToString(BuildContext context, Gender gender) {
  if (gender == Gender.MALE) {
    return Languages.of(context).maleText;
  } else if (gender == Gender.FEMALE) {
    return Languages.of(context).female;
  } else if (gender == Gender.UNKNOWN) {
    return Languages.of(context).unknownText;
  }
  return null;
}

enum Gender{
  MALE,
  FEMALE,
  UNKNOWN
}

Future<void> appLaunch(BuildContext context, String url, { String title}) async {
  var theUri = Uri.parse(url);
  launch(url);
  // if (mode != null) {
  //   launchUrl(theUri, mode: mode);
  //   return;
  // }
}
