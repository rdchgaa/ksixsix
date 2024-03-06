import 'dart:async';

import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';
import 'package:ima2_habeesjobs/net/network.dart';
import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:ima2_habeesjobs/util/language.dart';
import 'package:ima2_habeesjobs/util/other.dart';
import 'package:ima2_habeesjobs/util/soundpool_Util.dart';
import 'package:ima2_habeesjobs/widget/app_bar.dart';
import 'package:ima2_habeesjobs/widget/my_image.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'dart:math' as math;

Widget getFullCardBuild(int type, int num,{Function onDoubleTap,double width = 50.0}) {

  //花色校正
  Color textColor = Color(0xff000000);
  var image = 'assets/images/huase1.png';
  if (type == 1) {
    image = 'assets/images/huase4.png'; //黑桃
    textColor = Color(0xff000000);
  } else if (type == 2) {
    image = 'assets/images/huase1.png'; //红桃
    textColor = Color(0xB4FA0000);
  } else if (type == 3) {
    image = 'assets/images/huase2.png'; //梅花
    textColor = Color(0xff000000);
  } else if (type == 4) {
    image = 'assets/images/huase3.png'; //方块
    textColor = Color(0xB4FA0000);
  }

  Widget child;
  var height = width / 5.7 * 8.7;

  double fontSize = 10;
  if (width < 50) {
    fontSize = 10;
  } else if (width < 100) {
    fontSize = 13;
  } else {
    fontSize = 17;
  }

  var value = num.toString();

  if (num == 1) {
    value = 'A';
  } else if (num == 11) {
    value = 'J';
  } else if (num == 12) {
    value = 'Q';
  } else if (num == 13) {
    value = 'K';
  }


  var marginTop = 0.0;
  if(width>=100){
    marginTop = 5.0;
  }

  var numButtonIconWidth = 10.0;

  if (num > 10) {
    var jqkImage = 'assets/images/huase1.png';
    if (num == 11) {
      jqkImage = 'assets/images/j.png';
    } else if (num == 12) {
      jqkImage = 'assets/images/q.png';
    } else if (num == 13) {
      jqkImage = 'assets/images/k.png';
    }

    child = DecoratedBox(
      decoration: BoxDecoration(color: Color.fromRGBO(246, 246, 246, 1), borderRadius: BorderRadius.all(Radius.circular(6))),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Stack(
              children: [
                Image.asset(
                  jqkImage,
                  width: width * 0.7,
                  height: height,
                ),
                Positioned(
                  top: width * 0.22,
                  left: 1,
                  child: Image.asset(
                    image,
                    width: width * 0.25,
                    height: width * 0.25,
                  ),
                ),
                Positioned(
                  bottom: width * 0.22,
                  right: 1,
                  child: Transform.rotate(
                    angle: 180 * math.pi / 180,
                    child: Image.asset(
                      image,
                      width: width * 0.25,
                      height: width * 0.25,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: marginTop, left: 0.5),
                    child: SizedBox(
                      width: fontSize,
                      child: Column(
                        children: [
                          Text(
                            value,
                            style: TextStyle(fontSize: fontSize, color: textColor),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 0),
                            child: Image.asset(
                              image,
                              width: numButtonIconWidth,
                              height: numButtonIconWidth,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: marginTop, right: 0.5),
                    child: Transform.rotate(
                      angle: 180 * math.pi / 180,
                      child: Column(
                        children: [
                          Text(
                            value,
                            style: TextStyle(fontSize: fontSize, color: textColor),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 0),
                            child: Image.asset(
                              image,
                              width: numButtonIconWidth,
                              height: numButtonIconWidth,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }else{
    Widget picture = SizedBox();
    if(num==1){
      var iconWidth = width * 0.8;
      picture = Image.asset(
        image,
        width: iconWidth,
        height: iconWidth,
      );
    }else if(num==2){
      var iconWidth = width * 0.4;
      picture = Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Image.asset(
              image,
              width: iconWidth,
              height: iconWidth,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: Transform.rotate(
              angle: 180 * math.pi / 180,
              child: Image.asset(
                image,
                width: iconWidth,
                height: iconWidth,
              ),
            ),
          )
        ],
      );
    }else if(num==3){
      var iconWidth = width * 0.245;
      picture = Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Image.asset(
              image,
              width: iconWidth,
              height: iconWidth,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Image.asset(
              image,
              width: iconWidth,
              height: iconWidth,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: Transform.rotate(
              angle: 180 * math.pi / 180,
              child: Image.asset(
                image,
                width: iconWidth,
                height: iconWidth,
              ),
            ),
          )
        ],
      );
    }else if(num==4){
      var iconWidth = width * 0.245;
      picture = Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Image.asset(
                  image,
                  width: iconWidth,
                  height: iconWidth,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Image.asset(
                  image,
                  width: iconWidth,
                  height: iconWidth,
                ),
              ),
            ],
          ),
          Transform.rotate(
            angle: 180 * math.pi / 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Image.asset(
                    image,
                    width: iconWidth,
                    height: iconWidth,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Image.asset(
                    image,
                    width: iconWidth,
                    height: iconWidth,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }else if(num==5){
      var iconWidth = width * 0.245;
      picture = Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Image.asset(
                  image,
                  width: iconWidth,
                  height: iconWidth,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Image.asset(
                  image,
                  width: iconWidth,
                  height: iconWidth,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Image.asset(
              image,
              width: iconWidth,
              height: iconWidth,
            ),
          ),
          Transform.rotate(
            angle: 180 * math.pi / 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Image.asset(
                    image,
                    width: iconWidth,
                    height: iconWidth,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Image.asset(
                    image,
                    width: iconWidth,
                    height: iconWidth,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }else if(num==6){
      var iconWidth = width * 0.245;
      picture = Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Image.asset(
                  image,
                  width: iconWidth,
                  height: iconWidth,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Image.asset(
                  image,
                  width: iconWidth,
                  height: iconWidth,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Image.asset(
                  image,
                  width: iconWidth,
                  height: iconWidth,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Image.asset(
                  image,
                  width: iconWidth,
                  height: iconWidth,
                ),
              ),
            ],
          ),
          Transform.rotate(
            angle: 180 * math.pi / 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Image.asset(
                    image,
                    width: iconWidth,
                    height: iconWidth,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Image.asset(
                    image,
                    width: iconWidth,
                    height: iconWidth,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }else if(num==7){
      var iconWidth = width * 0.245;
      picture = Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Image.asset(
                      image,
                      width: iconWidth,
                      height: iconWidth,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Image.asset(
                      image,
                      width: iconWidth,
                      height: iconWidth,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Image.asset(
                      image,
                      width: iconWidth,
                      height: iconWidth,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Image.asset(
                      image,
                      width: iconWidth,
                      height: iconWidth,
                    ),
                  ),
                ],
              ),
              Transform.rotate(
                angle: 180 * math.pi / 180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Image.asset(
                        image,
                        width: iconWidth,
                        height: iconWidth,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Image.asset(
                        image,
                        width: iconWidth,
                        height: iconWidth,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: iconWidth*1.2,
            child: Padding(
              padding: EdgeInsets.only(top: 0.0),
              child: Image.asset(
                image,
                width: iconWidth,
                height: iconWidth,
              ),
            ),
          ),
        ],
      );
    }else if(num==8){
      var iconWidth = width * 0.245;
      picture = Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Image.asset(
                      image,
                      width: iconWidth,
                      height: iconWidth,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Image.asset(
                      image,
                      width: iconWidth,
                      height: iconWidth,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Image.asset(
                      image,
                      width: iconWidth,
                      height: iconWidth,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Image.asset(
                      image,
                      width: iconWidth,
                      height: iconWidth,
                    ),
                  ),
                ],
              ),
              Transform.rotate(
                angle: 180 * math.pi / 180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Image.asset(
                        image,
                        width: iconWidth,
                        height: iconWidth,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Image.asset(
                        image,
                        width: iconWidth,
                        height: iconWidth,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: iconWidth*1.2,
            child: Padding(
              padding: EdgeInsets.only(top: 0.0),
              child: Image.asset(
                image,
                width: iconWidth,
                height: iconWidth,
              ),
            ),
          ),
          Positioned(
            bottom: iconWidth*1.2,
            child: Padding(
              padding: EdgeInsets.only(top: 0.0),
              child: Transform.rotate(
                angle: 180 * math.pi / 180,
                child: Image.asset(
                  image,
                  width: iconWidth,
                  height: iconWidth,
                ),
              ),
            ),
          ),
        ],
      );
    }else if(num==9){
      var iconWidth = width * 0.245;
      picture = Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Image.asset(
                      image,
                      width: iconWidth,
                      height: iconWidth,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Image.asset(
                      image,
                      width: iconWidth,
                      height: iconWidth,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 0.0),
                    child: Image.asset(
                      image,
                      width: iconWidth,
                      height: iconWidth,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0.0),
                    child: Image.asset(
                      image,
                      width: iconWidth,
                      height: iconWidth,
                    ),
                  ),
                ],
              ),
              Transform.rotate(
                angle: 180 * math.pi / 180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0.0),
                      child: Image.asset(
                        image,
                        width: iconWidth,
                        height: iconWidth,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0.0),
                      child: Image.asset(
                        image,
                        width: iconWidth,
                        height: iconWidth,
                      ),
                    ),
                  ],
                ),
              ),
              Transform.rotate(
                angle: 180 * math.pi / 180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Image.asset(
                        image,
                        width: iconWidth,
                        height: iconWidth,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Image.asset(
                        image,
                        width: iconWidth,
                        height: iconWidth,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            child: Padding(
              padding: EdgeInsets.only(top: 0.0),
              child: Image.asset(
                image,
                width: iconWidth,
                height: iconWidth,
              ),
            ),
          ),
        ],
      );
    }else if(num==10){
      fontSize = 11;
      var iconWidth = width * 0.245;
      picture = Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Image.asset(
                      image,
                      width: iconWidth,
                      height: iconWidth,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Image.asset(
                      image,
                      width: iconWidth,
                      height: iconWidth,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 0.0),
                    child: Image.asset(
                      image,
                      width: iconWidth,
                      height: iconWidth,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0.0),
                    child: Image.asset(
                      image,
                      width: iconWidth,
                      height: iconWidth,
                    ),
                  ),
                ],
              ),
              Transform.rotate(
                angle: 180 * math.pi / 180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0.0),
                      child: Image.asset(
                        image,
                        width: iconWidth,
                        height: iconWidth,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0.0),
                      child: Image.asset(
                        image,
                        width: iconWidth,
                        height: iconWidth,
                      ),
                    ),
                  ],
                ),
              ),
              Transform.rotate(
                angle: 180 * math.pi / 180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Image.asset(
                        image,
                        width: iconWidth,
                        height: iconWidth,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Image.asset(
                        image,
                        width: iconWidth,
                        height: iconWidth,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: iconWidth*1.2,
            child: Padding(
              padding: EdgeInsets.only(top: 0.0),
              child: Image.asset(
                image,
                width: iconWidth,
                height: iconWidth,
              ),
            ),
          ),
          Positioned(
            bottom: iconWidth*1.2,
            child: Padding(
              padding: EdgeInsets.only(top: 0.0),
              child: Transform.rotate(
                angle: 180 * math.pi / 180,
                child: Image.asset(
                  image,
                  width: iconWidth,
                  height: iconWidth,
                ),
              ),
            ),
          ),
        ],
      );
    }

    child = DecoratedBox(
      decoration: BoxDecoration(color: Color.fromRGBO(246, 246, 246, 1), borderRadius: BorderRadius.all(Radius.circular(6))),
      child: SizedBox(
        width: width,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: marginTop+2.0, left: 2),
                child: Column(
                  children: [
                    Text(
                      value,
                      style: TextStyle(fontSize: fontSize, color: textColor),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Image.asset(
                        image,
                        width: numButtonIconWidth,
                        height: numButtonIconWidth,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: picture),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(bottom: marginTop+2.0, right: 2),
                child: Transform.rotate(
                  angle: 180 * math.pi / 180,
                  child: Column(
                    children: [
                      Text(
                        value,
                        style: TextStyle(fontSize: fontSize, color: textColor),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: Image.asset(
                          image,
                          width: numButtonIconWidth,
                          height: numButtonIconWidth,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }






  return InkWell(
    onDoubleTap: onDoubleTap,
    child: child,
  );



}
