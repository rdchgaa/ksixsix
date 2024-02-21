import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/gestures/long_press.dart';

const Duration _kMenuDuration = Duration(milliseconds: 300);
const double _kMenuCloseIntervalEnd = 2.0 / 3.0;
const double _kMenuHorizontalPadding = 16.0;
const double _kMenuDividerHeight = 16.0;
const double _kMenuMaxWidth = 5.0 * _kMenuWidthStep;
const double _kMenuMinWidth = 2.0 * _kMenuWidthStep;
const double _kMenuVerticalPadding = 8.0;
const double _kMenuWidthStep = 56.0;
const double _kMenuScreenPadding = 8.0;

class AppMenu<T> extends StatefulWidget {
  final GestureTapCallback onTap;

  final Widget child;

  final Offset offset;

  final PopupMenuItemBuilder<T> itemBuilder;

  final PopupMenuItemSelected<T> onSelected;

  final PopupMenuCanceled onCanceled;

  final PopupMenuDivider divider;

  const AppMenu({
    Key key,
    @required this.child,
    @required this.itemBuilder,
    this.onTap,
    this.offset = Offset.zero,
    this.onSelected,
    this.onCanceled,
    this.divider,
  }) : super(key: key);

  @override
  State<AppMenu<T>> createState() => _AppMenuState<T>();
}

class _AppMenuState<T> extends State<AppMenu<T>> {
  Offset _position;
  RectCallback getRectCallback(RenderBox referenceBox) => null;
  @override
  Widget build(BuildContext context) {
    final _ParentInkResponseState parentState = _ParentInkResponseProvider.of(context);
    return _InkResponseStateWidget(
      getRectCallback: getRectCallback,
      parentState: parentState,
      highlightShape: BoxShape.rectangle,
      containedInkWell: true,
      enableFeedback: true,
      child: this.widget.child,
      onTap: widget.onTap,
      onLongPressDown: (details) => _position = details.localPosition,
      onLongPressMoveUpdate: (details) => _position = details.localPosition,
      onLongPress: Platform.isAndroid || Platform.isIOS ? () => _onOpenMenu(context, _position) : null,
      onSecondaryTapUp: Platform.isWindows || Platform.isMacOS || Platform.isLinux ? (details) => _onOpenMenu(context, details.localPosition) : null,
    );
  }

  _onOpenMenu(BuildContext context, Offset offset) {
    var items = <PopupMenuEntry<T>>[];
    var list = widget.itemBuilder(context);
    if (list.isEmpty) {
      return;
    }
    for (var i = 0; i < list.length; i++) {
      if (0 < i) {
        items.add(widget.divider);
      }
      items.add(list[i]);
    }
    showAppMenu<T>(
      context: context,
      items: items,
      offset: offset,
    ).then<void>((T newValue) {
      if (!mounted) return null;
      if (newValue == null) {
        widget.onCanceled?.call();
        return null;
      }
      widget.onSelected?.call(newValue);
    });
  }
}

class _RenderMenuItem extends RenderShiftedBox {
  _RenderMenuItem(this.onLayout, [RenderBox child])
      : assert(onLayout != null),
        super(child);

  ValueChanged<Size> onLayout;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (child == null) {
      return Size.zero;
    }
    return child.getDryLayout(constraints);
  }

  @override
  void performLayout() {
    if (child == null) {
      size = Size.zero;
    } else {
      child.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(child.size);
      final BoxParentData childParentData = child.parentData as BoxParentData;
      childParentData.offset = Offset.zero;
    }
    onLayout(size);
  }
}

class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  _PopupMenuRouteLayout(
    this.position,
    this.itemSizes,
    this.selectedItemIndex,
    this.textDirection,
    this.padding,
  );

  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;

  // The sizes of each item are computed when the menu is laid out, and before
  // the route is laid out.
  List<Size> itemSizes;

  // The index of the selected item, or null if PopupMenuButton.initialValue
  // was not specified.
  final int selectedItemIndex;

  // Whether to prefer going to the left or to the right.
  final TextDirection textDirection;

  // The padding of unsafe area.
  EdgeInsets padding;

  // We put the child wherever position specifies, so long as it will fit within
  // the specified parent size padded (inset) by 8. If necessary, we adjust the
  // child's position so that it fits.

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(constraints.biggest).deflate(
      const EdgeInsets.all(_kMenuScreenPadding) + padding,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.

    final double buttonHeight = size.height - position.top - position.bottom;
    // Find the ideal vertical position.
    double y = position.top;
    if (selectedItemIndex != null && itemSizes != null) {
      double selectedItemOffset = _kMenuVerticalPadding;
      for (int index = 0; index < selectedItemIndex; index += 1) selectedItemOffset += itemSizes[index].height;
      selectedItemOffset += itemSizes[selectedItemIndex].height / 2;
      y = y + buttonHeight / 2.0 - selectedItemOffset;
    }

    // Find the ideal horizontal position.
    double x;
    // if (position.left > position.right) {
    //   // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
    //   x = size.width - position.right - childSize.width;
    // } else if (position.left < position.right) {
    // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
    x = position.left;
    // } else {
    //   // Menu button is equidistant from both edges, so grow in reading direction.
    //   assert(textDirection != null);
    //   switch (textDirection) {
    //     case TextDirection.rtl:
    //       x = size.width - position.right - childSize.width;
    //       break;
    //     case TextDirection.ltr:
    //       x = position.left;
    //       break;
    //   }
    // }

    // Avoid going outside an area defined as the rectangle 8.0 pixels from the
    // edge of the screen in every direction.
    if (x < _kMenuScreenPadding + padding.left)
      x = _kMenuScreenPadding + padding.left;
    else if (x + childSize.width > size.width - _kMenuScreenPadding - padding.right) x = size.width - childSize.width - _kMenuScreenPadding - padding.right;
    if (y < _kMenuScreenPadding + padding.top)
      y = _kMenuScreenPadding + padding.top;
    else if (y + childSize.height > size.height - _kMenuScreenPadding - padding.bottom)
      y = size.height - padding.bottom - _kMenuScreenPadding - childSize.height;

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) {
    // If called when the old and new itemSizes have been initialized then
    // we expect them to have the same length because there's no practical
    // way to change length of the items list once the menu has been shown.
    assert(itemSizes.length == oldDelegate.itemSizes.length);

    return position != oldDelegate.position ||
        selectedItemIndex != oldDelegate.selectedItemIndex ||
        textDirection != oldDelegate.textDirection ||
        !listEquals(itemSizes, oldDelegate.itemSizes) ||
        padding != oldDelegate.padding;
  }
}

class _MenuItem extends SingleChildRenderObjectWidget {
  const _MenuItem({
    Key key,
    this.onLayout,
    Widget child,
  })  : assert(onLayout != null),
        super(key: key, child: child);

  final ValueChanged<Size> onLayout;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMenuItem(onLayout);
  }

  @override
  void updateRenderObject(BuildContext context, covariant _RenderMenuItem renderObject) {
    renderObject.onLayout = onLayout;
  }
}

class _PopupMenu<T> extends StatelessWidget {
  const _PopupMenu({
    Key key,
    this.route,
    this.semanticLabel,
  }) : super(key: key);

  final _PopupMenuRoute<T> route;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final double unit = 1.0 / (route.items.length + 1.5); // 1.0 for the width and 0.5 for the last item's fade.
    final List<Widget> children = <Widget>[];
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);

    for (int i = 0; i < route.items.length; i += 1) {
      final double start = (i + 1) * unit;
      final double end = (start + 1.5 * unit).clamp(0.0, 1.0);
      final CurvedAnimation opacity = CurvedAnimation(
        parent: route.animation,
        curve: Interval(start, end),
      );
      Widget item = route.items[i];
      if (route.initialValue != null && route.items[i].represents(route.initialValue)) {
        item = Container(
          color: Theme.of(context).highlightColor,
          child: item,
        );
      }
      children.add(
        _MenuItem(
          onLayout: (Size size) {
            route.itemSizes[i] = size;
          },
          child: FadeTransition(
            opacity: opacity,
            child: item,
          ),
        ),
      );
    }

    final CurveTween opacity = CurveTween(curve: const Interval(0.0, 1.0 / 3.0));
    final CurveTween width = CurveTween(curve: Interval(0.0, unit));
    final CurveTween height = CurveTween(curve: Interval(0.0, unit * route.items.length));

    final Widget child = ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: _kMenuMinWidth,
        maxWidth: _kMenuMaxWidth,
      ),
      child: IntrinsicWidth(
        stepWidth: _kMenuWidthStep,
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: semanticLabel,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: _kMenuVerticalPadding,
            ),
            child: ListBody(children: children),
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: route.animation,
      builder: (BuildContext context, Widget child) {
        return Opacity(
          opacity: opacity.evaluate(route.animation),
          child: Material(
            shape: route.shape ?? popupMenuTheme.shape,
            color: route.color ?? popupMenuTheme.color,
            type: MaterialType.card,
            elevation: route.elevation ?? popupMenuTheme.elevation ?? 8.0,
            child: Align(
              alignment: AlignmentDirectional.topEnd,
              widthFactor: width.evaluate(route.animation),
              heightFactor: height.evaluate(route.animation),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}

class _PopupMenuRoute<T> extends PopupRoute<T> {
  _PopupMenuRoute({
    this.position,
    this.items,
    this.initialValue,
    this.elevation,
    this.barrierLabel,
    this.semanticLabel,
    this.shape,
    this.color,
    this.capturedThemes,
  }) : itemSizes = List<Size>.filled(items.length, null);

  final RelativeRect position;
  final List<PopupMenuEntry<T>> items;
  final List<Size> itemSizes;
  final T initialValue;
  final double elevation;
  final String semanticLabel;
  final ShapeBorder shape;
  final Color color;
  final CapturedThemes capturedThemes;

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: super.createAnimation(),
      curve: Curves.linear,
      reverseCurve: const Interval(0.0, _kMenuCloseIntervalEnd),
    );
  }

  @override
  Duration get transitionDuration => _kMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => null;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    int selectedItemIndex;
    if (initialValue != null) {
      for (int index = 0; selectedItemIndex == null && index < items.length; index += 1) {
        if (items[index].represents(initialValue)) selectedItemIndex = index;
      }
    }

    final Widget menu = _PopupMenu<T>(route: this, semanticLabel: semanticLabel);
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _PopupMenuRouteLayout(
              position,
              itemSizes,
              selectedItemIndex,
              Directionality.of(context),
              mediaQuery.padding,
            ),
            child: capturedThemes.wrap(menu),
          );
        },
      ),
    );
  }
}

Future<T> showAppMenu<T>({
  @required BuildContext context,
  @required List<PopupMenuEntry<T>> items,
  T initialValue,
  double elevation,
  String semanticLabel,
  ShapeBorder shape,
  Color color,
  Offset offset = Offset.zero,
}) {
  if (items.isEmpty) {
    return Future.value(null);
  }
  final NavigatorState navigator = Navigator.of(context, rootNavigator: true);
  final RenderBox self = context.findRenderObject() as RenderBox;
  final RenderBox overlay = navigator.overlay.context.findRenderObject() as RenderBox;

  final RelativeRect position = RelativeRect.fromRect(
    Rect.fromPoints(
      self.localToGlobal(offset, ancestor: overlay),
      self.localToGlobal(self.size.bottomRight(offset), ancestor: overlay),
    ),
    Offset.zero & overlay.size,
  );

  switch (Theme.of(context).platform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      break;
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
      semanticLabel ??= MaterialLocalizations.of(context).popupMenuLabel;
  }

  return navigator.push(_PopupMenuRoute<T>(
    position: position,
    items: items,
    initialValue: initialValue,
    elevation: elevation,
    semanticLabel: semanticLabel,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    shape: shape,
    color: color,
    capturedThemes: InheritedTheme.capture(from: context, to: navigator.context),
  ));
}

class _InkResponseStateWidget extends StatefulWidget {
  final GestureLongPressDownCallback onLongPressDown;
  final GestureLongPressMoveUpdateCallback onLongPressMoveUpdate;
  final GestureTapUpCallback onSecondaryTapUp;

  const _InkResponseStateWidget({
    this.child,
    this.onTap,
    this.onTapDown,
    this.onTapCancel,
    this.onDoubleTap,
    this.onLongPress,
    this.onHighlightChanged,
    this.onHover,
    this.mouseCursor,
    this.containedInkWell = false,
    this.highlightShape = BoxShape.circle,
    this.radius,
    this.borderRadius,
    this.customBorder,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.overlayColor,
    this.splashColor,
    this.splashFactory,
    this.enableFeedback = true,
    this.excludeFromSemantics = false,
    this.focusNode,
    this.canRequestFocus = true,
    this.onFocusChange,
    this.autofocus = false,
    this.parentState,
    this.getRectCallback,
    this.debugCheckContext,
    this.onLongPressDown,
    this.onLongPressMoveUpdate,
    this.onSecondaryTapUp,
  })  : assert(containedInkWell != null),
        assert(highlightShape != null),
        assert(enableFeedback != null),
        assert(excludeFromSemantics != null),
        assert(autofocus != null),
        assert(canRequestFocus != null);

  final Widget child;
  final GestureTapCallback onTap;
  final GestureTapDownCallback onTapDown;
  final GestureTapCallback onTapCancel;
  final GestureTapCallback onDoubleTap;
  final GestureLongPressCallback onLongPress;
  final ValueChanged<bool> onHighlightChanged;
  final ValueChanged<bool> onHover;
  final MouseCursor mouseCursor;
  final bool containedInkWell;
  final BoxShape highlightShape;
  final double radius;
  final BorderRadius borderRadius;
  final ShapeBorder customBorder;
  final Color focusColor;
  final Color hoverColor;
  final Color highlightColor;
  final MaterialStateProperty<Color> overlayColor;
  final Color splashColor;
  final InteractiveInkFeatureFactory splashFactory;
  final bool enableFeedback;
  final bool excludeFromSemantics;
  final ValueChanged<bool> onFocusChange;
  final bool autofocus;
  final FocusNode focusNode;
  final bool canRequestFocus;
  final _ParentInkResponseState parentState;
  final _GetRectCallback getRectCallback;
  final _CheckContext debugCheckContext;

  @override
  _InkResponseState createState() => _InkResponseState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final List<String> gestures = <String>[
      if (onTap != null) 'tap',
      if (onDoubleTap != null) 'double tap',
      if (onLongPress != null) 'long press',
      if (onTapDown != null) 'tap down',
      if (onTapCancel != null) 'tap cancel',
    ];
    properties.add(IterableProperty<String>('gestures', gestures, ifEmpty: '<none>'));
    properties.add(DiagnosticsProperty<MouseCursor>('mouseCursor', mouseCursor));
    properties.add(DiagnosticsProperty<bool>('containedInkWell', containedInkWell, level: DiagnosticLevel.fine));
    properties.add(DiagnosticsProperty<BoxShape>(
      'highlightShape',
      highlightShape,
      description: '${containedInkWell ? "clipped to " : ""}$highlightShape',
      showName: false,
    ));
  }
}

/// in [_InkResponseState].
enum _HighlightType {
  pressed,
  hover,
  focus,
}

abstract class _ParentInkResponseState {
  void markChildInkResponsePressed(_ParentInkResponseState childState, bool value);
}

class _ParentInkResponseProvider extends InheritedWidget {
  const _ParentInkResponseProvider({
    this.state,
    Widget child,
  }) : super(child: child);

  final _ParentInkResponseState state;

  @override
  bool updateShouldNotify(_ParentInkResponseProvider oldWidget) => state != oldWidget.state;

  static _ParentInkResponseState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ParentInkResponseProvider>()?.state;
  }
}

typedef _GetRectCallback = RectCallback Function(RenderBox referenceBox);

typedef _CheckContext = bool Function(BuildContext context);

class _InkResponseState extends State<_InkResponseStateWidget> with AutomaticKeepAliveClientMixin<_InkResponseStateWidget> implements _ParentInkResponseState {
  Set<InteractiveInkFeature> _splashes;
  InteractiveInkFeature _currentSplash;
  bool _hovering = false;
  final Map<_HighlightType, InkHighlight> _highlights = <_HighlightType, InkHighlight>{};
  Map<Type, Action<Intent>> _actionMap;

  bool get highlightsExist => _highlights.values.where((InkHighlight highlight) => highlight != null).isNotEmpty;

  final ObserverList<_ParentInkResponseState> _activeChildren = ObserverList<_ParentInkResponseState>();

  @override
  void markChildInkResponsePressed(_ParentInkResponseState childState, bool value) {
    assert(childState != null);
    final bool lastAnyPressed = _anyChildInkResponsePressed;
    if (value) {
      _activeChildren.add(childState);
    } else {
      _activeChildren.remove(childState);
    }
    final bool nowAnyPressed = _anyChildInkResponsePressed;
    if (nowAnyPressed != lastAnyPressed) {
      widget.parentState?.markChildInkResponsePressed(this, nowAnyPressed);
    }
  }

  bool get _anyChildInkResponsePressed => _activeChildren.isNotEmpty;

  void _simulateTap([Intent intent]) {
    _startSplash(context: context);
    _handleTap();
  }

  void _simulateLongPress() {
    _startSplash(context: context);
    _handleLongPress();
  }

  @override
  void initState() {
    _actionMap = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: _simulateTap),
      ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(onInvoke: _simulateTap),
    };
    super.initState();
    FocusManager.instance.addHighlightModeListener(_handleFocusHighlightModeChange);
  }

  @override
  void didUpdateWidget(_InkResponseStateWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isWidgetEnabled(widget) != _isWidgetEnabled(oldWidget)) {
      if (enabled) {
        updateHighlight(_HighlightType.hover, value: _hovering, callOnHover: false);
      }
      _updateFocusHighlights();
    }
  }

  @override
  void dispose() {
    FocusManager.instance.removeHighlightModeListener(_handleFocusHighlightModeChange);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => highlightsExist || (_splashes != null && _splashes.isNotEmpty);

  Color getHighlightColorForType(_HighlightType type) {
    const Set<MaterialState> focused = <MaterialState>{MaterialState.focused};
    const Set<MaterialState> hovered = <MaterialState>{MaterialState.hovered};

    switch (type) {
      case _HighlightType.pressed:
        return widget.highlightColor ?? Theme.of(context).highlightColor;
      case _HighlightType.focus:
        return widget.overlayColor?.resolve(focused) ?? widget.focusColor ?? Theme.of(context).focusColor;
      case _HighlightType.hover:
        return widget.overlayColor?.resolve(hovered) ?? widget.hoverColor ?? Theme.of(context).hoverColor;
    }
  }

  Duration getFadeDurationForType(_HighlightType type) {
    switch (type) {
      case _HighlightType.pressed:
        return const Duration(milliseconds: 200);
      case _HighlightType.hover:
      case _HighlightType.focus:
        return const Duration(milliseconds: 50);
    }
  }

  void updateHighlight(_HighlightType type, {bool value, bool callOnHover = true}) {
    final InkHighlight highlight = _highlights[type];
    void handleInkRemoval() {
      assert(_highlights[type] != null);
      _highlights[type] = null;
      updateKeepAlive();
    }

    if (type == _HighlightType.pressed) {
      widget.parentState?.markChildInkResponsePressed(this, value);
    }
    if (value == (highlight != null && highlight.active)) return;
    if (value) {
      if (highlight == null) {
        final RenderBox referenceBox = context.findRenderObject() as RenderBox;
        _highlights[type] = InkHighlight(
          controller: Material.of(context),
          referenceBox: referenceBox,
          color: getHighlightColorForType(type),
          shape: widget.highlightShape,
          radius: widget.radius,
          borderRadius: widget.borderRadius,
          customBorder: widget.customBorder,
          rectCallback: widget.getRectCallback(referenceBox),
          onRemoved: handleInkRemoval,
          textDirection: Directionality.of(context),
          fadeDuration: getFadeDurationForType(type),
        );
        updateKeepAlive();
      } else {
        highlight.activate();
      }
    } else {
      highlight.deactivate();
    }
    assert(value == (_highlights[type] != null && _highlights[type].active));

    switch (type) {
      case _HighlightType.pressed:
        widget.onHighlightChanged?.call(value);
        break;
      case _HighlightType.hover:
        if (callOnHover) widget.onHover?.call(value);
        break;
      case _HighlightType.focus:
        break;
    }
  }

  InteractiveInkFeature _createInkFeature(Offset globalPosition) {
    final MaterialInkController inkController = Material.of(context);
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    final Offset position = referenceBox.globalToLocal(globalPosition);
    const Set<MaterialState> pressed = <MaterialState>{MaterialState.pressed};
    final Color color = widget.overlayColor?.resolve(pressed) ?? widget.splashColor ?? Theme.of(context).splashColor;
    final RectCallback rectCallback = widget.containedInkWell ? widget.getRectCallback(referenceBox) : null;
    final BorderRadius borderRadius = widget.borderRadius;
    final ShapeBorder customBorder = widget.customBorder;

    InteractiveInkFeature splash;
    void onRemoved() {
      if (_splashes != null) {
        assert(_splashes.contains(splash));
        _splashes.remove(splash);
        if (_currentSplash == splash) _currentSplash = null;
        updateKeepAlive();
      } // else we're probably in deactivate()
    }

    splash = (widget.splashFactory ?? Theme.of(context).splashFactory).create(
      controller: inkController,
      referenceBox: referenceBox,
      position: position,
      color: color,
      containedInkWell: widget.containedInkWell,
      rectCallback: rectCallback,
      radius: widget.radius,
      borderRadius: borderRadius,
      customBorder: customBorder,
      onRemoved: onRemoved,
      textDirection: Directionality.of(context),
    );

    return splash;
  }

  void _handleFocusHighlightModeChange(FocusHighlightMode mode) {
    if (!mounted) {
      return;
    }
    setState(() {
      _updateFocusHighlights();
    });
  }

  bool get _shouldShowFocus {
    final NavigationMode mode = MediaQuery.maybeOf(context)?.navigationMode ?? NavigationMode.traditional;
    switch (mode) {
      case NavigationMode.traditional:
        return enabled && _hasFocus;
      case NavigationMode.directional:
        return _hasFocus;
    }
  }

  void _updateFocusHighlights() {
    bool showFocus;
    switch (FocusManager.instance.highlightMode) {
      case FocusHighlightMode.touch:
        showFocus = false;
        break;
      case FocusHighlightMode.traditional:
        showFocus = _shouldShowFocus;
        break;
    }
    updateHighlight(_HighlightType.focus, value: showFocus);
  }

  bool _hasFocus = false;

  void _handleFocusUpdate(bool hasFocus) {
    _hasFocus = hasFocus;
    _updateFocusHighlights();
    widget.onFocusChange?.call(hasFocus);
  }

  void _handleTapDown(TapDownDetails details) {
    if (_anyChildInkResponsePressed) return;
    _startSplash(details: details);
    widget.onTapDown?.call(details);
  }

  void _startSplash({TapDownDetails details, BuildContext context}) {
    assert(details != null || context != null);

    Offset globalPosition;
    if (context != null) {
      final RenderBox referenceBox = context.findRenderObject() as RenderBox;
      assert(referenceBox.hasSize, 'InkResponse must be done with layout before starting a splash.');
      globalPosition = referenceBox.localToGlobal(referenceBox.paintBounds.center);
    } else {
      globalPosition = details.globalPosition;
    }
    final InteractiveInkFeature splash = _createInkFeature(globalPosition);
    _splashes ??= HashSet<InteractiveInkFeature>();
    _splashes.add(splash);
    _currentSplash = splash;
    updateKeepAlive();
    updateHighlight(_HighlightType.pressed, value: true);
  }

  void _handleTap() {
    _currentSplash?.confirm();
    _currentSplash = null;
    updateHighlight(_HighlightType.pressed, value: false);
    if (widget.onTap != null) {
      if (widget.enableFeedback) Feedback.forTap(context);
      widget.onTap?.call();
    }
  }

  void _handleTapCancel() {
    _currentSplash?.cancel();
    _currentSplash = null;
    widget.onTapCancel?.call();
    updateHighlight(_HighlightType.pressed, value: false);
  }

  void _handleDoubleTap() {
    _currentSplash?.confirm();
    _currentSplash = null;
    widget.onDoubleTap?.call();
  }

  void _handleLongPress() {
    _currentSplash?.confirm();
    _currentSplash = null;
    if (widget.onLongPress != null) {
      if (widget.enableFeedback) Feedback.forLongPress(context);
      widget.onLongPress();
    }
  }

  @override
  void deactivate() {
    if (_splashes != null) {
      final Set<InteractiveInkFeature> splashes = _splashes;
      _splashes = null;
      for (final InteractiveInkFeature splash in splashes) splash.dispose();
      _currentSplash = null;
    }
    assert(_currentSplash == null);
    for (final _HighlightType highlight in _highlights.keys) {
      _highlights[highlight]?.dispose();
      _highlights[highlight] = null;
    }
    widget.parentState?.markChildInkResponsePressed(this, false);
    super.deactivate();
  }

  bool _isWidgetEnabled(_InkResponseStateWidget widget) {
    return widget.onTap != null || widget.onDoubleTap != null || widget.onLongPress != null;
  }

  bool get enabled => _isWidgetEnabled(widget);

  void _handleMouseEnter(PointerEnterEvent event) {
    _hovering = true;
    if (enabled) {
      _handleHoverChange();
    }
  }

  void _handleMouseExit(PointerExitEvent event) {
    _hovering = false;
    // If the exit occurs after we've been disabled, we still
    // want to take down the highlights and run widget.onHover.
    _handleHoverChange();
  }

  void _handleHoverChange() {
    updateHighlight(_HighlightType.hover, value: _hovering);
  }

  bool get _canRequestFocus {
    final NavigationMode mode = MediaQuery.maybeOf(context)?.navigationMode ?? NavigationMode.traditional;
    switch (mode) {
      case NavigationMode.traditional:
        return enabled && widget.canRequestFocus;
      case NavigationMode.directional:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {

    super.build(context); // See AutomaticKeepAliveClientMixin.
    for (final _HighlightType type in _highlights.keys) {
      _highlights[type]?.color = getHighlightColorForType(type);
    }

    const Set<MaterialState> pressed = <MaterialState>{MaterialState.pressed};
    _currentSplash?.color = widget.overlayColor?.resolve(pressed) ?? widget.splashColor ?? Theme.of(context).splashColor;

    final MouseCursor effectiveMouseCursor = MaterialStateProperty.resolveAs<MouseCursor>(
      widget.mouseCursor ?? MaterialStateMouseCursor.clickable,
      <MaterialState>{
        if (!enabled) MaterialState.disabled,
        if (_hovering && enabled) MaterialState.hovered,
        if (_hasFocus) MaterialState.focused,
      },
    );
    return _ParentInkResponseProvider(
      state: this,
      child: Actions(
        actions: _actionMap,
        child: Focus(
          focusNode: widget.focusNode,
          canRequestFocus: _canRequestFocus,
          onFocusChange: _handleFocusUpdate,
          autofocus: widget.autofocus,
          child: MouseRegion(
            cursor: effectiveMouseCursor,
            onEnter: _handleMouseEnter,
            onExit: _handleMouseExit,
            child: Semantics(
              onTap: widget.excludeFromSemantics || widget.onTap == null ? null : _simulateTap,
              onLongPress: widget.excludeFromSemantics || widget.onLongPress == null ? null : _simulateLongPress,
              child: GestureDetector(
                onTapDown: enabled ? _handleTapDown : null,
                onTap: enabled ? _handleTap : null,
                onTapCancel: enabled ? _handleTapCancel : null,
                onDoubleTap: widget.onDoubleTap != null ? _handleDoubleTap : null,
                onLongPress: widget.onLongPress != null ? _handleLongPress : null,
                behavior: HitTestBehavior.translucent,
                excludeFromSemantics: true,
                onLongPressDown: widget.onLongPressDown,
                onLongPressMoveUpdate: widget.onLongPressMoveUpdate,
                onSecondaryTapUp: widget.onSecondaryTapUp,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
