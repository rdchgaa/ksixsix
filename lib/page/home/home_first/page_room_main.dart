import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    roomTimer.cancel();
    roomTimer = null;
    // exitRoom();
  }

  initData() {
    getRoomState();
    roomTimer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      getRoomState();
    });
  }

  getRoomState() async {
    var user = context.read<SerUser>();
    var res = await LoadingCall.of(context).call((state, controller) async {
      return await NetWork.getGameState(context, widget.roomId, user.gameId);
    }, isShowLoading: false);

    if (res != null) {
      if (res == 1) {
        if (clickBack) {
          return;
        }
        if (mounted) {
          showToast(context, '房间已解散');
          exitRoom();
        }
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
      if (mounted) {
        showToast(context, '房间已解散');
        exitRoom();
      }
    } else if (state > 0) {
      enterTheGame();
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
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var user = context.watch<SerUser>();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
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
                  SafeArea(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 300,
                          height: height,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          clickBack = true;
                                        });
                                        exitRoom();
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
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
                                                user.isRoomMaster ? '解散房间' : '离开房间',
                                                style: TextStyle(fontSize: 16, color: Color(0xffeeeeee)),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: InkWell(
                                              onTap: () async {
                                                showAlertDialogRule(context);
                                              },
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Center(
                                                          child: Image.asset(
                                                        'assets/images/rule.png',
                                                        width: 30,
                                                        height: 30,
                                                      )),
                                                      Text(
                                                        '游戏规则',
                                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xffeeeeee)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: SizedBox(
                                        width: 300,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                color: Color(0xffffffff),
                                                borderRadius: BorderRadius.all(Radius.circular(80 / 2)),
                                                boxShadow: [
                                                  BoxShadow(color: user.isRoomMaster ? roomMasterColor : playerColor, blurRadius: 33, offset: Offset(0, 0))
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
                                                padding: EdgeInsets.only(top: 10),
                                                child: Row(
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
                                                    if (user.isRoomMaster)
                                                      Text(
                                                        ' (房主)',
                                                        style: TextStyle(fontSize: 14, color: roomMasterColor),
                                                      )
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      if (user.isRoomMaster)
                                        InkWell(
                                          onTap: () {
                                            enterTheGame(clickStart: true);
                                            // playSound();
                                          },
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              DecoratedBox(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(image: AssetImage("assets/images/button1.webp"), fit: BoxFit.fill),
                                                ),
                                                child: SizedBox(
                                                  width: 200,
                                                  height: 65,
                                                  child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(bottom: 5.0),
                                                      child: Text(
                                                        '进入游戏',
                                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffeeeeee)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 15, top: 10),
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
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: getRightBuild())
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  getRightBuild() {
    var imageWidth = 70.0;
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 20, top: 10, bottom: 20),
      child: DecoratedBox(
        decoration: BoxDecoration(color: Color(0x33000000), borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                userList.length < 1 ? emptyPeopleItem() : peopleItem(userList[0]),
                userList.length < 2
                    ? Padding(padding: const EdgeInsets.only(left: 100.0), child: emptyPeopleItem())
                    : Padding(
                        padding: const EdgeInsets.only(left: 100.0),
                        child: peopleItem(userList[1]),
                      ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  userList.length < 3 ? emptyPeopleItem() : peopleItem(userList[2]),
                  userList.length < 4
                      ? Padding(padding: const EdgeInsets.only(left: 100.0), child: emptyPeopleItem())
                      : Padding(
                          padding: const EdgeInsets.only(left: 100.0),
                          child: peopleItem(userList[3]),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  peopleItem(item) {
    var imageWidth = 70.0;
    return Column(
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
          padding: EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Text(
                item['nick_name'],
                style: TextStyle(fontSize: 16, color: Color(0xffdddddd)),
              ),
              if (item['is_master'] == 1)
                Text(
                  ' (房主)',
                  style: TextStyle(fontSize: 14, color: roomMasterColor),
                )
            ],
          ),
        ),
      ],
    );
  }

  emptyPeopleItem() {
    var imageWidth = 80.00;
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: widget.roomId.toString()));
        showToast(context, '复制房间号成功，请发送给您的牌友');
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
