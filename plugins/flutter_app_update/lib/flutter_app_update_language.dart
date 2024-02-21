import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class FlutterAppUpdateLanguages {
  static const LocalizationsDelegate<FlutterAppUpdateLanguages> delegate = _AppLocalizationsDelegate();

  final String findNewVersionText;

  static final _language = FlutterAppUpdateLanguages();

  final String updateContentText;

  final String newVersionNumberText;

  final String skipText;

  final String updateText;

  final String getPermissionTipText;

  final String updateFailTipText;

  static FlutterAppUpdateLanguages of(BuildContext context) {
    var ret = Localizations.of<FlutterAppUpdateLanguages>(context, FlutterAppUpdateLanguages);
    return ret ?? _language;
  }

  FlutterAppUpdateLanguages({this.findNewVersionText = "发现新版本",
  this.updateContentText = "更新内容：",
  this.newVersionNumberText = "最新版本号{number}",
  this.skipText = "暂不",
  this.updateText = "更新",
  this.getPermissionTipText = "需要同意保存权限!",
  this.updateFailTipText = "更新失败，请稍后再试!",
  });

  factory FlutterAppUpdateLanguages.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return FlutterAppUpdateLanguages(
      findNewVersionText: map['findNewVersionText']?.toString(),
      updateContentText: map['updateContentText']?.toString(),
      newVersionNumberText: map['newVersionNumberText']?.toString(),
      skipText: map['skipText']?.toString(),
      updateText: map['updateText']?.toString(),
      getPermissionTipText: map['getPermissionTipText']?.toString(),
      updateFailTipText: map['updateFailTipText']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'findNewVersionText': findNewVersionText,
      'updateContentText': updateContentText,
      'newVersionNumberText': newVersionNumberText,
      'skipText': skipText,
      'updateText': updateText,
      'getPermissionTipText': getPermissionTipText,
      'updateFailTipText': updateFailTipText,
    };
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<FlutterAppUpdateLanguages> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => kMaterialSupportedLanguages.contains(locale.languageCode);

  @override
  Future<FlutterAppUpdateLanguages> load(Locale locale) {
    return rootBundle.loadString("packages/flutter_app_update/assets/languages/${locale.languageCode}.json").then((value) {
      return FlutterAppUpdateLanguages.fromMap(json.decode(value)["data"]);
    }, onError: (e) {
      return FlutterAppUpdateLanguages();
    });
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;

  @override
  String toString() => 'FlutterAppUpdateLanguages.delegate(zh)';
}
