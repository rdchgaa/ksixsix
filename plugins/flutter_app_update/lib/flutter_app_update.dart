// You have generated a new plugin project without
// specifying the `--platforms` flag. A plugin project supports no platforms is generated.
// To add platforms, run `flutter create -t plugin --platforms <platforms> .` under the same
// directory. You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_update/flutter_app_update_language.dart';
import 'package:flutter_app_update/toast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class FlutterAppUpdate {
  static const MethodChannel _channel = const MethodChannel('flutter_app_update');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> checkVersion(
    BuildContext context, {
    String name,
    int code,
    int minCode,
    String content,
    String url,
  }) async {
    var info = await PackageInfo.fromPlatform();
    int number = int.parse(info.buildNumber.isEmpty ? "0" : info.buildNumber);

    if (number < (code ?? 0)) {
      return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            child: _ShowDialog(
              url: url,
              number: number,
              content: content,
              minCode: minCode,
              name: name,
            ),
            onWillPop: () async => false,
          );
        },
      );
    }
    return false;
  }

  static Future<bool> installApp(String path) async {
    return await _channel.invokeMethod("installApp", path);
  }
}

class _ShowDialog extends StatefulWidget {
  final String url;

  final int number;

  final int minCode;

  final String content;

  final String name;

  const _ShowDialog({
    Key key,
    this.url,
    this.number,
    this.minCode,
    this.content,
    this.name,
  }) : super(key: key);

  @override
  __ShowDialogState createState() => __ShowDialogState();
}

class __ShowDialogState extends State<_ShowDialog> {
  double _currentProgress;

  @override
  Widget build(BuildContext context) {
    var versiontStyle = TextStyle(fontSize: 16, color: Color(0xff007171));
    var contentStyle = TextStyle(fontSize: 16, color: Colors.white);
    final size = MediaQuery.of(context).size;
    var bixHeight = size.height - 300;
    return Center(
      child: SizedBox(
        width: 300,
        // height: bixHeight,
        child: Material(
          color: Color(0x00000000),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                image: AssetImage("assets/new_icons/version_bg.png"),
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff009595),
                  Color(0xff0D5B5B),
                ],
              ),
              // image: new DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/new_icons/icon_update_bg.png')),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      FlutterAppUpdateLanguages.of(context).findNewVersionText,
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 27),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 19),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          color: Color(0xffb1dcdc),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                          child: Text(FlutterAppUpdateLanguages.of(context).newVersionNumberText.replaceAll("{number}", widget.name), style: versiontStyle),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          FlutterAppUpdateLanguages.of(context).updateContentText,
                          style: contentStyle,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          minHeight: 50,
                          maxHeight: 200,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: SingleChildScrollView(
                            child: Text(
                              widget.content,
                              style: contentStyle,
                            ),
                          ),
                        ),
                      ),
                      if (null != _currentProgress)
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            child: LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF8B226)),
                              backgroundColor: Color(0xFFFFF3D9),
                              value: _currentProgress,
                              minHeight: 8,
                            ),
                          ),
                        ),
                      if (null != _currentProgress) Center(child: Text('${(_currentProgress * 100).toStringAsFixed(2)}%', style: contentStyle)),
                      if (null == _currentProgress)
                        Padding(
                          padding: const EdgeInsets.only(top: 17),
                          child: ButtonTheme(
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              // crossAxisAlignment: CrossAxisAlignment.,
                              children: [
                                if (widget.number >= widget.minCode)
                                  TextButton(
                                    child: Text(
                                      FlutterAppUpdateLanguages.of(context).skipText,
                                      style: TextStyle(color: Color(0xffD6D6D6), fontSize: 16),
                                    ),
                                    style: ButtonStyle(
                                        // shape: MaterialStateProperty.all(BorderS)
                                        minimumSize: MaterialStateProperty.all(Size(100, 32)),
                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                        side: MaterialStateProperty.all(BorderSide(
                                          color: Color(0xffD6D6D6),
                                          width: 1,
                                          style: BorderStyle.solid,
                                        ))),
                                    onPressed: ()=>Navigator.of(context).pop(),
                                  ),

                                TextButton(
                                  child: Text(
                                    FlutterAppUpdateLanguages.of(context).updateText,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ButtonStyle(
                                    // shape: MaterialStateProperty.all(BorderS)
                                      minimumSize: MaterialStateProperty.all(Size(100, 32)),
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                      backgroundColor:MaterialStateProperty.all(Color(0xFFF8B226)),
                                      side: MaterialStateProperty.all(BorderSide(
                                        color: Color(0xFFF8B226),
                                        width: 1,
                                        style: BorderStyle.solid,
                                      )),
                                  ),
                                  onPressed: () => _onUpdate(context),
                                  ),
                                // RaisedButton(
                                //   child: Text(
                                //     FlutterAppUpdateLanguages.of(context).updateText,
                                //     style: TextStyle(color: Colors.white),
                                //   ),
                                //   shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(20),
                                //     // side: BorderSide(
                                //     //   width: 1,
                                //     //   color: Color(0xFFF8B226),
                                //     //   style: BorderStyle.solid,
                                //     // ),
                                //   ),
                                //   color: Color(0xFFF8B226),
                                //   onPressed: () => _onUpdate(context),
                                // ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onUpdate(BuildContext context) async {
    try {
      if (Platform.isAndroid) {
        Directory directory = await getTemporaryDirectory();
        String savePath = directory.path + "/Chat Me_app_${widget.name}.apk";
        if (await Permission.storage.isDenied) {
          if ((await Permission.storage.request()).isDenied) {
            showToast(context, FlutterAppUpdateLanguages.of(context).getPermissionTipText);
            return;
          }
        }
        setState(() {
          _currentProgress = 0;
        });
        await _downloadAndInstall(savePath);
      } else if (Platform.isWindows) {
        Directory directory = await getDownloadsDirectory();
        String savePath = directory.path + "/Chat Me_${widget.name}.exe";
        await _downloadAndInstall(savePath);
      } else if (Platform.isIOS) {
        await launch(widget.url);
        exit(0);
      } else if (Platform.isMacOS) {
        Directory directory = await getDownloadsDirectory();
        String savePath = directory.path + "/Chat Me_${widget.name}.dmg";
        await _downloadAndInstall(savePath);
      }
      Navigator.of(context).pop(true);
    } catch (e) {
      _currentProgress = null;
      showToast(context, FlutterAppUpdateLanguages.of(context).updateFailTipText);
      setState(() {
        _currentProgress = null;
      });
      rethrow;
    }
  }

  Future<void> _downloadAndInstall(String savePath) async {
    await Dio().download(widget.url, savePath, onReceiveProgress: (count, total) {
      setState(() {
        _currentProgress = count / total;
      });
    });
    if (Platform.isAndroid) {
      FlutterAppUpdate.installApp(savePath);
    } else if (Platform.isWindows) {
      await launch(savePath);
      exit(0);
    } else if (Platform.isMacOS) {
      await launch(savePath);
      exit(0);
    }
  }
}
