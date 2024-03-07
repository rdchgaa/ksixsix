import 'package:flutter_svg/svg.dart';
import 'package:xxc_flutter_utils/xxc_flutter_utils.dart';
import 'package:ima2_habeesjobs/util/other.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget leading;
  final bool automaticallyImplyLeading;
  final Widget title;
  final List<Widget> actions;
  final Widget flexibleSpace;
  final PreferredSizeWidget bottom;
  final double elevation;
  final Color shadowColor;
  final Color foregroundColor;
  final Color pcForegroundColor;
  final List<Color> backgroundColor;
  final List<Color> pcBackgroundColor;
  final Brightness brightness;
  final IconThemeData iconTheme;
  final IconThemeData actionsIconTheme;
  final TextTheme textTheme;
  final bool primary;
  final bool centerTitle;
  final bool excludeHeaderSemantics;
  final double titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  final double toolbarHeight;
  final double leadingWidth;
  final bool backwardsCompatibility;
  final TextStyle toolbarTextStyle;
  final TextStyle titleTextStyle;
  final SystemUiOverlayStyle systemOverlayStyle;
  final ShapeBorder shape;

  Size _preferredSize;

  MyAppBar({
    Key key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.shadowColor,
    this.shape,
    this.brightness,
    this.iconTheme,
    this.actionsIconTheme,
    this.textTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.toolbarHeight,
    this.leadingWidth,
    this.backwardsCompatibility,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark
    ),
    this.backgroundColor = const [Color(0x00703EFE), Color(0x000703EFE)],
    this.pcBackgroundColor = const [Color(0xffeeeeee), Color(0xffeeeeee)],
    this.pcForegroundColor = Colors.black87,
    this.foregroundColor = Colors.white,
  }) : super(key: key) {
    _preferredSize = Size.fromHeight(toolbarHeight ?? kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0));
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isPc(context) ? pcBackgroundColor : backgroundColor,
        ),
      ),
      child: AppBar(
        leading: this.leading ??
            IconButton(
              icon: Padding(
                padding: const EdgeInsets.only(top: 9, bottom: 9),
                child: Center(
                  child: SvgPicture.string(
                    svg_i3q6wh,
                    allowDrawingOutsideViewBox: true,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              onPressed: () {
                // AutoRouter.of(context).pop();
                Navigator.pop(context);
              },
            ),
        automaticallyImplyLeading: this.automaticallyImplyLeading,
        title: this.title,
        actions: this.actions,
        flexibleSpace: this.flexibleSpace,
        bottom: this.bottom,
        elevation: this.elevation,
        shadowColor: this.shadowColor,
        backgroundColor: Colors.transparent,
        shape: this.shape,
        foregroundColor: isPc(context) ? this.pcForegroundColor : this.foregroundColor,
        brightness: this.brightness,
        iconTheme: IconThemeData(color: isPc(context) ? this.pcForegroundColor : this.foregroundColor).merge(this.iconTheme),
        actionsIconTheme: this.actionsIconTheme,
        textTheme: this.textTheme,
        primary: this.primary,
        centerTitle: this.centerTitle,
        excludeHeaderSemantics: this.excludeHeaderSemantics,
        titleSpacing: this.titleSpacing,
        toolbarOpacity: this.toolbarOpacity,
        bottomOpacity: this.bottomOpacity,
        toolbarHeight: this.toolbarHeight,
        leadingWidth: this.leadingWidth,
        backwardsCompatibility: this.backwardsCompatibility,
        toolbarTextStyle: this.toolbarTextStyle,
        titleTextStyle: titleTextStyle,
        systemOverlayStyle: this.systemOverlayStyle,
      ),
    );
  }

  @override
  Size get preferredSize => _preferredSize;
}

class EditAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Color> backgroundColor;
  final double toolbarHeight;
  final Widget child;

  Size _preferredSize;

  EditAppBar({
    Key key,
    this.backgroundColor = const [Color(0xff008080), Color(0xff008080)],
    this.toolbarHeight,
    this.child,
  }) : super(key: key) {
    this._preferredSize = Size.fromHeight(toolbarHeight ?? kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.top + preferredSize.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: this.backgroundColor,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: this.child,
      ),
    );
  }

  Size get preferredSize => this._preferredSize;
}

const String svg_i3q6wh =
    '<svg viewBox="1.5 6.4 22.8 14.4" ><path transform="matrix(-1.0, 0.0, 0.0, -1.0, 24.26, 20.86)" d="M 14.31960105895996 0.3926757872104645 C 13.76555919647217 0.9152726531028748 13.76555919647217 1.765827536582947 14.31960105895996 2.289395809173584 L 18.10688209533691 5.867764472961426 L 1.419087290763855 5.867764472961426 C 0.6353968381881714 5.867764472961426 0 6.468213558197021 0 7.208800792694092 C 0 7.949387073516846 0.6353968381881714 8.550809860229492 1.419087290763855 8.550809860229492 L 18.10623741149902 8.550809860229492 L 14.31960105895996 12.12917709350586 C 13.76555919647217 12.65177249908447 13.76555919647217 13.50232887268066 14.31960105895996 14.02589893341064 C 14.87364101409912 14.54849433898926 15.77267074584961 14.54849433898926 16.32671356201172 14.02589893341064 L 22.34805107116699 8.335739135742188 C 22.66985321044922 8.031068801879883 22.80432319641113 7.616061210632324 22.75160980224609 7.219081401824951 C 22.81175804138184 6.815980911254883 22.67795753479004 6.391677379608154 22.3501091003418 6.081862926483154 L 16.32671356201172 0.3926757872104645 C 16.0496940612793 0.1308923959732056 15.68642425537109 0 15.32315635681152 0 C 14.95989036560059 0 14.59662055969238 0.1308923959732056 14.31960105895996 0.3926757872104645 Z" fill="#0e0f0f" stroke="#0e0f0f" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';

Widget leading(BuildContext context) {
  return SizedBox(
    width: 26,
    height: 14,
    child: InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Center(
        child: SvgPicture.string(
          svg_i3q6wh,
          allowDrawingOutsideViewBox: true,
          fit: BoxFit.fill,
        ),
      ),
    ),
  );
}