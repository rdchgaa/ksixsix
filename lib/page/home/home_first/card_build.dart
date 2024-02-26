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

Widget getCardBuild(int type, int num,{Function onTap,double width = 50.0}) {

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

  Color textColor = Color(0xff000000);
  var image = 'assets/images/huase1.png';
  if (type == 1) {
    image = 'assets/images/huase1.png';
    textColor = Color(0xB4FA0000);
  } else if (type == 2) {
    image = 'assets/images/huase2.png';
  } else if (type == 3) {
    image = 'assets/images/huase3.png';
    textColor = Color(0xB4FA0000);
  } else if (type == 4) {
    image = 'assets/images/huase4.png';
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
                    padding: const EdgeInsets.only(top: 0.0, left: 0.5),
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
                    padding: const EdgeInsets.only(bottom: 0.0, right: 0.5),
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
      decoration: BoxDecoration(color: Color.fromRGBO(246, 246, 246, 1), borderRadius: BorderRadius.all(Radius.circular(6))),
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0, left: 2),
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
                padding: const EdgeInsets.only(bottom: 2.0, right: 2),
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
    onTap: onTap,
    child: child,
  );
}

Widget getCardBackBuild({Function onTap,double width = 50.0}) {
  var height = width / 5.7 * 8.7;

  return InkWell(
    onTap: onTap,
    child: DecoratedBox(
      decoration: BoxDecoration(
        // color: Color.fromRGBO(246, 246, 246, 1),
        borderRadius: BorderRadius.all(Radius.circular(4)),
        image: DecorationImage(image: AssetImage("assets/images/cardback.png"), fit: BoxFit.cover),

      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Image.asset('assets/images/niured.png',width: width * 0.6,height: width * 0.6,color: Colors.red.withOpacity(0.6),),
        ),
      ),
    ),
  );
}
