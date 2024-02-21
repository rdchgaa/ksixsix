import 'dart:async';

import 'package:ima2_habeesjobs/dao/dao_user.dart';
import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ManageDao {
  static Database _database;

  static void init() async {
    var version = 7;

    String path = (await getApplicationDocumentsDirectory()).path;
    _database ??= await openDatabase(
      join(path, 'baseFlutterDemo/${getUserId().toString()}.db'),
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      version: version,
    );
    DaoUser.init(_database);
  }

  static void close() async {
    DaoUser.close();
    await _database?.close();
    _database = null;
  }

  static FutureOr<void> _onCreate(Database db, int version) {
    DaoUser.onCreate(db, version);
  }

  static FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) {
    DaoUser.onUpgrade(db, oldVersion, newVersion);
  }
}

class Sql {
  StringBuffer _text;

  List<dynamic> _list = [];

  Sql(String text) {
    _text = StringBuffer(text)..write(" ");
  }

  List<dynamic> get param => _list;

  String get sql => _text.toString();

  Sql a(String text) {
    _text
      ..write(text)
      ..write(" ");
    return this;
  }

  Sql p(dynamic param) {
    _text.write("? ");
    _list.add(_data(param));
    return this;
  }

  Sql l(List<dynamic> list, [String separator = ","]) {
    for (int i = 0; i < list.length; i++) {
      if (0 != i) {
        _text
          ..write(separator)
          ..write(" ");
      }
      _text.write("? ");
      _list.add(_data(list[i]));
    }
    return this;
  }

  dynamic _data(dynamic val) {
    if (val is bool) {
      return val ? 1 : 0;
    }
    return val;
  }

  @override
  String toString() {
    var ret = _text.toString();
    for (var i = 0; i < _list.length; i++) {
      ret = ret.replaceFirst("?", "'${_list[i]}'");
    }
    return ret;
  }
}
