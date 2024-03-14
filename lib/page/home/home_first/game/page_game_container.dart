import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ima2_habeesjobs/page/home/home_first/card_build.dart';
import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:ima2_habeesjobs/util/audioplayer_utils.dart';
import 'package:ima2_habeesjobs/widget/my_button.dart';
import 'package:ima2_habeesjobs/widget/my_image.dart';
import 'package:ima2_habeesjobs/widget/ui_tabbar.dart';
import 'package:provider/provider.dart';

///扑克牌入场卡片
class CardBackBuild extends StatefulWidget {
  final Function onTap;
  final double width;
  final int index;
  final Function onDoubleTap;

  const CardBackBuild({
    Key key,
    this.onTap,
    this.width = 50,
    this.index = 0,
    this.onDoubleTap,
  }) : super(key: key);

  @override
  _CardBackBuildState createState() => _CardBackBuildState();
}

class _CardBackBuildState extends State<CardBackBuild> with TickerProviderStateMixin {
  AnimationController _slideController;
  Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        setState(() {});
      });
    _animation = Tween(begin: const Offset(0, -150), end: const Offset(0, 0)).animate(_slideController);
    Future.delayed(Duration(milliseconds: 200 * widget.index), () {
      _slideController.forward();
    });

    playSound();
  }

  playSound() {
    if (widget.index == 0) {
      AudioPlayerUtilFapai.playSound();
    }
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
          }, onDoubleTap: () {
            widget.onDoubleTap();
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

  bool _hide = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100), lowerBound: 0, upperBound: 100)
      ..addListener(() {
        setState(() {
          _size = _scaleController.value;
        });
      });
    Future.delayed(Duration(milliseconds: 100), () {
      _scaleController.forward();
    });
    // hideTimer = Timer(Duration(seconds: 4), () {
    //   Future.delayed(Duration(milliseconds: 100), () async {
    //     _hide = true;
    //     setState(() {
    //
    //     });
    //   });
    // });
  }

  hide(bool value) async {
    await _scaleController.reverse();
    _hide = true;
    setState(() {});
    if (value) {
      widget.onTap(value);
    }
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
    if (_hide) {
      return SizedBox();
    }
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
              boxShadow: [BoxShadow(color: Color(0xff08BF42), blurRadius: 33, offset: Offset(0, 0))],
            ),
            child: Container(
                width: _size,
                height: _size,
                transformAlignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    hide(true);
                  },
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(_size / 2)),
                        image: DecorationImage(
                          image: AssetImage('assets/images/xingqiu3.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Center(
                        child: Text('抢庄', style: TextStyle(fontSize: 25 * (_size / 100), fontWeight: FontWeight.bold, color: Color(0xffffffff))),
                      )),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: SizedBox(
                width: 50,
                height: 28,
                child: _size < 100
                    ? SizedBox()
                    : MyButton.gradient(
                        backgroundColor: [Color(0x99918ea9), Color(0xff21143f)],
                        onPressed: () {
                          hide(false);
                        },
                        child: Text('返回', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
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
    super.initState();
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
        boxShadow: [BoxShadow(color: Color(0xff08BF42), blurRadius: 33, offset: Offset(0, 0))],
      ),
      child: SizedBox(
          width: _size,
          height: _size,
          child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(_size / 2)),
                image: DecorationImage(
                  image: AssetImage('assets/images/xingqiu3.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Center(
                  child: Text('庄', style: TextStyle(fontSize: fontSize * (_size / widget.width), fontWeight: FontWeight.bold, color: Color(0xffffffff)))))),
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
    super.initState();
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

///当轮结果
class ResultSingleBuild extends StatefulWidget {
  final Function onClose;
  final resultData;

  const ResultSingleBuild({
    Key key,
    this.resultData,
    this.onClose,
  }) : super(key: key);

  @override
  _ResultSingleBuildState createState() => _ResultSingleBuildState();
}

class _ResultSingleBuildState extends State<ResultSingleBuild> with TickerProviderStateMixin {
  AnimationController _slideController;
  Animation<Offset> _animation;

  Color roomMasterColor = Color(0xffffaf49);

  bool _hide = false;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400))
      ..addListener(() {
        setState(() {});
      });
    _animation = Tween(begin: const Offset(0, -500), end: const Offset(0, 0)).animate(_slideController);
    Future.delayed(Duration(milliseconds: 100), () {
      _slideController.forward();
    });
    AudioPlayerUtilJinshu.playSound();
  }

  onClose() async {
    await _slideController.reverse();
    // widget.onClose();
    _hide = true;
    setState(() {});
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
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
                            colors: [Color(0xcc47b86f), Color(0xcc011713), Color(0xcc47b86f), Color(0xcc011713), Color(0xcc0877bf)],
                          ),
                          // color: Color(0xcc555555),
                          boxShadow: [BoxShadow(color: Color(0xffffffff), blurRadius: 33, offset: Offset(0, 0))],
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          // border: Border.all(color: Color(0xffffffff), width: 2)
                        ),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            SizedBox(
                              width: con.maxWidth * 0.85,
                              height: con.maxHeight * 0.8,
                              child: ResultSingleItemContainer(resultData: widget.resultData),
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
}

///最终结果展示 10轮
class FinalResultBuild extends StatefulWidget {
  final finalResultData;
  final Function onClose;

  const FinalResultBuild({
    Key key,
    this.finalResultData,
    this.onClose,
  }) : super(key: key);

  @override
  _FinalResultBuildState createState() => _FinalResultBuildState();
}

class _FinalResultBuildState extends State<FinalResultBuild> with TickerProviderStateMixin {
  AnimationController _slideController;
  Animation<Offset> _animation;

  Color roomMasterColor = Color(0xffffaf49);

  bool _hide = false;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400))
      ..addListener(() {
        setState(() {});
      });
    _animation = Tween(begin: const Offset(0, -500), end: const Offset(0, 0)).animate(_slideController);
    Future.delayed(Duration(milliseconds: 100), () {
      _slideController.forward();
    });
    AudioPlayerUtilBoli.playSound();
  }

  onClose() async {
    await _slideController.reverse();
    _hide = true;
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
                          // gradient: LinearGradient(
                          //   begin: Alignment.topLeft,
                          //   end: Alignment.bottomRight,
                          //   colors: [Color(0xcc075383), Color(0xcc011826)],
                          // ),
                          // color: Color(0xcc555555),
                          image: DecorationImage(
                            image: AssetImage('assets/images/xingkong2.png'),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [BoxShadow(color: Color(0xffffffff), blurRadius: 33, offset: Offset(0, 0))],
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          // border: Border.all(color: Color(0xffffffff), width: 2)
                        ),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            SizedBox(
                              width: con.maxWidth * 0.85,
                              height: Platform.isIOS?con.maxHeight * 0.90:con.maxHeight * 0.85,
                              child: DefaultTabController(
                                initialIndex: 0,
                                length: 11,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 50.0),
                                      child: SizedBox(
                                        height: 48,
                                        width: double.infinity,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: UiTabBar(tabs: [
                                            Tab(text: '战绩'),
                                            Tab(text: '一'),
                                            Tab(text: '二'),
                                            Tab(text: '三'),
                                            Tab(text: '四'),
                                            Tab(text: '五'),
                                            Tab(text: '六'),
                                            Tab(text: '七'),
                                            Tab(text: '八'),
                                            Tab(text: '九'),
                                            Tab(text: '十')
                                          ]),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        children: <Widget>[
                                          mainBuild(widget.finalResultData['final_result']),
                                          for (var i = 0; i < 10; i++)
                                            getSingleBuild(widget.finalResultData['item_list'].length > (i) ? widget.finalResultData['item_list'][i] : null),
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

  mainBuild(final_result) {
    return ResultAllInfoItemContainer(final_result: final_result);
  }

  getSingleBuild(gameItemResultData) {
    if (gameItemResultData == null) {
      return SizedBox();
    }
    return ResultSingleItemContainer(
      resultData: gameItemResultData['list'],
    );
  }
}

///当轮结果 组件
class ResultSingleItemContainer extends StatefulWidget {
  final resultData;

  const ResultSingleItemContainer({
    Key key,
    this.resultData,
  }) : super(key: key);

  @override
  _ResultSingleItemContainerState createState() => _ResultSingleItemContainerState();
}

class _ResultSingleItemContainerState extends State<ResultSingleItemContainer> with AutomaticKeepAliveClientMixin {
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
    var playerList = [];
    for (var i = 0; i < widget.resultData.length; i++) {
      var item = widget.resultData[i];
      if (item == null) {
        continue;
      }
      var vocation = item['vocation'];
      if (vocation == 1) {
        zhuangResult = widget.resultData[i];
      } else {
        playerList.add(widget.resultData[i]);
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
                  if (playerList.length >= 1) getPlayerItem1Build(playerList[0]),
                  if (playerList.length >= 2) getPlayerItem2Build(playerList[1]),
                ],
              ),
              // if(false)
              if (playerList.length >= 3)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (playerList.length >= 3) getPlayerItem3Build(playerList[2]),
                      if (playerList.length >= 4) getPlayerItem4Build(playerList[3]),
                    ],
                  ),
                )
            ],
          )
        ],
      ),
    );
  }

  getZhuangPlayerItemBuild(resultItem) {
    if (resultItem == null) {
      return SizedBox();
    }
    var headWidth = 40.0;
    var user = context.watch<SerUser>();
    var isSelf = false;
    if (resultItem['user_id'] == getUserId()) {
      isSelf = true;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DecoratedBox(
          decoration: isSelf
              ? BoxDecoration(
                  // border: Border.all(width: 1, color: Color(0xffd16664)),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0x66edd577),
                )
              : BoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 38.0, top: 2, bottom: 2),
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
                              boxShadow: [BoxShadow(color: Color(0xff08BF42), blurRadius: 33, offset: Offset(0, 0))],
                            ),
                            child: SizedBox(
                                width: 16,
                                height: 16,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(16 / 2)),
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/xingqiu3.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  child: Center(child: Text('庄', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xffffffff)))),
                                )),
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
                          style: TextStyle(fontSize: 12, color: Color(0xffdddddd),fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: getPokersBuild(resultItem['poker'], width: 35),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: getNiuTypeIcon(resultItem['poker_result']),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: getJifenBuild(resultItem['score'], bei: resultItem['multiple']),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  getPlayerItem1Build(var resultItem) {
    var isSelf = false;
    if (resultItem['user_id'] == getUserId()) {
      isSelf = true;
    }
    return DecoratedBox(
      decoration: isSelf
          ? BoxDecoration(
              // border: Border.all(width: 1, color: Color(0xffd16664)),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0x66edd577),
            )
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
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: getJifenBuild(resultItem['score'], bei: resultItem['multiple']),
            ),
          ],
        ),
      ),
    );
  }

  getPlayerItem2Build(var resultItem) {
    var isSelf = false;
    if (resultItem['user_id'] == getUserId()) {
      isSelf = true;
    }
    return DecoratedBox(
      decoration: isSelf
          ? BoxDecoration(
              // border: Border.all(width: 1, color: Color(0xffffffff)),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0x66edd577),
            )
          : BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 0.0, top: 2, bottom: 2),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 0),
              child: getJifenBuild(resultItem['score'], bei: resultItem['multiple']),
            ),
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
    if (resultItem['user_id'] == getUserId()) {
      isSelf = true;
    }
    return DecoratedBox(
      decoration: isSelf
          ? BoxDecoration(
              // border: Border.all(width: 1, color: Color(0xffffffff)),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0x66edd577),
            )
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
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: getJifenBuild(resultItem['score'], bei: resultItem['multiple']),
            ),
          ],
        ),
      ),
    );
  }

  getPlayerItem4Build(var resultItem) {
    var isSelf = false;
    if (resultItem['user_id'] == getUserId()) {
      isSelf = true;
    }
    return DecoratedBox(
      decoration: isSelf
          ? BoxDecoration(
              // border: Border.all(width: 1, color: Color(0xffffffff)),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0x66edd577),
            )
          : BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 0.0, top: 2, bottom: 2),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 0),
              child: getJifenBuild(resultItem['score'], bei: resultItem['multiple']),
            ),
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
            style: TextStyle(fontSize: 12, color: Color(0xffdddddd),fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  getPokersBuild(var pokers, {double width = 28}) {
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

  getJifenBuild(int fen, {int bei = 1}) {
    return Padding(
      padding: EdgeInsets.only(left: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/jinbi.png",
                width: 14,
                height: 14,
              ),
              if (fen > 0 && bei > 1)
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(
                    'x' + bei.toString(),
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
              style: TextStyle(fontSize: 14, color: fen > 0 ? Color(0xff00ea00) : Color(0xffffffff),fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

///10轮，总览，第一个页面组件
class ResultAllInfoItemContainer extends StatefulWidget {
  final final_result;

  const ResultAllInfoItemContainer({
    Key key,
    this.final_result,
  }) : super(key: key);

  @override
  _ResultAllInfoItemContainerState createState() => _ResultAllInfoItemContainerState();
}

class _ResultAllInfoItemContainerState extends State<ResultAllInfoItemContainer> with AutomaticKeepAliveClientMixin {
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

    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 8, left: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (widget.final_result.length >= 1) getZhuangPlayerItemBuild(widget.final_result[0]),
          Row(
            children: [
              if (widget.final_result.length >= 2) getPlayerItem1Build(widget.final_result[1]),
              // if(false)
              if (widget.final_result.length >= 3) getPlayerItem1Build(widget.final_result[2]),
              if (widget.final_result.length >= 4) getPlayerItem1Build(widget.final_result[3]),
              if (widget.final_result.length >= 5) getPlayerItem1Build(widget.final_result[4]),
            ],
          )
        ],
      ),
    );
  }

  getZhuangPlayerItemBuild(gameFinalResultData) {
    var headWidth = 70.0;
    var user = context.watch<SerUser>();
    var isSelf = false;
    return DecoratedBox(
      decoration: isSelf
          ? BoxDecoration(
              // border: Border.all(width: 1, color: Color(0xffffffff)),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0x66ffffff),
            )
          : BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 2, bottom: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Column(
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
                            gameFinalResultData['avatar'],
                            width: headWidth - 1,
                            height: headWidth - 1,
                          ),
                        ),
                      ),
                      if (gameFinalResultData['vocation'] == 1)
                        DecoratedBox(
                          decoration: BoxDecoration(
                            boxShadow: [BoxShadow(color: Color(0xff08BF42), blurRadius: 33, offset: Offset(0, 0))],
                          ),
                          child: SizedBox(
                              width: 16,
                              height: 16,
                              child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(16 / 2)),
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/xingqiu3.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  child: Center(child: Text('庄', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xffffffff)))))),
                        )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: SizedBox(
                      width: 80,
                      height: 35,
                      child: Center(
                        child: Text(
                          gameFinalResultData['nick_name'],
                          maxLines: 2,
                          overflow: TextOverflow.visible,
                          style: TextStyle(fontSize: 16, color: Color(0xffdddddd)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: getJifenBuild(gameFinalResultData['all_score']),
            ),
          ],
        ),
      ),
    );
  }

  getPlayerItem1Build(gameFinalResultData) {
    var headWidth = 70.0;
    var user = context.watch<SerUser>();
    var isSelf = true;
    return DecoratedBox(
      decoration: isSelf
          ? BoxDecoration(
              // border: Border.all(width: 1, color: Color(0xffffffff)),
              borderRadius: BorderRadius.all(Radius.circular(60)),
               boxShadow: [BoxShadow(color: Color(0x66f484b1), blurRadius: 33, offset: Offset(0, 0))],
              color: Color(0x66edd577),
            )
          : BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 2, bottom: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Column(
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
                            gameFinalResultData['avatar'],
                            width: headWidth - 1,
                            height: headWidth - 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: SizedBox(
                      width: 80,
                      height: 35,
                      child: Center(
                        child: Text(
                          gameFinalResultData['nick_name'],
                          maxLines: 2,
                          overflow: TextOverflow.visible,
                          style: TextStyle(fontSize: 16, color: Color(0xffdddddd),fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: getJifenBuild(
                gameFinalResultData['all_score'],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getHeadBuild() {
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
                  boxShadow: [BoxShadow(color: Color(0xff08BF42), blurRadius: 33, offset: Offset(0, 0))],
                ),
                child: SizedBox(
                    width: 16,
                    height: 16,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16 / 2)),
                          image: DecorationImage(
                            image: AssetImage('assets/images/xingqiu3.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Center(child: Text('庄', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xffffffff)))))),
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

  getJifenBuild(int fen, {int bei = 1}) {
    return Padding(
      padding: EdgeInsets.only(left: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/jinbi.png",
                width: 20,
                height: 20,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              fen.toString(),
              maxLines: 1,
              style: TextStyle(fontSize: 16, color: fen > 0 ? Color(0xff00ea00) : Color(0xffffffff),fontWeight: FontWeight.bold),
            ),
          ),
          if (fen > 0)
            Padding(
              padding: EdgeInsets.only(top: 0),
              child: Image.asset(
                "assets/images/win.png",
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
            )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
