import 'package:flutter/material.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';
import 'package:ima2_habeesjobs/app.dart';
import 'package:ima2_habeesjobs/dao/manage_dao.dart';
import 'package:ima2_habeesjobs/net/api.dart';
import 'package:ima2_habeesjobs/net/net_file.dart';
import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:ima2_habeesjobs/service/ser_base.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:ima2_habeesjobs/util/app_cache_manager.dart';
import 'package:ima2_habeesjobs/util/datetime.dart';
import 'package:ima2_habeesjobs/util/language.dart';
import 'package:ima2_habeesjobs/widget/app_bar.dart';
import 'package:ima2_habeesjobs/widget/app_content.dart';
import 'package:ima2_habeesjobs/widget/my_image.dart';
import 'package:provider/provider.dart';

class _ControlUserInfo extends RouterDataNotifier {
  var workList = [];

  init(BuildContext context) {
    updateData(context);
    value = true;
  }

  updateData(BuildContext context) {
    notifyListeners();
  }
}

class PageUserInfo extends RouterDataWidget<_ControlUserInfo> {
  PageUserInfo({Key key}) : super(key: key);

  @override
  _PageUserInfoState createState() => _PageUserInfoState();

  @override
  _ControlUserInfo initData(BuildContext context) {
    return _ControlUserInfo();
  }
}

class _PageUserInfoState extends RouterDataWidgetState<PageUserInfo> {
  @override
  Widget buildContent(BuildContext context) {
    var user = context.watch<SerUser>();
    var buttonStyle = ButtonStyle(
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: MaterialStateProperty.all(StadiumBorder()),
      minimumSize: MaterialStateProperty.all(Size(double.infinity, 40)),
      backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
      foregroundColor: MaterialStateProperty.all(Colors.white),
    );
    var textRightStyle = TextStyle(color: Color(0xff333333));
    var leftStyle = TextStyle(color: Color(0xff474747), fontSize: 16);
    return Scaffold(
      appBar: MyAppBar(
        // backgroundColor: [Color(0xFF21A27C), Color(0xFF21A27C)],
        centerTitle: true,
        title: Text(
          "Online CV",
          style: TextStyle(fontSize: 18, color: Color(0xFF292929), fontWeight: FontWeight.w800),
        ),
      ),
      body: AppContent(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 0),
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 0),
                            child: Row(
                              children: [
                                Text(
                                  user.nickname ?? '',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF292929)),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Image.asset("assets/imgs/icon_my_edit.png", width: 20, height: 20),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 0),
                            child: Row(
                              children: [
                                Image.asset("assets/imgs/icon_age.png", width: 12, height: 12),
                                Padding(
                                  padding: EdgeInsets.only(left: 1),
                                  child: Text(
                                    (context.read<SerUser>().info?.birthday != null)
                                        ? (DateTime.now().year - context.read<SerUser>().info?.birthday?.year).toString()
                                        : 'not set',
                                    style: TextStyle(fontSize: 13, color: Color(0xFFA9AAAD)),
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Image.asset("assets/imgs/icon_workw.png", width: 12, height: 12),
                                Padding(
                                  padding: EdgeInsets.only(left: 1),
                                  child: Text(
                                    context.read<SerUser>().signature ?? '',
                                    style: TextStyle(fontSize: 13, color: Color(0xFFA9AAAD)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 0),
                        child: HeadImage.network(
                          user.avatarUrl,
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    AutoRouter.of(context).pushNamed("/user_update_nickname");
                  },
                  // onTap: () => widget.data._onEditHeadImage(context, user),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Work experience',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF292929)),
                    ),
                    IconButton(
                      onPressed: () async {
                        await AutoRouter.of(context).pushNamed("/user/work/edit");

                        widget.data.updateData(context);
                      },
                      icon: Image.asset("assets/imgs/icon_my_add.png", width: 20, height: 20),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 0),
                    child: ListView.separated(
                      padding: EdgeInsets.only(top: 20),
                        itemBuilder: (context, index) {
                          var item = widget.data.workList[index];
                          return SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 0, bottom: 0),
                                  child: Text(
                                    item['name'],
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF292929)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16, bottom: 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item['title'],
                                        style: TextStyle(fontSize: 13, color: Color(0xFF777C89)),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            DateTime.fromMillisecondsSinceEpoch(item['start']).format("yyyy.MM.dd") ?? 'unknown',
                                            style: TextStyle(fontSize: 13, color: Color(0xFF777C89)),
                                          ),
                                          Text(
                                            ' - ',
                                            style: TextStyle(fontSize: 13, color: Color(0xFFA9AAAD)),
                                          ),
                                          Text(
                                            DateTime.fromMillisecondsSinceEpoch(item['end']).format("yyyy.MM.dd") ?? 'unknown',
                                            style: TextStyle(fontSize: 13, color: Color(0xFF777C89)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16, bottom: 0),
                                  child: Text(
                                    item['content'],
                                    style: TextStyle(fontSize: 15, color: Color(0xFF777C89)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(top: 24, bottom: 24),
                            child: Divider(
                              height: 1,
                              color: Color(0xffeeeeee),
                            ),
                          );
                        },
                        itemCount: widget.data.workList.length)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
