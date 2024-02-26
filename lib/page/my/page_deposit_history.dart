import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:ima2_habeesjobs/widget/app_bar.dart';
import 'package:ima2_habeesjobs/widget/app_content.dart';
import 'package:provider/provider.dart';

class PageDepositHistory extends StatefulWidget {
  final int enterType; //进入类型，1：竖屏进入，2：横屏进入
  const PageDepositHistory({
    Key key,
    this.enterType = 1,
  }) : super(key: key);

  @override
  _PageDepositHistoryState createState() => _PageDepositHistoryState();
}

class _PageDepositHistoryState extends State<PageDepositHistory> {
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
    if (widget.enterType == 2) {
      SystemChrome.setPreferredOrientations([
        // 强制横屏
        DeviceOrientation.landscapeLeft
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var user = context.watch<SerUser>();
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/login_back.webp'),
          fit: BoxFit.fill,
        ),
      ),
      child: Loading(
        child: LoadingCall(
            onInitLoading: _onInitLoading,
            emptyBuilder: (context) {
              return UiEmptyView(type: EmptyType.data);
            },
            errorBuilder: (context, error) {
              return UiEmptyView(type: EmptyType.network, onPressed: () => _onInitLoading(context));
            },
            builder: (context) {
              return Stack(
                children: [
                  Scaffold(
                    backgroundColor: Color(0x00ffffff),
                    appBar: MyAppBar(
                      title: Text(
                        '获取门票',
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
                      leading: leading(context),
                    ),
                    body: LayoutBuilder(builder: (context, con) {
                      return ListView.builder(
                          itemCount: 6,
                          physics: const ClampingScrollPhysics(),
                          padding: EdgeInsets.only(top: 0),
                          itemBuilder: (context, index) {
                            if (index == 4) {
                              return getFailBuild(con);
                            }
                            if (index > 3) {
                              return getWaitBuild(con);
                            }
                            return getSuccessBuild(con);
                          });
                    }),
                  ),
                ],
              );
            }),
      ),
    );
  }

  getWaitBuild(BoxConstraints con) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 20,
                    ),
                    child: Text(
                      '时间：2024-02-07 19:58:00',
                      style: TextStyle(fontSize: 12, color: Color(0xff333333)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 20, top: 5),
                    child: Row(
                      children: [
                        Text(
                          '兑换数量：',
                          style: TextStyle(fontSize: 12, color: Color(0xff333333)),
                        ),
                        Text(
                          '50',
                          style: TextStyle(fontSize: 16, color: Color(0xff333333)),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Image.asset(
                          'assets/images/piao.png',
                          width: 18,
                          height: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '审核中',
                      style: TextStyle(
                        fontFamily: 'Source Han Sans CN',
                        fontSize: 14,
                        color: Color(0xFF0E0F0F),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getFailBuild(BoxConstraints con) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xFFaaaaaa),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 20,
                    ),
                    child: Text(
                      '时间：2024-02-07 19:58:00',
                      style: TextStyle(fontSize: 12, color: Color(0xff333333)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 20, top: 5),
                    child: Row(
                      children: [
                        Text(
                          '兑换数量：',
                          style: TextStyle(fontSize: 12, color: Color(0xff333333)),
                        ),
                        Text(
                          '50',
                          style: TextStyle(fontSize: 16, color: Color(0xff333333)),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Image.asset(
                          'assets/images/piao.png',
                          width: 18,
                          height: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '审核失败',
                      style: TextStyle(
                        fontFamily: 'Source Han Sans CN',
                        fontSize: 14,
                        color: Color(0xFF0E0F0F),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getSuccessBuild(BoxConstraints con) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0XFF21A27C),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 20,
                    ),
                    child: Text(
                      '时间：2024-02-07 19:58:00',
                      style: TextStyle(fontSize: 12, color: Color(0xffeeeeee)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 20, top: 5),
                    child: Row(
                      children: [
                        Text(
                          '兑换数量：',
                          style: TextStyle(fontSize: 12, color: Color(0xffeeeeee)),
                        ),
                        Text(
                          '50',
                          style: TextStyle(fontSize: 16, color: Color(0xffeeeeee)),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Image.asset(
                          'assets/images/piao.png',
                          width: 18,
                          height: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '已通过',
                      style: TextStyle(
                        fontFamily: 'Source Han Sans CN',
                        fontSize: 14,
                        color: true ? Color(0xffffffff) : Color(0xFF0E0F0F),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onInitLoading(BuildContext context) async {
    return true;
  }
}
