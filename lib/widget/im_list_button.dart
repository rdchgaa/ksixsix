// @dart = 2.18

import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImListButton extends StatelessWidget {
  final ImListButtonStyle? style;

  final GestureTapCallback? onTap;

  final String title;

  final String? text;

  final Widget? child;

  final String? subTitle;

  final bool active;

  final ImIconStyle? iconStyle;

  const ImListButton({
    Key? key,
    this.style,
    this.onTap,
    required this.title,
    this.text,
    this.child,
    this.subTitle,
    this.iconStyle,
    this.active = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = this.style ?? ImListButtonStyle();
    Widget child = Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: style.titleStyle,
    );
    if (null != subTitle) {
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          child,
          Text(
            subTitle!,
            style: style.subTitleStyle,
          ),
        ],
      );
    }
    child = ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: style.minHeight,
        maxHeight: style.maxHeight,
        maxWidth: style.maxWidth,
        minWidth: style.minWidth,
      ),
      child: Row(
        children: [
          if (null != iconStyle)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Image.asset(
                iconStyle!.asset,
                width: iconStyle!.width,
                height: iconStyle!.height,
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, left: 10, top: 10, bottom: 10),
              child: child,
            ),
          ),
          if (null != text)
            Text(
              text!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 15, height: 22 / 15),
            ),
          if (null != this.child)
            child = DefaultTextStyle(
              style: style.textStyle,
              child: this.child!,
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: null != onTap ? Image.asset("assets/imgs/icon_right.png", width: 12, height: 12) : null,

          ),
        ],
      ),
    );
    if (null != onTap) {
      child = InkWell(
        child: child,
        onTap: onTap,
      );
    }
    if (active) {
      child = Ink(
        color: style.activeColor,
        child: child,
      );
    }
    return child;
  }
}

class ImListButtonStyle {
  final double minWidth;

  final double maxWidth;

  final double minHeight;

  final double maxHeight;

  final TextStyle titleStyle;

  final TextStyle subTitleStyle;

  final TextStyle textStyle;

  final ImIconStyle? rightIcon;

  final Color activeColor;

  const ImListButtonStyle({
    this.minHeight = 50,
    this.maxHeight = double.infinity,
    this.minWidth = 100,
    this.maxWidth = double.infinity,
    this.titleStyle = const TextStyle(fontSize: 15, color: Color(0xff292929)),
    this.textStyle = const TextStyle(fontSize: 15, color: Color(0xFFF73983)),
    this.subTitleStyle = const TextStyle(fontSize: 15, color: Color(0xff9E9E9E)),
    this.rightIcon,
    this.activeColor = const Color(0xfff0f0f0),
  });

  ImListButtonStyle copyWith({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
    TextStyle? titleStyle,
    TextStyle? subTitleStyle,
    TextStyle? textStyle,
    ImIconStyle? rightIcon,
  }) {
    return ImListButtonStyle(
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight ?? this.maxHeight,
      titleStyle: titleStyle ?? this.titleStyle,
      subTitleStyle: subTitleStyle ?? this.subTitleStyle,
      textStyle: textStyle ?? this.textStyle,
      rightIcon: rightIcon ?? this.rightIcon,
    );
  }
}

class ImListInputButton extends StatefulWidget {
  final ImListInputButtonStyle? style;

  final GestureTapCallback? onTap;

  final String title;

  final String? hintText;

  final Widget? child;

  final String? subTitle;

  final bool active;

  final ImIconStyle? iconStyle;

  final Function(String) onChange;

  final bool autofocus;

  ImListInputButton({
    Key? key,
    this.style,
    this.onTap,
    required this.title,
    this.hintText,
    this.child,
    this.subTitle,
    required this.active,
    this.iconStyle,
    required this.onChange,
    this.autofocus = false,
  }) : super(key: key);

  @override
  _ImListInputButtonState createState() => _ImListInputButtonState();
}

class _ImListInputButtonState extends State<ImListInputButton> {
  @override
  Widget build(BuildContext context) {
    var style = widget.style ?? ImListInputButtonStyle();
    Widget child = Text(
      widget.title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: style.titleStyle,
    );
    if (null != widget.subTitle) {
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          child,
          Text(
            widget.subTitle!,
            style: style.subTitleStyle,
          ),
        ],
      );
    }
    child = ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: style.minHeight,
        maxHeight: style.maxHeight,
        maxWidth: style.maxWidth,
        minWidth: style.minWidth,
      ),
      child: Row(
        children: [
          if (null != widget.iconStyle)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Image.asset(
                widget.iconStyle!.asset,
                width: widget.iconStyle!.width,
                height: widget.iconStyle!.height,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16, top: 10, bottom: 10),
            child: child,
          ),
          Expanded(
            child: TextFormField(
              textAlign: TextAlign.right,
              autofocus: widget.autofocus,
              initialValue: "",
              // onSaved: (value) {
              //   widget.data?.nikeName = value;
              // },
              onChanged: (value) {
                widget.onChange(value);
                setState(() {});
              },
              maxLines: 1,
              maxLength: 15,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Color(0xffC4C4C4), fontSize: 13, height: 18 / 13),
                counterText: '',
                filled: true,
                // hintStyle: TextStyle(color: Color(0xff999999), fontSize: 13, height: 18 / 13),
                errorStyle: TextStyle(color: Color(0xff767676), fontSize: 13, height: 18 / 13),
                fillColor: Color(0x00f4f4f4),
                focusColor: Colors.white,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 0),
              ),
              validator: (value) {
                // if (value == null || value.isEmpty) {
                //   return Languages.of(context).newNickname;
                // }
                return null;
              },
            ),
          ),
          if (null != widget.child)
            child = DefaultTextStyle(
              style: style.textStyle,
              child: widget.child!,
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: null != widget.onTap ? Image.asset("assets/imgs/icon_right.png", width: 12, height: 12) : null,
          ),
        ],
      ),
    );
    return child;
  }
}

class ImListInputButtonStyle {
  final double minWidth;

  final double maxWidth;

  final double minHeight;

  final double maxHeight;

  final TextStyle titleStyle;

  final TextStyle subTitleStyle;

  final TextStyle textStyle;

  final ImIconStyle? rightIcon;

  final Color activeColor;

  const ImListInputButtonStyle({
    this.minHeight = 50,
    this.maxHeight = double.infinity,
    this.minWidth = 100,
    this.maxWidth = double.infinity,
    this.titleStyle = const TextStyle(fontSize: 15, color: Color(0xff292929)),
    this.textStyle = const TextStyle(fontSize: 15, color: Color(0xFFF73983)),
    this.subTitleStyle = const TextStyle(fontSize: 15, color: Color(0xff9E9E9E)),
    this.rightIcon,
    this.activeColor = const Color(0xfff0f0f0),
  });

  ImListInputButtonStyle copyWith({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
    TextStyle? titleStyle,
    TextStyle? subTitleStyle,
    TextStyle? textStyle,
    ImIconStyle? rightIcon,
  }) {
    return ImListInputButtonStyle(
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight ?? this.maxHeight,
      titleStyle: titleStyle ?? this.titleStyle,
      subTitleStyle: subTitleStyle ?? this.subTitleStyle,
      textStyle: textStyle ?? this.textStyle,
      rightIcon: rightIcon ?? this.rightIcon,
    );
  }
}

class ImIconStyle {
  final String asset;

  final double height;

  final double width;

  const ImIconStyle({
    required this.asset,
    this.height = 18,
    this.width = 18,
  });

  ImIconStyle copyWith({
    String? asset,
    double? height,
    double? width,
  }) {
    return ImIconStyle(
      asset: asset ?? this.asset,
      height: height ?? this.height,
      width: width ?? this.width,
    );
  }
}
