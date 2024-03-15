import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ima2_habeesjobs/page/home/home_first/game/button_container.dart';
import 'package:xxc_flutter_utils/xxc_flutter_utils.dart';
import 'package:ima2_habeesjobs/dialog/alert_dialog_rule.dart';
import 'package:ima2_habeesjobs/net/network.dart';
import 'package:ima2_habeesjobs/page/home/home_first/page_game_main.dart';
import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:ima2_habeesjobs/util/audioplayer_utils.dart';
import 'package:ima2_habeesjobs/util/navigator.dart';
import 'package:ima2_habeesjobs/widget/app_content.dart';
import 'package:ima2_habeesjobs/widget/my_image.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class PageRoomMain extends StatefulWidget {
  final int roomId;

  const PageRoomMain({
    Key key,
    this.roomId,
  }) : super(key: key);

  @override
  _PageRoomMainState createState() => _PageRoomMainState();
}

class _PageRoomMainState extends State<PageRoomMain> {
  Color roomMasterColor = Color(0xffffaf49);

  Color playerColor = Color(0x66ffffff);

  Timer roomTimer = null;

  List userList = [];

  bool clickBack = false;

  @override
  void initState() {
    super.initState();
    // SoundpoolUtil.playSound();
  }

  Future<void> playSound() async {
    // SoundpoolUtil2.playSound();
  }

  @override
  void dispose() {
    super.dispose();
    if(roomTimer!=null){
      roomTimer.cancel();
      roomTimer = null;
    }
    SystemChrome.setPreferredOrientations([
      // 强制竖屏
      DeviceOrientation.portraitUp
    ]);
    // exitRoom();
  }

  initData() {
    getRoomState();
    roomTimer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      getRoomState();
    });
  }

  getRoomState() async {
    if(!mounted){
      return;
    }
    var user = context.read<SerUser>();
    var res = await LoadingCall.of(context).call((state, controller) async {
      return await NetWork.getGameState(context, widget.roomId, user.gameId);
    }, isShowLoading: false);

    if (res != null) {
      if (res == 1) {
        if (clickBack) {
          return;
        }
        jiesanRoom();
      } else {
        await setRoomInfo(res);
        checkRoomState(res['state']);
      }
    } else {}
  }

  setRoomInfo(var res) {
    getRightUserList(res['user_list_info']);
  }

  getRightUserList(List user_list) {
    userList = [];
    for (var i = 0; i < user_list.length; i++) {
      if (user_list[i]['user_id'] == getUserId()) {
        if(user_list[i]['is_master']==1){
          // isMaster = true;
          var user = context.read<SerUser>();
          user.isRoomMaster = true;
        }
      } else {
        userList.add(user_list[i]);
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  checkRoomState(int state) {
    ///-1，游戏解散， 0 组队状态 ，>0游戏中状态
    if (state == -1) {
      if (clickBack) {
        return;
      }
      jiesanRoom();
    } else if (state > 0) {
      enterTheGame();
    }
  }

  jiesanRoom(){
    if (mounted) {
      showToast(context, '房间已解散');
      if(roomTimer==null){
        return;
      }
      roomTimer.cancel();
      roomTimer = null;
      setState(() {

      });
      exitRoom();
    }
  }

  enterTheGame({bool clickStart = false}) async {
    if (userList.length < 1) {
      showToast(context, '等待好友进入房间');
      return;
    }
    roomTimer.cancel();
    roomTimer = null;
    setState(() {});

    if (clickStart) {
      var res = await LoadingCall.of(context).call((state, controller) async {
        return await NetWork.roomToGameStart(context, getUserId(), widget.roomId);
      }, isShowLoading: false);
      if (res == null || res == 1) {
        initData();
        return;
      }
    }

    Vibration.vibrate(duration: 200, amplitude: 50);
    AudioPlayerUtilTaikong.playSound();
    await PageGameMain(
      roomId: widget.roomId,
    ).push(context);
    var user = context.read<SerUser>();
    user.gameId = null;
    AudioPlayerUtilBackGround.stopSound();
    Navigator.pop(context);
    // initData();
    ///TODO 重置房间
  }

  exitRoom() async {
    //返回首页进行房间移除
    if(roomTimer!=null){
      roomTimer.cancel();
      roomTimer = null;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var user = context.watch<SerUser>();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        print("onWillPop");
        return Future.value(false);
        // true 当前路由出栈退出
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        body: Loading(
          child: LoadingCall(
              onInitLoading: _onInitLoading,
              emptyBuilder: (context) {
                return UiEmptyView(type: EmptyType.data);
              },
              errorBuilder: (context, error) {
                return UiEmptyView(type: EmptyType.network, onPressed: () => _onInitLoading(context));
              },
              builder: (context) {
                return Stack(
                  children: [
                    Image.asset(
                      'assets/images/rome_back.png',
                      width: width,
                      height: height,
                      fit: BoxFit.cover,
                    ),
                    // DecoratedBox(
                    //   decoration: BoxDecoration(color: Color(0x66000000)),
                    //   child: SizedBox(
                    //     width: width,
                    //     height: height,
                    //   ),
                    // ),
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Color(0x66000000)),
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                clickBack = true;
                                              });
                                              exitRoom();
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                    child: Icon(
                                                      Icons.keyboard_arrow_left,
                                                      color: Color(0xffffffff),
                                                      size: 30,
                                                    ),
                                                  ),
                                                  Text(
                                                    user.isRoomMaster ? '解散队伍' : '离开队伍',
                                                    style: TextStyle(fontSize: 16, color: Color(0xffeeeeee)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 10, top: 10,right: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 5.0),
                                                  child: Text(
                                                    '房间号：' + widget.roomId.toString(),
                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffeeeeee)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                   Padding(
                                    padding: const EdgeInsets.only(top:10,bottom: 20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        user.isRoomMaster?InkWell(
                                          onTap: () {
                                            enterTheGame(clickStart: true);
                                            // playSound();
                                          },
                                          child: Stack(
                                            children: [
                                              EnterButtonBuild(width: 120,),
                                              DecoratedBox(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(image: AssetImage("assets/images/button3.png"), fit: BoxFit.cover),
                                                  borderRadius: BorderRadius.all(Radius.circular(60)),
                                                  // boxShadow: [BoxShadow(color: Color(0xffcccccc), blurRadius: 33, offset: Offset(0, 0))],
                                                ),
                                                child: SizedBox(
                                                  width: 120,
                                                  height: 120,
                                                  child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(bottom: 20.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            '启',
                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xccffffff)),
                                                          ),
                                                          SizedBox(width: 10,),
                                                          Text(
                                                            '动',
                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xccffffff)),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ):Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            DecoratedBox(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(image: AssetImage("assets/images/yuanyuan.png"), fit: BoxFit.cover),
                                                borderRadius: BorderRadius.all(Radius.circular(60)),
                                                boxShadow: [BoxShadow(color: Color(0xff000000), blurRadius: 33, offset: Offset(0, 0))],
                                              ),
                                              child: SizedBox(
                                                width: 220,
                                                height: 120,
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(bottom: 15.0),
                                                    child: Text(
                                                      '等待房主开始',
                                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xccffffff)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [Color(0x99460a70), Color(0x33d4bff9) ],
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 10.0, bottom: 10, left: 20, right: 20),
                                            child: SizedBox(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        width: 80,
                                                        height: 80,
                                                        decoration: BoxDecoration(
                                                          color: Color(0xffffffff),
                                                          borderRadius: BorderRadius.all(Radius.circular(80 / 2)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: user.isRoomMaster ? roomMasterColor : playerColor, blurRadius: 33, offset: Offset(0, 0))
                                                          ],
                                                        ),
                                                        child: Center(
                                                          child: HeadImage.network(
                                                            user.info.avatar ?? '',
                                                            width: 79,
                                                            height: 79,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding: EdgeInsets.only(left: 20),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                (getUserId() == null || getUserId() == 0) ? '登录/注册' : (user.nickname),
                                                                style: TextStyle(
                                                                  fontFamily: 'Source Han Sans CN',
                                                                  fontSize: 18,
                                                                  color: const Color(0xffeeeeee),
                                                                  fontWeight: FontWeight.w700,
                                                                ),
                                                                softWrap: false,
                                                              ),
                                                            ],
                                                          )),
                                                    ],
                                                  ),
                                                  if (user.isRoomMaster)
                                                      Column(
                                                        children: [
                                                          Image.asset('assets/images/fangzhu.png',width: 30,height: 30,),
                                                          Text(
                                                            '房主',
                                                            style: TextStyle(fontSize: 12, color: Color(0xff34ac38)),
                                                          )
                                                        ],
                                                      )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(child: getRightBuild())
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  getRightBuild() {
    var imageWidth = 70.0;
    List<Widget> listBuild = [];
    for (var i = 0; i < userList.length; i++) {
      listBuild.add(peopleItem(userList[i]));
    }
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: listBuild,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    Clipboard.setData(ClipboardData(text: widget.roomId.toString()));
                    showToast(context, '复制房间号成功，请发送给您的好友');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text('分享房间号给您的好友\n让朋友们加入队伍吧',textAlign:TextAlign.center,style: TextStyle(fontSize: 12,color: Color(0xffdddddd)),),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  peopleItem(item) {
    var imageWidth = 50.0;

    return Container(
      margin: EdgeInsets.only( top: 20),
      padding: EdgeInsets.only(left: 20, right: 20, top: 10,bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x995f8118), Color(0x33f3f6e6) ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: imageWidth,
                height: imageWidth,
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.all(Radius.circular(imageWidth / 2)),
                  boxShadow: [BoxShadow(color: item['is_master'] == 1 ? roomMasterColor : playerColor, blurRadius: 33, offset: Offset(0, 0))],
                ),
                child: Center(
                  child: HeadImage.network(
                    item['avatar'],
                    width: imageWidth - 1,
                    height: imageWidth - 1,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                      item['nick_name'],
                      style: TextStyle(fontSize: 16, color: Color(0xffdddddd)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (item['is_master'] == 1)
            Column(
            children: [
              Image.asset('assets/images/fangzhu.png',width: 30,height: 30,),
              Text(
                '房主',
                style: TextStyle(fontSize: 12, color: Color(0xff34ac38)),
              )
            ],
          )
        ],
      ),
    );
  }

  emptyPeopleItem() {
    var imageWidth = 80.00;
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: widget.roomId.toString()));
        showToast(context, '复制房间号成功，请发送给您的好友');
      },
      child: Container(
        width: imageWidth,
        height: imageWidth,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: playerColor, blurRadius: 33, offset: Offset(0, 0))],
          color: Color(0xaaffffff),
          borderRadius: BorderRadius.all(Radius.circular(imageWidth / 2)),
        ),
        child: Center(
            child: Text(
          '+',
          style: TextStyle(fontSize: 50, color: Color(0xffffaf49)),
        )),
      ),
    );
  }

  Future<bool> _onInitLoading(BuildContext context) async {
    initData();
    return true;
  }
}
