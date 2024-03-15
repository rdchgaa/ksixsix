import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ima2_habeesjobs/page/home/home_first/full_card_build.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:provider/provider.dart';
import 'package:scratcher/scratcher.dart';

///看牌 组件  手动上划看牌
class LookPokerBuildGuakai extends StatefulWidget {
  final Function onClose;
  final pokers;
  final Function onDoubleTap;

  final Function(int index) onOpen;

  const LookPokerBuildGuakai({
    Key key,
    this.pokers,
    this.onClose,
    this.onDoubleTap,
    this.onOpen,
  }) : super(key: key);

  @override
  _LookPokerBuildGuakaiState createState() => _LookPokerBuildGuakaiState();
}

class _LookPokerBuildGuakaiState extends State<LookPokerBuildGuakai> with TickerProviderStateMixin {
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
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: tabController,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onDoubleTap: widget.onDoubleTap,
                            child: getPokerBox(1),
                          ),
                          getPokerBox(2),
                          getPokerBox(3),
                          getPokerBox(4),
                          getPokerBox(5),
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
              ),
            );
          }),
        ),
      ),
    );
  }

  getPokerBox(int num) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var pokerWidth = height / 8.7 * 5.7 - 50;

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
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
              // child: (num <= 1)
              //     ? SizedBox()
              //     : InkWell(
              //         onTap: () {
              //           var index = 0;
              //           if (num == 3) {
              //             index = 1;
              //           } else if (num == 4) {
              //             index = 2;
              //           } else if (num == 5) {
              //             index = 3;
              //           }
              //           tabController.animateTo(index);
              //         },
              //         child: SizedBox(
              //           width: 100,
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Image.asset(
              //                 'assets/images/turn_left.png',
              //                 width: 25,
              //                 height: 25,
              //                 fit: BoxFit.contain,
              //                 color: Color(0xff00c2c9),
              //               ),
              //               Text(
              //                 '上一张',
              //                 style: TextStyle(fontSize: 14, color: Color(0xff00c2c9)),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Builder(builder: (context) {
                return Scratcher(
                  brushSize: 25,
                  threshold: 50,
                  image: Image.asset(
                    'assets/images/cardback.png',
                    fit: BoxFit.fill,
                  ),
                  onChange: (value) {
                    if(num<5){
                      if(value>=80){
                          tabController.animateTo(num);
                      }
                    }
                    if (value >= 50) {
                      widget.onOpen(num);
                      if (num == 1) {
                        setState(() {
                          zhedang1 = false;
                        });
                      } else if (num == 2) {
                        setState(() {
                          zhedang2 = false;
                        });
                      } else if (num == 3) {
                        setState(() {
                          zhedang3 = false;
                        });
                      } else if (num == 4) {
                        setState(() {
                          zhedang4 = false;
                        });
                      } else if (num == 5) {
                        setState(() {
                          zhedang5 = false;
                        });
                      }
                    }
                  },
                  onThreshold: () => print("Threshold reached, you won!"),
                  child: getFullCardBuild(
                    poker['hua_se'],
                    poker['poker_number'],
                    width: pokerWidth,
                    showNum: num == 1 ? !zhedang1 : num == 2 ? !zhedang2 :num == 3 ? !zhedang3:num == 4 ? !zhedang4 :num == 5 ? !zhedang5 :false,
                  ),
                );
              }),
            ),
            Builder(
              builder: (context) {
                bool showNext = false;
                if (num == 1) {
                  if(zhedang1 == false){
                    showNext = true;
                  }
                } else if (num == 2) {
                  if(zhedang2 == false){
                    showNext = true;
                  }
                } else if (num == 3) {
                  if(zhedang3 == false){
                    showNext = true;
                  }
                } else if (num == 4) {
                  if(zhedang4 == false){
                    showNext = true;
                  }
                } else if (num == 5) {
                  if(zhedang5 == false){
                    showNext = true;
                  }
                }
                return SizedBox(
                  width: 100,
                  child: (num >= 5 || !showNext)
                      ? SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '请',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xffeeeeee)),
                        ),
                        Text(
                          '刮开',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: roomMasterColor),
                        ),
                        Text(
                          '牌面',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xffeeeeee)),
                        ),
                      ],
                    ),
                  )
                      : InkWell(
                          onTap: () {
                            tabController.animateTo(num);
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
      ),
    );
  }

  getPoker1() {
    var poker = widget.pokers[0];
    return ListView(
      // controller: controller1,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: 0),
      children: [
        getPokerNullBoxBuild(),
        Center(
            child: Stack(
          children: [
            getFullCardBuild(poker['hua_se'], poker['poker_number'], width: pokerWidth),
            if (zhedang1)
              Positioned(
                  top: 6,
                  left: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Color.fromRGBO(246, 246, 246, 1)),
                    child: SizedBox(
                      width: zhedangWidth,
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
                      width: zhedangWidth,
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
                'assets/images/turn_left.png',
                width: 25,
                height: 25,
                fit: BoxFit.contain,
                color: Color(0xff00c2c9),
              ),
              Text(
                '滑动卡片',
                style: TextStyle(fontSize: 14, color: Color(0xff00c2c9)),
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
}
