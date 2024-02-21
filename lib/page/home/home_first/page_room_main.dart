import 'dart:async';

import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';
import 'package:ima2_habeesjobs/net/network.dart';
import 'package:ima2_habeesjobs/page/home/home_first/page_game_main.dart';
import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:ima2_habeesjobs/util/language.dart';
import 'package:ima2_habeesjobs/util/navigator.dart';
import 'package:ima2_habeesjobs/util/other.dart';
import 'package:ima2_habeesjobs/util/soundpool_Util.dart';
import 'package:ima2_habeesjobs/widget/app_bar.dart';
import 'package:ima2_habeesjobs/widget/app_content.dart';
import 'package:ima2_habeesjobs/widget/my_image.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class PageRoomMain extends StatefulWidget {
  final int roomId;
  const PageRoomMain({
    Key key, this.roomId,
  }) : super(key: key);

  @override
  _PageRoomMainState createState() => _PageRoomMainState();
}

class _PageRoomMainState extends State<PageRoomMain> {

  Color roomMasterColor = Color(0xffffaf49);

  Color playerColor = Color(0x66ffffff);

  Timer roomTimer = null;

  List userList = [];

  int homeowner = -1;

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
    // exitRoom();
  }

  initData(){
    getRoomState();
    roomTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      getRoomState();
    });
  }
  getRoomState() async{
    var res = await LoadingCall.of(context).call((state, controller) async {
      return await NetWork.getRoomMainInfo(context,widget.roomId);
    }, isShowLoading: false);

    if (res!=null) {
      if(res==1){
        showToast(context, '房间已解散');
        Navigator.pop(context);
      }else{
        await setRoomInfo(res);
        checkRoomState(res['state']);
      }
    } else {
    }
  }

  setRoomInfo(var res){
    getRightUserList(res['user_list']);
    homeowner = res['homeowner'];
    if(mounted){
      setState(() {

      });
    }
  }


  getRightUserList(List user_list){
    userList = [];
    for(var i = 0 ;i<user_list.length;i++){
      if(user_list[i]['user_id']==getUserId()){
      }else{
        userList.add(user_list[i]);
      }
    }
  }

  checkRoomState(int state){
    /// 房主 [ 0:不可开始(玩家未准备，房间人数小于2) 1:可以开始，全部准备(人数>1) ]
    /// 其他 [ 2：开始中  3:进入游戏(包括房主) ]
    /// 当房主收到状态 1（可以开始）点击开始房间状态值会变成 3， 所有人就会收到房间状态3  进行游戏
    if(state==3){
      enterTheGame();
    }
  }


  enterTheGame({bool clickStart = false}) async{
    if(userList.length<1){
      showToast(context, '等待好友进入房间');
      // return ;
    }
    roomTimer.cancel();
    roomTimer = null;
    setState(() {
    });

    if(clickStart){
      var res = await LoadingCall.of(context).call((state, controller) async {
        return await NetWork.roomToGameStart(context,getUserId(),widget.roomId);
      }, isShowLoading: false);
      if(res==null||res==1){
        initData();
        return;
      }
    }

    Vibration.vibrate(duration: 200, amplitude: 50);
    await PageGameMain(roomId: widget.roomId,).push(context);
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
                  'assets/images/home.png',
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                ),
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
                                      exitRoom();
                                    },
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
                                          user.isRoomMaster?'解散房间':'离开房间',
                                          style: TextStyle(fontSize: 16, color: Color(0xffeeeeee)),
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
                                            decoration: BoxDecoration(
                                              boxShadow: [BoxShadow(color:user.isRoomMaster?roomMasterColor: playerColor, blurRadius: 33, offset: Offset(0, 0))],
                                            ),
                                            child: HeadImage.network(
                                              user.info.avatar ?? '',
                                              width: 80,
                                              height: 80,
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
                                                if(user.isRoomMaster)Text(' (房主)',style: TextStyle(fontSize: 14,color: roomMasterColor),)
                                              ],
                                            )
                                          ),
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
                                    if(user.isRoomMaster)InkWell(
                                      onTap: () {
                                        enterTheGame(clickStart:true);
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
                                              '房间号：'+widget.roomId.toString(),
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
          }
        ),
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
                userList.length<1?emptyPeopleItem():peopleItem(userList[0]),
                userList.length<2?Padding(padding: const EdgeInsets.only(left: 100.0),child: emptyPeopleItem()):Padding(
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
                  userList.length<3?emptyPeopleItem():peopleItem(userList[2]),
                  userList.length<4?Padding(padding: const EdgeInsets.only(left: 100.0),child: emptyPeopleItem()):Padding(
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

  peopleItem(item){
    var imageWidth = 70.0;
    return Column(
      children: [
        Container(
          width: imageWidth,
          height: imageWidth,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: item['user_id']==homeowner?roomMasterColor:playerColor, blurRadius: 33, offset: Offset(0, 0))],
          ),
          child: HeadImage.network(
            '',
            width: imageWidth,
            height: imageWidth,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Text(item['nick_name'],style: TextStyle(fontSize: 16,color: Color(0xffdddddd)),),
              if(item['user_id']==homeowner)Text(' (房主)',style: TextStyle(fontSize: 14,color: roomMasterColor),)
            ],
          ),
        ),
      ],
    );
  }

  emptyPeopleItem(){
    var imageWidth= 80.00;
    return InkWell(
      onTap: (){
        Clipboard.setData(ClipboardData(text: '12345'));
        showToast(context, '复制房间号成功，请发送给您的牌友');
      },
      child: Container(
        width: imageWidth,
        height: imageWidth,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: playerColor, blurRadius: 33, offset: Offset(0, 0))],
          color: Color(0xaaffffff),
          borderRadius: BorderRadius.all(Radius.circular(imageWidth/2)),
        ),
        child: Center(child: Text('+',style: TextStyle(fontSize: 50,color: Color(0xffffaf49)),)),

      ),
    );
  }

  Future<bool> _onInitLoading(BuildContext context) async {
    initData();
    return true;
  }

}
