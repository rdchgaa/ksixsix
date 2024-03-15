import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ima2_habeesjobs/page/home/home_first/full_card_build.dart';
import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:ima2_habeesjobs/util/audioplayer_utils.dart';
import 'package:ima2_habeesjobs/widget/my_button.dart';
import 'package:provider/provider.dart';
import 'package:scratcher/scratcher.dart';

///看牌 组件  手动上划看牌
class GameSetContainer extends StatefulWidget {
  final Function onClose;
  final pokers;
  final Function onDoubleTap;

  final Function(int index) onOpen;

  final Function onExit;

  const GameSetContainer({
    Key key,
    this.pokers,
    this.onClose,
    this.onDoubleTap,
    this.onOpen, this.onExit,
  }) : super(key: key);

  @override
  _GameSetContainerState createState() => _GameSetContainerState();
}

class _GameSetContainerState extends State<GameSetContainer> with TickerProviderStateMixin {
  AnimationController _slideController;
  Animation<Offset> _animation;

  Color roomMasterColor = Color(0xffffaf49);

  bool _hide = false;

  Duration duration = Duration(milliseconds: 300);

  bool voiceOpen = true;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400))
      ..addListener(() {
        setState(() {});
      });
    _animation = Tween(begin: const Offset(-1500, 0), end: const Offset(0, 0)).animate(_slideController);
    Future.delayed(Duration(milliseconds: 100), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    widget.onClose();
    super.dispose();
  }

  onClose() async {
    await _slideController.reverse();
    _hide = true;
    widget.onClose();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_hide) {
      return SizedBox();
    }
    var headWidth = 30.0;
    var user = context.watch<SerUser>();
    return LayoutBuilder(builder: (context, con) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: con.maxWidth * 0.35,
          height: con.maxHeight,
          child: Transform.translate(
            offset: _animation.value,
            child: Align(
              alignment: Alignment.centerLeft,
              child: LayoutBuilder(builder: (context, con) {
                return InkWell(
                  onTap: () {
                    onClose();
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xaa000000),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 50,right: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Color(0xffc6f68d), Color(0xff0259ee)],
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: 50,
                                      height: 30,
                                      child: Center(
                                        child: Text(
                                    '音乐',
                                    style: TextStyle(fontSize: 12, color: Color(0xffffffff)),
                                  ),
                                      ))),
                              CupertinoSwitch(
                                // 当前 switch 的开关
                                value: voiceOpen,
                                // 点击或者拖拽事件
                                onChanged: (value){
                                  voiceOpen = value;
                                  if(value){
                                    AudioPlayerUtilBackGround.playSound();
                                  }else{
                                    AudioPlayerUtilBackGround.stopSound();
                                  }
                                  setState(() {

                                  });
                                },
                              )
                            ],
                          ),
                          Divider(height: 20,color: Color(0xaaffffff),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(6)),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Color(0x99c6f68d), Color(0xff0259ee)],
                                    ),
                                  ),
                                  child: SizedBox(
                                      width: 80,
                                      height: 30,
                                      child: Center(
                                        child: Text(
                                          '搓牌效果',
                                          style: TextStyle(fontSize: 12, color: Color(0xffffffff)),
                                        ),
                                      ))),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                              onTap: (){
                                setCuopaiType(1);
                              },
                                child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(30)),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: getCuopaiType()==1?[Color(0xffe1fdee), Color(0xff00a72a),Color(0xfff33caa)]:[Color(0xccffffff), Color(0xcc000000)],
                                      ),
                                    ),
                                    child: SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: Center(
                                          child: Text(
                                            '刮开',
                                            style: TextStyle(fontSize: 12, color: Color(0xffffffff)),
                                          ),
                                        ))),
                              ),
                              SizedBox(width: 20,),
                              InkWell(
                                onTap: (){
                                  setCuopaiType(2);
                                },
                                child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(30)),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: getCuopaiType()==2?[Color(0xffe1fdee), Color(0xff00a72a),Color(0xfff33caa)]:[Color(0xccffffff), Color(0xcc000000)],
                                      ),
                                    ),
                                    child: SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: Center(
                                          child: Text(
                                            '左滑',
                                            style: TextStyle(fontSize: 12, color: Color(0xffffffff)),
                                          ),
                                        ))),
                              ),
                              SizedBox(width: 20,),
                              InkWell(
                                onTap: (){
                                  setCuopaiType(3);
                                },
                                child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(30)),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: getCuopaiType()==3?[Color(0xffe1fdee), Color(0xff00a72a),Color(0xfff33caa)]:[Color(0xccffffff), Color(0xcc000000)],
                                      ),
                                    ),
                                    child: SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: Center(
                                          child: Text(
                                            '搓角',
                                            style: TextStyle(fontSize: 12, color: Color(0xffffffff)),
                                          ),
                                        ))),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Text(
                            '(更多搓牌效果，持续更新中)',
                            style: TextStyle(fontSize: 12, color: Color(0xccffffff)),
                          ),
                          Divider(height: 20,color: Color(0xaaffffff),),
                          Spacer(),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Builder(
                              builder: (context) {
                                var user = context.watch<SerUser>();
                                return Padding(
                                  padding: EdgeInsets.only(top: 0, left: 0,right: 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        child: Padding(
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
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          widget.onClose();
                                          widget.onExit();
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SizedBox(
                                                width: 80,
                                                height: 35,
                                                child: MyButton.gradient(
                                                    backgroundColor: [Color(0xff918ea9), Color(0xff21143f)],
                                                    child: Text(user.isRoomMaster?'结束游戏':'退出游戏', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xffffffff)))))
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 50,)
                                    ],
                                  ),
                                );
                              }
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      );
    });
  }
}
