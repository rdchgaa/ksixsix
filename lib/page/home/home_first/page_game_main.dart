import 'dart:async';

import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';
import 'package:ima2_habeesjobs/net/network.dart';
import 'package:ima2_habeesjobs/page/home/home_first/card_build.dart';
import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:ima2_habeesjobs/util/language.dart';
import 'package:ima2_habeesjobs/util/other.dart';
import 'package:ima2_habeesjobs/util/soundpool_Util.dart';
import 'package:ima2_habeesjobs/widget/app_bar.dart';
import 'package:ima2_habeesjobs/widget/app_content.dart';
import 'package:ima2_habeesjobs/widget/my_button.dart';
import 'package:ima2_habeesjobs/widget/my_image.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class PageGameMain extends StatefulWidget {
  final int roomId;

  const PageGameMain({
    Key key,
    this.roomId,
  }) : super(key: key);

  @override
  _PageGameMainState createState() => _PageGameMainState();
}

class _PageGameMainState extends State<PageGameMain> {
  Color roomMasterColor = Color(0xffffaf49);

  Color playerColor = Color(0x66ffffff);

  Timer roomTimer = null;

  List<int> myBetting = [];

  bool showCard1 = false;
  bool showCard2 = false;
  bool showCard3 = false;
  bool showCard4 = false;
  bool showCard5 = false;

  List playerList = [];
  int homeowner = -1;

  bool selfReady = false;

  @override
  void initState() {
    super.initState();
    // SoundpoolUtil.playSound();
  }

  Future<void> playSound() async {
    SoundpoolUtil2.playSound();
  }

  @override
  void dispose() {
    super.dispose();
    roomTimer.cancel();
    roomTimer = null;
    // leaveRoom();
  }

  // leaveRoom() async {
  //   var res = await NetWork.getRoomMainInfo(context, 1);
  //
  //   if (res != null) {
  //   } else {}
  // }

  initData() async {
    roomTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      getRoomState();

      // getGameState();
    });
  }

  getGameState() async {
    var res = await LoadingCall.of(context).call((state, controller) async {
      return await NetWork.roomToGameStart(context, getUserId(), widget.roomId);
    }, isShowLoading: false);
    if (res == null || res == 1) {}
  }

  getRoomState() async {
    var res = await LoadingCall.of(context).call((state, controller) async {
      return await NetWork.getRoomMainInfo(context, widget.roomId);
    }, isShowLoading: false);

    if (res != null) {
      if (res == 1) {
        showToast(context, '房间已解散');
        Navigator.pop(context);
      } else {
        getRightUserList(res['user_list']);
        homeowner = res['homeowner'];
        var state = res['state'];
        checkRoomState(state);
        if (mounted) {
          setState(() {});
        }
      }
    } else {}
  }

  getRightUserList(List user_list) {
    playerList = [];
    for (var i = 0; i < user_list.length; i++) {
      if (user_list[i]['user_id'] == getUserId()) {
      } else {
        playerList.add(user_list[i]);
      }
    }
  }

  checkRoomState(int state) {
    /// 房主 [ 0:不可开始(玩家未准备，房间人数小于2) 1:可以开始，全部准备(人数>1) ]
    /// 其他 [ 2：开始中  3:进入游戏(包括房主) ]
    /// 当房主收到状态 1（可以开始）点击开始房间状态值会变成 3， 所有人就会收到房间状态3  进行游戏
    if (state == 3) {
      //进入游戏,游戏中页面，不做操作
    }
  }

  /// 开始游戏   1:选择庄闲  2(庄-发牌)  3:(闲-投注)  3:看牌  4:显示输赢
  startTheGame() async {
    Vibration.vibrate(duration: 200, amplitude: 50);
    selectZhuang();
  }

  selectZhuang() {

  }

  setZhuang() async{
    Vibration.vibrate(duration: 200, amplitude: 50);
    var res = await LoadingCall.of(context).call((state, controller) async {
      return await NetWork.setZhuang(context, getUserId(), widget.roomId, true);
    }, isShowLoading: false);
    if (res != null && res != 1) {
      setState(() {
        selfReady = true;
      });
    }

  }

  readyGame() async {
    var res = await LoadingCall.of(context).call((state, controller) async {
      return await NetWork.roomReady(context, getUserId(), widget.roomId, true);
    }, isShowLoading: false);
    if (res != null && res != 1) {
      setState(() {
        selfReady = true;
      });
    }
  }

  endGame() async{
    ///TODO 结束游戏  调取接口

    var res = await LoadingCall.of(context).call((state, controller) async {
      return await NetWork.dissolutionRoom(context, getUserId(), widget.roomId);
    }, isShowLoading: false);

    if (res != null && res != 1) {
      //结束成功
      roomTimer.cancel();
      roomTimer = null;
      Navigator.pop(context);
    }
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
      child: Loading(
        child: LoadingCall(
            onInitLoading: _onInitLoading,
            emptyBuilder: (context) {
              return UiEmptyView(type: EmptyType.data);
            },
            errorBuilder: (context, error) {
              return UiEmptyView(type: EmptyType.network, onPressed: () => _onInitLoading(context));
            },
            builder: (context) {
              return Scaffold(
                backgroundColor: const Color(0xffffffff),
                body: Stack(
                  children: [
                    Image.asset(
                      'assets/images/desk.png',
                      width: width,
                      height: height,
                      fit: BoxFit.cover,
                    ),
                    SafeArea(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 50,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: getMethodBuild(),
                                    ),
                                    Expanded(child: SizedBox()),
                                    SizedBox(
                                      width: 150,
                                      child: leaveGameBuild(),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(child: getPlayersBuild()),
                              false?getBetBuild():SizedBox(height: 80,child: selfZhuangBuild(),)
                            ],
                          ),
                          Positioned(bottom:5,left: 60, child: getSelfInfoItemBuild()),
                          Positioned(top: 0, child: getMyCardBuild()),
                          Positioned(bottom: 0, right: 0, child: getButtonBuild()),
                          Positioned(child: getCenterInfoBuild()),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  selfZhuangBuild(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: roomMasterColor, blurRadius: 33, offset: Offset(0, 0))],
          ),
          child: SizedBox(
              width: 35,
              height: 35,
              child: MyButton.gradient(
                  backgroundColor: [Color(0xfff3ec6c), Color(0xffbe5a05)],
                  child: Text('庄', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
        ),
      ),
    );
  }

  changeCard(int index) {
    print('changeCard---------$index');
  }

  getMyCardBuild() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        !showCard1
            ? getCardBackBuild(onTap: () {
                setState(() {
                  showCard1 = true;
                });
              })
            : getCardBuild(1, 1, onTap: () {
                changeCard(1);
              }),
        SizedBox(width: 10),
        !showCard2
            ? getCardBackBuild(onTap: () {
                setState(() {
                  showCard2 = true;
                });
              })
            : getCardBuild(2, 3, onTap: () {
                changeCard(2);
              }),
        SizedBox(width: 10),
        !showCard3
            ? getCardBackBuild(onTap: () {
                setState(() {
                  showCard3 = true;
                });
              })
            : getCardBuild(3, 11, onTap: () {
                changeCard(3);
              }),
        SizedBox(width: 10),
        !showCard4
            ? getCardBackBuild(onTap: () {
                setState(() {
                  showCard4 = true;
                });
              })
            : getCardBuild(4, 12, onTap: () {
                changeCard(4);
              }),
        SizedBox(width: 10),
        !showCard5
            ? getCardBackBuild(onTap: () {
                setState(() {
                  showCard5 = true;
                });
              })
            : getCardBuild(1, 13, onTap: () {
                changeCard(5);
              }),
      ],
    );
  }

  leaveGameBuild() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: InkWell(
            onTap: () async {
              endGame();
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage("assets/images/button1.webp"), fit: BoxFit.fill),
                  ),
                  child: SizedBox(
                    width: 120,
                    height: 40,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          '结束游戏',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffeeeeee)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  getMethodBuild() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: InkWell(
            onTap: () async {
              setState(() {
                showCard1 = showCard2 = showCard3 = showCard4 = showCard5 = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage("assets/images/button1.webp"), fit: BoxFit.fill),
                  ),
                  child: SizedBox(
                    width: 60,
                    height: 25,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 3.0),
                        child: Text(
                          '看牌',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xffeeeeee)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  getBetBuild() {
    var imageWidth = 30.0;
    if(false){
      return SizedBox(height: 40.0+35.0,);
    }
    return SizedBox(
      height: 80,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: SizedBox(
          child: Column(
            children: [
              myBettingBuild(),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getChoumaItemBuild(1, padding: EdgeInsets.only(left: 0)),
                  getChoumaItemBuild(10),
                  getChoumaItemBuild(50),
                  getChoumaItemBuild(100),
                  getChoumaItemBuild(500),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  myBettingBuild() {
    var width = MediaQuery.of(context).size.width;

    List<Widget> listBuild = [];
    for (var i = 0; i < myBetting.length; i++) {
      listBuild.add(Padding(
        padding: EdgeInsets.only(left: 5),
        child: Center(
          child: getChoumaItemBuild(myBetting[i], imageWidth: 24, padding: EdgeInsets.only(left: 0)),
        ),
      ));
    }
    return SizedBox(
      width: width,
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: listBuild,
      ),
    );
  }

  getButtonBuild() {
    var user = context.watch<SerUser>();

    Widget readyButton = SizedBox(
        width: 70,
        height: 70,
        child: MyButton.gradient(
            backgroundColor: [Color(0xff70d9fe), Color(0xff2933e0)],
            onPressed: () {
              readyGame();
            },
            child: Text('准备', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffffffff)))));
    if (selfReady) {
      //房主默认准备
      readyButton = SizedBox(
          width: 70,
          height: 70,
          child: MyButton.gradient(
              backgroundColor: [Color(0xffffffff), Color(0xff000000)], child: Text('已准备', style: TextStyle(fontSize: 15, color: Color(0xffffffff)))));
    }
    Widget startButton = SizedBox(
        width: 70,
        height: 70,
        child: MyButton.gradient(
            backgroundColor: [Color(0xffcbffc0), Color(0xff056910)],
            onPressed: () {
              startTheGame();
            },
            child: Text('开始', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffffffff)))));

    bool allReady = true;
    for (var i = 0; i < playerList.length; i++) {
      var player = playerList[i];
      if (player['state'] != 1) {
        allReady = false;
      }
    }
    if (!allReady) {
      startButton = SizedBox(
          width: 70,
          height: 70,
          child: MyButton.gradient(
              backgroundColor: [Color(0xffffffff), Color(0xff000000)],
              child: Text('待玩家\n准备', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Color(0xffffffff)))));
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 10, right: 20),
      child: Row(
        children: [
          if (!user.isRoomMaster)
            Padding(
              padding: const EdgeInsets.only(bottom: 0, right: 20),
              child: readyButton,
            ),
          if (user.isRoomMaster) startButton
        ],
      ),
    );
  }

  getChoumaItemBuild(int num, {double imageWidth = 35.0, EdgeInsetsGeometry padding}) {
    var image = 'assets/images/money1.png';
    Color color = Color(0xffbab321);
    if (num == 1) {
      image = 'assets/images/money1.png';
      color = Color(0xffbab321);
    } else if (num == 10) {
      image = 'assets/images/money10.png';
      color = Color(0xff37ab18);
    } else if (num == 50) {
      image = 'assets/images/money50.png';
      color = Color(0xff1296db);
    } else if (num == 100) {
      image = 'assets/images/money100.png';
      color = Color(0xff081459);
    } else if (num == 500) {
      image = 'assets/images/money500.png';
      color = Color(0xffd81e06);
    }
    double fontSize = 10.0;
    if (imageWidth < 35) {
      fontSize = 6.0;
    }
    return Padding(
      padding: padding ?? EdgeInsets.only(left: 30),
      child: InkWell(
        onTap: () {
          if (myBetting.length >= 10) {
            showToast(context, '最多投注10次');
            return;
          }
          Vibration.vibrate(duration: 200, amplitude: 50);
          myBetting.add(num);
          setState(() {});
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                image,
              ),
              fit: BoxFit.fill,
            ),
            boxShadow: [BoxShadow(color: roomMasterColor, blurRadius: 33, offset: Offset(0, 0))],
          ),
          child: SizedBox(
            width: imageWidth,
            height: imageWidth,
            child: Center(
                child: Text(
              num.toString(),
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: color),
            )),
          ),
        ),
      ),
    );
  }

  getPlayerBettingBuild(int playerIndex, List<int> list) {
    List<Widget> listBuild = [];
    var padding = const EdgeInsets.only(left: 40.0);
    double imageWidth = 17.0;
    if (playerIndex == 0) {
      padding = const EdgeInsets.only(left: 40.0);
      imageWidth = 17.0;
    }
    if (playerIndex == 1) {
      list = list.reversed.toList();
      padding = const EdgeInsets.only(right: 40.0);
      imageWidth = 17.0;
    }
    if (playerIndex == 2) {
      padding = const EdgeInsets.only(left: 12.0);
      imageWidth = 20.0;
    }
    if (playerIndex == 3) {
      list = list.reversed.toList();
      padding = const EdgeInsets.only(right: 12.0);
      imageWidth = 20.0;
    }
    if (2 < 2) {
      if (playerIndex == 0) {
        padding = const EdgeInsets.only(left: 30.0);
        imageWidth = 20.0;
      }
      if (playerIndex == 1) {
        list = list.reversed.toList();
        padding = const EdgeInsets.only(right: 30.0);
        imageWidth = 20.0;
      }
    }
    for (var i = 0; i < list.length; i++) {
      listBuild.add(Padding(
        padding: EdgeInsets.only(left: 2),
        child: Center(
          child: getChoumaItemBuild(list[i], imageWidth: imageWidth, padding: EdgeInsets.only(left: 0)),
        ),
      ));
    }
    return Padding(
      padding: padding,
      child: SizedBox(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: listBuild,
        ),
      ),
    );
  }

  getPlayersBuild() {
    var imageWidth = 40.0;
    var peopleWidth = 100.0;
    var peopleHeight = 65.0;
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ///1排
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: getPlayer1Build(),
              ),
              Expanded(
                child: getPlayer2Build(),
              ),
            ],
          ),

          ///2排
          Padding(
            padding: EdgeInsets.only(top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: getPlayer3Build(),
                ),
                Expanded(
                  child: getPlayer4Build(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getPlayer1Build() {
    if(playerList.length<1){
      return SizedBox();
    }
    return Row(
      children: [
        getPlayerInfoItemBuild(0),
        getPlayerBettingBuild(0, [1, 1, 1, 1, 1, 100, 10]),
      ],
    );
  }

  getPlayer2Build() {
    if(playerList.length<2){
      return SizedBox();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        getPlayerBettingBuild(1, [1, 1, 1, 1, 1, 100, 10, 50, 500, 500]),
        getPlayerInfoItemBuild(1),
      ],
    );
  }

  getPlayer3Build() {
    if(playerList.length<3){
      return SizedBox();
    }
    return Row(
      children: [
        getPlayerInfoItemBuild(2),
        getPlayerBettingBuild(2, [1, 100, 1, 10, 10, 50, 500, 500, 1, 50]),
      ],
    );
  }

  getPlayer4Build() {
    if(playerList.length<4){
      return SizedBox();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        getPlayerBettingBuild(3, [1, 1, 1, 1, 1, 100, 10, 50, 500, 500]),
        getPlayerInfoItemBuild(3),
      ],
    );
  }

  getPlayerInfoItemBuild(int index) {
    var imageWidth = 40.0;
    var peopleWidth = 100.0;
    var peopleHeight = 65.0;

    var player = playerList[index];
    Widget readyButton = SizedBox(
        width: 40,
        height: 16,
        child: MyButton.gradient(
            backgroundColor: [Color(0xff70d9fe), Color(0xff2933e0)],
            child: Padding(
              padding: const EdgeInsets.only(bottom: 1.0),
              child: Text('已准备', style: TextStyle(fontSize: 10, color: Color(0xffffffff))),
            )));
    if(0==player['state']) {
      readyButton = SizedBox(
          width: 40,
          height: 16,
          child: MyButton.gradient(
              backgroundColor: [Color(0xffffffff), Color(0xff000000)],
              child: Padding(
                padding: const EdgeInsets.only(bottom: 1.0),
                child: Text('未准备', style: TextStyle(fontSize: 10, color: Color(0xffffffff))),
              )));
    }

    var zhuangBuild = DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: roomMasterColor, blurRadius: 33, offset: Offset(0, 0))],
      ),
      child: SizedBox(
          width: 16,
          height: 16,
          child: MyButton.gradient(
              backgroundColor: [Color(0xfff3ec6c), Color(0xffbe5a05)],
              onPressed: () {
                setZhuang();
              },
              child: Text('庄', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
    );

    return SizedBox(
      width: peopleWidth,
      // height: peopleHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: imageWidth,
            height: imageWidth,
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: roomMasterColor, blurRadius: 33, offset: Offset(0, 0))],
            ),
            child: HeadImage.network(
              '',
              width: imageWidth,
              height: imageWidth,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  player['nick_name'],
                  maxLines: 2,
                  style: TextStyle(fontSize: 12, color: Color(0xffdddddd)),
                ),
                if(homeowner==player['user_id'])Text(
                  '(房主)',
                  style: TextStyle(fontSize: 10, color: Color(0xff0ac940)),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              readyButton,
              zhuangBuild
            ],
          )
        ],
      ),
    );
  }

  getSelfInfoItemBuild() {
    var user = context.read<SerUser>();
    var imageWidth = 50.0;
    var peopleWidth = 100.0;

    return SizedBox(
      // width: peopleWidth,
      // height: peopleHeight,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: imageWidth,
                height: imageWidth,
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: roomMasterColor, blurRadius: 33, offset: Offset(0, 0))],
                ),
                child: HeadImage.network(
                  '',
                  width: imageWidth,
                  height: imageWidth,
                ),
              ),

            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.nickname,
                        maxLines: 1,
                        style: TextStyle(fontSize: 12, color: Color(0xffdddddd)),
                      ),
                      if(user.isRoomMaster)Text(
                        '(房主)',
                        style: TextStyle(fontSize: 10, color: Color(0xff0ac940)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  emptyPeopleItem() {
    var imageWidth = 80.00;
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: '12345'));
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

  getCenterInfoBuild() {
    Widget startButton = DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: roomMasterColor, blurRadius: 33, offset: Offset(0, 0))],
      ),
      child: SizedBox(
          width: 100,
          height: 100,
          child: MyButton.gradient(
              backgroundColor: [Color(0xfff3ec6c), Color(0xffbe5a05)],
              onPressed: () {
                setZhuang();
              },
              child: Text('抢庄', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
    );

    return Padding(
      padding: EdgeInsets.only(top: 0),
      child: startButton,
    );
  }

  Future<bool> _onInitLoading(BuildContext context) async {
    initData();
    var user = context.read<SerUser>();
    if (user.isRoomMaster) {
      //房主默认准备
      readyGame();
    }
    return true;
  }
}
