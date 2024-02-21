import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_app_update/flutter_app_update_language.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  const MethodChannel channel = MethodChannel('flutter_app_update');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('language to json', () async {
    var file = File("assets/languages/en.json");
    if(!file.existsSync()){
      file.createSync();
    }
    var text = file.readAsStringSync();
    var map = json.decode(text);
    var language = FlutterAppUpdateLanguages.fromMap(map["data"]);
    var a = language.toMap();
    var b = FlutterAppUpdateLanguages().toMap();
    for (var key in a.keys) {
      a[key] ??= b[key];
    }
    map["data"] = a;
    text = json.encode(map);
    file.writeAsString(text);
  });
}
