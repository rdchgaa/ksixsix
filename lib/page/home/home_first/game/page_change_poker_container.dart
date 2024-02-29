import 'dart:async';

import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';
import 'package:ima2_habeesjobs/net/network.dart';
import 'package:ima2_habeesjobs/page/home/home_first/card_build.dart';
import 'package:ima2_habeesjobs/page/home/home_first/game/page_game_container.dart';
import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:ima2_habeesjobs/util/language.dart';
import 'package:ima2_habeesjobs/util/other.dart';
import 'package:ima2_habeesjobs/util/soundpool_Util.dart';
import 'package:ima2_habeesjobs/widget/app_bar.dart';
import 'package:ima2_habeesjobs/widget/app_content.dart';
import 'package:ima2_habeesjobs/widget/my_button.dart';
import 'package:ima2_habeesjobs/widget/my_image.dart';
import 'package:ima2_habeesjobs/widget/ui_tabbar.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

///变牌
class ChangePokerBuild extends StatefulWidget {
  final userList;
  final vocation_user_id;
  final userPokers;
  final Function(int num) onTap;
  final Function onClose;
  const ChangePokerBuild({
    Key key,
    this.userPokers, this.onTap, this.onClose, this.userList, this.vocation_user_id,
  }) : super(key: key);

  @override
  _ChangePokerBuildState createState() => _ChangePokerBuildState();
}

class _ChangePokerBuildState extends State<ChangePokerBuild> with TickerProviderStateMixin {
  AnimationController _slideController;
  Animation<Offset> _animation;

  Color roomMasterColor = Color(0xffffaf49);

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });
    _animation = Tween(begin: const Offset(0, -500), end: const Offset(0, 0)).animate(_slideController);
    Future.delayed(Duration(milliseconds: 100), () {
      _slideController.forward();
    });
  }

  onClose() async {
    await _slideController.reverse();
    widget.onClose();
    setState(() {});
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var itemWidth = 60.0;
    var itemHieght = 40.0;
    var fontSize = 14.0;

    var niuColors = [Color(0xffc4e9c8), Color(0xff006610)];
    return Container(
      child: Transform.translate(
        offset: _animation.value,
        child: Center(
          child: LayoutBuilder(builder: (context, con) {
            return InkWell(
              onTap: () {
                onClose();
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0x33000000),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () {},
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xcc075383),Color(0xcc011826)],
                            ),
                            // color: Color(0xcc555555),
                            boxShadow: [BoxShadow(color: Color(0x99555555), blurRadius: 33, offset: Offset(0, 0))],
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: Color(0xffffffff), width: 2)),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            SizedBox(
                              width: con.maxWidth * 0.7,
                              height: con.maxHeight * 0.7,
                              child: DefaultTabController(
                                initialIndex: 0,
                                length: 2,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 48,
                                      width: double.infinity,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: UiTabBar(tabs: [
                                          Tab(text: '功能'),
                                          Tab(text: '看牌'),
                                        ]),
                                      ),
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        children: <Widget>[
                                          getButtonListBuild(),
                                          getPokerListBuild(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0, right: 5),
                              child: InkWell(
                                onTap: () {
                                  onClose();
                                },
                                child: SizedBox(
                                  width: 35,
                                  height: 35,
                                  child: Icon(
                                    Icons.close,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  getButtonListBuild(){
    var itemWidth = 60.0;
    var itemHieght = 40.0;
    var fontSize = 14.0;

    var niuColors = [Color(0xffc4e9c8), Color(0xff006610)];
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                  width: itemWidth,
                  height: itemHieght,
                  child: MyButton.gradient(
                      backgroundColor: [Color(0xffc6515c), Color(0xff56041e)],
                      onPressed: () {
                        widget.onTap(1);
                      },
                      child: Text('炸弹', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
              SizedBox(
                  width: itemWidth,
                  height: itemHieght,
                  child: MyButton.gradient(
                      backgroundColor: [Color(0xffffccce), Color(0xffc80000)],
                      onPressed: () {
                        widget.onTap(2);
                      },
                      child: Text('五小', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
              SizedBox(
                  width: itemWidth,
                  height: itemHieght,
                  child: MyButton.gradient(
                      backgroundColor: [Color(0xfff3df6a), Color(0xff937008)],
                      onPressed: () {
                        widget.onTap(3);
                      },
                      child: Text('金牛', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
              SizedBox(
                  width: itemWidth,
                  height: itemHieght,
                  child: MyButton.gradient(
                      backgroundColor: [Color(0xffe1e1e1), Color(0xff403f3f)],
                      onPressed: () {
                        widget.onTap(4);
                      },
                      child: Text('银牛', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
              SizedBox(
                  width: itemWidth,
                  height: itemHieght,
                  child: MyButton.gradient(
                      backgroundColor: [Color(0xff92caf0), Color(0xff084993)],
                      onPressed: () {
                        widget.onTap(5);
                      },
                      child: Text('牛牛', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
              // SizedBox(
              //     width: itemWidth,
              //     height: itemHieght,
              //     child: MyButton.gradient(
              //         backgroundColor: [Color(0xff666666), Color(0xff666666)],
              //         onPressed: () {
              //           widget.onTap(7);
              //         },
              //         child: Text('没牛', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),

            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                  width: itemWidth,
                  height: itemHieght,
                  child: MyButton.gradient(
                      backgroundColor: niuColors,
                      onPressed: () {
                        widget.onTap(61);
                      },
                      child: Text('牛1', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
              SizedBox(
                  width: itemWidth,
                  height: itemHieght,
                  child: MyButton.gradient(
                      backgroundColor: niuColors,
                      onPressed: () {
                        widget.onTap(62);
                      },
                      child: Text('牛2', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
              SizedBox(
                  width: itemWidth,
                  height: itemHieght,
                  child: MyButton.gradient(
                      backgroundColor: niuColors,
                      onPressed: () {
                        widget.onTap(63);
                      },
                      child: Text('牛3', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
              SizedBox(
                  width: itemWidth,
                  height: itemHieght,
                  child: MyButton.gradient(
                      backgroundColor: niuColors,
                      onPressed: () {
                        widget.onTap(64);
                      },
                      child: Text('牛4', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
              SizedBox(
                  width: itemWidth,
                  height: itemHieght,
                  child: MyButton.gradient(
                      backgroundColor: niuColors,
                      onPressed: () {
                        widget.onTap(65);
                      },
                      child: Text('牛5', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                  width: itemWidth,
                  height: itemHieght,
                  child: MyButton.gradient(
                      backgroundColor: niuColors,
                      onPressed: () {
                        widget.onTap(66);
                      },
                      child: Text('牛6', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
              SizedBox(
                  width: itemWidth,
                  height: itemHieght,
                  child: MyButton.gradient(
                      backgroundColor: niuColors,
                      onPressed: () {
                        widget.onTap(67);
                      },
                      child: Text('牛7', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
              SizedBox(
                  width: itemWidth,
                  height: itemHieght,
                  child: MyButton.gradient(
                      backgroundColor: niuColors,
                      onPressed: () {
                        widget.onTap(68);
                      },
                      child: Text('牛8', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
              SizedBox(
                  width: itemWidth,
                  height: itemHieght,
                  child: MyButton.gradient(
                      backgroundColor: niuColors,
                      onPressed: () {
                        widget.onTap(69);
                      },
                      child: Text('牛9', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
              SizedBox(
                width: itemWidth,
                height: itemHieght,
              )
            ],
          ),
        ],
      ),
    );
  }
  getPokerListBuild(){
    return SingleItemContainer(userList:widget.userList,vocation_user_id:widget.vocation_user_id,userPokers:widget.userPokers);
  }
}


///当轮结果 组件
class SingleItemContainer extends StatefulWidget {
  final userList;
  final vocation_user_id;
  final userPokers;
  const SingleItemContainer({
    Key key, this.userPokers, this.userList, this.vocation_user_id,
  }) : super(key: key);

  @override
  _SingleItemContainerState createState() => _SingleItemContainerState();
}

class _SingleItemContainerState extends State<SingleItemContainer> with AutomaticKeepAliveClientMixin {
  Color roomMasterColor = Color(0xffffaf49);

  @override
  void initState() {
    super.initState();
  }

  onClose() async {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var headWidth = 30.0;
    var user = context.watch<SerUser>();
    var zhuangResult = null;
    var playerPokers = [];
    for(var i = 0 ;i<widget.userPokers.length;i++){
      if(widget.userPokers[i]['user_id']==widget.vocation_user_id){
        zhuangResult = widget.userPokers[i];
      }else{
        playerPokers.add(widget.userPokers[i]);
      }
    }
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 8, left: 8.0, right: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          getZhuangPlayerItemBuild(zhuangResult),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if(playerPokers.length>=1)getPlayerItem1Build(playerPokers[0]),
                  if(playerPokers.length>=2)getPlayerItem2Build(playerPokers[1]),
                ],
              ),
              // if(false)
              if(playerPokers.length>=3)Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if(playerPokers.length>=3)getPlayerItem3Build(playerPokers[2]),
                    if(playerPokers.length>=4)getPlayerItem4Build(playerPokers[3]),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  getZhuangPlayerItemBuild(var resultItem) {
    var headWidth = 40.0;
    var user = context.watch<SerUser>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0.0, right: 8.0, top: 2, bottom: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        width: headWidth,
                        height: headWidth,
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          borderRadius: BorderRadius.all(Radius.circular(headWidth / 2)),
                        ),
                        child: Center(
                          child: HeadImage.network(
                            resultItem['avatar'],
                            width: headWidth - 1,
                            height: headWidth - 1,
                          ),
                        ),
                      ),
                      if (true)
                        DecoratedBox(
                          decoration: BoxDecoration(
                            boxShadow: [BoxShadow(color: roomMasterColor, blurRadius: 33, offset: Offset(0, 0))],
                          ),
                          child: SizedBox(
                              width: 16,
                              height: 16,
                              child: MyButton.gradient(
                                  backgroundColor: [Color(0xfff3ec6c), Color(0xffbe5a05)],
                                  child: Text('庄', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
                        )
                    ],
                  ),
                  SizedBox(
                    width: 70,
                    height: 15,
                    child: Center(
                      child: Text(
                        resultItem['nick_name'].toString(),
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                        style: TextStyle(fontSize: 12, color: Color(0xffdddddd)),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 0),
                child: getPokersBuild(resultItem['poker'],width: 35),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: getNiuTypeIcon(resultItem['poker_result']),
              ),
            ],
          ),
        ),
      ],
    );
  }

  getPlayerItem1Build(var resultItem) {
    var isSelf = false;
    if(resultItem['user_id']==getUserId()){
      isSelf = true;
    }
    return DecoratedBox(
      decoration: isSelf
          ? BoxDecoration(border: Border.all(width: 1, color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(10)), color: Color(0x22ffffff))
          : BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0, right: 8.0, top: 2, bottom: 2),
        child: Row(
          children: [
            getHeadBuild(resultItem),
            Padding(
              padding: EdgeInsets.only(left: 0),
              child: getPokersBuild(resultItem['poker']),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: getNiuTypeIcon(resultItem['poker_result']),
            ),
          ],
        ),
      ),
    );
  }

  getPlayerItem2Build(var resultItem) {
    var isSelf = false;
    if(resultItem['user_id']==getUserId()){
      isSelf = true;
    }
    return DecoratedBox(
      decoration: isSelf
          ? BoxDecoration(border: Border.all(width: 1, color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(10)), color: Color(0x22ffffff))
          : BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 0.0, top: 2, bottom: 2),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: getNiuTypeIcon(resultItem['poker_result']),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: getPokersBuild(resultItem['poker']),
            ),
            Padding(
              padding: EdgeInsets.only(left: 0),
              child: getHeadBuild(resultItem),
            ),
          ],
        ),
      ),
    );
  }

  getPlayerItem3Build(var resultItem) {
    var isSelf = false;
    if(resultItem['user_id']==getUserId()){
      isSelf = true;
    }
    return DecoratedBox(
      decoration: isSelf
          ? BoxDecoration(border: Border.all(width: 1, color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(10)), color: Color(0x22ffffff))
          : BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0, right: 8.0, top: 2, bottom: 2),
        child: Row(
          children: [
            getHeadBuild(resultItem),
            Padding(
              padding: EdgeInsets.only(left: 0),
              child: getPokersBuild(resultItem['poker']),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: getNiuTypeIcon(resultItem['poker_result']),
            ),
          ],
        ),
      ),
    );
  }

  getPlayerItem4Build(var resultItem) {
    var isSelf = false;
    if(resultItem['user_id']==getUserId()){
      isSelf = true;
    }
    return DecoratedBox(
      decoration: isSelf
          ? BoxDecoration(border: Border.all(width: 1, color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(10)), color: Color(0x22ffffff))
          : BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 0.0, top: 2, bottom: 2),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: getNiuTypeIcon(resultItem['poker_result']),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: getPokersBuild(resultItem['poker']),
            ),
            Padding(
              padding: EdgeInsets.only(left: 0),
              child: getHeadBuild(resultItem),
            ),
          ],
        ),
      ),
    );
  }

  getHeadBuild(var resultItem) {
    var headWidth = 30.0;
    var user = context.watch<SerUser>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: headWidth,
              height: headWidth,
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.all(Radius.circular(headWidth / 2)),
              ),
              child: Center(
                child: HeadImage.network(
                  resultItem['avatar'],
                  width: headWidth - 1,
                  height: headWidth - 1,
                ),
              ),
            ),
            if (false)
              DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: roomMasterColor, blurRadius: 33, offset: Offset(0, 0))],
                ),
                child: SizedBox(
                    width: 16,
                    height: 16,
                    child: MyButton.gradient(
                        backgroundColor: [Color(0xfff3ec6c), Color(0xffbe5a05)],
                        child: Text('庄', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
              )
          ],
        ),
        SizedBox(
          width: 50,
          height: 15,
          child: Text(
            resultItem['nick_name'].toString(),
            maxLines: 1,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Color(0xffdddddd)),
          ),
        ),
      ],
    );
  }

  getPokersBuild(var pokers ,{double width = 28}) {
    var lineWidth = 5.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getCardBuild(pokers[0]['hua_se'], pokers[0]['poker_number'], width: width),
        SizedBox(
          width: lineWidth,
        ),
        getCardBuild(pokers[1]['hua_se'], pokers[1]['poker_number'], width: width),
        SizedBox(
          width: lineWidth,
        ),
        getCardBuild(pokers[2]['hua_se'], pokers[2]['poker_number'], width: width),
        SizedBox(
          width: lineWidth,
        ),
        getCardBuild(pokers[3]['hua_se'], pokers[3]['poker_number'], width: width),
        SizedBox(
          width: lineWidth,
        ),
        getCardBuild(pokers[4]['hua_se'], pokers[4]['poker_number'], width: width),
      ],
    );
  }


  @override
  bool get wantKeepAlive => true;
}
