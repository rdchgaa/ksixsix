import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';

Future<bool> showAlertDialogUpdate(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return DialogAlertUpdateBox(
        // contentAlign: contentAlign,
      );
    },
  );
}

class DialogAlertUpdateBox extends StatefulWidget {

  const DialogAlertUpdateBox({
    Key key,
  }) : super(key: key);

  @override
  _DialogAlertUpdateBoxState createState() => _DialogAlertUpdateBoxState();
}

class _DialogAlertUpdateBoxState extends State<DialogAlertUpdateBox> {

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      // 强制竖屏
      DeviceOrientation.portraitUp
    ]);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      // 强制竖屏
      DeviceOrientation.landscapeLeft
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: const Alignment(0, 0),
        child: Material(
          // borderRadius: BorderRadius.all(Radius.circular(10)),
          child: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/update_erweima.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SizedBox(
              width:width*0.8,
              height: width*1.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 279, minHeight: 166 - 54.0),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10,),
                      child: Text(
                        '下载最新版App',
                        style: const TextStyle(color: Color(0xffffffff), fontSize: 22),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 9, left: 32, right: 32),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                          SizedBox(
                            width: 80,
                            height: 38,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context,true);
                              },
                              child: Text(
                                '返回',
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
