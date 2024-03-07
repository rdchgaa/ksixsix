import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:xxc_flutter_utils/xxc_flutter_utils.dart';

Future<bool> showAlertDialog(BuildContext context, {String title, String content, String buttonOk, String buttonCancel}) {
  // return AutoRouter.of(context).pushNamed("/dialog_alert", params: {
  //   "title": title,
  //   "content": content,
  //   "buttonCancel": buttonCancel,
  //   "buttonOk": buttonOk,
  // });
  return showDialog(
    context: context,
    builder: (context) {
      return DialogAlertBox(
        title: title,
        content: content,
        buttonOk: buttonOk,
        buttonCancel: buttonCancel,
        // contentAlign: contentAlign,
      );
    },
  );
}

class _ControlAlertBox extends RouterDataNotifier {
  final String title;
  final String content;
  final String buttonOk;
  final String buttonCancel;

  _ControlAlertBox({
    this.title,
    this.content,
    this.buttonOk,
    this.buttonCancel,
  });

  init(BuildContext context) {
    value = true;
  }
}



class DialogAlertBox extends StatefulWidget {
  final String title;
  final String content;
  final String buttonOk;
  final String buttonCancel;

  const DialogAlertBox({
    Key key,
    this.title,
    this.content,
    this.buttonOk,
    this.buttonCancel,
  }) : super(key: key);

  @override
  _DialogAlertBoxState createState() => _DialogAlertBoxState();
}

class _DialogAlertBoxState extends State<DialogAlertBox> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var buttonWidth = (width-60) / (null != widget.buttonCancel && null != widget.buttonOk ? 2 : 1);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: const Alignment(0, 0),
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0,right: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 279, minHeight: 166 - 54.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18, bottom: 9, left: 32, right: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (null != this.widget.title)
                          Text(
                            this.widget.title,
                            style: const TextStyle(color: Color(0xff575757), fontSize: 16),
                          ),
                        Text(
                          this.widget.content,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xff868686), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 1,
                  child: Divider(height: 1),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (null != widget.buttonCancel)
                      SizedBox(
                        width: buttonWidth-20,
                        height: 38,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context,false);
                          },
                          child: Text(
                            this.widget.buttonCancel,
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color(0xFF21A27C)),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            foregroundColor: MaterialStateProperty.all(Color(0xffffffff)),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4)))),
                          ),
                        ),
                      ),
                    if (null != widget.buttonCancel && null != widget.buttonOk)
                      SizedBox(
                        width: 10,
                        // child: VerticalDivider(
                        //   width: 10,
                        // ),
                        // height: 53,
                      ),
                    if (null != widget.buttonOk)
                      SizedBox(
                        width: buttonWidth-20,
                        height: 38,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context,true);
                          },
                          child: Text(
                            this.widget.buttonOk,
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color(0xFFF2F2F2)),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            foregroundColor: MaterialStateProperty.all(Color(0xFF0E0F0F)),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4)))),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
