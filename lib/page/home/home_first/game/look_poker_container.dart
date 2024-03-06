import 'dart:async';

import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';
import 'package:ima2_habeesjobs/net/network.dart';
import 'package:ima2_habeesjobs/page/home/home_first/card_build.dart';
import 'package:ima2_habeesjobs/page/home/home_first/full_card_build.dart';
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

///看牌 组件  手动上划看牌
class LookPokerBuild extends StatefulWidget {
  final Function onClose;
  final pokers;
  final Function onDoubleTap;

  const LookPokerBuild({
    Key key,
    this.pokers,
    this.onClose, this.onDoubleTap,
  }) : super(key: key);

  @override
  _LookPokerBuildState createState() => _LookPokerBuildState();
}

class _LookPokerBuildState extends State<LookPokerBuild> with TickerProviderStateMixin {
  AnimationController _slideController;
  Animation<Offset> _animation;

  Color roomMasterColor = Color(0xffffaf49);

  bool _hide = false;

  var pokerWidth = 110.0;
  var pokerHeight = 110.0 / 5.7 * 8.7;

  ScrollController controller1 = ScrollController();
  ScrollController controller2 = ScrollController();
  ScrollController controller3 = ScrollController();
  ScrollController controller4 = ScrollController();
  ScrollController controller5 = ScrollController();

  bool zhedang1 = true;
  bool zhedang2 = true;
  bool zhedang3 = true;
  bool zhedang4 = true;
  bool zhedang5 = true;

  double zhedangWidth = 14.0;

  Duration duration= Duration(milliseconds: 300);

  int lookingCountdown = 19; //看牌倒计时
  Timer lookingTimer;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400))
      ..addListener(() {
        setState(() {});
      });
    _animation = Tween(begin: const Offset(0, 800), end: const Offset(0, 0)).animate(_slideController);
    Future.delayed(Duration(milliseconds: 100), () {
      _slideController.forward();
    });

    controller1.addListener(ScrollListener1);
    controller2.addListener(ScrollListener2);
    controller3.addListener(ScrollListener3);
    controller4.addListener(ScrollListener4);
    controller5.addListener(ScrollListener5);

    initTimer();

  }

  @override
  void dispose() {
    _slideController.dispose();
    controller1.removeListener(ScrollListener1());
    controller2.removeListener(ScrollListener2());
    controller3.removeListener(ScrollListener3());
    controller4.removeListener(ScrollListener4());
    controller5.removeListener(ScrollListener5());
    if (lookingTimer != null) {
      lookingTimer.cancel();
      lookingTimer = null;
    }
    widget.onClose();
    super.dispose();

  }

  initTimer(){
    if(lookingTimer == null){
      lookingTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
        if (lookingCountdown == 0) {
          lookingTimer.cancel();
          lookingTimer = null;
          onClose();
        }
        lookingCountdown = lookingCountdown - 1;
        setState(() {});
      });
    }
  }
  onClose() async {
    await _slideController.reverse();
    _hide = true;
    widget.onClose();
    setState(() {});
  }

  ScrollListener1(){
    if(controller1.offset>=(pokerWidth/2)){
      // controller1.removeListener(ScrollListener1());
      controller1.animateTo(controller1.position.maxScrollExtent, duration: duration, curve: Curves.linear);
      setState(() {
        zhedang1 = false;
      });
    }
  }
  ScrollListener2(){
    if(controller2.offset>=(pokerWidth/2)){
      // controller1.removeListener(ScrollListener1());
      controller2.animateTo(controller2.position.maxScrollExtent, duration: duration, curve: Curves.linear);
      setState(() {
        zhedang2 = false;
      });
    }
  }
  ScrollListener3(){
    if(controller3.offset>=(pokerWidth/2)){
      // controller1.removeListener(ScrollListener1());
      controller3.animateTo(controller3.position.maxScrollExtent, duration: duration, curve: Curves.linear);
      setState(() {
        zhedang3 = false;
      });
    }
  }
  ScrollListener4(){
    if(controller4.offset>=(pokerWidth/2)){
      // controller1.removeListener(ScrollListener1());
      controller4.animateTo(controller4.position.maxScrollExtent, duration: duration, curve: Curves.linear);
      setState(() {
        zhedang4 = false;
      });
    }
  }
  ScrollListener5(){
    if(controller5.offset>=(pokerWidth/2)){
      // controller1.removeListener(ScrollListener1());
      controller5.animateTo(controller5.position.maxScrollExtent, duration: duration, curve: Curves.linear);
      setState(() {
        zhedang5 = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hide) {
      return SizedBox();
    }
    var headWidth = 30.0;
    var user = context.watch<SerUser>();
    return Container(
      // width: widget.width,
      // height: height,
      child: Transform.translate(
        offset: _animation.value,
        child: Center(
          child: LayoutBuilder(builder: (context, con) {
            return InkWell(
              onTap: () {
                // onClose();
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0x55000000),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getPokerBox(1),
                          getPokerBox(2),
                          getPokerBox(3),
                          getPokerBox(4),

                          InkWell(
                            onDoubleTap: widget.onDoubleTap,
                            child: getPokerBox(5),
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      bottom: 10,right: 10,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0, right: 20),
                        child: InkWell(
                          onTap: () {
                            onClose();
                          },
                          child: Text('立即翻开'+'\n'+lookingCountdown.toString(),textAlign:TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 14),),
                          // child: SizedBox(
                          //   width: 35,
                          //   height: 35,
                          //   child: Icon(
                          //     Icons.close,
                          //     size: 20,
                          //     color: Colors.white,
                          //   ),
                          // ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
  getPokerBox(int num){
    return Padding(
      padding: EdgeInsets.only(left:10,top:10 ,bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xcc0f7357),Color(0xcc011713)],
            ),
            // color: Color(0xcc555555),
            boxShadow: [BoxShadow(color: Color(0xffeeb202), blurRadius: 33, offset: Offset(0, 0))],
            borderRadius: BorderRadius.all(Radius.circular(6)),
            border: Border.all(color: Color(0xffb68a08), width: 2)),
        child: SizedBox(
          width: pokerWidth,
          height: pokerHeight+0,
          // child: getCardBuild(0,1,width: itemWidth),
          child: num==1?getPoker1():num==2?getPoker2():num==3?getPoker3():num==4?getPoker4():num==5?getPoker5():SizedBox(),
        ),
      ),
    );
  }

  getPoker1(){
    var poker = widget.pokers[0];
    return ListView(
      controller: controller1,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: 0),
      children: [
        getPokerNullBoxBuild(),
        Center(child: Stack(
          children: [
            getFullCardBuild(poker['hua_se'], poker['poker_number'],width: pokerWidth),
            if(zhedang1)Positioned(
                top: 6,left: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color.fromRGBO(246, 246, 246, 1)),
                  child: SizedBox(width: zhedangWidth,height: 40,),
                )),
            if(zhedang1)Positioned(
                right: 0,bottom: 6,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color.fromRGBO(246, 246, 246, 1)),
                  child: SizedBox(width: zhedangWidth,height: 40,),
                )),
          ],
        ))
      ],
    );
  }
  getPoker2(){
    var poker = widget.pokers[1];
    return ListView(
      controller: controller2,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: 0),
      children: [
        getPokerNullBoxBuild(),
        Center(child: Stack(
          children: [
            getFullCardBuild(poker['hua_se'], poker['poker_number'],width: pokerWidth),
            if(zhedang2)Positioned(
                top: 6,left: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color.fromRGBO(246, 246, 246, 1)),
                  child: SizedBox(width: zhedangWidth,height: 40,),
                )),
            if(zhedang2)Positioned(
                right: 0,bottom: 6,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color.fromRGBO(246, 246, 246, 1)),
                  child: SizedBox(width: zhedangWidth,height: 40,),
                )),
          ],
        ))
      ],
    );
  }
  getPoker3(){
    var poker = widget.pokers[2];
    return ListView(
      controller: controller3,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: 0),
      children: [
        getPokerNullBoxBuild(),
        Center(child: Stack(
          children: [
            getFullCardBuild(poker['hua_se'], poker['poker_number'],width: pokerWidth),
            if(zhedang3)Positioned(
                top: 6,left: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color.fromRGBO(246, 246, 246, 1)),
                  child: SizedBox(width: zhedangWidth,height: 40,),
                )),
            if(zhedang3)Positioned(
                right: 0,bottom: 6,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color.fromRGBO(246, 246, 246, 1)),
                  child: SizedBox(width: zhedangWidth,height: 40,),
                )),
          ],
        ))
      ],
    );
  }
  getPoker4(){
    var poker = widget.pokers[3];
    return ListView(
      controller: controller4,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: 0),
      children: [
        getPokerNullBoxBuild(),
        Center(child: Stack(
          children: [
            getFullCardBuild(poker['hua_se'], poker['poker_number'],width: pokerWidth),
            if(zhedang4)Positioned(
                top: 6,left: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color.fromRGBO(246, 246, 246, 1)),
                  child: SizedBox(width: zhedangWidth,height: 40,),
                )),
            if(zhedang4)Positioned(
                right: 0,bottom: 6,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color.fromRGBO(246, 246, 246, 1)),
                  child: SizedBox(width: zhedangWidth,height: 40,),
                )),
          ],
        ))
      ],
    );
  }
  getPoker5(){
    var poker = widget.pokers[4];
    return ListView(
      controller: controller5,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: 0),
      children: [
        getPokerNullBoxBuild(),
        Center(child: Stack(
          children: [
            getFullCardBuild(poker['hua_se'], poker['poker_number'],width: pokerWidth),
            if(zhedang5)Positioned(
                top: 6,left: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color.fromRGBO(246, 246, 246, 1)),
                  child: SizedBox(width: 15,height: 40,),
                )),
            if(zhedang5)Positioned(
                right: 0,bottom: 6,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color.fromRGBO(246, 246, 246, 1)),
                  child: SizedBox(width: 15,height: 40,),
                )),
          ],
        ))
      ],
    );
  }

  getPokerNullBoxBuild(){
    return Row(
      children: [
        SizedBox(
          width: pokerWidth,
          height: pokerHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/zuola.png',width: 40,height: 40,fit: BoxFit.contain,),
              Text('拉出扑克',style: TextStyle(fontSize: 16,color: Color(0xffe19b4b)),),
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
}
