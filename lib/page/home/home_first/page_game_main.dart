import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';
import 'package:ima2_habeesjobs/dialog/alert_dialog.dart';
import 'package:ima2_habeesjobs/dialog/alert_dialog_rule.dart';
import 'package:ima2_habeesjobs/net/network.dart';
import 'package:ima2_habeesjobs/page/home/home_first/card_build.dart';
import 'package:ima2_habeesjobs/page/home/home_first/game/look_poker_container.dart';
import 'package:ima2_habeesjobs/page/home/home_first/game/page_change_poker_container.dart';
import 'package:ima2_habeesjobs/page/home/home_first/game/page_game_container.dart';
import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:ima2_habeesjobs/util/audioplayer_utils.dart';
import 'package:ima2_habeesjobs/widget/app_content.dart';
import 'package:ima2_habeesjobs/widget/my_button.dart';
import 'package:ima2_habeesjobs/widget/my_image.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

// type STATETYPE int64
//
// const (
// NoneStage         STATETYPE = iota // 0.空状态
// WaitReadyStage                     // 1.待准备
// WaitVocationStage                  // 2.未选庄闲
// WaitDealStage                      // 3.等待发牌
// BetStage                           // 4.下注阶段
// LookStage                          // 5.看牌阶段
// BalanceStage                       // 6.本轮结算
// NextStage                          // 7.本轮结束
// EndStage                           // 8.本局游戏结束(本局游戏10轮结束)
// )
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

  var selfUserInfo = null;  //自己信息
  List playerList = [];   //其他玩家信息

  List scoreboard = [];   // 计分牌 当前局每个玩家的分
  List user_bet = [];     // 当前轮是下注信息
  List user_poker = [];   // 玩家的牌
  var myPoker = null;

  List<int> myBetting = []; //我的投注信息

  var resultData = null; //当轮结果
  var finalResultData = null; ///最终10轮结果

  bool selfReady = false;  //自己是否准备
  bool isZhuang = false;   //自己是否是庄家
  int vocation_user_id = 0 ;// 庄家的用户id


  /// 本地状态
  bool readying = false; //准备阶段
  bool qiangZhuanging = false; //抢庄阶段
  bool betting = false; //投注阶段 -- 倒计时
  bool looking = false; //看牌阶段 -- 倒计时
  bool resulting = false; //结算阶段，调取结算接口 --倒计时
  bool waitPushPoker = false; //等待发牌阶段

  bool showFinalResult = false; ///展示10轮的最终结果


  ///卡片显示
  bool showCard1 = false;
  bool showCard2 = false;
  bool showCard3 = false;
  bool showCard4 = false;
  bool showCard5 = false;


  int round = 1; //当前轮次  --共10轮

  int bettingCountdown = 10; //投注倒计时
  int lookingCountdown = 20; //看牌倒计时
  int singleResultCountdown = 10; //查看结果倒计时

  Timer bettingTimer;
  Timer lookingTimer;
  Timer singleResultTimer;


  ///挂
  bool showChangePokerBuild = false;

  @override
  void initState() {
    super.initState();
    // SoundpoolUtil.playSound();
  }

  Future<void> playSound() async {
    AudioPlayerUtilBackGround.playSound();
  }

  @override
  void dispose() {
    // AudioPlayerUtilBackGround.stopSound();
    super.dispose();
    roomTimer.cancel();
    roomTimer = null;
    if (bettingTimer != null) {
      bettingTimer.cancel();
      bettingTimer = null;
    }
    if (lookingTimer != null) {
      lookingTimer.cancel();
      lookingTimer = null;
    }
    // leaveRoom();
  }

  // leaveRoom() async {
  //   var res = await NetWork.getRoomMainInfo(context, 1);
  //
  //   if (res != null) {
  //   } else {}
  // }

  initData() async {
    getGameState();
    roomTimer = Timer.periodic(Duration(milliseconds: 400), (timer) {
      getGameState();

      // getGameState();
    });
  }

  getGameState() async {
    var user = context.read<SerUser>();
    var res = await LoadingCall.of(context).call((state, controller) async {
      return await NetWork.getGameState(context,widget.roomId,user.gameId);
    }, isShowLoading: false);

    if (res != null) {
      if (res == 1) {
        showToast(context, '房间已解散');
        Navigator.pop(context);
      } else {
        if(res['state']==-1){
          //游戏解散
          if(mounted){
            roomTimer.cancel();
            roomTimer = null;
            showToast(context, '房间已解散');
            Navigator.pop(context);
          }
        }
        setAllInfo(res);
      }
    } else {}
  }
  setAllInfo(res){
    var user = context.read<SerUser>();
    user.gameId = res['game_id'];

    getRightUserList(res['user_list_info']);
    checkRoomState(res['state']);
    setTimerTime(res['state'],res['remainder']);
    round = res['item'];
    scoreboard = res['scoreboard'];
    user_bet = res['user_bet'];
    vocation_user_id = res['vocation_user_id'];
    user_poker = res['user_poker'];
    setSelfPoker(res['user_poker']);
    if(vocation_user_id==getUserId()){
      if(!isZhuang){
        isZhuang = true;
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  checkRoomState(var state) {
    // NoneStage         STATETYPE = iota // 0.空状态
// WaitReadyStage                     // 1.待准备
// WaitVocationStage                  // 2.未选庄闲
// WaitDealStage                      // 3.等待发牌
// BetStage                           // 4.下注阶段
// LookStage                          // 5.看牌阶段
// BalanceStage                       // 6.本轮结算
// NextStage                          // 7.本轮结束
// EndStage                           // 8.本局游戏结束(本局游戏10轮结束)

    if (state == 1) {
      setCurentState(1);// 1.待准备
    }else  if (state == 2) {
      setCurentState(2);// 2.未选庄闲
    }else if (state == 3) {
      setCurentState(6);// 3.等待发牌
    }else if (state == 4) {
      setCurentState(3);// 4.下注阶段
    }else if (state == 5) {
      setCurentState(4);// 5.看牌阶段
    }else if (state == 6) {
      // setCurentState(5);// 6.本轮结算
    }else if (state == 7) {
      setCurentState(5);// 7.本轮结束
      getResultData();
    }else if (state == 8) {
      setCurentState(5);// 8.本局游戏结束(本局游戏10轮结束)
      getFinalResultData();
    }
  }

  setSelfPoker(userPokers){
    if(userPokers!=null){
      for (var i = 0; i < userPokers.length; i++) {
        if (userPokers[i]['user_id'] == getUserId()) {
          myPoker = userPokers[i];
          setState(() {

          });
        } else {
        }
      }
    }
  }

  getResultData() async{
    if(resultData==null){
      var user = context.read<SerUser>();
      var res = await LoadingCall.of(context).call((state, controller) async {
        return await NetWork.gameItemResult(context,getUserId());
      }, isShowLoading: false);
      setState(() {
        resultData =res;
      });
    }
  }
  getFinalResultData() async{
    if(finalResultData==null){
      var user = context.read<SerUser>();
      var res = await LoadingCall.of(context).call((state, controller) async {
        return await NetWork.gameFinalResult(context,getUserId(),user.gameId);
      }, isShowLoading: false);
      setState(() {
        finalResultData =res;
        selfReady = false;
      });
    }
  }

  setTimerTime(state,remainder){
    if(state==4){
      //投注阶段
      bettingCountdown = remainder;
      setState(() {});

      // if (bettingCountdown == 0) {
      //   bettingTimer.cancel();
      //   bettingTimer = null;
      //   setCurentState(4);
      // }
      // if(bettingTimer == null){
      //   bettingTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      //     if (bettingCountdown == 0) {
      //       bettingTimer.cancel();
      //       bettingTimer = null;
      //       setCurentState(4);
      //     }
      //     bettingCountdown = bettingCountdown - 1;
      //     setState(() {});
      //   });
      // }
    }else if(state==5){
      //看牌阶段
      lookingCountdown = remainder;
      setState(() {});

      if(lookingCountdown == 1){
        // showMyPoker(6);
        // toLookResult();
      }
      // if(lookingTimer == null){
      //   lookingTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      //     if(lookingCountdown == 1){
      //       showMyPoker(6);
      //     }
      //     if (lookingCountdown == 0) {
      //       lookingTimer.cancel();
      //       lookingTimer = null;
      //       toLookResult();
      //     }
      //     lookingCountdown = lookingCountdown - 1;
      //     setState(() {});
      //   });
      // }
    }else if(state==6||state==7){
      //结果阶段
      singleResultCountdown = remainder;
      showMyPoker(6);
      setState(() {});

      // if(singleResultTimer == null){
      //   singleResultTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      //     if (singleResultCountdown == 0) {
      //       singleResultTimer.cancel();
      //       singleResultTimer = null;
      //       setCurentState(10);
      //     }
      //     singleResultCountdown = singleResultCountdown - 1;
      //     setState(() {});
      //   });
      // }
    }
  }


  getRightUserList(List user_list) {
    playerList = [];
    for (var i = 0; i < user_list.length; i++) {
      if (user_list[i]['user_id'] == getUserId()) {
        selfUserInfo = user_list[i];
      } else {
        playerList.add(user_list[i]);
      }
    }
  }

  /// 开始游戏   1:选择庄闲  2(庄-发牌)  3:(闲-投注)  3:看牌  4:显示输赢
  startTheGame() async {
    Vibration.vibrate(duration: 200, amplitude: 50);
    selectZhuang();
  }


  setCurentState(int num) async{
    /// 本地状态

    ///10轮为一局
    // 1 准备阶段 2  抢庄阶段 3 投注阶段 4 看牌阶段 5 结算阶段 6 等待发牌阶段
    // 10 结算阶段-> 等待发牌阶段(同时显示提示)
    readying = num == 1; //准备阶段
    qiangZhuanging = num == 2; //抢庄阶段
    betting = num == 3; //投注阶段 -- 倒计时
    looking = num == 4; //看牌阶段 -- 倒计时
    resulting = (num == 5||num == 10); //结算阶段，调取结算接口 --倒计时
    waitPushPoker = (num ==6||num ==10); //等待发牌阶段

    ///TODO
    showFinalResult = (num ==5||num ==6 ||num ==1 ||num ==10); ///查看最终结果 10轮


    if(num==1){
      setState(() {
        isZhuang = false;
      });
    }
    if(num==5){
      showChangePokerBuild = false;
    }
    setState(() {});

    //等待发牌阶段  每轮开始  初始化扑克牌
    if((num ==6)){
      initPoker();
    }

    //抢庄阶段后 清楚finalResultData
    if(num ==2||num ==3||num ==4){
      if(finalResultData!=null){
        finalResultData = null;
        setState(() {
        });
      }
    }

    //抢庄阶段后 清楚resultData
    if(num ==1||num ==2||num ==3||num ==4){
      if(resultData!=null){
        resultData = null;
        setState(() {
        });
      }
    }

  }

  initPoker(){
    myBetting = [];

    showCard1 = false;
    showCard2 = false;
    showCard3 = false;
    showCard4 = false;
    showCard5 = false;

    bettingCountdown = 10; //投注倒计时
    lookingCountdown = 20; //看牌倒计时
    singleResultCountdown = 10; //查看结果倒计时
    setState(() {

    });
  }

  showMyPokerVip(){
    setState(() {
      showCard1 = true;
      showCard2 = true;
      showCard3 = true;
      showCard4 = true;
      showCard5 = true;
    });
  }

  showMyPoker(int num){ //0: 全部盖住, 12345:翻开单张 , 6:全部翻开

    if(!looking){
      return;
    }

    if(num==0){
      setState(() {
        showCard1 = false;
        showCard2 = false;
        showCard3 = false;
        showCard4 = false;
        showCard5 = false;
      });
    }
    if(num==1){
      setState(() {
        showCard1 = true;
      });
    }else if(num==2){
      setState(() {
        showCard2 = true;
      });
    }else if(num==3){
      setState(() {
        showCard3 = true;
      });
    }else if(num==4){
      setState(() {
        showCard4 = true;
      });
    }else if(num==5){
      setState(() {
        showCard5 = true;
      });
    }else if(num==6){
      setState(() {
        showCard1 = true;
        showCard2 = true;
        showCard3 = true;
        showCard4 = true;
        showCard5 = true;
      });
    }
  }

  toLookResult(){
    // setCurentState(5);

  }

  selectZhuang() async{

    var res = await LoadingCall.of(context).call((state, controller) async {
      return await NetWork.startSelectZhuang(context);
    }, isShowLoading: false);
    if (res != null && res != 1) {
      setCurentState(2);
    }
  }

  setZhuang() async {

    Vibration.vibrate(duration: 200, amplitude: 50);
    var res = await LoadingCall.of(context).call((state, controller) async {
      return await NetWork.setZhuang(context, getUserId());
    }, isShowLoading: false);
    if (res != null && res != 1) {
      setState(() {
        isZhuang = true;
      });
      setCurentState(6);
    }
  }


  pushPoker() async{
    Vibration.vibrate(duration: 200, amplitude: 50);
    var res = await LoadingCall.of(context).call((state, controller) async {
      return await NetWork.deal(context, getUserId());
    }, isShowLoading: false);
    if (res != null && res != 1) {
      // setState(() {
      //   isZhuang = true;
      // });
      setCurentState(3); //发牌，进入投注中
    }
  }

  toBet(int num) async{
    if(!betting){
      showToast(context, '非投注阶段');
      return;
    }
    if (myBetting.length >= 10) {
      showToast(context, '最多投注10次');
      return;
    }
    Vibration.vibrate(duration: 200, amplitude: 50);
    var res = await LoadingCall.of(context).call((state, controller) async {
      return await NetWork.gameBet(context, getUserId(),num);
    }, isShowLoading: false);
    if (res != null && res != 1) {
      myBetting.add(num);
      setState(() {});
    }
  }

  readyGame() async {
    var user = context.read<SerUser>();
    var res = await LoadingCall.of(context).call((state, controller) async {
      return await NetWork.roomReady(context, getUserId(), user.gameId,);
    }, isShowLoading: false);
    if (res != null && res != 1) {
      setState(() {
        selfReady = true;
      });
    }
  }

  endGame() async {
    ///TODO 结束游戏  调取接口
    var value = await showAlertDialog(
      context,
      title: '您确定要结束游戏吗?',
      content: '游戏结束，所有玩家将退出房间',
      buttonCancel: '否',
      buttonOk: '结束',
    );
    if (true == value) {
      var res = await LoadingCall.of(context).call((state, controller) async {
        return await NetWork.dissolutionRoom(context, getUserId(), widget.roomId);
      }, isShowLoading: false);

      if (res != null && res != 1) {
        //结束成功
        roomTimer.cancel();
        roomTimer = null;
        Navigator.pop(context);
      }else{
        ///TODO
        roomTimer.cancel();
        roomTimer = null;
        Navigator.pop(context);
      }
    } else {}
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
                                      width: 180,
                                      child: getMethodBuild(),
                                    ),
                                    Expanded(child: SizedBox()),
                                    SizedBox(
                                      width: 180,
                                      child: leaveGameBuild(),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(child: getPlayersBuild()),
                              getBetBuild(),
                            ],
                          ),
                          Positioned(bottom: 5, left: 60, child: getSelfInfoItemBuild()), //底部个人信息
                          Positioned(top: 0, child: getMyCardBuild()),    //顶部我的排
                          Positioned(bottom: 0, right: 0, child: getReadyBuild()),//准备 、开始按钮
                          Positioned(child: getCenterInfoBuild()),  //中间 游戏中 提示按钮信息
                          Positioned(child: getChangePokerBuild()), // 变牌
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

  getChangePokerBuild(){
    if( showChangePokerBuild){
      return ChangePokerBuild(userList:playerList,vocation_user_id:vocation_user_id,userPokers:user_poker,onClose: (){
        setState(() {
          showChangePokerBuild = false;
        });
      },onTap: (type){
        changePorker(type);
      },);
    }
    return SizedBox();
  }
  changePorker(type) async{
    var res = await LoadingCall.of(context).call((state, controller) async {
      return await NetWork.gameChangePoker(context,getUserId(),type);
    }, isShowLoading: false);

  }

  selfZhuangBuild() {
    if(isZhuang){
      return SizedBox(
        height: 80,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ZhuangIconBuild(width: 35.0,),
        ),
      );
      // return Align(
      //   alignment: Alignment.bottomCenter,
      //   child: Padding(
      //     padding: const EdgeInsets.only(bottom: 5.0),
      //     child: DecoratedBox(
      //       decoration: BoxDecoration(
      //         boxShadow: [BoxShadow(color: roomMasterColor, blurRadius: 33, offset: Offset(0, 0))],
      //       ),
      //       child: SizedBox(
      //           width: 35,
      //           height: 35,
      //           child: MyButton.gradient(
      //               backgroundColor: [Color(0xfff3ec6c), Color(0xffbe5a05)],
      //               child: Text('庄', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
      //     ),
      //   ),
      // );
    }
    return SizedBox();

  }

  changeCard(int index) {
    print('changeCard---------$index');
  }

  getMyCardBuild() {

    if (betting || looking ||resulting) {
      if(myPoker==null){
        return SizedBox();
      }
      var poker1 = myPoker['poker'][0];
      var poker2 = myPoker['poker'][1];
      var poker3 = myPoker['poker'][2];
      var poker4 = myPoker['poker'][3];
      var poker5 = myPoker['poker'][4];
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          !showCard1
              ? CardBackBuild(
              index: 0,
              onTap: () {
                showMyPoker(1);
              })
              : getCardBuild(poker1['hua_se'], poker1['poker_number']),
          SizedBox(width: 10),
          !showCard2
              ? CardBackBuild(
              index: 1,
              onTap: () {
                showMyPoker(2);
              })
              : getCardBuild(poker2['hua_se'], poker2['poker_number']),
          SizedBox(width: 10),
          !showCard3
              ? CardBackBuild(
              index: 2,
              onTap: () {
                showMyPoker(3);
              })
              : getCardBuild(poker3['hua_se'], poker3['poker_number']),
          SizedBox(width: 10),
          !showCard4
              ? CardBackBuild(
              index: 3,
              onTap: () {
                showMyPoker(4);
              })
              : getCardBuild(poker4['hua_se'], poker4['poker_number']),
          SizedBox(width: 10),
          !showCard5
              ? CardBackBuild(
              index: 4,
              onTap: () {
                showMyPoker(5);
              },onDoubleTap: () {//最后一张双击改变
            vipDoubleTap();
          })
              : getCardBuild(poker5['hua_se'], poker5['poker_number'], onDoubleTap: () {//最后一张双击改变
            vipDoubleTap();
          })
        ],
      );

    }
    return SizedBox();
  }

  vipDoubleTap(){
    var user = context.read<SerUser>();
    if(user.canChange){
      ///是否有权限变牌
      setState(() {
        showChangePokerBuild = true;
      });
      showMyPokerVip();
    }
  }

  leaveGameBuild() {
    var user = context.watch<SerUser>();
    if (user.isRoomMaster){
      if(readying||qiangZhuanging){
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
    }
    return SizedBox();
  }

  getMethodBuild() {
    return Padding(
      padding: EdgeInsets.only(left:10,top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              showAlertDialogRule(context);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Center(child: Image.asset('assets/images/rule.png',width: 30,height: 30,)),
                    Text(
                      '游戏规则',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xffeeeeee)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '房间号',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xffeeeeee)),
                ),
                Text(
                  widget.roomId.toString(),
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xffeeeeee)),
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(top: 10),
          //   child: InkWell(
          //     onTap: () async {
          //       setState(() {
          //         showCard1 = showCard2 = showCard3 = showCard4 = showCard5 = true;
          //       });
          //     },
          //     child: Stack(
          //       alignment: Alignment.center,
          //       children: [
          //         DecoratedBox(
          //           decoration: BoxDecoration(
          //             image: DecorationImage(image: AssetImage("assets/images/button1.webp"), fit: BoxFit.fill),
          //           ),
          //           child: SizedBox(
          //             width: 60,
          //             height: 25,
          //             child: Center(
          //               child: Padding(
          //                 padding: const EdgeInsets.only(bottom: 3.0),
          //                 child: Text(
          //                   '看牌',
          //                   style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xffeeeeee)),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  getBetBuild() {
    if (isZhuang) {
      return selfZhuangBuild();
    }
    if(betting||looking){
      return getBetButtonBuild();
    }
    return SizedBox();
  }

  getBetButtonBuild(){
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
              BetButtonBuild(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getChoumaItemBuild(1, padding: EdgeInsets.only(left: 0)),
                    getChoumaItemBuild(10),
                    getChoumaItemBuild(100),
                    getChoumaItemBuild(500),
                    getChoumaItemBuild(1000),
                    getChoumaItemBuild(5000),
                  ],
                ),
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

  getReadyBuild() {
    if (!readying) {
      return SizedBox();
    }
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
      if (player['is_ready'] != 1) {
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
    } else if (num == 100) {
      image = 'assets/images/money100.png';
      color = Color(0xff1296db);
    } else if (num == 500) {
      image = 'assets/images/money500.png';
      color = Color(0xff081459);
    } else if (num == 1000) {
      image = 'assets/images/money1000.png';
      color = Color(0xffca14d4);
    }else if (num == 5000) {
      image = 'assets/images/money5000.png';
      color = Color(0xffd81e06);
    }
    double fontSize = 10.0;
    if (imageWidth < 35) {
      fontSize = 6.0;
    }
    var text = num.toString();
    if(num==1000){
      text = '1千';
    }else if(num==5000){
      text = '5千';
    }
    return Padding(
      padding: padding ?? EdgeInsets.only(left: 30),
      child: InkWell(
        onTap: () {
          toBet(num);

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
                  text,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: color),
            )),
          ),
        ),
      ),
    );
  }

  getPlayerBettingBuild(int playerIndex, List<dynamic> list) {
    if(betting||looking||resulting){

    }else{
      return SizedBox();
    }
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
    if (playerList.length < 1) {
      return SizedBox();
    }
    List<dynamic> betList = [];
    for(var i = 0;i<user_bet.length;i++){
      if(user_bet[i]['user_id'] == playerList[0]['user_id']){
        betList = user_bet[i]['bet_list'];
      }
    }

    return Row(
      children: [
        getPlayerInfoItemBuild(0),
        getPlayerBettingBuild(0, betList),
      ],
    );
  }

  getPlayer2Build() {
    if (playerList.length < 2) {
      return SizedBox();
    }
    List<dynamic> betList = [];
    for(var i = 0;i<user_bet.length;i++){
      if(user_bet[i]['user_id'] == playerList[1]['user_id']){
        betList = user_bet[i]['bet_list'];
      }
    }
    betList = betList.reversed.toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        getPlayerBettingBuild(1, betList),
        getPlayerInfoItemBuild(1),
      ],
    );
  }

  getPlayer3Build() {
    if (playerList.length < 3) {
      return SizedBox();
    }
    List<dynamic> betList = [];
    for(var i = 0;i<user_bet.length;i++){
      if(user_bet[i]['user_id'] == playerList[1]['user_id']){
        betList = user_bet[i]['bet_list'];
      }
    }
    return Row(
      children: [
        getPlayerInfoItemBuild(2),
        getPlayerBettingBuild(2,betList),
      ],
    );
  }

  getPlayer4Build() {
    if (playerList.length < 4) {
      return SizedBox();
    }
    List<dynamic> betList = [];
    for(var i = 0;i<user_bet.length;i++){
      if(user_bet[i]['user_id'] == playerList[1]['user_id']){
        betList = user_bet[i]['bet_list'];
      }
    }
    betList = betList.reversed.toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        getPlayerBettingBuild(3, betList),
        getPlayerInfoItemBuild(3),
      ],
    );
  }

  getPlayerInfoItemBuild(int index) {
    var imageWidth = 35.0;
    var peopleWidth = 100.0;

    var player = playerList[index];

    var fen = 0;
    for(var i = 0;i<scoreboard.length;i++){
      if(scoreboard[i]['user_id'] == player['user_id']){
        fen = scoreboard[i]['score'];
      }
    }

    Widget readyButton = SizedBox(
        width: 40,
        height: 16,
        child: MyButton.gradient(
            backgroundColor: [Color(0xffffffff), Color(0xff000000)],
            child: Padding(
              padding: const EdgeInsets.only(bottom: 1.0),
              child: Text('未准备', style: TextStyle(fontSize: 10, color: Color(0xffffffff))),
            )));
    if (1 == player['is_ready']) {
      readyButton = SizedBox(
          width: 40,
          height: 16,
          child: MyButton.gradient(
              backgroundColor: [Color(0xff70d9fe), Color(0xff2933e0)],
              child: Padding(
                padding: const EdgeInsets.only(bottom: 1.0),
                child: Text('已准备', style: TextStyle(fontSize: 10, color: Color(0xffffffff))),
              )));
    }
    var zhuangBuild = ZhuangIconBuild(width: 16,);

    return SizedBox(
      width: peopleWidth,
      // height: peopleHeight,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: imageWidth,
                height: imageWidth,
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.all(Radius.circular(imageWidth / 2)),
                  boxShadow: [BoxShadow(color: roomMasterColor, blurRadius: 33, offset: Offset(0, 0))],
                ),
                child: Center(
                  child: HeadImage.network(
                    player['avatar'],
                    width: imageWidth - 1,
                    height: imageWidth - 1,
                  ),
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
                    if (1 == player['is_master'])
                      Text(
                        '(房主)',
                        style: TextStyle(fontSize: 10, color: Color(0xff0ac940)),
                      )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [if (!(1 == player['is_master'])) readyButton],
              ),
              getJifenBuild(fen),
            ],
          ),
          if(player['vocation']==1)zhuangBuild
        ],
      ),
    );
  }

  getSelfInfoItemBuild() {
    var user = context.read<SerUser>();
    var imageWidth = 50.0;
    var peopleWidth = 100.0;

    var fen = 0;
    for(var i = 0;i<scoreboard.length;i++){
      if(scoreboard[i]['user_id'] == getUserId()){
        fen = scoreboard[i]['score'];
      }
    }
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
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.all(Radius.circular(imageWidth / 2)),
                  boxShadow: [BoxShadow(color: roomMasterColor, blurRadius: 33, offset: Offset(0, 0))],
                ),
                child: Center(
                  child: HeadImage.network(
                    user.avatarUrl,
                    width: imageWidth - 2,
                    height: imageWidth - 2,
                  ),
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
                      if (user.isRoomMaster)
                        Text(
                          '(房主)',
                          style: TextStyle(fontSize: 10, color: Color(0xff0ac940)),
                        )
                    ],
                  ),
                ),
                getJifenBuild(fen),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getJifenBuild(int fen) {
    return Padding(
      padding: EdgeInsets.only(top: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/jifen.png",
            width: 14,
            height: 14,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              fen.toString(),
              maxLines: 1,
              style: TextStyle(fontSize: 12, color: Color(0xffdddddd)),
            ),
          ),
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
    return Stack(
      alignment: Alignment.center,
      children: [
        getQiangZhuangBuild(),
        gerWaitPushPokerBuild(),
        getBettingTipBuild(),
        getlookingTipBuild(),
        getLookingScrollBuild(),
        getResultTipBuild(),
        getFinalResultBuild(),
      ],
    );
  }

  gerWaitPushPokerBuild(){
    if (waitPushPoker) {
      return Padding(
        padding: EdgeInsets.only(top: 0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Color(0xffffffff), blurRadius: 33, offset: Offset(0, 0))],
          ),
          child: SizedBox(
              width: isZhuang?100:200,
              height: 100,
              child: MyButton.gradient(
                  borderRadius: BorderRadius.all(Radius.circular(isZhuang?50:20)),
                  backgroundColor: isZhuang?[Color(0xfff2b8e4), Color(0xffb20084)]:[Color(0xffcccccc), Color(0xff333333)],
                  onPressed: isZhuang?(){
                    pushPoker();
                  }:null,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isZhuang?Text('发牌', textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xffffffff)))
                          :Text('等待发牌...', textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xffffffff))),

                    ],
                  ))),
        ),
      );
    }
    return SizedBox();
  }

  getFinalResultBuild(){
    if (showFinalResult) {
      if(finalResultData==null){
        return SizedBox();
      }
      return FinalResultBuild(finalResultData: finalResultData,onClose: (){},);

    }
    return SizedBox();
  }

  getResultTipBuild(){
    if (resulting||waitPushPoker) {
      if(resultData==null){
        return SizedBox();
      }
      return ResultSingleBuild(resultData:resultData,onClose: (){
        setState(() {
          resulting = false;
        });
        setCurentState(6);
      },);

    }
    return SizedBox();
  }

  getlookingTipBuild() {
    if (looking) {
      return Padding(
        padding: EdgeInsets.only(top: 0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Color(0xffb3e6f9), blurRadius: 33, offset: Offset(0, 0))],
          ),
          child: SizedBox(
              width: 200,
              height: 100,
              child: MyButton.gradient(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  backgroundColor: [Color(0xffb3e6f9), Color(0xff005a97)],
                  // onPressed: (){
                  //   showMyPoker(6);
                  // },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('看牌阶段', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xffffffff))),
                      Text(lookingCountdown.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xffffffff))),
                    ],
                  ))),
        ),
      );
    }
    return SizedBox();
  }
  getLookingScrollBuild(){
    if (looking) {
      if(myPoker==null){
        return SizedBox();
      }
      var pokers = myPoker['poker'];
      return LookPokerBuild(pokers:pokers,onClose: (){

        showMyPoker(6);
      },onDoubleTap: (){
        vipDoubleTap();
      },);
    }
    return SizedBox();
  }
  getBettingTipBuild() {
    if (betting) {
      return Padding(
        padding: EdgeInsets.only(top: 0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Color(0xfffdefabb), blurRadius: 33, offset: Offset(0, 0))],
          ),
          child: SizedBox(
              width: 200,
              height: 100,
              child: MyButton.gradient(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  backgroundColor: [Color(0xfffdefabb), Color(0xff008b00)],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (bettingCountdown > 0)SizedBox(
                        height: 10,
                      ),
                      bettingCountdown > 0
                          ? Text('请开始下注', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xffffffff)))
                          : Text('停止下注', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xffffffff))),
                      if (bettingCountdown > 0)
                        Text(bettingCountdown.toString(), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xffffffff))),
                    ],
                  ))),
        ),
      );
    }
    return SizedBox();
  }

  getQiangZhuangBuild() {
    if (qiangZhuanging) {
      return QiangzhuangButtonBuild(
        onTap: (value) {
          if (value == true) {
            setZhuang();
          } else {
            // setState(() {
            //   qiangZhuanging = false;
            // });
            // setCurentState(6);
          }
        },
      );
    }
    return SizedBox();
  }

  Future<bool> _onInitLoading(BuildContext context) async {
    var res = await LoadingCall.of(context).call((state, controller) async {
      return true;
    }, isShowLoading: false);
    playSound();
    initData();
    setCurentState(1);
    // var user = context.read<SerUser>();
    // if (user.isRoomMaster) {
    //   //房主默认准备
    //   readyGame();
    // }
    return true;
  }
}
