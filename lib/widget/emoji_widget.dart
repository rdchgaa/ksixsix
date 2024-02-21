import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui' as ui show PlaceholderAlignment;

typedef TextToRichSpan = Widget Function(String text);

class RichEditingController extends TextEditingController {
  final TextToRichSpan textToRichSpan;

  RichEditingController({String text, this.textToRichSpan}) : super(text: text);

  TextSpan buildTextSpan({BuildContext context, TextStyle style, bool withComposing}) {
    assert(!value.composing.isValid || !withComposing || value.isComposingRangeValid);

    var list = <InlineSpan>[];
    var matches = RegExp('[${RichSpan.codeTextStart}-${RichSpan.codeTextEnd}]').allMatches(text);
    var index = 0;
    var start = 0;
    matches.forEach((element) {
      if (index < element.start) {
        list.add(TextSpan(text: text.substring(index, element.start)));
      }
      list.add(_textToSapne(
        text.substring(
          element.start,
          element.end,
        ),
        style,
      ));
      index = element.end;
      start++;
    });
    if (index < text.length) {
      list.add(TextSpan(text: text.substring(index, text.length)));
    }

    return TextSpan(
      children: list,
      style: style,
    );
  }

  void addSpan(String codeText) {
    assert(1 == codeText.length);
    assert(RichSpan.codeTextStart.codeUnitAt(0) <= codeText.codeUnitAt(0));
    assert(RichSpan.codeTextEnd.codeUnitAt(0) >= codeText.codeUnitAt(0));

    var baseOffset = value.selection.baseOffset;
    var temp = value.text;
    if (0 < temp.length && baseOffset < temp.length && -1 < baseOffset) {
      temp = temp.substring(0, baseOffset) + codeText + temp.substring(baseOffset);
    } else {
      temp += codeText;
    }

    baseOffset += codeText.length;
    value = value.copyWith(
      text: temp,
      selection: value.selection.copyWith(
        baseOffset: baseOffset,
        extentOffset: baseOffset,
      ),
    );
  }

  InlineSpan _textToSapne(String text, TextStyle style) {
    var child = textToRichSpan?.call(text);
    if (null != child) {
      return RichSpan(text, child: child, style: style, baseline: TextBaseline.alphabetic);
    }
    return TextSpan(
      text: text,
    );
  }
}

class RichSpan extends WidgetSpan {
  static final codeTextStart = '\uE000';
  static final codeTextEnd = '\uF8FF';

  final String codeText;

  const RichSpan(
    this.codeText, {
    child,
    ui.PlaceholderAlignment alignment = ui.PlaceholderAlignment.bottom,
    TextBaseline baseline,
    TextStyle style,
  })  : assert(child != codeText),
        assert(child != null),
        assert(baseline != null ||
            !(identical(alignment, ui.PlaceholderAlignment.aboveBaseline) ||
                identical(alignment, ui.PlaceholderAlignment.belowBaseline) ||
                identical(alignment, ui.PlaceholderAlignment.baseline))),
        super(
          child: child,
          alignment: alignment,
          baseline: baseline,
          style: style,
        );

  @override
  int codeUnitAtVisitor(int index, Accumulator offset) {
    if (index - offset.value < codeText.length) {
      return codeText.codeUnitAt(0);
    }
    offset.increment(codeText.length);
    return null;
  }
}

Widget textToRichSpan(String text, {double width = 18, double height = 18}) {
  var value = text.codeUnitAt(0) - RichSpan.codeTextStart.codeUnitAt(0);
  if (0 < value && 125 >= value) {
    return IndexToEmojiWidget(
      index: value,
      width: width,
      height: height,
    );
  }
  return null;
}

List<InlineSpan> toTextSpan(String text, {double width = 18, double height = 18, String start}) {
  var list = <InlineSpan>[];
  if (text.isNotEmpty) {
    if (null != start && text.startsWith(start)) {
      list.add(TextSpan(
        text: start,
        style: const TextStyle(color: Color(0xffF34235)),
      ));
      text = text.substring(start.length);
    }
    var codeTextStart;
    var matches = RegExp('[${RichSpan.codeTextStart}-${RichSpan.codeTextEnd}]').allMatches(text);
    var index = 0;
    matches.forEach((element) {
      if (index < element.start) {
        list.add(TextSpan(text: text.substring(index, element.start)));
      }
      list.add(textToSpan(
        text.substring(
          element.start,
          element.end,
        ),
        width: width,
        height: height,
      ));
      index = element.end;
    });
    if (index < text.length) {
      list.add(TextSpan(text: text.substring(index, text.length)));
    }
  }
  return list;
}

InlineSpan textToSpan(String text, {double width = 18, double height = 18}) {
  var child = textToRichSpan(text, width: width, height: height);
  if (null != child) {
    return RichSpan(text, child: child);
  }
  return TextSpan(
    text: text,
  );
}

class IndexToEmojiWidget extends StatelessWidget {
  final int index;
  final double width;
  final double height;

  const IndexToEmojiWidget({
    Key key,
    this.index,
    this.width = 18,
    this.height = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/emojis/emoji_${index.toString().padLeft(3, '0')}.webp",
      width: width,
      height: height,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('index', index));
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
  }
}
