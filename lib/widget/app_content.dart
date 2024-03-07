import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ima2_habeesjobs/util/language.dart';

class AppContent extends StatelessWidget {
  final Widget child;
  final Color color;

  const AppContent({Key key, this.child, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color??Theme.of(context).scaffoldBackgroundColor,
      child: LayoutBuilder(builder: (context, con) {
        return Center(
          child: SizedBox(
            width: min(con.biggest.width, 640),
            height: con.biggest.height,
            child: child,
          ),
        );
      }),
    );
  }
}


class UiEmptyView extends StatelessWidget {
  final EmptyType type;

  final FutureVoidCallback onPressed;

  final String tips;

  const UiEmptyView({Key key, this.type = EmptyType.data, this.onPressed, this.tips}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var image = 'icon_no_data.webp';
    var text = "";
    switch (this.type) {
      case EmptyType.network:
        image = 'my/icon_no_network.webp';
        text = '网络错误';
        break;
      case EmptyType.game:
        image = 'my/icon_no_data.webp';
        text = '暂无数据';
        break;
      case EmptyType.live:
        image = 'my/icon_no_video.webp';
        text = '暂无数据';
        break;
      case EmptyType.data:
        image = 'my/icon_monky.webp';
        text = '暂无数据';
        break;
      case EmptyType.gift:
        image = 'my/icon_no_data.webp';
        text = '暂无数据';
        break;
    }
    if (tips != null && tips != '') {
      text = tips;
    }
    return LayoutBuilder(builder: (context, con) {
      return SizedBox.fromSize(
        size: con.biggest,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images2/" + image,
              width: 140,
              height: 140,
            ),
            if(tips != null)Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(text,style: TextStyle(fontSize: 14,color: Color(0xffffffff)),),
            ),
            // if (null != onPressed)
            //   Padding(
            //     padding: style.textPadding,
            //     child: UiOutlinedButton(
            //       onPressed: onPressed,
            //       style: UiTheme
            //           .of(context)
            //           .buttonOutlinedBig,
            //       child: Text(Languages
            //           .of(context)
            //           .reloadText),
            //     ),
            //   ),
          ],
        ),
      );
    });
  }
}

enum EmptyType {
  network,
  game,
  live,
  data,
  gift,
  video,
  chart,
  activated,
}

typedef FutureVoidCallback = Future Function();