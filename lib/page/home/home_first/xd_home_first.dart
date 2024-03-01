import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';
import 'package:ima2_habeesjobs/dialog/alert_dialog_update.dart';
import 'package:ima2_habeesjobs/net/network.dart';
import 'package:ima2_habeesjobs/page/home/home_first/game/page_game_container.dart';
import 'package:ima2_habeesjobs/page/home/home_first/page_room_main.dart';
import 'package:ima2_habeesjobs/page/login/page_login.dart';
import 'package:ima2_habeesjobs/page/my/page_set_up.dart';
import 'package:ima2_habeesjobs/page/my/page_xd_edit_info.dart';
import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:ima2_habeesjobs/util/audioplayer_utils.dart';
import 'package:ima2_habeesjobs/util/datetime.dart';
import 'package:ima2_habeesjobs/util/navigator.dart';
import 'package:ima2_habeesjobs/util/other.dart';
import 'package:ima2_habeesjobs/util/soundpool_Util.dart';
import 'package:ima2_habeesjobs/widget/app_content.dart';
import 'package:ima2_habeesjobs/widget/my_image.dart';
import 'package:ima2_habeesjobs/widget/refresh_loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

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
  @override
  void initState() {
    super.initState();
    // SoundpoolUtil.playSound();
    SystemChrome.setPreferredOrientations([
      // 强制竖屏
      DeviceOrientation.landscapeLeft
    ]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  creatRoom() async{
    if(!checkCanUse()){
      return;
    }
    var res = await LoadingCall.of(context).call((state, controller) async {
      return await NetWork.getCreatRoom(context,getUserId());
    }, isShowLoading: true);
    if(res!=null){
      var user = context.read<SerUser>();
      user.isRoomMaster = true;
      goRoom(res['room_Id']);
    }
  }
  joinRoom() async{
    if(!checkCanUse()){
      return;
    }
    var res = await LoadingCall.of(context).call((state, controller) async {
      return await NetWork.getJoinRoom(context,getUserId(),int.tryParse(_unRoomId.text)??0);
    }, isShowLoading: true);
    if(res!=null){
      var user = context.read<SerUser>();
      user.isRoomMaster = false;
      goRoom(res['room_Id']);
    }
  }
  goRoom(int roomId)async{
    if(checkCanUse()){
      hideTextInput();
      await PageRoomMain(roomId: roomId,).push(context);
      var user = context.read<SerUser>();
      user.gameId = null;
      hideTextInput();
      leaveRoom(roomId);
    }
  }

  leaveRoom(int roomId) async{
    var user = context.read<SerUser>();
    var res = await LoadingCall.of(context).call((state, controller) async {
      if(user.isRoomMaster){
        user.isRoomMaster = false;
        return await NetWork.dissolutionRoom(context,getUserId(),roomId);
      }else{
        user.isRoomMaster = false;
        return await NetWork.leaveRoom(context,getUserId(),roomId);
      }
    }, isShowLoading: true);
    if (res!=null) {
    } else {
    }
  }

  bool checkCanUse(){
    if(DateTime(2024,4,1).millisecondsSinceEpoch<DateTime.now().millisecondsSinceEpoch){
      ///TODO 请更新或下载新版本后使用
      showToast(context, '请更新或下载新版本后使用。');
      showAlertDialogUpdate(context,enterType: 2);
      return false;
    }
    return true;
  }
  bool checkLogin(){
    if((getUserId() == null || getUserId() == 0)){
      return false;
    }
    return true;
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
                  child: Stack(
                    children: [
                      Row(
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
                                      Padding(
                                        padding: EdgeInsets.only(left:5),
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
                                            children: [
                                              Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: Color(0xffffffff),
                                                  borderRadius: BorderRadius.all(Radius.circular(50 / 2)),
                                                  boxShadow: [BoxShadow(color: Color(0xaaffffff), blurRadius: 33, offset: Offset(0, 0))],
                                                ),
                                                child: Center(
                                                  child: HeadImage.network(
                                                    user.info.avatar ?? '',
                                                    width: 50-1.0,
                                                    height: 50-1.0,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 15),
                                                child: Text(
                                                  checkLogin() ? (user.nickname):'登录/注册',
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
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left:5,top: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
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
                                                style: TextStyle(color: Color(0xFFffffff), fontSize: 16,fontWeight: FontWeight.bold),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Color(0x22ffffff),
                                                  prefix: SizedBox(width: 0,),
                                                  // prefixIconConstraints: BoxConstraints(),
                                                  // prefix: Text('+91 ',style: TextStyle(fontSize: 14,color: Color(0xff999999)),),
                                                  hintText: '输入房间号',
                                                  hintStyle: TextStyle(color: Color(0xFFCCCCCC), fontSize: 11),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                                    borderSide: BorderSide(style: BorderStyle.none),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(30)),
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
                                              child: InkWell(
                                                onTap: () async{
                                                  if(!checkLogin()){
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
                                                        image: DecorationImage(image: AssetImage("assets/images/button1.webp"), fit: BoxFit.fill),
                                                      ),
                                                      child: SizedBox(
                                                        width: 120,
                                                        height: 45,
                                                        child: Center(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(bottom: 5.0),
                                                            child: Text(
                                                              '加入房间',
                                                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xffeeeeee)),
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
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: InkWell(
                                          onTap: () async {
                                            if(!checkLogin()){
                                              PageLogin().push(context);
                                              return;
                                            }
                                            creatRoom();
                                          },
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              DecoratedBox(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(image: AssetImage("assets/images/button1.webp"), fit: BoxFit.fill),
                                                ),
                                                child: SizedBox(
                                                  width: 250,
                                                  height: 65,
                                                  child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(bottom: 5.0),
                                                      child: Text(
                                                        '创建房间',
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
                                  ),
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left:5,bottom: 20.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 10.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(image: AssetImage("assets/images/new_logo.webp"), fit: BoxFit.fill),
                                                    ),
                                                    child: SizedBox(
                                                      width: 50,
                                                      height: 50,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 5.0),
                                                    child: Text(
                                                      'K牛牛',
                                                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xffffffff)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(bottom:30,right:0,child: InkWell(
                                        onTap: () async{
                                          // AudioPlayerUtilBackGround.playSound();
                                          await PageSetUp().push(context);
                                          // AudioPlayerUtilBackGround.stopSound();
                                        },
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(image: AssetImage("assets/images/set.png"), fit: BoxFit.fill),
                                          ),
                                          child: SizedBox(
                                            width: 25,
                                            height: 25,
                                          ),
                                        ),
                                      ),)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(child: getRightBuild())
                        ],
                      ),
                      getRecordBuild()
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
  getRecordBuild(){
    if(showRecord&&finalResultData!=null){
      return FinalResultBuild(finalResultData: finalResultData,onClose: (){
        setState(() {
          showRecord = false;
          finalResultData = null;
        });
      },);
    }
    return SizedBox();
  }

  showFinalResultBuild(record) async{
    var user = context.read<SerUser>();
    var res = await LoadingCall.of(context).call((state, controller) async {
      return await NetWork.gameFinalResult(context,getUserId(),record['game_id']);
    }, isShowLoading: true);
    finalResultData = res;
    showRecord = true;
    setState(() {

    });
  }

  getRightBuild() {
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 20, top: 10, bottom: 20),
      child: DecoratedBox(
        decoration: BoxDecoration(color: Color(0x33000000), borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
              child: Text(
                '游戏记录',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Expanded(
                child: RefreshLoadingIndicator(
                  onRefresh: (type) => _onRefresh(context, type),
                  child: Builder(
                    builder: (context) {
                      if(historyList.length==0){
                        return ListView(
                          children: [
                            SizedBox(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 50.0),
                                  child: Text('暂无记录，先玩一局吧',style: TextStyle(fontSize: 14,color: Color(0xffcccccc)),),
                                ),
                              ),
                            )
                          ],
                        );
                      }
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
                                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), color: Color(0xFF131530)),
                                  padding: EdgeInsets.only(left: 16, right: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                                        child: Text(
                                          '时间：'+time.toString(),
                                          style: TextStyle(fontSize: 12, color: Color(0xffeeeeee)),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
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
                                              '结果：',
                                              style: TextStyle(fontSize: 12, color: Color(0xffeeeeee)),
                                            ),
                                            Text(
                                              item['score'].toString(),
                                              maxLines: 1,
                                              style: TextStyle(fontSize: 12, color: Color(0xffdddddd)),
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
                    }
                  ),
                ))
          ],
        ),
      ),
    );
  }


  Future<bool> _onRefresh(BuildContext context, OnRefreshType type) async {
    if (OnRefreshType.Refresh == type) {
      await LoadingCall.of(context).call((state, controller) async {
        var res = await NetWork.userGameRecord(context,getUserId());
        historyList = res??[];
        historyList = historyList.reversed.toList();
        _pageIndex = 1;
      }, isShowLoading: false);
      setState(() {});
      return true;
    } else {
      await LoadingCall.of(context).call((state, controller) async {
        // var res = await NetWork.userGameRecord(context,getUserId());
        // historyList.addAll(res.recordList);
        // _pageIndex += 1;
      },isShowLoading: false);
      setState(() {});
      return true;
    }
  }

  Future<bool> _onInitLoading(BuildContext context) async {
    await LoadingCall.of(context).call((state, controller) async {
      var res = await NetWork.userGameRecord(context,getUserId());
      historyList = res??[];
      historyList = historyList.reversed.toList();
      _pageIndex = 1;
    }, isShowLoading: false);
    setState(() {});
    return true;
  }

}
