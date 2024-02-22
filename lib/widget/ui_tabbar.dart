import 'package:flutter/material.dart';
import 'package:ima2_habeesjobs/widget/app_tab_indicator.dart';
import 'package:ima2_habeesjobs/widget/ui_layout.dart';

class UiTabBarStyle {
  final Color unselectedLabelColor;

  final TextStyle labelStyle;

  final TextStyle unselectedLabelStyle;

  final Color labelColor;

  final bool isScrollable;

  final TabBarIndicatorSize indicatorSize;

  final Color indicatorColor;

  final Decoration indicator;

  final EdgeInsets labelPadding;

  final BorderRadius splashBorderRadius;

  final EdgeInsetsGeometry indicatorPadding;

  final double height;

  final BoxConstraints constraints;

  final EdgeInsetsGeometry padding;

  UiTabBarStyle(
      {this.unselectedLabelColor,
      this.labelStyle,
      this.unselectedLabelStyle,
      this.labelColor, this.isScrollable,
      this.indicatorSize,
      this.indicatorColor,
      this.indicator,
      this.labelPadding,
      this.splashBorderRadius,
      this.indicatorPadding,
      this.height,
      this.constraints,
      this.padding});

  UiTabBarStyle copyWith({
    Color unselectedLabelColor,
    TextStyle labelStyle,
    TextStyle unselectedLabelStyle,
    Color labelColor,
    bool isScrollable,
    TabBarIndicatorSize indicatorSize,
    Color indicatorColor,
    Decoration indicator,
    EdgeInsets labelPadding,
    BorderRadius splashBorderRadius,
    EdgeInsetsGeometry indicatorPadding,
    double height,
    BoxConstraints constraints,
    EdgeInsetsGeometry padding,
  }) {
    return UiTabBarStyle(
      unselectedLabelColor: unselectedLabelColor ?? this.unselectedLabelColor,
      labelStyle: labelStyle ?? this.labelStyle,
      unselectedLabelStyle: unselectedLabelStyle ?? this.unselectedLabelStyle,
      labelColor: labelColor ?? this.labelColor,
      isScrollable: isScrollable ?? this.isScrollable,
      indicatorSize: indicatorSize ?? this.indicatorSize,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      indicator: indicator ?? this.indicator,
      labelPadding: labelPadding ?? this.labelPadding,
      splashBorderRadius: splashBorderRadius ?? this.splashBorderRadius,
      indicatorPadding: indicatorPadding ?? this.indicatorPadding,
      height: height ?? this.height,
      constraints: constraints ?? this.constraints,
      padding: padding ?? this.padding,
    );
  }
}

class UiTabBar extends StatefulWidget {
  final List<Widget> tabs;
  final UiTabBarStyle style;
  final void Function(int index) onChange;
  final TabController controller;
  const UiTabBar({
    Key key,
    this.tabs,
    this.style,
    this.onChange,
    this.controller,
  }) : super(key: key);

  @override
  State<UiTabBar> createState() => _UiTabBarState();
}

class _UiTabBarState extends State<UiTabBar> {
  TabController _controller;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(widget.controller!=null){
        _controller = widget.controller;
      }else{
        _controller = DefaultTabController.of(context);
      }
      _controller?.addListener(_onListener);
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant UiTabBar oldWidget) {
    if (_controller != DefaultTabController.of(context)) {
      if(widget.controller == null){
        _controller?.removeListener(_onListener);
        _controller = DefaultTabController.of(context);
        _controller?.addListener(_onListener);
      }
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onListener);
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var style = this.widget.style ?? uiTabBarStyle;
    return Padding(
      padding: style.padding,
      child: TabBar(
        controller: widget.controller??null,
        unselectedLabelColor: style.unselectedLabelColor,
        labelStyle: style.labelStyle,
        unselectedLabelStyle: style.unselectedLabelStyle,
        labelColor: style.labelColor,
        isScrollable: style.isScrollable,
        indicatorSize: style.indicatorSize,
        indicatorColor: style.indicatorColor,
        indicator: style.indicator,
        labelPadding: style.labelPadding,
        splashBorderRadius: style.splashBorderRadius,
        indicatorPadding: style.indicatorPadding,
        tabs: widget.tabs,
      ),
    );
  }

  void _onListener() {
    widget.onChange?.call(_controller?.index ?? 0);
  }
}


//Tabber样式
UiTabBarStyle get uiTabBarStyle => UiTabBarStyle(
  height: 38,
  padding: EdgeInsets.only(top: 5, bottom: 5),
  unselectedLabelColor: unselectedTabColor,
  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
  unselectedLabelStyle: const TextStyle(fontSize: 18),
  labelColor: Colors.white,
  isScrollable: true,
  indicatorSize: TabBarIndicatorSize.label,
  indicatorColor: foregroundColor,
  indicator: AppUnderlineTabIndicator(
    borderSide: BorderSide(width: 4.0, color: foregroundColor),
    strokeCap: StrokeCap.round,
  ),
  labelPadding: const EdgeInsets.symmetric(
    horizontal: 12,
  ),
  indicatorPadding: const EdgeInsets.only(bottom: 2, left: 10, right: 10),
  constraints: BoxConstraints(minWidth: 80),
);


//TabBar 没有选中的字体颜色#6A768D
Color get unselectedTabColor => const Color(0xff6A768D);

//TabBar 选中的字体
Color get selectedTabColor => const Color(0xffFFFFFF);
