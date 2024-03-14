import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:xxc_flutter_utils/xxc_flutter_utils.dart';
import 'package:ima2_habeesjobs/service/ser_base.dart';
import 'package:ima2_habeesjobs/util/datetime.dart';
import 'package:ima2_habeesjobs/util/language.dart';
import 'package:image/image.dart' as img;
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

String getOnlineText(BuildContext context, bool isOnline, DateTime time) {
  if (true == isOnline) {
    return '在线';
  }
  if (null == time || 0 == time.millisecondsSinceEpoch) {
    return '不在线';
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
    showToast(context, '当前是最新版本');
  // }
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

toUpdate(BuildContext context){
  Clipboard.setData(ClipboardData(text: 'http://47.97.250.198'));
  if(Platform.isIOS){
    showToast(context, '下载链接已复制到剪切板，请在Safari浏览器中打开');
    // appLaunch(context, 'http://47.97.250.198');
  }else{
    showToast(context, '下载链接已复制到剪切板，请在浏览器中打开');
    Future.delayed(Duration(milliseconds: 1000),(){
      appLaunch(context, 'http://47.97.250.198');
    });
  }
}
