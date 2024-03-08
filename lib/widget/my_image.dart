import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ima2_habeesjobs/util/image_util.dart';

class MyImage extends StatelessWidget {
  final ImageProvider image;
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const MyImage({
    Key key,
    this.image,
    this.width = 52.43,
    this.height = 52.43,
    this.borderRadius = const BorderRadius.all(Radius.circular(200)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: this.borderRadius,
      child: Image(
        image: this.image ?? AssetImage(""),
        height: this.height,
        width: this.width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return ColoredBox(
            color: Colors.lightBlue,
            child: Icon(
              Icons.group_rounded,
              size: this.width,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}

class HeadDecoration {
  final Widget child;
  final double width;
  final double height;

  final Widget label;

  HeadDecoration({
    this.child,
    this.width,
    this.height,
    this.label,
  });
}

class HeadImage extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  Uint8List _image;
  String _url;
  final HeadDecoration decoration;

  final Widget child;

  final BoxFit fit;

  final String defaultAssetImage;

  final AlignmentGeometry alignment;

  final Border border;

  HeadImage.memory(Uint8List image,
      {Key key,
      this.width = 54,
      this.height = 54,
      this.borderRadius = const BorderRadius.all(Radius.circular(200)),
      this.decoration,
      this.child,
      this.fit = BoxFit.cover,
      this.defaultAssetImage,
      this.alignment = Alignment.center,
      this.border})
      : super(key: key) {
    _image = image;
  }

  HeadImage.network(
    String url, {
    this.width = 54,
    this.height = 54,
    this.borderRadius = const BorderRadius.all(Radius.circular(200)),
    this.decoration,
    this.child,
    this.fit = BoxFit.cover,
    this.defaultAssetImage,
    this.alignment = Alignment.center,
    this.border,
  }) : super(key: ValueKey(url)) {
    _url = url;
  }

  @override
  _HeadImageState createState() => _HeadImageState();
}

class _HeadImageState extends State<HeadImage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (widget._image != null) {
      child = Image.memory(widget._image);
      // child = ImageUtil.networkImage(
      //     url: widget._url ?? '',
      //     errorWidget: ("assets/images2/icon-touxiang.webp".toImage
      //       ..width = widget.width
      //       ..height = widget.height));
    } else if (widget._url != null) {
      var url = (widget._url) ?? '';
      url = url.replaceAll('http:/192', 'http://192');
      child = ImageUtil.networkImage(
          url: url,
          // errorWidget: (Image.asset('assets/images2/icon-touxiang.webp',width: widget.width,height: widget.height,)));
          errorWidget: (Image.asset(
            'assets/images/default_head.png',
            width: widget.width,
            height: widget.height,
          )));
    }
    child = ClipRRect(
      borderRadius: widget.borderRadius,
      child: child,
    );

    if (null != widget.border) {
      child = DecoratedBox(
        decoration: BoxDecoration(
          border: widget.border,
          borderRadius: widget.borderRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: child,
        ),
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: child,
          ),
          if (null != widget.child)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: widget.borderRadius,
                child: widget.child,
              ),
            ),
          if (null != widget.decoration)
            Positioned(
              left: (widget.width - widget.decoration.width) / 2,
              right: (widget.width - widget.decoration.width) / 2,
              top: (widget.height - widget.decoration.height) / 2,
              bottom: (widget.height - widget.decoration.height) / 2,
              child: widget.decoration.child,
            ),
          if (null != widget.decoration && null != widget.decoration.label)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: (widget.height - widget.decoration.height) / 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: widget.decoration.label,
              ),
            ),
        ],
      ),
    );
  }
}

///各牌型间的大小 :  炸弹>五小>金牛>银牛>牛牛>有牛>没牛。
Widget getNiuTypeIcon(var pokerResult, {double width = 25}) {
  //HasNiu      int64        `json:"has_niu"`       // 是否有牛  // 0:无牛  1:有牛  2:牛牛  3:五小  4:银牛  5:金牛  6:炸弹
//type     7炸弹>6五小>5金牛>4银牛>3牛牛>2有牛>1没牛。
  if(pokerResult==null){
    return SizedBox();
  }
  var type = 1;
  if (pokerResult['has_niu'] == 0) {
    type = 1;
  } else if (pokerResult['has_niu'] == 1) {
    type = 2;
  } else if (pokerResult['has_niu'] == 2) {
    type = 3;
  } else if (pokerResult['has_niu'] == 3) {
    type = 6;
  } else if (pokerResult['has_niu'] == 4) {
    type = 4;
  } else if (pokerResult['has_niu'] == 5) {
    type = 5;
  } else if (pokerResult['has_niu'] == 6) {
    type = 7;
  }


  Widget child = SizedBox();
  if(type == 1){
    return SizedBox();
  }
  if (type == 7) {
    child = Image.asset('assets/images/zhadan.png');
  }
  if (type == 6) {
    child = DecoratedBox(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), color: Color(0xffff0000), border: Border.all(width: 1, color: Color(0xffffffff))),
      child: SizedBox(
        width: width,
        height: width,
        child: Center(
            child: Text(
          '小',
          style: TextStyle(fontSize: 12, color: Color(0xffffffff)),
        )),
      ),
    );
  }
  if (type == 5) {
    child = Image.asset('assets/images/jinniu.png');
  }
  if (type == 4) {
    child = Image.asset('assets/images/yinniu.png');
  }
  if (type == 3) {
    child = Image.asset('assets/images/niuniu.png', color: Color(0xff00a2ff));
  }
  if (type == 2) {
    //有牛
    var textColor = Color(0xffffffff);
    if(pokerResult['niu_num']>=7){
      textColor = Color(0xffec6553);
    }
    child = Row(
      children: [
        Center(child: Image.asset('assets/images/youniu.png', width: 20, height: 20,)),
        Padding(
          padding: EdgeInsets.only(left: 2),
          child: Text(pokerResult['niu_num'].toString(), style: TextStyle(fontSize: 18, color: textColor, fontWeight: FontWeight.bold)),
        )
      ],
    );
    return SizedBox(
      child: child,
    );
  }

  return SizedBox(
    width: width,
    height: width,
    child: child,
  );
}
