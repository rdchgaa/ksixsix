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

class CardBackBuild extends StatefulWidget {
  final Function onTap;
  final double width;
  const CardBackBuild({
    Key key, this.onTap, this.width = 50,
  }) : super(key: key);

  @override
  _CardBackBuildState createState() => _CardBackBuildState();
}

class _CardBackBuildState extends State<CardBackBuild> with TickerProviderStateMixin{

  AnimationController _slideController;
  Animation<Offset> _animation;

  @override
  void initState() {
    _slideController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..addListener(() {
        setState(() {});
      });
    _animation = Tween(begin: const Offset(0, 0), end: const Offset(100, 100)).animate(_slideController);
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var height = widget.width / 5.7 * 8.7;
    return Transform.translate(
      offset: _animation.value,
      child: Container(
        width: 100,
        height: 200 / 2,
        child: getCardBackBuild(onTap: () {
          widget.onTap();
        }),
      ),
    );
  }

}
