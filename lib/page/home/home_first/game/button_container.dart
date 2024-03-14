import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ima2_habeesjobs/page/home/home_first/card_build.dart';
import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:ima2_habeesjobs/util/audioplayer_utils.dart';
import 'package:ima2_habeesjobs/widget/my_button.dart';
import 'package:ima2_habeesjobs/widget/my_image.dart';
import 'package:ima2_habeesjobs/widget/ui_tabbar.dart';
import 'package:provider/provider.dart';


///抢庄按钮
class EnterButtonBuild extends StatefulWidget {
  final Function onTap;
  final double width;
  final Color color;

  const EnterButtonBuild({
    Key key,
    this.onTap,
    this.width = 120, this.color = const Color(0xffffaf49),
  }) : super(key: key);

  @override
  _EnterButtonBuildState createState() => _EnterButtonBuildState();
}

class _EnterButtonBuildState extends State<EnterButtonBuild> with TickerProviderStateMixin {

  AnimationController _scaleController;
  double _size = 0;

  Timer hideTimer;

  bool _hide = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500), lowerBound: 0, upperBound: widget.width)
      ..addListener(() {
        setState(() {
          _size = _scaleController.value;
        });
      });
    Future.delayed(Duration(milliseconds: 100), () {
      repeatPlay();
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

  repeatPlay() async{
    await _scaleController.forward();
    await _scaleController.reverse();
    repeatPlay();
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
    if(hideTimer!=null){
      hideTimer.cancel();
      hideTimer = null;
    }
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: widget.color, blurRadius: widget.width/2, offset: Offset(0, 0))],
            ),
            child: Container(
                width: _size,
                height: _size,
                transformAlignment: Alignment.center,),
          ),
        ],
      ),
    );
  }
}
