import 'dart:convert';

import 'package:fixnum/fixnum.dart';

import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'manage_dao.dart';

class DaoUser {
  static Database _database;

  static void init(Database database) {
    DaoUser._database = database;
  }

  static void onCreate(Database db, int version) async {
    await db.execute(
      '''CREATE TABLE user (
            id INTEGER PRIMARY KEY,
            userId INTEGER, 
            lastLoginTime INTEGER, 
            headImgUrl Text, 
            signature Text, 
            nickName Text, 
            username Text, 
            registeTime INTEGER, 
            staff INTEGER, 
            sex INTEGER, 
            avatarUrl Text, 
            phone Text,
            setting Text
            )''',
    );

    await db.execute(
      '''
          CREATE UNIQUE INDEX object ON user(userId)
      ''',
    );
  }

  static Future<void> set( info,) async {
    // Sql sql = new Sql("REPLACE INTO user(userId,lastLoginTime,headImgUrl,signature,nickName,username,registeTime,sex,avatarUrl,phone,setting,staff)")
    //   ..a("VALUES(")
      // ..p(info.userId.toInt()).a(",")
      // ..p(info.lastLoginTime).a(",")
      // ..p(info.avatar).a(",")
      // ..p(info.signature).a(",")
      // ..p(info.name).a(",")
      // ..p(info.userName).a(",")
      // ..p(info.registerTime).a(",")
      // ..p(info.gender==null?'':info.gender.value).a(",")
      // ..p(info.avatar).a(",")
      // ..p(info.mobile).a(",")
      // // ..p(json.encode(setting.toMap())).a(",")
      // ..p(true == info.isWaiter ? 1 : 0).a("")
      // ..a(")");
    // await _database.execute(sql.sql, sql.param);
  }

  static Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (7 > oldVersion) {
      await db.execute('alter table friends add isStaff integer default false not null;');
    }
  }

  static Future get() async {
    List<Map> maps = await _database?.query(
      "user",
      limit: 1,
    );
    if (maps.isEmpty) {
      return null;
    }
    return maps[0];
    // return AppUserInitInfoReps(
    //   info: ExtUserInfo.fromMap(maps[0]),
    //   setting: UserSettings.fromMap(json.decode(maps[0]["setting"])),
    // );
  }

  static close() async {
    await _database?.close();
    _database = null;
  }
}
