import 'dart:math' as math;

import 'package:flutter/material.dart';

Widget getCardBuild(int type, int num,{Function onDoubleTap,double width = 50.0}) {

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
    fontSize = 12;
  } else if (width < 100) {
    fontSize = 15;
  } else {
    fontSize = 20;
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


  var jqkImage = 'assets/images/huase1.png';
  if (num > 10) {
    if (num == 11) {
      jqkImage = 'assets/images/j.png';
    } else if (num == 12) {
      jqkImage = 'assets/images/q.png';
    } else if (num == 13) {
      jqkImage = 'assets/images/k.png';
    }

    child = DecoratedBox(
      decoration: BoxDecoration(color: Color.fromRGBO(246, 246, 246, 1), borderRadius: BorderRadius.all(Radius.circular(width/15))),
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
                  child: Image.asset(
                    image,
                    width: width * 0.25,
                    height: width * 0.25,
                  ),
                ),
                Positioned(
                  bottom: width * 0.22,
                  right: 0,
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
                      child: Text(
                        value,
                        style: TextStyle(fontSize: fontSize, color: textColor),
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
                      child: Text(
                        value,
                        style: TextStyle(fontSize: fontSize, color: textColor),
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
    child = DecoratedBox(
      decoration: BoxDecoration(color: Color.fromRGBO(246, 246, 246, 1), borderRadius: BorderRadius.all(Radius.circular(width/15))),
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: marginTop+2.0, left: 2),
                child: Text(
                  value,
                  style: TextStyle(fontSize: fontSize, color: textColor),
                ),
              ),
            ),
            Expanded(
                child: Image.asset(
                  image,
                  width: width * 0.8,
                  height: width * 0.8,
                )),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(bottom: marginTop+2.0, right: 2),
                child: Transform.rotate(
                  angle: 180 * math.pi / 180,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: fontSize, color: textColor),
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

Widget getCardBackBuild({Function onTap,Function onDoubleTap,double width = 50.0}) {
  var height = width / 5.7 * 8.7;

  return InkWell(
    onTap: onTap,
    onDoubleTap: onDoubleTap,
    child: DecoratedBox(
      decoration: BoxDecoration(
        // color: Color.fromRGBO(246, 246, 246, 1),
        borderRadius: BorderRadius.all(Radius.circular(width/9)),
        image: DecorationImage(image: AssetImage("assets/images/cardback.png"), fit: BoxFit.fill),

      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          // child: Image.asset('assets/images/youniu.png',width: width * 0.6,height: width * 0.6,color: Colors.red.withOpacity(0.9),),
        ),
      ),
    ),
  );
}
