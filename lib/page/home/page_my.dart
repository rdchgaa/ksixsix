import 'package:ima2_habeesjobs/dao/manage_dao.dart';
import 'package:ima2_habeesjobs/page/page_init.dart';
import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:ima2_habeesjobs/service/ser_base.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:ima2_habeesjobs/util/language.dart';
import 'package:ima2_habeesjobs/util/navigator.dart';
import 'package:ima2_habeesjobs/util/other.dart';
import 'package:ima2_habeesjobs/widget/app_bar.dart';
import 'package:ima2_habeesjobs/widget/item_layout.dart';
import 'package:ima2_habeesjobs/widget/my_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';
import 'package:provider/provider.dart';

class _ControlMy extends RouterDataNotifier {
  _ControlMy();

  init(BuildContext context) {
    value = true;
  }
}

class PageMy extends RouterDataWidget<_ControlMy> {
  final Map<String, dynamic> param;

  PageMy({Key key, this.param}) : super(key: key);

  @override
  _PagePageMyState createState() => _PagePageMyState();

  @override
  initData(BuildContext context) {
    return _ControlMy();
  }
}

class _PagePageMyState extends RouterDataWidgetState<PageMy> {
  @override
  Widget buildContent(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            child: Image.asset(
              "assets/imgs/icon_my_bg.png",
              width: double.infinity,
              height: 267,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                MyAppBar(
                  leadingWidth: 1,
                  leading: SizedBox(),
                  centerTitle: true,
                  title: Text(
                    'personal center',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                  actions: [
                    InkWell(
                      onTap: (){
                        _onExit(context);
                      },
                      child: Text(
                        'personal center',
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _onExit(BuildContext context) async {
    print('1');
    setChannel(null);
    setUserId(null);
    setToken(null);
    await context.read<SerBase>().close();
    await ManageDao.close();

    // AutoRouter.of(context).pushNamedAndRemoveUntil(
    //   "/",
    //   predicate: (router) => true,
    //   params: {
    //     "isCheckVersion": "false",
    //   },
    // );
    PageInit().pushAndRemoveUntil(context, (route) => true);
  }

  _onShareLink() {
    Clipboard.setData(ClipboardData(text: "https://im-pre.ng888.cyou/"));
    showToast(context, Languages.of(context).shareLinkTip);
  }
}
