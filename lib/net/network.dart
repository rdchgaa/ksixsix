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
import 'package:xxc_flutter_utils/xxc_flutter_utils.dart';
import 'package:ima2_habeesjobs/net/dio_util.dart';
import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:provider/provider.dart';

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
        if(data['tip']!='登录成功'){
          showToast(context, data['tip']);
        }

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
        if(data['tip']!='登录成功'){
          showToast(context, data['tip']);
        }
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

///修改用户信息
  static userModify(BuildContext context,String name,String avatar) async{
    var res = await DioUtils.instance.getRequest(Method.post, 'user/modify',
      queryParameters: {
        "user_id":getUserId(), // 账号
        "nick_name": name, // 密码
        "avatar":avatar,
      },
      options: Options(headers: {'token':getToken()}),
    );
    if(res!=null){
      var value = json.decode(res.data);
      if(value['code']==0){
        return true;
      }else{
        showToast(context, '修改失败，请稍后再试');
      }
    }
    return null;
  }


  //查询游戏记录  userId
  static userGameRecord(BuildContext context,int userId,int page) async{
    var res = await DioUtils.instance.getRequest(Method.get, 'user/game/record',
      queryParameters: {
        "user_id":userId, // 账号
        "page":page, // 账号
        "limit":20, // 账号
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
        if(data=="已在房间"){
          return {"room_Id":roomId};
        }
        showToast(context, data);
        // showToast(context, '房间不存在');
      }else {
        showToast(context, '获取房间信息失败，请稍后再试');
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
  static roomReady(BuildContext context,int user_id,int game_id) async{
    var user = context.read<SerUser>();
    var res = await DioUtils.instance.getRequest(Method.get, 'game/ready/',
      queryParameters: {
        "user_id":user_id, //
        "game_id": user.gameId, //
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

  //【开始选庄闲接口】状态1(待准备) 由房主调用, 如果有玩家未准备会返回信息提示； 如果都准备了,状态变更为 2(未确认庄闲)
  static startSelectZhuang(BuildContext context) async{
    var user = context.read<SerUser>();
    var res = await DioUtils.instance.getRequest(Method.get, 'game/vocation/select/',
      queryParameters: {
        "game_id": user.gameId, // 游戏id,由 【开始游戏接口】获得
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
        showToast(context, '开始失败，请稍后再试');
        return 1;
      }else{
        // showToast(context, '获取房间信息失败，请稍后再试');
      }
    }
    return null;
  }

  //选择庄闲
  static setZhuang(BuildContext context,int user_id) async{
    var user = context.read<SerUser>();
    var res = await DioUtils.instance.getRequest(Method.get, 'game/vocation/set/',
      queryParameters: {
        "user_id":user_id, //
        "game_id": user.gameId, // 游戏id,由 【开始游戏接口】获得
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
  static deal(BuildContext context,int user_id) async{
    var user = context.read<SerUser>();
    var res = await DioUtils.instance.getRequest(Method.get, 'game/deal/',
      queryParameters: {
        "game_id": user.gameId, // 游戏id,由 【开始游戏接口】获得
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
        showToast(context, '发牌失败，请稍后再试');
        return 1;
      }else{
        // showToast(context, '获取房间信息失败，请稍后再试');
      }
    }
    return null;
  }

  //投注
  static gameBet(BuildContext context,int user_id,int score) async{
    var user = context.read<SerUser>();
    var res = await DioUtils.instance.getRequest(Method.get, 'game/bet/',
      queryParameters: {
        "game_id": user.gameId, // 游戏id,由 【开始游戏接口】
        "user_id": user_id, // 游戏id,由 【开始游戏接口】获得
        "score": score, // 游戏id,由 【开始游戏接口】获得
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
        showToast(context, '投注失败，请稍后再试');
        return 1;
      }else{
        // showToast(context, '获取房间信息失败，请稍后再试');
      }
    }
    return null;
  }


  //【本轮结算结果接口】状态7(本轮结束)所有玩家调用，返回本轮结算结果，未满10轮读秒时间结束后状态变为 3(待发牌)
  static gameItemResult(BuildContext context,int user_id,) async{
    var user = context.read<SerUser>();
    var res = await DioUtils.instance.getRequest(Method.get, 'game/item/result/',
      queryParameters: {
        "game_id": user.gameId, // 游戏id,由 【开始游戏接口】
        "user_id": user_id, // 游戏id,由 【开始游戏接口】获得
      },
      options: Options(headers: {'token':getToken()}),
    );
    if(res!=null){
      try{
        var value = json.decode(res.data);
        if(value['code']==0){
          var data = value['data'];
          // showToast(context, data['tip']);
          return data;
        }else if(value['code']==1){
          // showToast(context, '请等待结果');
          return 1;
        }else{
          // showToast(context, '获取房间信息失败，请稍后再试');
        }
      }catch(e){
        return null;
      }
    }
    return null;
  }


  //【本局结算结果接口】10轮 状态8(本局游戏结束) 所有玩家调用, 时间到状态变为 1(待准备)
  static gameFinalResult(BuildContext context,int user_id,int gameId) async{
    var res = await DioUtils.instance.getRequest(Method.get, 'game/final/result/',
      queryParameters: {
        "game_id": gameId, // 游戏id,由 【开始游戏接口】
        "user_id": user_id, // 游戏id,由 【开始游戏接口】获得
      },
      options: Options(headers: {'token':getToken()}),
    );
    if(res!=null){
      try{
        var value = json.decode(res.data);
        if(value['code']==0){
          var data = value['data'];
          // showToast(context, data['tip']);
          return data;
        }else if(value['code']==1){
          // showToast(context, '请等待结果');
          return 1;
        }else{
          // showToast(context, '获取房间信息失败，请稍后再试');
        }
      }catch(e){
        return null;
      }
    }
    return null;
  }


  //换牌接口，在当前游戏轮剩余的牌中随机换成指定类型的牌， 如果剩余的牌无法组合成需要换的类型接口会报错，请换一种类型;
  //1:炸弹  2:五小  3:金牛  4:银牛  5:牛牛  6:有牛
  // 61牛1
  // 62牛2
  // 63牛3
  // 64牛4
  // 65牛5
  // 66牛6
  // 67牛7
  // 68牛8
  // 69牛9
  static gameChangePoker(BuildContext context,int user_id,int type) async{
    var user = context.read<SerUser>();
    var res = await DioUtils.instance.getRequest(Method.get, 'game/change/',
      queryParameters: {
        "game_id": user.gameId, // 游戏id,由 【开始游戏接口】
        "user_id": user_id, // 游戏id,由 【开始游戏接口】获得
        "type":type,
      },
      options: Options(headers: {'token':getToken()}),
    );
    if(res!=null){
      try{
        var value = json.decode(res.data);
        if(value['code']==0){
          var data = value['data'];
          // showToast(context, data['tip']);
          return data;
        }else if(value['code']==1){
          showToast(context, value['data']);
          return 1;
        }else{
          showToast(context, '更换失败，请稍后再试');
        }
      }catch(e){
        return null;
      }
    }
    return null;
  }
}