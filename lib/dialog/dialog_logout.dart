import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:ima2_habeesjobs/widget/my_button.dart';
import 'package:ima2_habeesjobs/widget/ui_layout.dart';
import 'package:provider/provider.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    clipBehavior: Clip.none,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return DialogLogout();
    },
  );
}

class DialogLogout extends StatefulWidget {
  const DialogLogout({Key key}) : super(key: key);

  @override
  _DialogLogoutState createState() => _DialogLogoutState();
}

class _DialogLogoutState extends State<DialogLogout> {
  @override
  Widget build(BuildContext context) {
    var st = const TextStyle(fontSize: 14);
    var account = context.watch<SerUser>();
    var width = MediaQuery.of(context).size.width;
    return UiModalBottomLayout(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12, right: 12),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      '您确定要退出当前帐户吗？',
                      textAlign: TextAlign.center,
                      style: textStyleH3White,
                    )),
                Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 100,
                          height: 100,
                          child: MyButton.gradient(
                              backgroundColor: [Color(0xfff3ec6c), Color(0xffbe5a05)],
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: Text('退出登录', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
                      SizedBox(
                          width: 100,
                          height: 100,
                          child: MyButton.gradient(
                              backgroundColor: [Color(0xfff3ec6c), Color(0xffbe5a05)],
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text('取消', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xffffffff))))),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<bool> _onInitLoading(BuildContext context) async {
    await LoadingCall.of(context).call((state, controller) async {});
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
