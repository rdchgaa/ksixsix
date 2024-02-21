import 'package:ima2_habeesjobs/util/language.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';

Future<DateTime> showTimeDialog(
  BuildContext context, {
  CupertinoTimerPickerMode mode = CupertinoTimerPickerMode.hms,
  DateTime initialTimerDuration,
  int minuteInterval = 1,
  int secondInterval = 1,
  DateTime minimumDate,
  Color backgroundColor,
  String title,
}) {
  var min = minimumDate != null ? minimumDate.millisecondsSinceEpoch.toString() : null;
  return AutoRouter.of(context).pushNamed("/dialog_time", params: {
    'mode': mode.index.toString(),
    'initialTimerDuration': initialTimerDuration.millisecondsSinceEpoch.toString(),
    'minuteInterval': minuteInterval.toString(),
    'secondInterval': secondInterval.toString(),
    'backgroundColor': backgroundColor,
    'minimumDate': min,
    'title': title,
  });
}

class _ControlTimeDialog extends RouterDataNotifier {
  final CupertinoTimerPickerMode mode;
  final DateTime initialTimerDuration;
  final int minuteInterval;
  final int secondInterval;
  final DateTime minimumDate;
  final String title;

  _ControlTimeDialog({
    this.mode,
    this.initialTimerDuration,
    this.minuteInterval = 1,
    this.secondInterval = 1,
    this.minimumDate,
    this.title,
  });

  init(BuildContext context) {
    value = true;
  }
}

class TimeDialog extends RouterDataWidget<_ControlTimeDialog> implements PageSize {
  // const TimeDialog({Key? key}) : super(key: key);
  final Map<String, dynamic> param;

  TimeDialog({this.param});

  @override
  _TimeDialogState createState() => _TimeDialogState();

  _ControlTimeDialog initData(BuildContext context) {
    var min = param["minimumDate"] != null ? DateTime.fromMillisecondsSinceEpoch(int.parse(param["minimumDate"])) : null;
    return _ControlTimeDialog(
      mode: CupertinoTimerPickerMode.values[int.parse(param["mode"])],
      title: param["title"],
      initialTimerDuration: DateTime.fromMillisecondsSinceEpoch(int.parse(param["initialTimerDuration"])),
      minimumDate: min,
      minuteInterval: int.parse(param["minuteInterval"]),
    );
  }

  @override
  SizePage get size => SizePage(320, 300);
}

class _TimeDialogState extends RouterDataWidgetState<TimeDialog> {
  DateTime nowTime = DateTime.now();

  @override
  Widget buildContent(BuildContext context) {
    return LayoutBuilder(builder: (context, con) {
      var width = (con.smallest.width - 1) / 2;
      return Material(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text(
                widget.data.title,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(
              height: 201,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.dateAndTime,
                initialDateTime: widget.data.initialTimerDuration,
                // minuteInterval: 1,
                minimumDate: widget.data.minimumDate,
                use24hFormat: true,
                onDateTimeChanged: (time) {
                  nowTime = time;
                  // widget.data._value = time;
                },
              ),
            ),
            SizedBox(
              width: con.smallest.width,
              child: Divider(height: 1),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: width,
                  height: 53,
                  child: TextButton(
                    onPressed: () {
                      AutoRouter.of(context).pop(null);
                    },
                    child: Text(
                      Languages.of(context).cancelButtonLabel,
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: MaterialStateProperty.all(Color(0xff8B8B8B)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                    ),
                  ),
                ),
                SizedBox(
                  child: VerticalDivider(
                    width: 1,
                  ),
                  height: 53,
                ),
                SizedBox(
                  width: width,
                  height: 53,
                  child: TextButton(
                    onPressed: () {
                      // Navigator.pop(context, nowTime);
                      AutoRouter.of(context).pop(nowTime);
                    },
                    child: Text(
                      Languages.of(context).okButtonLabel,
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: MaterialStateProperty.all(Color(0xff414141)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
