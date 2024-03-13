import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ima2_habeesjobs/widget/app_content.dart';

//有标题加按钮板块style
class UiLayoutTitleAndButtonStyle {
  final TextStyle titleStyle;

  final EdgeInsetsGeometry titlePadding;

  final EdgeInsetsGeometry childPadding;

  final MainAxisAlignment mainAxisAlignment;

  UiLayoutTitleAndButtonStyle({
    this.titleStyle,
    this.titlePadding,
    this.childPadding,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
  });

  UiLayoutTitleAndButtonStyle copyWith({
    TextStyle titleStyle,
    EdgeInsetsGeometry titlePadding,
    EdgeInsetsGeometry childPadding,
    MainAxisAlignment mainAxisAlignment,
  }) {
    return UiLayoutTitleAndButtonStyle(
      titleStyle: titleStyle ?? this.titleStyle,
      titlePadding: titlePadding ?? this.titlePadding,
      childPadding: childPadding ?? this.childPadding,
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
    );
  }
}


//横排 icon+widget+箭头
class UiLayoutTitleAndIconItemStyle {
  final Widget rightIcon;
  final EdgeInsetsGeometry itemPadding;
  final double height;
  final TextStyle titleStyle;

  UiLayoutTitleAndIconItemStyle({
    this.itemPadding,
    this.titleStyle,
    this.height,
    this.rightIcon,
  });
}

//横排 icon+文字+箭头
class UiLayoutTextAndIconItem extends StatelessWidget {
  UiLayoutTitleAndIconItemStyle style;
  final Widget leftIcon;
  final Widget rightIcon;
  final String title;
  final FutureVoidCallback onTap;

  UiLayoutTextAndIconItem({Key key, this.leftIcon, this.title, this.onTap, this.rightIcon, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UiLayoutTitleAndIconItemStyle style = this.style ?? layoutItemStyle;
    return LayoutBuilder(
      builder: (context, con) {
        return InkWell(
          onTap: onTap,
          child: SizedBox(
            height: style.height,
            child: Padding(
              padding: style.itemPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (leftIcon != null) leftIcon,
                  Expanded(
                    child: Text(
                      title,
                      style: style.titleStyle,
                    ),
                  ),
                  if (null != this.rightIcon) this.rightIcon else if (style.rightIcon != null) style.rightIcon
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


class UiModalBottomLayoutStyle {
  final BorderRadius borderRadius;
  final ImageFilter filter;
  final Color color;
  final Color closeColor;
  final List<BoxShadow> boxShadow;

  UiModalBottomLayoutStyle({
    this.borderRadius,
    this.filter,
    this.color,
    this.closeColor,
    this.boxShadow,
  });

  UiModalBottomLayoutStyle copyWith({
    BorderRadius borderRadius,
    ImageFilter filter,
    Color color,
    Color closeColor,
    List<BoxShadow> boxShadow,
  }) {
    return UiModalBottomLayoutStyle(
      borderRadius: borderRadius ?? this.borderRadius,
      filter: filter ?? this.filter,
      color: color ?? this.color,
      closeColor: closeColor ?? this.closeColor,
      boxShadow: boxShadow ?? this.boxShadow,
    );
  }
}
//底部菜单层
class UiModalBottomLayout extends StatelessWidget {
  final List<Widget> children;
  final UiModalBottomLayoutStyle style;

  const UiModalBottomLayout({Key key, this.children, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = this.style ?? modalBottomLayoutStyle;
    return Container(
      decoration: BoxDecoration(
        borderRadius: style.borderRadius,
        boxShadow: style.boxShadow,
      ),
      padding: EdgeInsets.only(top: 2),
      child: ClipRRect(
        borderRadius: style.borderRadius,
        child: BackdropFilter(
          filter: style.filter,
          child: Material(
            color: style.color,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  child: Material(
                    color: style.closeColor,
                    child: SizedBox(
                      width: 78,
                      height: 24,
                      child: InkWell(
                        onTap: () async {
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images2/icon_down.webp",
                              width: 12,
                              height: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

















//底部弹窗背景样式
UiModalBottomLayoutStyle get modalBottomLayoutStyle => UiModalBottomLayoutStyle(
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(10),
      topRight: Radius.circular(10),
    ),
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    color: areaBg.withOpacity(0.8),
    closeColor: areaButton,
    boxShadow: [BoxShadow(color: Color(0xFFE870D0).withOpacity(0.2), blurRadius: 6, offset: Offset(0, -3))]);



UiLayoutTitleAndIconItemStyle get layoutItemStyle => UiLayoutTitleAndIconItemStyle(
  height: 56,
  itemPadding: const EdgeInsets.only(left: 16, right: 16),
  titleStyle: textStyleH3White,
  rightIcon: Image.asset(
    'assets/images/right.png',
    width: 12,
    height: 12,
  ),
);
UiLayoutTitleAndIconItemStyle get layoutItemStyle2 => UiLayoutTitleAndIconItemStyle(
  height: 60,
  itemPadding: const EdgeInsets.only(left: 24, right: 24),
  titleStyle: textStyleBody4,
  rightIcon: Image.asset(
    'assets/images/right.png',
    width: 15,
    height: 15,
  ),
);


//H3：14；0xffFFFFFF
TextStyle get textStyleH3White => const TextStyle(fontSize: 14, color: Color(0xffffffff), fontWeight: FontWeight.normal);
TextStyle get textStyleBody4 => const TextStyle(fontSize: 14, color: Color(0xffdddddd), fontWeight: FontWeight.normal);
//H3：14；0xffFFFFFF
TextStyle get textStyleH3 => TextStyle(fontSize: 14, color: Color(0xff3A4052), fontWeight: FontWeight.normal);
//H4：12；0xff6A768D
TextStyle get textStyleH4 => const TextStyle(fontSize: 12, color: Color(0xff6A768D), fontWeight: FontWeight.normal);


//边距（小）
EdgeInsets paddingSmall = const EdgeInsets.all(8);

//圆角（迷你）
BorderRadius borderRadiusMin = BorderRadius.circular(4);


//区号弹框背景
Color get areaBg => Color(0xff131530);

//区号弹窗按钮
Color get areaButton => Color(0xff090720);




//背景框 装饰样式
BoxDecoration get backGroundDecoration => BoxDecoration(color: backgroundColorModule, borderRadius: borderRadiusMin);


//模块背景色
ColorSwatch backgroundColorModule = const MaterialColor(
  0xff131530,
  <int, Color>{
    50: Color(0xfff8f4ff),
    100: Color(0xfff0edff),
    200: Color(0xffe6e2ff),
    300: Color(0xffd5d2f8),
    400: Color(0xffb0add3),
    500: Color(0xff908db1),
    600: Color(0xff686687),
    700: Color(0xff545273),
    800: Color(0xff353453),
    900: Color(0xff131530),
  },
);
//前景主色调
ColorSwatch foregroundColor = const MaterialColor(
  0xFFA900E6,
  <int, Color>{
    50: Color(0xfff5e5fc),
    100: Color(0xffe6bff7),
    200: Color(0xffd694f4),
    300: Color(0xffc566ef),
    400: Color(0xffb73eeb),
    500: Color(0xffa900e6),
    600: Color(0xff9706e0),
    700: Color(0xff7d09d9),
    800: Color(0xff6609d4),
    900: Color(0xff240acd),
  },
);