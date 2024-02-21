import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatefulWidget {
  final List<MyNavigationBarItem> items;

  int currentIndex;

  final double height;

  final void Function(int) onTap;

  AppBottomNavigationBar({Key key, this.items, this.currentIndex = 0, this.height = 61, this.onTap}) : super(key: key);

  @override
  _AppBottomNavigationBarState createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    var bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      padding: EdgeInsets.only(bottom: bottom),
      height: widget.height + bottom + 0.5,
      child: Column(
        children: [
          Divider(height: 0.5),
          Row(
            children: [
              for (var item in widget.items)
                Expanded(
                  child: SizedBox(
                    height: widget.height,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: null != item.onPressed
                          ? item.onPressed
                          : () {
                        setState(() {
                          widget.currentIndex = item.index;
                        });
                        widget.onTap(item.index);
                      },
                      child: Center(
                        child: _Tag(
                          child: (item.index == widget.currentIndex ? item.icon : item.unselected) ?? item.icon,
                          color: item.tagColor,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final Widget child;

  final double width;

  final double height;

  final Color color;

  const _Tag({
    Key key,
    this.child,
    this.width = 10,
    this.height = 10,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        this.child,
        if (null != this.color)
          Positioned(
            top: -this.height * 0.4,
            right: -this.width * 0.4,
            child: Container(
              width: this.width,
              height: this.width,
              decoration: BoxDecoration(
                color: this.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

class MyNavigationBarItem {
  final int index;
  final Widget icon;
  final Widget unselected;
  final Color tagColor;
  final VoidCallback onPressed;

  MyNavigationBarItem({
    this.index,
    this.icon,
    this.unselected,
    this.tagColor,
    this.onPressed,
  });
}

class AppNavigationRail extends StatefulWidget {
  final List<MyNavigationBarItem> items;

  final List<Widget> headers;

  final List<Widget> bottoms;

  int currentIndex;

  final double width;

  final void Function(int) onTap;

  AppNavigationRail({Key key, this.items, this.currentIndex = 0, this.width = 61, this.onTap, this.headers, this.bottoms}) : super(key: key);

  @override
  _AppNavigationRailState createState() => _AppNavigationRailState();
}

class _AppNavigationRailState extends State<AppNavigationRail> {
  @override
  Widget build(BuildContext context) {
    var left = MediaQuery.of(context).padding.left;
    return Material(
      color: Theme.of(context).navigationRailTheme.backgroundColor,
      child: SizedBox(
        width: widget.width + left,
        child: Column(
          children: [
            if (null != widget.headers) ...widget.headers,
            for (var item in widget.items)
              SizedBox(
                height: widget.width,
                child: IconButton(
                  padding: EdgeInsets.all(4),
                  onPressed: null != item.onPressed
                      ? item.onPressed
                      : () {
                          setState(() {
                            widget.currentIndex = item.index;
                          });
                          widget.onTap(item.index);
                        },
                  icon: Center(
                    child: _Tag(
                      child: (item.index == widget.currentIndex ? item.icon : item.unselected) ?? item.icon,
                      color: item.tagColor,
                    ),
                  ),
                ),
              ),
            Spacer(),
            if (null != widget.bottoms) ...widget.bottoms,
          ],
        ),
      ),
    );
  }
}
