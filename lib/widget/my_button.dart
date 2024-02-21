import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final List<Color> backgroundColor;

  final VoidCallback onPressed;

  final ButtonStyle style;

  final BorderRadius borderRadius;

  Widget _child;

  bool _isLine = false;

  MyButton.gradient({
    Key key,
    this.backgroundColor = const [Color(0xff046a39), Color(0xff046a39)],
    Widget child,
    this.onPressed,
    this.style,
    this.borderRadius = const BorderRadius.all(Radius.circular(100)),
  })  : _child = child,
        super(key: key);

  MyButton.line({
    Key key,
    this.backgroundColor,
    Widget child,
    this.onPressed,
    this.style,
    this.borderRadius = const BorderRadius.all(Radius.circular(100)),
  })  : _child = child,
        super(key: key) {
    _isLine = true;
  }

  MyButton.columnIcon({
    Key key,
    this.backgroundColor,
    String title,
    Widget icon,
    this.onPressed,
    this.style,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  })  : assert(null != icon),
        super(key: key) {
    this._child = Column(
      children: [
        icon,
        Text(title),
      ],
    );
  }

  ButtonStyle get _style {
    var ret = ButtonStyle(
      foregroundColor: MaterialStateProperty.all(Colors.white),
      minimumSize: MaterialStateProperty.all(Size(41.67, 36)),
      padding: MaterialStateProperty.all(EdgeInsets.zero),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: this.borderRadius)),
    );

    if (null == this.style) {
      return ret;
    } else {
      return style.merge(ret);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: this.borderRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: null == this.backgroundColor
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: this.backgroundColor,
                ),
        ),
        child: Material(
          color: Colors.transparent,
          child: _isLine
              ? OutlinedButton(
                  onPressed: this.onPressed,
                  child: this._child,
                  style: _style,
                )
              : TextButton(
                  onPressed: this.onPressed,
                  child: this._child,
                  style: _style,
                ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<Color>('backgroundColor', backgroundColor));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
    properties.add(DiagnosticsProperty<ButtonStyle>('style', style));
  }
}
