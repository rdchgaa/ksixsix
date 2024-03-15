import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ima2_habeesjobs/page/home/home_first/full_card_build.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:provider/provider.dart';
import 'package:scratcher/scratcher.dart';
import 'dart:math' as math;

///看牌 组件  手动上划看牌
class LookPokerBuildShangla extends StatefulWidget {
  final Function onClose;
  final pokers;
  final Function onDoubleTap;

  final Function(int index) onOpen;

  const LookPokerBuildShangla({
    Key key,
    this.pokers,
    this.onClose,
    this.onDoubleTap,
    this.onOpen,
  }) : super(key: key);

  @override
  _LookPokerBuildShanglaState createState() => _LookPokerBuildShanglaState();
}

class _LookPokerBuildShanglaState extends State<LookPokerBuildShangla> with TickerProviderStateMixin {
  AnimationController _slideController;
  Animation<Offset> _animation;

  Color roomMasterColor = Color(0xffffaf49);

  bool _hide = false;

  var pokerWidth = 110.0;
  var pokerHeight = 110.0 / 5.7 * 8.7;

  bool zhedang1 = true;
  bool zhedang2 = true;
  bool zhedang3 = true;
  bool zhedang4 = true;
  bool zhedang5 = true;

  double zhedangWidth = 14.0;

  Duration duration = Duration(milliseconds: 300);

  int lookingCountdown = 29; //看牌倒计时
  Timer lookingTimer;

  TabController tabController;


  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);

    _slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400))
      ..addListener(() {
        setState(() {});
      });
    _animation = Tween(begin: const Offset(0, 800), end: const Offset(0, 0)).animate(_slideController);
    Future.delayed(Duration(milliseconds: 100), () {
      _slideController.forward();
    });

    initTimer();
  }

  @override
  void dispose() {
    _slideController.dispose();
    if (lookingTimer != null) {
      lookingTimer.cancel();
      lookingTimer = null;
    }
    tabController.dispose();
    tabController = null;
    widget.onClose();
    super.dispose();
  }

  initTimer() {
    if (lookingTimer == null) {
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    if (_hide) {
      return SizedBox();
    }
    var headWidth = 30.0;
    var user = context.watch<SerUser>();
    return Container(
      // width: widget.width,
      // height: height,
      child: Center(
        child: LayoutBuilder(builder: (context, con) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0x99000000),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: tabController,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PokerShanglaItem(index:1,pokers: widget.pokers,height:con.maxHeight,onClose: (){
                        tabController.animateTo(1);
                        widget.onOpen(1);
                      },onDoubleTap:(){
                        widget.onDoubleTap();
                      }),
                      PokerShanglaItem(index:2,pokers: widget.pokers,height:con.maxHeight,onClose: (){
                        tabController.animateTo(2);
                        widget.onOpen(2);
                      },onDoubleTap:(){}),
                      PokerShanglaItem(index:3,pokers: widget.pokers,height:con.maxHeight,onClose: (){
                        tabController.animateTo(3);
                        widget.onOpen(3);
                      },onDoubleTap:(){}),
                      PokerShanglaItem(index:4,pokers: widget.pokers,height:con.maxHeight,onClose: (){
                        tabController.animateTo(4);
                        widget.onOpen(4);
                      },onDoubleTap:(){}),
                      PokerShanglaItem(index:5,pokers: widget.pokers,height:con.maxHeight,onClose: (){
                        // widget.onClose();
                        onClose();
                      },onDoubleTap:(){}),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 20,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0, right: 20),
                    child: InkWell(
                      onTap: () {
                        onClose();
                      },
                      child: Text(
                        '立即查看' + '\n' + lookingCountdown.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
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
          );
        }),
      ),
    );
  }

}



///看牌 组件  手动上划看牌
class PokerShanglaItem extends StatefulWidget {
  final double height;
  final int index;
  final pokers;
  final Function onClose;
  final Function onDoubleTap;
  const PokerShanglaItem({
    Key key,
    this.onClose, this.pokers, this.index, this.height, this.onDoubleTap,
  }) : super(key: key);

  @override
  _PokerShanglaItemState createState() => _PokerShanglaItemState();
}

class _PokerShanglaItemState extends State<PokerShanglaItem> with TickerProviderStateMixin {
  Color roomMasterColor = Color(0xffffaf49);
  bool zhedang = true;

  AnimationController _animationPoker;

  AnimationController _animationPokerRotation ;

  double _dxStart = 0;
  double _dyStart = 0;

  double _dxCha = 0;
  double _dyCha = 0;

  double _dxCha2 = 0;
  double _dyCha2 = 0;

  double _dx = 0;
  double _dy = 0;

  @override
  void initState() {
    super.initState();
    _animationPoker = AnimationController.unbounded(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animationPokerRotation = AnimationController.unbounded(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    var height = widget.height;
    var pokerWidth = height / 8.7 * 5.7 ;
    var h1 = height- (height-pokerWidth)/2;

    _dxCha = 0;
    // _dyCha =  h1-10;

    _dxCha2 = 50;
    _dyCha2 =  h1*2;
    _animationPoker.value = h1;
    _animationPokerRotation.value = 5.0;
  }

  @override
  void dispose() {
    _animationPoker.dispose();
    _animationPokerRotation.dispose();
    super.dispose();
  }


  void _onHorizontalDragStart(DragStartDetails details) {
    var dx = details.localPosition.dx;
    var dy = details.localPosition.dy;
    _dxStart = dx;
    _dyStart = dy;
    setState(() {

    });
  }
  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    var dx = details.localPosition.dx;
    var dy = details.localPosition.dy;

    _dxCha = _dxCha2 + dx - _dxStart;
    _dyCha = _dyCha2 +dy - _dyStart;

    _animationPoker.value = _dyCha/2;
    _animationPokerRotation.value = _dxCha/10;
    setState(() {

    });

    var height = MediaQuery.of(context).size.height;
    var pokerWidth = height / 8.7 * 5.7 ;

    var h1 = height- (height-pokerWidth)/2;

    if(_animationPoker.value<=h1-100){
      setState(() {
        zhedang = false;
      });
    }
    if(_animationPoker.value<=h1-150){

      widget.onClose();
    }
  }
  _onHorizontalDragEnd(DragEndDetails details){
    _dxCha2 = _dxCha;
    _dyCha2 = _dyCha;
    setState(() {

    });
    // HapticFeedback.selectionClick();
    // _animationPoker.animateTo(0,duration: Duration(milliseconds: 500));
  }

  void _resetAnimation() {
    // HapticFeedback.selectionClick();
    // _animationPoker.animateTo(0);
    // setState(() {
    //
    // });
    // HapticFeedback.selectionClick();
    // if (!_isDialogShown) {
    //   _animation.animateTo(0);
    // }
  }

  @override
  Widget build(BuildContext context) {
    var headWidth = 30.0;
    var user = context.watch<SerUser>();
    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      onHorizontalDragCancel: _resetAnimation,
      onDoubleTap: (){
        widget.onDoubleTap();
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0x11000000),
        ),
        child: LayoutBuilder(builder: (context, con) {
          return getPokerBox(widget.index);
        }),
      ),
    );
  }

  getPokerBox(int num) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var pokerWidth = height / 8.7 * 5.7 ;

    var poker = widget.pokers[0];
    if (num == 1) {
      poker = widget.pokers[0];
    } else if (num == 2) {
      poker = widget.pokers[1];
    } else if (num == 3) {
      poker = widget.pokers[2];
    } else if (num == 4) {
      poker = widget.pokers[3];
    } else if (num == 5) {
      poker = widget.pokers[4];
    }
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/zuoshang.png',width: 50,height: 50,),
                    SizedBox(width: 50,),
                    Image.asset('assets/images/youshang.png',width: 50,height: 50,),
                  ],
                ),
              Text('请拉出扑克',style: TextStyle(fontSize: 14,color: Color(0xccffffff)),),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 100,
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '第',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xffeeeeee)),
                      ),
                      Text(
                        num.toString(),
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: roomMasterColor),
                      ),
                      Text(
                        '张排',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xffeeeeee)),
                      ),
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0,_animationPoker.value),
                child: Transform.rotate(
                  angle: _animationPokerRotation.value * math.pi / 180,
                  child: Transform.rotate(
                    angle: 90 * math.pi / 180,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Builder(builder: (context) {
                        return getFullCardBuild(
                          poker['hua_se'],
                          poker['poker_number'],
                          width: pokerWidth,
                          showNum: !zhedang,
                        );
                      }),
                    ),
                  ),
                ),
              ),
              Builder(
                  builder: (context) {
                    var height = widget.height;
                    var pokerWidth = height / 8.7 * 5.7 ;

                    var h1 = height- (height-pokerWidth)/2;
                    return SizedBox(
                      width: 100,
                      child: (num >= 5 || zhedang)
                          ? InkWell(
                        onTap: (){
                          var height = MediaQuery.of(context).size.height;
                          _animationPoker.value = h1;
                          _animationPokerRotation.value = 5 ;
                          setState(() {

                          });
                        },
                            child: SizedBox(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '请',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xffeeeeee)),
                              ),
                              Text(
                                '斜拉',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: roomMasterColor),
                              ),
                              Text(
                                '扑克',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xffeeeeee)),
                              ),
                            ],
                        ),
                      ),
                          )
                          : InkWell(
                        onTap: () {
                          widget.onClose();
                        },
                        child: SizedBox(
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/turn_right.png',
                                width: 25,
                                height: 25,
                                fit: BoxFit.contain,
                                color: Color(0xff00c2c9),
                              ),
                              Text(
                                '下一张',
                                style: TextStyle(fontSize: 14, color: Color(0xff00c2c9)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              ),
            ],
          ),
        ],
      ),
    );
  }

}