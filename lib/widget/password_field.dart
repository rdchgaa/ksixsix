import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordController {
  List<String> _textList = [];
  _PasswordFieldState _state;

  PasswordController(int count) {
    _textList = List.filled(count, null);
  }

  void clear() {
    for (var i = 0; i < _textList.length; i++) {
      _textList[i] = null;
    }
    _state?.clear();
  }

  Future<dynamic> showTextInput() {
    _state._node.requestFocus();
    return SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  Future<dynamic> hideTextInput() {
    _state._node.unfocus();
    return SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  String get text => _textList.join();
}

class PasswordField extends StatefulWidget {
  final int count;
  final double size;

  final double spacing;

  final TextStyle style;

  final List<TextInputFormatter> inputFormatters;

  final TextAlign textAlign;

  final void Function(String value) onSubmit;

  final PasswordController controller;

  final bool autofocus;

  final TextInputType keyboardType;

  const PasswordField({
    Key key,
    this.count = 6,
    this.size = 40,
    this.spacing = 2,
    this.style,
    this.inputFormatters = const [],
    this.textAlign = TextAlign.center,
    this.onSubmit,
    this.controller,
    this.autofocus = true,
    this.keyboardType = TextInputType.number,
  }) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  FocusScopeNode _node = FocusScopeNode();
  PasswordController _controller;

  GlobalKey<FormState> _formKey = GlobalKey();

  get style {
    var s = TextStyle(fontSize: 25, color: Color(0xff009FE8));
    if (null != widget.style) {
      s.merge(widget.style);
    }
    return s;
  }

  @override
  void initState() {
    _controller = widget.controller ?? PasswordController(widget.count);
    _controller._state = this;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PasswordField oldWidget) {
    if (widget.controller != oldWidget.controller) {
      _controller = widget.controller ?? PasswordController(widget.count);
      _controller._state = this;
    } else if (widget.count != oldWidget) {
      _controller._textList = List.generate(widget.count, (index) => index < _controller._textList.length ? _controller._textList[index] : null);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: FocusScope(
        node: _node,
        onKey: (node, event) {
          if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
            _node.previousFocus();
          }
          return KeyEventResult.ignored;
        },
        child: Wrap(
          spacing: widget.spacing,
          children: [
            for (var i = 0; i < widget.count; i++)
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: TextFormField(
                  autofocus: widget.autofocus ? 0 == i : false,
                  style: style,
                  textAlign: widget.textAlign,
                  onChanged: (val) => onChanged(context, val, i),
                  cursorColor: Color(0xff009FE8),
                  keyboardType: widget.keyboardType,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    ...widget.inputFormatters ?? [],
                  ],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    isCollapsed: false,
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff009FE8))),
                    enabledBorder: null == _controller._textList[i] ? null : UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff009FE8))),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void onChanged(BuildContext context, String text, int index) {
    if (text.isNotEmpty) {
      _node.nextFocus();
      _controller._textList[index] = text;
    } else {
      _controller._textList[index] = null;
    }

    if (!_controller._textList.contains(null)) {
      widget.onSubmit?.call(_controller._textList.join());
    }
    setState(() {});
  }

  void clear() {
    _formKey.currentState.reset();
  }
}
