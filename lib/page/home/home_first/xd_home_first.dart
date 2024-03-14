import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ima2_habeesjobs/dialog/alert_dialog_update.dart';
import 'package:ima2_habeesjobs/net/network.dart';
import 'package:ima2_habeesjobs/page/home/home_first/full_card_build.dart';
import 'package:ima2_habeesjobs/page/home/home_first/game/button_container.dart';
import 'package:ima2_habeesjobs/page/home/home_first/game/page_game_container.dart';
import 'package:ima2_habeesjobs/page/home/home_first/page_room_main.dart';
import 'package:ima2_habeesjobs/page/login/page_login.dart';
import 'package:ima2_habeesjobs/page/my/page_set_up.dart';
import 'package:ima2_habeesjobs/page/my/page_xd_edit_info.dart';
import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:ima2_habeesjobs/util/navigator.dart';
import 'package:ima2_habeesjobs/util/other.dart';
import 'package:ima2_habeesjobs/widget/app_content.dart';
import 'package:ima2_habeesjobs/widget/my_image.dart';
import 'package:ima2_habeesjobs/widget/refresh_loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:xxc_flutter_utils/xxc_flutter_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

class XdHomeFirst extends StatefulWidget {
  const XdHomeFirst({
    Key key,
  }) : super(key: key);

  @override
  _XdHomeFirstState createState() => _XdHomeFirstState();
}

class _XdHomeFirstState extends State<XdHomeFirst> {
  TextEditingController _unRoomId = new TextEditingController(text: '');

  int _pageIndex = 1;

  var historyList = [];

  bool showRecord = false;

  var finalResultData = null;

  var versionInfo = null;

  @override
  void initState() {
    super.initState();
    // SoundpoolUtil.playSound();
    SystemChrome.setPreferredOrientations([
      // 强制竖屏
      DeviceOrientation.portraitUp
    ]);

    ///TODO  测试
    // controller1.addListener(ScrollListener1);
    getVersionInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getVersionInfo() async{
    var info = await PackageInfo.fromPlatform();
    var res = await LoadingCall.of(context).call((state, controller) async {
      return await NetWork.getVersionInfo(context, info.version);
    }, isShowLoading: true);
    if (res != null) {
      versionInfo = res;
    }
  }

  creatRoom() async {
    if (!checkCanUse()) {
      return;
    }
    var res = await LoadingCall.of(context).call((state, controller) async {
      return await NetWork.getCreatRoom(context, getUserId());
    }, isShowLoading: true);
    if (res != null) {
      var user = context.read<SerUser>();
      user.isRoomMaster = true;
      goRoom(res['room_Id']);
    }
  }

  joinRoom() async {
    if (!checkCanUse()) {
      return;
    }
    if (_unRoomId.text == '') {
      showToast(context, '请输入房间号');
      return;
    }
    var res = await LoadingCall.of(context).call((state, controller) async {
      return await NetWork.getJoinRoom(context, getUserId(), int.tryParse(_unRoomId.text) ?? 0);
    }, isShowLoading: true);
    if (res != null) {
      var user = context.read<SerUser>();
      user.isRoomMaster = false;
      goRoom(res['room_Id']);
    }
  }

  goRoom(int roomId) async {
    hideTextInput();
    await PageRoomMain(
      roomId: roomId,
    ).push(context);
    var user = context.read<SerUser>();
    user.gameId = null;
    hideTextInput();
    leaveRoom(roomId);
    _onRefresh(context, OnRefreshType.Refresh);
  }

  leaveRoom(int roomId) async {
    var user = context.read<SerUser>();
    var res = await LoadingCall.of(context).call((state, controller) async {
      if (user.isRoomMaster) {
        user.isRoomMaster = false;
        return await NetWork.dissolutionRoom(context, getUserId(), roomId);
      } else {
        user.isRoomMaster = false;
        return await NetWork.leaveRoom(context, getUserId(), roomId);
      }
    }, isShowLoading: true);
    if (res != null) {
    } else {}
  }

  bool checkCanUse() {
    if (versionInfo!=null) {
      toUpdate(context);
      return false;
    }
    return true;
  }

  bool checkLogin() {
    if ((getUserId() == null || getUserId() == 0)) {
      return false;
    }
    return true;
  }

  ///TODO   测试组件
  var pokerWidth = 110.0;
  var pokerHeight = 110.0 / 5.7 * 8.7;

  ScrollController controller1 = ScrollController();
  bool zhedang1 = true;

  ScrollListener1() async {
    if (controller1.offset >= (pokerWidth / 2)) {
      // controller1.removeListener(ScrollListener1());
      await controller1.animateTo(controller1.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.linear);
      zhedang1 = false;
      setState(() {});
    }
  }

  getTestBuild() {
    return SizedBox();
    return Center(
      child: getPokerBox(1),
    );
  }

  getPokerBox(int num) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xcc0f7357), Color(0xcc011713)],
            ),
            // color: Color(0xcc555555),
            boxShadow: [BoxShadow(color: Color(0xffeeb202), blurRadius: 33, offset: Offset(0, 0))],
            borderRadius: BorderRadius.all(Radius.circular(6)),
            border: Border.all(color: Color(0xffb68a08), width: 2)),
        child: SizedBox(
          width: pokerWidth,
          height: pokerHeight + 0,
          // child: getCardBuild(0,1,width: itemWidth),
          child: getPoker1(),
        ),
      ),
    );
  }

  getPoker1() {
    return ListView(
      controller: controller1,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: 0),
      children: [
        getPokerNullBoxBuild(),
        Center(
            child: Stack(
          children: [
            getFullCardBuild(4, 10, width: pokerWidth),
            if (zhedang1)
              Positioned(
                  top: 6,
                  left: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Color.fromRGBO(246, 246, 246, 1)),
                    child: SizedBox(
                      width: 15,
                      height: 40,
                    ),
                  )),
            if (zhedang1)
              Positioned(
                  right: 0,
                  bottom: 6,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Color.fromRGBO(246, 246, 246, 1)),
                    child: SizedBox(
                      width: 15,
                      height: 40,
                    ),
                  )),
          ],
        ))
      ],
    );
  }

  getPokerNullBoxBuild() {
    return Row(
      children: [
        SizedBox(
          width: pokerWidth,
          height: pokerHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/zuola.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              Text(
                '拉出扑克',
                style: TextStyle(fontSize: 16, color: Color(0xffe19b4b)),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10,
          height: pokerHeight,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = context.watch<SerUser>();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0x00ffffff),
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
              return DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/home.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0x77000000),
                      ),
                      child: SizedBox(
                        width: width,
                        height: height,
                      ),
                    ),
                    SafeArea(
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                // width: 300,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: GestureDetector(
                                              onTap: () async {
                                                // var res = await NetWork.toLogin();
                                                if (checkLogin()) {
                                                  PageXdEditInfo().push(context);
                                                } else {
                                                  // AutoRouter.of(context).pushNamed(
                                                  //   "/my_edit_info",
                                                  // );
                                                  PageLogin().push(context);
                                                }
                                                // return AutoRouter.of(context).pushNamed("/dialog_alert", params: {
                                                //   "title": title,
                                                //   "content": content,
                                                //   "buttonCancel": buttonCancel,
                                                //   "buttonOk": buttonOk,
                                                // });
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 80,
                                                        height: 80,
                                                        decoration: BoxDecoration(
                                                          color: Color(0xffffffff),
                                                          borderRadius: BorderRadius.all(Radius.circular(80 / 2)),
                                                          boxShadow: [BoxShadow(color: Color(0xaaffffff), blurRadius: 40, offset: Offset(0, 0))],
                                                        ),
                                                        child: Center(
                                                          child: HeadImage.network(
                                                            user.info.avatar ?? '',
                                                            width: 80 - 2.0,
                                                            height: 80 - 2.0,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 15),
                                                        child: Text(
                                                          checkLogin() ? (user.nickname) : '请登录',
                                                          style: TextStyle(
                                                            fontFamily: 'Source Han Sans CN',
                                                            fontSize: 18,
                                                            color: const Color(0xffeeeeee),
                                                            fontWeight: FontWeight.w700,
                                                          ),
                                                          softWrap: false,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      // AudioPlayerUtilBackGround.playSound();
                                                      await PageSetUp(versionInfo: versionInfo,).push(context);
                                                      // AudioPlayerUtilBackGround.stopSound();
                                                    },
                                                    child: Row(
                                                      children: [
                                                        // DecoratedBox(
                                                        //   decoration: BoxDecoration(
                                                        //     image: DecorationImage(image: AssetImage("assets/images/new_logo.webp"), fit: BoxFit.fill),
                                                        //   ),
                                                        //   child: SizedBox(
                                                        //     width: 50,
                                                        //     height: 50,
                                                        //   ),
                                                        // ),
                                                        DecoratedBox(
                                                          decoration: BoxDecoration(
                                                            image: DecorationImage(image: AssetImage("assets/images/set.png"), fit: BoxFit.fill),
                                                          ),
                                                          child: SizedBox(
                                                            width: 30,
                                                            height: 30,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5, top: 25),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 40,
                                                  width: 110,
                                                  child: TextFormField(
                                                    autofocus: false,
                                                    onChanged: (val) {},
                                                    controller: _unRoomId,
                                                    keyboardType: TextInputType.number,
                                                    cursorColor: Color(0xFF21A27C),
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(color: Color(0xFFffffff), fontSize: 16, fontWeight: FontWeight.bold),
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Color(0x44ffffff),
                                                      prefix: SizedBox(
                                                        width: 0,
                                                      ),
                                                      // prefixIconConstraints: BoxConstraints(),
                                                      // prefix: Text('+91 ',style: TextStyle(fontSize: 14,color: Color(0xff999999)),),
                                                      hintText: '输入房间号',
                                                      hintStyle: TextStyle(color: Color(0xFFdddddd), fontSize: 11),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        borderSide: BorderSide(style: BorderStyle.none),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        borderSide: BorderSide(style: BorderStyle.none),
                                                      ),
                                                      // border: InputBorder.none
                                                    ),
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(20),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 10),
                                                  child: SizedBox(
                                                    child: Icon(
                                                      Icons.arrow_right_alt_rounded,
                                                      color: Colors.white,
                                                      size: 25,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 10),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      if (!checkLogin()) {
                                                        PageLogin().push(context);
                                                        return;
                                                      }
                                                      joinRoom();
                                                    },
                                                    child: Stack(
                                                      alignment: Alignment.center,
                                                      children: [
                                                        DecoratedBox(
                                                          decoration: BoxDecoration(
                                                            image: DecorationImage(image: AssetImage("assets/images/button2.png"), fit: BoxFit.fill),
                                                            borderRadius: BorderRadius.all(Radius.circular(50)),
                                                            boxShadow: [BoxShadow(color: Color(0x99ffffff), blurRadius: 25, offset: Offset(0, 0))],
                                                          ),
                                                          child: SizedBox(
                                                            width: 50,
                                                            height: 50,
                                                            child: Center(
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(bottom: 5.0),
                                                                // child: Text(
                                                                //   '加入房间',
                                                                //   style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xffeeeeee)),
                                                                // ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 30),
                                            child: InkWell(
                                              onTap: () async {
                                                if (!checkLogin()) {
                                                  PageLogin().push(context);
                                                  return;
                                                }
                                                creatRoom();
                                              },
                                              child: Stack(
                                                alignment: Alignment.topLeft,
                                                children: [
                                                  EnterButtonBuild(width: 120,),
                                                  DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(image: AssetImage("assets/images/button4.png"), fit: BoxFit.cover),
                                                      borderRadius: BorderRadius.all(Radius.circular(60)),
                                                      // boxShadow: [BoxShadow(color: Color(0xffeeb202), blurRadius: 33, offset: Offset(0, 0))],
                                                    ),
                                                    child: SizedBox(
                                                      width: 120,
                                                      height: 120,
                                                      child: Center(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(bottom: 5.0),
                                                          // child: Text(
                                                          //   '启动',
                                                          //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffeeeeee)),
                                                          // ),
                                                          // child: EnterButtonBuild(),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              getRightBuild()
                            ],
                          ),
                          getRecordBuild()
                        ],
                      ),
                    ),
                    // getTestBuild(),
                  ],
                ),
              );
            }),
      ),
    );
  }

  getRecordBuild() {
    if (showRecord && finalResultData != null) {
      return FinalResultBuild(
        finalResultData: finalResultData,
        onClose: () async{
          SystemChrome.setPreferredOrientations([
            // 强制竖屏
            DeviceOrientation.portraitUp
          ]);
          setState(() {
            showRecord = false;
            finalResultData = null;
          });
        },
      );
    }
    return SizedBox();
  }

  showFinalResultBuild(record) async {
    var user = context.read<SerUser>();
    var res = await LoadingCall.of(context).call((state, controller) async {
      return await NetWork.gameFinalResult(context, getUserId(), record['game_id']);
    }, isShowLoading: true);

    SystemChrome.setPreferredOrientations([
      // 强制竖屏
      DeviceOrientation.landscapeLeft
    ]);
    finalResultData = res;
    showRecord = true;
    setState(() {});
  }

  getRightBuild() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 20),
        child: DecoratedBox(
          decoration: BoxDecoration(color: Color(0x33000000), borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(color: Color(0x44000000), borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/paiming.png',width: 25,height: 25,),
                      SizedBox(width: 5,),
                      Text(
                        '战绩',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: RefreshLoadingIndicator(
                onRefresh: (type) => _onRefresh(context, type),
                child: Builder(builder: (context) {
                  // return ListView(
                  //   children: [
                  //     SizedBox(
                  //       child: Center(
                  //         child: Padding(
                  //           padding: const EdgeInsets.only(top: 50.0),
                  //           child: Text('游戏记录后续版本开放，尽请期待',style: TextStyle(fontSize: 14,color: Color(0xffcccccc)),),
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // );
                  if (historyList.length == 0) {
                    return ListView(
                      children: [
                        SizedBox(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: Padding(
                                padding: EdgeInsets.only(top: 30),
                                child: InkWell(
                                  onTap: () async {
                                    if (!checkLogin()) {
                                      PageLogin().push(context);
                                      return;
                                    }
                                    creatRoom();
                                  },
                                  child: Column(
                                    children: [
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(image: AssetImage("assets/images/button1.png"), fit: BoxFit.cover),
                                          borderRadius: BorderRadius.all(Radius.circular(60)),
                                          // boxShadow: [BoxShadow(color: Color(0xffeeb202), blurRadius: 33, offset: Offset(0, 0))],
                                        ),
                                        child: SizedBox(
                                          width: 80,
                                          height: 80,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: 5.0),
                                              // child: Text(
                                              //   '启动',
                                              //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffeeeeee)),
                                              // ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text('先战斗一场',style: TextStyle(fontSize: 12,color: Color(0xffdddddd)),)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }
                  return LayoutBuilder(builder: (context, con) {
                    List<Widget> itemBuilds = [];
                    for (var i = 0; i < historyList.length; i++) {
                      var item = historyList[i];
                      var time = item['created_at'];
                      itemBuilds.add(SizedBox(
                        width: (con.maxWidth - 10) / 2,
                        height: 80,
                        child: InkWell(
                          onTap: () {
                            showFinalResultBuild(item);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: item['score'] > 0 ? [Color(0x668fdfb0), Color(0x66006a25)] : [Color(0x66bbbbbb), Color(0x66333333)],
                                ),
                              ),
                              padding: EdgeInsets.only(left: 16, right: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 0, right: 10, top: 0, bottom: 0),
                                    child: Text(
                                      '' + time.toString().replaceAll(' ', '\n'),
                                      style: TextStyle(fontSize: 12, color: item['score'] > 0 ? Color(0xffffffff) : Color(0xffeeeeee)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 0, right: 0, bottom: 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Image.asset(
                                        //   "assets/images/jifen.png",
                                        //   width: 14,
                                        //   height: 14,
                                        // ),
                                        // Padding(
                                        //   padding: const EdgeInsets.only(left: 2.0),
                                        //   child: Text(
                                        //     '+100',
                                        //     maxLines: 1,
                                        //     style: TextStyle(fontSize: 12, color: Color(0xffdddddd)),
                                        //   ),
                                        // ),
                                        Text(
                                          (item['score'] > 0 ? '+' : ''),
                                          style: TextStyle(fontSize: 16, color: item['score'] > 0 ? Color(0xffffffff) : Color(0xffaaaaaa)),
                                        ),
                                        Text(
                                          item['score'].toString(),
                                          maxLines: 1,
                                          style: TextStyle(fontSize: 16, color: item['score'] > 0 ? Color(0xffffffff) : Color(0xffaaaaaa)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ));
                    }
                    return SingleChildScrollView(
                      child: Wrap(
                        spacing: 10.0,
                        children: itemBuilds,
                      ),
                    );
                  });
                  return ListView.builder(
                      itemCount: historyList.length,
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.only(top: 0),
                      itemBuilder: (context, index) {
                        var item = historyList[index];
                        var time = item['created_at'];
                        // time =DateTime.fromMillisecondsSinceEpoch(time*1000).format("yyyy/MM/dd HH:mm:ss");
                        return InkWell(
                          onTap: () {
                            showFinalResultBuild(item);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 10, left: 16, right: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: item['score'] > 0 ? [Color(0xbb8fdfb0), Color(0xbb006a25)] : [Color(0xbbbbbbbb), Color(0xbb333333)],
                                ),
                              ),
                              padding: EdgeInsets.only(left: 16, right: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 5, right: 10, top: 10, bottom: 10),
                                    child: Text(
                                      '' + time.toString(),
                                      style: TextStyle(fontSize: 12, color: item['score'] > 0 ? Color(0xffffffff) : Color(0xffeeeeee)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                    child: Row(
                                      children: [
                                        // Image.asset(
                                        //   "assets/images/jifen.png",
                                        //   width: 14,
                                        //   height: 14,
                                        // ),
                                        // Padding(
                                        //   padding: const EdgeInsets.only(left: 2.0),
                                        //   child: Text(
                                        //     '+100',
                                        //     maxLines: 1,
                                        //     style: TextStyle(fontSize: 12, color: Color(0xffdddddd)),
                                        //   ),
                                        // ),
                                        Text(
                                          (item['score'] > 0 ? '+' : ''),
                                          style: TextStyle(fontSize: 12, color: item['score'] > 0 ? Color(0xffffffff) : Color(0xffaaaaaa)),
                                        ),
                                        Text(
                                          item['score'].toString(),
                                          maxLines: 1,
                                          style: TextStyle(fontSize: 12, color: item['score'] > 0 ? Color(0xffffffff) : Color(0xffaaaaaa)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onRefresh(BuildContext context, OnRefreshType type) async {
    if (OnRefreshType.Refresh == type) {
      _pageIndex = 1;
      await LoadingCall.of(context).call((state, controller) async {
        var res = await NetWork.userGameRecord(context, getUserId(), _pageIndex);
        historyList = res == null ? [] : res['list'];
        // historyList = historyList.reversed.toList();
      }, isShowLoading: false);
      setState(() {});
      return true;
    } else {
      await LoadingCall.of(context).call((state, controller) async {
        var res = await NetWork.userGameRecord(context, getUserId(), _pageIndex);
        historyList.addAll(res['list']);
        _pageIndex += 1;
      }, isShowLoading: false);
      setState(() {});
      return true;
    }
  }

  Future<bool> _onInitLoading(BuildContext context) async {
    await LoadingCall.of(context).call((state, controller) async {
      _pageIndex = 1;
      var res = await NetWork.userGameRecord(context, getUserId(), _pageIndex);
      historyList = res == null ? [] : res['list'];
      // historyList = historyList.reversed.toList();
    }, isShowLoading: false);
    setState(() {});
    return true;
  }
}
