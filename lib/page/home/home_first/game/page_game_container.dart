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

///扑克牌入场卡片
class CardBackBuild extends StatefulWidget {
  final Function onTap;
  final double width;
  final int index;

  const CardBackBuild({
    Key key,
    this.onTap,
    this.width = 50,
    this.index = 0,
  }) : super(key: key);

  @override
  _CardBackBuildState createState() => _CardBackBuildState();
}

class _CardBackBuildState extends State<CardBackBuild> with TickerProviderStateMixin {
  AnimationController _slideController;
  Animation<Offset> _animation;

  @override
  void initState() {
    _slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        setState(() {});
      });
    _animation = Tween(begin: const Offset(0, -150), end: const Offset(0, 0)).animate(_slideController);
    Future.delayed(Duration(milliseconds: 200 * widget.index), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = widget.width / 5.7 * 8.7;
    return Container(
      width: widget.width,
      height: height,
      child: Transform.translate(
        offset: _animation.value,
        child: Center(
          child: getCardBackBuild(onTap: () {
            widget.onTap();
          }),
        ),
      ),
    );
  }
}

///抢庄按钮
class QiangzhuangButtonBuild extends StatefulWidget {
  final Function onTap;
  final double width;

  const QiangzhuangButtonBuild({
    Key key,
    this.onTap,
    this.width = 100,
  }) : super(key: key);

  @override
  _QiangzhuangButtonBuildState createState() => _QiangzhuangButtonBuildState();
}

class _QiangzhuangButtonBuildState extends State<QiangzhuangButtonBuild> with TickerProviderStateMixin {
  Color roomMasterColor = Color(0xffffaf49);

  AnimationController _scaleController;
  double _size = 0;

  Timer hideTimer;

  @override
  void initState() {
    _scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100), lowerBound: 0, upperBound: 100)
      ..addListener(() {
        setState(() {
          _size = _scaleController.value;
        });
      });
    Future.delayed(Duration(milliseconds: 100), () {
      _scaleController.forward();
    });
    hideTimer = Timer(Duration(seconds: 4), () {
      Future.delayed(Duration(milliseconds: 100), () async {
        hide(false);
      });
    });
  }

  hide(bool value) async {
    await _scaleController.reverse();
    widget.onTap(value);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    hideTimer.cancel();
    hideTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = widget.width / 5.7 * 8.7;
    return getQiangZhuangBuild();
  }

  getQiangZhuangBuild() {
    return Padding(
      padding: EdgeInsets.only(top: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: roomMasterColor, blurRadius: 33, offset: Offset(0, 0))],
            ),
            child: Container(
                width: _size,
                height: _size,
                transformAlignment: Alignment.center,
                child: MyButton.gradient(
                    backgroundColor: [Color(0xfff3ec6c), Color(0xffbe5a05)],
                    onPressed: () {
                      hide(true);
                    },
                    child: Text('抢庄', style: TextStyle(fontSize: 25 * (_size / 100), fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: SizedBox(
                width: 50,
                height: 28,
                child: _size < 100
                    ? SizedBox()
                    : MyButton.gradient(
                        backgroundColor: [Color(0xfffffffff), Color(0xff000000)],
                        onPressed: () {
                          hide(false);
                        },
                        child: Text('不抢', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
          ),
        ],
      ),
    );
  }
}

///庄家标记
class ZhuangIconBuild extends StatefulWidget {
  final double width;

  const ZhuangIconBuild({
    Key key,
    this.width = 35.0,
  }) : super(key: key);

  @override
  _ZhuangIconBuildState createState() => _ZhuangIconBuildState();
}

class _ZhuangIconBuildState extends State<ZhuangIconBuild> with TickerProviderStateMixin {
  Color roomMasterColor = Color(0xffffaf49);

  AnimationController _scaleController;
  double _size = 35;

  @override
  void initState() {
    _size = widget.width;
    _scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300), lowerBound: widget.width, upperBound: 80)
      ..addListener(() {
        setState(() {
          _size = _scaleController.value;
        });
      });

    Future.delayed(Duration(milliseconds: 100), () async {
      await _scaleController.forward();
      _scaleController.reverse();
    });
  }

  hide(bool value) async {
    await _scaleController.reverse();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getQiangZhuangBuild();
  }

  getQiangZhuangBuild() {
    var fontSize = 12;
    if (widget.width < 30) {
      fontSize = 10;
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: roomMasterColor, blurRadius: 33, offset: Offset(0, 0))],
      ),
      child: SizedBox(
          width: _size,
          height: _size,
          child: MyButton.gradient(
              backgroundColor: [Color(0xfff3ec6c), Color(0xffbe5a05)],
              child: Text('庄', style: TextStyle(fontSize: fontSize * (_size / widget.width), fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
    );
  }
}

///bet投注按钮入场
class BetButtonBuild extends StatefulWidget {
  final Widget child;

  const BetButtonBuild({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  _BetButtonBuildState createState() => _BetButtonBuildState();
}

class _BetButtonBuildState extends State<BetButtonBuild> with TickerProviderStateMixin {
  AnimationController _slideController;
  Animation<Offset> _animation;

  @override
  void initState() {
    _slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        setState(() {});
      });
    _animation = Tween(begin: const Offset(0, 150), end: const Offset(0, 0)).animate(_slideController);
    Future.delayed(Duration(milliseconds: 200), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: widget.width,
      // height: height,
      child: Transform.translate(
        offset: _animation.value,
        child: Center(
          child: widget.child,
        ),
      ),
    );
  }
}

///bet投注按钮入场
class ResultSingleBuild extends StatefulWidget {
  final Function onClose;
  final Widget child;

  const ResultSingleBuild({
    Key key,
    this.child,
    this.onClose,
  }) : super(key: key);

  @override
  _ResultSingleBuildState createState() => _ResultSingleBuildState();
}

class _ResultSingleBuildState extends State<ResultSingleBuild> with TickerProviderStateMixin {
  AnimationController _slideController;
  Animation<Offset> _animation;

  Color roomMasterColor = Color(0xffffaf49);

  @override
  void initState() {
    _slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animation = Tween(begin: const Offset(0, -500), end: const Offset(0, 0)).animate(_slideController);
    Future.delayed(Duration(milliseconds: 100), () {
      _slideController.forward();
    });
  }

  onClose() async{
    await _slideController.reverse();
    widget.onClose();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                            color: Color(0xcc555555),
                            boxShadow: [BoxShadow(color: Color(0x99555555), blurRadius: 33, offset: Offset(0, 0))],
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: Color(0xffffffff), width: 2)),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            SizedBox(
                              width: con.maxWidth * 0.9,
                              height: con.maxHeight * 0.8,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 0, bottom: 8, left: 8.0, right: 8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    getZhuangPlayerItemBuild(),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            getPlayerItem1Build(),
                                            // if(false)
                                              getPlayerItem2Build(),
                                          ],
                                        ),
                                        // if(false)
                                          Padding(
                                          padding: const EdgeInsets.only(top: 12.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              getPlayerItem3Build(),
                                              getPlayerItem4Build(),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
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

  getZhuangPlayerItemBuild(){
    var headWidth = 40.0;
    var user = context.watch<SerUser>();
    var isSelf = true;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DecoratedBox(
          decoration: isSelf?BoxDecoration(
              border: Border.all(width: 1,color: Color(0xffffffff)),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0x22ffffff)
          ):BoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.only(left: 0.0,right: 8.0,top: 2,bottom: 2),
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
                              '',
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
                          user.nickname,
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
                  child: getPokersBuild(width: 35),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: getNiuTypeIcon(6),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: getJifenBuild(100,bei: 3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  getPlayerItem1Build() {
    bool isSelf = true;
    return DecoratedBox(
      decoration: isSelf?BoxDecoration(
        border: Border.all(width: 1,color: Color(0xffffffff)),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Color(0x22ffffff)
      ):BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(left:0.0,right: 8.0,top: 2,bottom: 2),
        child: Row(
          children: [
            getHeadBuild(),
            Padding(
              padding: EdgeInsets.only(left: 0),
              child: getPokersBuild(),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: getNiuTypeIcon(7),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: getJifenBuild(100,bei: 2),
            ),
          ],
        ),
      ),
    );
  }
  getPlayerItem2Build() {
    bool isSelf = true;
    return DecoratedBox(
      decoration: isSelf?BoxDecoration(
          border: Border.all(width: 1,color: Color(0xffffffff)),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0x22ffffff)
      ):BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0,right: 0.0,top: 2,bottom: 2),
        child: Row(
          children: [

            Padding(
              padding: EdgeInsets.only(left: 0),
              child: getJifenBuild(-100),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: getNiuTypeIcon(6),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: getPokersBuild(),
            ),
            Padding(
              padding: EdgeInsets.only(left: 0),
              child: getHeadBuild(),
            ),
          ],
        ),
      ),
    );
  }
  getPlayerItem3Build() {
    bool isSelf = false;
    return DecoratedBox(
      decoration: isSelf?BoxDecoration(
          border: Border.all(width: 1,color: Color(0xffffffff)),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0x22ffffff)
      ):BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0,right: 8.0,top: 2,bottom: 2),
        child: Row(
          children: [
            getHeadBuild(),
            Padding(
              padding: EdgeInsets.only(left: 0),
              child: getPokersBuild(),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: getNiuTypeIcon(3),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: getJifenBuild(100),
            ),
          ],
        ),
      ),
    );
  }
  getPlayerItem4Build() {
    bool isSelf = false;
    return DecoratedBox(
      decoration: isSelf?BoxDecoration(
          border: Border.all(width: 1,color: Color(0xffffffff)),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0x22ffffff)
      ):BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0,right: 0.0,top: 2,bottom: 2),
        child: Row(
          children: [

            Padding(
              padding: EdgeInsets.only(left: 0),
              child: getJifenBuild(100),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: getNiuTypeIcon(2),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: getPokersBuild(),
            ),
            Padding(
              padding: EdgeInsets.only(left: 0),
              child: getHeadBuild(),
            ),
          ],
        ),
      ),
    );
  }

  getHeadBuild(){
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
                  '',
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
          width: 50,
          height: 15,
          child: Text(
            user.nickname,
            maxLines: 1,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Color(0xffdddddd)),
          ),
        ),
      ],
    );
  }

  getPokersBuild({double width = 28}) {
    var lineWidth = 5.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getCardBuild(1, 1,width: width),
        SizedBox(width: lineWidth,),
        getCardBuild(2, 10,width: width),
        SizedBox(width: lineWidth,),
        getCardBuild(3, 11,width: width),
        SizedBox(width: lineWidth,),
        getCardBuild(4, 12,width: width),
        SizedBox(width: lineWidth,),
        getCardBuild(1, 13,width: width),
      ],
    );
  }

  getJifenBuild(int fen, {int bei = 1}) {
    return Padding(
      padding: EdgeInsets.only(left: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/jifen.png",
                width: 14,
                height: 14,
              ),
              if(bei>1)Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text(
                  'x'+bei.toString(),
                  maxLines: 1,
                  style: TextStyle(fontSize: 12, color: Color(0xffffffff)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              fen.toString(),
              maxLines: 1,
              style: TextStyle(fontSize: 14, color: fen>0?Color(0xff00ea00):Color(0xffffffff)),
            ),
          ),
        ],
      ),
    );
  }
}
