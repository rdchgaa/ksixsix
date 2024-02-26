import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';
import 'package:ima2_habeesjobs/net/dio_util.dart';
import 'package:ima2_habeesjobs/service/preferences.dart';

class NetWork {

  static toLogin(BuildContext context,String account,String password) async{
    var res = await DioUtils.instance.getRequest(Method.post, 'login',
      queryParameters: {
        "account":account, // 账号
        "password": password, // 密码
      },
      options: null,
    );
    if(res!=null){
      var value = json.decode(res.data);
      if(value['code']==0){
        var data = value['data'];
        showToast(context, data['tip']);

        if(data['user_id']!=null&&(data['token']!=null&&data['token']!=""))
          return data;
      }else{
        showToast(context, '登录失败，请稍后再试');
      }
    }
    return null;
  }
  static toRegister(BuildContext context,String account,String password,String nick_name,) async{
    var res = await DioUtils.instance.getRequest(Method.post, 'register',
      queryParameters: {
        "account":account, // 账号
        "password": password, // 密码
        "nick_name": nick_name // 玩家昵称
      },
      options: null,
    );
    if(res!=null){
      var value = json.decode(res.data);
      if(value['code']==0){
        var data = value['data'];
        showToast(context, data['tip']);

        if(data['user_id']!=null&&(data['token']!=null&&data['token']!=""))
        return data;
      }else{
        showToast(context, '注册失败，请稍后再试');
      }
    }
    return null;
  }

  static getUserInfo(BuildContext context,int user_id,) async{
    var res = await DioUtils.instance.getRequest(Method.get, 'user/'+user_id.toString(),
      options: Options(headers: {'token':getToken()}),
    );
    if(res!=null){
      var value = json.decode(res.data);
      if(value['code']==0){
        var data = value['data'];
        // showToast(context, data['tip']);

        if(data['user_id']!=null)
          return data;
      }else{
        showToast(context, '用户信息获取失败，请稍后再试');
      }
    }
    return null;
  }




  //创建房间  userId
  static getCreatRoom(BuildContext context,int userId,) async{
    var res = await DioUtils.instance.getRequest(Method.get, 'room/new/'+userId.toString(),
      options: Options(headers: {'token':getToken()}),
    );
    if(res!=null){
      var value = json.decode(res.data);
      if(value['code']==0){
        var data = value['data'];
        // showToast(context, data['tip']);

        if(data['room_Id']!=null)
          return data;
      }else{
        // showToast(context, '获取房间信息失败，请稍后再试');
      }
    }
    return null;
  }



  //加入房间  user_id  room_id
  static getJoinRoom(BuildContext context,int userId,int roomId,) async{
    var res = await DioUtils.instance.getRequest(Method.get, 'room/join/',
      queryParameters: {
        "user_id":userId, // 账号
        "room_id": roomId, // 密码
      },
      options: Options(headers: {'token':getToken()}),
    );
    if(res!=null){
      var value = json.decode(res.data);
      if(value['code']==0){
        var data = value['data'];
        // showToast(context, data['tip']);

        if(data['room_Id']!=null)
          return data;
      }else if(value['code']==1){
        var data = value['data'];
        showToast(context, data);
        // showToast(context, '房间不存在');
      }else {
        showToast(context, '获取房间信息失败，请稍后再试');
      }
    }
    return null;
  }



  //房间信息，轮询请求获取房间玩家准备的情况
  static getRoomMainInfo(BuildContext context,int room_id,) async{
    var res = await DioUtils.instance.getRequest(Method.get, 'room/info/'+room_id.toString(),
      options: Options(headers: {'token':getToken()}),
    );
    if(res!=null){
      var value = json.decode(res.data);
      if(value['code']==0){
        var data = value['data'];
        // showToast(context, data['tip']);

        if(data['room_Id']!=null)
          return data;
      }else if(value['code']==1){
        //房间不存在
        return 1;
        // showToast(context, '获取房间信息失败，请稍后再试');
      }
    }
    return null;
  }

  //【游戏状态接口】 轮询获取游戏状态信息
  static getGameState(BuildContext context,int room_id,int game_id,) async{
    var parame = {
      "room_id": room_id, // 房间id(必传)
    };
    if(game_id!=null){
      parame = {
        "game_id":game_id, // 游戏id
        "room_id": room_id, // 房间id(必传)
      };
    }
    var res = await DioUtils.instance.getRequest(Method.get, 'game/state',
      queryParameters: parame,
      options: Options(headers: {'token':getToken()}),
    );
    if(res!=null){
      var value = json.decode(res.data);
      if(value['code']==0){
        var data = value['data'];
        // showToast(context, data['tip']);

        return data;
      }else if(value['code']==1){
        //房间不存在
        return 1;
        // showToast(context, '获取房间信息失败，请稍后再试');
      }
    }
    return null;
  }


  //离开房间
  static leaveRoom(BuildContext context,int user_id,int room_id,) async{
    var res = await DioUtils.instance.getRequest(Method.get, 'room/out/',
      queryParameters: {
        "user_id":user_id, // 账号
        "room_id": room_id, // 密码
      },
      options: Options(headers: {'token':getToken()}),
    );
    if(res!=null){
      var value = json.decode(res.data);
      if(value['code']==0){
        var data = value['data'];
        // showToast(context, data['tip']);

        return data;
      }else{
        // showToast(context, '获取房间信息失败，请稍后再试');
      }
    }
    return null;
  }


  //房主解散房间
  static dissolutionRoom(BuildContext context,int user_id,int room_id,) async{
    var res = await DioUtils.instance.getRequest(Method.get, 'room/dissolution/',
      queryParameters: {
        "user_id":user_id, // 账号
        "room_id": room_id, // 密码
      },
      options: Options(headers: {'token':getToken()}),
    );
    if(res!=null){
      var value = json.decode(res.data);
      if(value['code']==0){
        var data = value['data'];
        // showToast(context, data['tip']);
        return data;
      }else{
        // showToast(context, '获取房间信息失败，请稍后再试');
      }
    }
    return null;
  }



  //房主在房间点击开始游戏
  static roomToGameStart(BuildContext context,int user_id,int room_id,) async{
    var res = await DioUtils.instance.getRequest(Method.get, 'game/start/',
      queryParameters: {
        "user_id":user_id, // 房主
        "room_id": room_id, // 房间
      },
      options: Options(headers: {'token':getToken()}),
    );
    if(res!=null){
      var value = json.decode(res.data);
      if(value['code']==0){
        var data = value['data'];
        // showToast(context, data['tip']);
        return data;
      }else if(value['code']==1){
        showToast(context, '开始游戏失败');
        return 1;
      }else{
        // showToast(context, '获取房间信息失败，请稍后再试');
      }
    }
    return null;
  }

  //用户准备or取消准备
  static roomReady(BuildContext context,int user_id,int room_id,bool readyType) async{
    var res = await DioUtils.instance.getRequest(Method.get, 'room/ready/',
      queryParameters: {
        "user_id":user_id, // 房主
        "room_id": room_id, // 房间
        "ready_type": readyType?1:0, // 玩家准备类型  1:玩家准备 非1:未准备
      },
      options: Options(headers: {'token':getToken()}),
    );
    if(res!=null){
      var value = json.decode(res.data);
      if(value['code']==0){
        var data = value['data'];
        // showToast(context, data['tip']);
        return data;
      }else if(value['code']==1){
        showToast(context, '准备失败，请稍后再试');
        return 1;
      }else{
        // showToast(context, '获取房间信息失败，请稍后再试');
      }
    }
    return null;
  }

  //选择庄闲
  static setZhuang(BuildContext context,int user_id,int room_id,bool readyType) async{
    var res = await DioUtils.instance.getRequest(Method.get, 'game/set/master/',
      queryParameters: {
        "user_id":user_id, //
        "game_id": room_id, // 游戏id,由 【开始游戏接口】获得
      },
      options: Options(headers: {'token':getToken()}),
    );
    if(res!=null){
      var value = json.decode(res.data);
      if(value['code']==0){
        var data = value['data'];
        // showToast(context, data['tip']);
        return data;
      }else if(value['code']==1){
        showToast(context, '选择庄家信息失败，请稍后再试');
        return 1;
      }else{
        // showToast(context, '获取房间信息失败，请稍后再试');
      }
    }
    return null;
  }

  //发牌
  static deal(BuildContext context,int user_id,int room_id,bool readyType) async{
    var res = await DioUtils.instance.getRequest(Method.get, 'game/deal/',
      queryParameters: {
        "user_id":user_id, // 房主
        "game_id": room_id, // 游戏id,由 【开始游戏接口】获得
      },
      options: Options(headers: {'token':getToken()}),
    );
    if(res!=null){
      var value = json.decode(res.data);
      if(value['code']==0){
        var data = value['data'];
        // showToast(context, data['tip']);
        return data;
      }else if(value['code']==1){
        showToast(context, '选择庄家信息失败，请稍后再试');
        return 1;
      }else{
        // showToast(context, '获取房间信息失败，请稍后再试');
      }
    }
    return null;
  }
}