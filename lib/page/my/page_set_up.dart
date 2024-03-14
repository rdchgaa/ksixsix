import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ima2_habeesjobs/util/other.dart';
import 'package:xxc_flutter_utils/xxc_flutter_utils.dart';
import 'package:ima2_habeesjobs/dialog/alert_dialog.dart';
import 'package:ima2_habeesjobs/dialog/alert_dialog_update.dart';
import 'package:ima2_habeesjobs/page/my/page_deposit.dart';
import 'package:ima2_habeesjobs/page/my/page_user_about_us.dart';
import 'package:ima2_habeesjobs/page/page_init.dart';
import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:ima2_habeesjobs/util/app_cache_manager.dart';
import 'package:ima2_habeesjobs/util/navigator.dart';
import 'package:ima2_habeesjobs/widget/app_bar.dart';
import 'package:ima2_habeesjobs/widget/ui_layout.dart';
import 'package:provider/src/provider.dart';

//设置页面
class PageSetUp extends StatefulWidget {
  final versionInfo ;
  const PageSetUp({Key key, this.versionInfo}) : super(key: key);

  @override
  _PageSetUpState createState() => _PageSetUpState();
}

class _PageSetUpState extends State<PageSetUp> {
  var txtStyle = const TextStyle(fontSize: 14, color: Color(0xff474747), fontWeight: FontWeight.bold);

  GlobalKey<State<StatefulWidget>> _cacheSizeKey = GlobalKey();

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
    // SystemChrome.setPreferredOrientations([
    //   // 强制竖屏
    //   DeviceOrientation.landscapeLeft
    // ]);
  }

  @override
  Widget build(BuildContext context) {
    var user = context.watch<SerUser>();
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/login_back.webp'),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Color(0x00000000),
        appBar: MyAppBar(
          title: Text(
            '设置',
            style: TextStyle(
              fontFamily: 'Source Han Sans CN',
              fontSize: 16,
              color: const Color(0xff292929),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            softWrap: false,
          ),
          centerTitle: true,
          leading: SizedBox(
            width: 26,
            height: 14,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Center(
                child: SvgPicture.string(
                  svg_i3q6wh,
                  allowDrawingOutsideViewBox: true,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            LayoutBuilder(builder: (context, con) {
              var iconWidth = (con.maxWidth - 120) / 2;
              return Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Color(0x66000000)),

                child: Column(
                  children: [
                    if (checkLogin() && widget.versionInfo ==null &&false)
                      Column(
                        children: [
                          UiLayoutTextAndIconItem(
                            style: layoutItemStyle2,
                            title: '获取门票',
                            leftIcon: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Image.asset('assets/images/piao.png', width: 30, height: 30),
                            ),
                            onTap: () async {
                              PageDeposit().push(context);
                            },
                          ),
                          const Divider(height: 1,color: Color(0x99000000),),
                        ],
                      ),
                    UiLayoutTextAndIconItem(
                      style: layoutItemStyle2,
                      title: '清除缓存',
                      leftIcon: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Image.asset('assets/images/clean.png', width: 30, height: 30),
                      ),
                      onTap: () => _onClearCache(context),
                      rightIcon: Row(
                        children: [
                          Padding(
                            padding: paddingSmall,
                            child: FutureBuilder<int>(
                              key: _cacheSizeKey,
                              future: AppCacheManager().getCacheSize(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  const Align(alignment: Alignment.centerRight, child: CupertinoActivityIndicator());
                                }
                                return Text(
                                  _numToString(snapshot.data ?? 0),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontSize: 14, color: Color(0xFF02ee77)),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 8),
                          // Image.asset("assets/images2/icon_clear_cache_mark.webp", width: 16, height: 16,color: Color(0xffA901E6),),
                        ],
                      ),
                    ),
                    const Divider(height: 1,color: Color(0x99000000)),
                    UiLayoutTextAndIconItem(
                      style: layoutItemStyle2,
                      title: '关于我们',
                      leftIcon: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Image.asset('assets/images/aboutus.png', width: 30, height: 30),
                      ),
                      onTap: () async {
                        await PageUserAboutUs().push(context);
                      },
                    ),
                    const Divider(height: 1,color: Color(0x99000000)),
                    UiLayoutTextAndIconItem(
                      style: layoutItemStyle2,
                      title: '版本更新',
                      leftIcon: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Image.asset('assets/images/update.png', width: 30, height: 30),
                      ),
                      onTap: () async {
                        // showAlertDialogUpdate(context, enterType: 1);
                        toUpdate(context);
                      },
                    ),
                  ],
                ),
              );
            }),
            Spacer(),
            if (checkLogin())
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12),
                child: InkWell(
                  onTap: () async {
                    // var value = await showLogoutDialog(context);
                    var value = await showAlertDialog(
                      context,
                      content: '退出登录',
                      buttonCancel: '取消',
                      buttonOk: '确定',
                    );
                    if (true != value) {
                      return;
                    }

                    user.unLogin();
                    const PageInit().pushAndRemoveUntil(context, (router) => false);
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      image: DecorationImage(
                        image: AssetImage('assets/images/tuichu.png'),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [BoxShadow(color: Color(0xff000000), blurRadius: 33, offset: Offset(0, 0))],
                    ),
                    child: SizedBox(
                      width: 140,
                      height: 70,
                      child: InkWell(
                        child: Center(
                          child: Text(
                            '退出登录',
                            style: textStyleH3.copyWith(
                              color: Color(0xddd7fbfa),
                              fontSize: 18,fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(height: 38)
          ],
        ),
      ),
    );
  }

  bool checkLogin() {
    if ((getUserId() == null || getUserId() == 0)) {
      return false;
    }
    return true;
  }

  String _numToString(int i) {
    if (i > 1024 * 1024 * 1024 * 1024) {
      return "${(i / (1024 * 1024 * 1024 * 1024)).toStringAsFixed(2)}TB";
    } else if (i > 1024 * 1024 * 1024) {
      return "${(i / (1024 * 1024 * 1024)).toStringAsFixed(2)}GB";
    } else if (i > 1024 * 1024) {
      return "${(i / (1024 * 1024)).toStringAsFixed(2)}MB";
    }
    return "${(i / 1024).toStringAsFixed(2)}KB";
  }

  Future _onClearCache(BuildContext context) async {
    await LoadingCall.of(context).call((state, controller) => AppCacheManager().clearCache());
    await LoadingCall.of(context).call((state, controller) => AppCacheManager().clearCache());
    showToast(context, '清除成功');
    setState(() {
      _cacheSizeKey = GlobalKey();
    });
  }
}

bool checkLogin() {
  if ((getUserId() == null || getUserId() == 0)) {
    return false;
  }
  return true;
}
