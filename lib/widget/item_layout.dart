import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LayoutItem extends StatelessWidget {
  final GestureTapCallback onTap;

  final String title;

  final Widget rightIcon;

  final Widget leftIcon;

  final TextStyle titleStyle;

  final Widget content;
  final double height;

  const LayoutItem({
    Key key,
    this.onTap,
    this.title,
    this.rightIcon,
    this.leftIcon,
    this.titleStyle = const TextStyle(color: Color(0xff474747), fontSize: 16),
    this.content,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, con) {
        return SizedBox(
          height: this.height ?? 48,
          child: InkWell(
            onTap: this.onTap,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 11),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (this.leftIcon != null) this.leftIcon,
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: con.biggest.width / 4 * 3),
                    child: Text(
                      this.title,
                      style: this.titleStyle,
                    ),
                  ),
                  Expanded(child: null != this.content ? this.content : SizedBox()),
                  this.rightIcon ??
              SizedBox()
                      // Image.asset(
                      //   "assets/new_icons/icon_n_right.png",
                      //   width: 18,
                      //   height: 18,
                      // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class LayoutItemSecond extends StatelessWidget {
  final GestureTapCallback onTap;

  final Widget title;
  final double height;
  final double left;
  final double right;
  final Widget rightIcon;
  final Widget leftIcon;

  const LayoutItemSecond({
    Key key,
    this.onTap,
    this.title,
    this.rightIcon,
    this.leftIcon,
    this.height,
    this.left,
    this.right,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: this.height ?? 44,
      child: InkWell(
        onTap: this.onTap,
        child: Padding(
          padding:  EdgeInsets.only(left:  this.left??12, right: this.right??12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (this.leftIcon != null) this.leftIcon,
              if (this.title != null) Expanded(child: this.title) else Spacer(),
              if (this.rightIcon != null) this.rightIcon,
            ],
          ),
        ),
      ),
    );
  }
}
