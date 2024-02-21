import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';
import 'package:ima2_habeesjobs/dialog/dialog_image.dart';
import 'package:ima2_habeesjobs/dialog/select_image_dialog.dart';
import 'package:ima2_habeesjobs/net/net_file.dart';
import 'package:ima2_habeesjobs/page/uitls/page_edit_image.dart';
import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:ima2_habeesjobs/util/language.dart';
import 'package:ima2_habeesjobs/util/navigator.dart';
import 'package:ima2_habeesjobs/util/other.dart';
import 'package:ima2_habeesjobs/util/page_clip_image.dart';
import 'package:ima2_habeesjobs/widget/app_bar.dart';
import 'package:ima2_habeesjobs/widget/app_content.dart';
import 'package:ima2_habeesjobs/widget/my_image.dart';
import 'package:ima2_habeesjobs/widget/ui_layout.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:ui' as ui;

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
  TextEditingController _unName = new TextEditingController(text: '');

  List<int> _avatar;

  String _avatarUrl;

  int selectMoney = 10;

  bool showShoukuanma = false;

  bool showOrderModal = false;

  bool showApplySuccessBuild = false;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      // 强制竖屏
      DeviceOrientation.portraitUp
    ]);
    var user = context.read<SerUser>();
    _unName = TextEditingController(text: user.nickname);
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

  onSelectImage(BuildContext context) async {
    var val = await showSelectImageDialog(context);
    if (null == val) {
      return;
    }

    File file = File(val); // 创建一个File对象来表示要读取的文件

    List<int> bytes;
    try {
      bytes = await file.readAsBytes(); // 使用readAsBytes()函数从文件中读取字节并存入bytes变量中
    } catch (e) {
      print('Error reading the file: $e');
    }
    setState(() {
      _avatar = bytes;
    });
    // FileImage image =FileImage(File(val));
    // var img = await PageClipImage(image: FileImage(File(val))).push(context);
    // if (null == img) {
    //   return;
    // }
    // encodeJpg(img as ui.Image, quality: 70).then((value) {
    //   setState(() {
    //     _avatar = value;
    //   });
    // });

    // setState(() {});
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
                    leading: SizedBox(
                      width: 26,
                      height: 14,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: SvgPicture.string(
                            _svg_i3q6wh,
                            allowDrawingOutsideViewBox: true,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              toApplyHistory();
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(6.4, 6.0, 6.4, 6.8),
                              child: Text(
                                '申请记录',
                                style: TextStyle(fontFamily: 'Source Han Sans CN', fontSize: 16, color: Color(0xFF21A27C), fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                                softWrap: false,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  body: Stack(
                    children: [
                      showApplySuccessBuild?getApplySuccessBuild():Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: ListView(
                          children: <Widget>[
                            SafeArea(child: SizedBox()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getShoukuanmaImageBuild(),
                                getOrderModalImageBuild(),
                                getUpdateImageBuild(),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 32, bottom: 10),
                              child: Row(
                                children: [
                                  Text(
                                    '请选择兑换数量',
                                    style: TextStyle(
                                      fontFamily: 'Source Han Sans CN',
                                      fontSize: 16,
                                      color: const Color(0xff0e0f0f),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    softWrap: false,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      '（当前门票数：',
                                      style: TextStyle(
                                        fontFamily: 'Source Han Sans CN',
                                        fontSize: 14,
                                        color: const Color(0XFF21A27C),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      softWrap: false,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 0),
                                    child: Image.asset(
                                      'assets/images/piao.png',
                                      width: 14,
                                      height: 14,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 2),
                                    child: Text(
                                      selectMoney.toString()+'）',
                                      style: TextStyle(
                                        fontFamily: 'Source Han Sans CN',
                                        fontSize: 14,
                                        color: const Color(0XFF21A27C),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      softWrap: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 0),
                              child: Text(
                                '门票等价于支付金额￥',
                                style: TextStyle(
                                  fontFamily: 'Source Han Sans CN',
                                  fontSize: 12,
                                  color: const Color(0xffff2c14),
                                  fontWeight: FontWeight.w700,
                                ),
                                softWrap: false,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 0, top: 18),
                              child: LayoutBuilder(builder: (context, con) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectMoney = 10;
                                            });
                                          },
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                                color: selectMoney == 10 ? Color(0XFF21A27C) : Color(0xFFFFFFFF),
                                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                                border: Border.all(width: 1, color: Color(0xFFEBEBEB))),
                                            child: SizedBox(
                                              width: (con.maxWidth - 40) / 2,
                                              height: 56,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Image.asset(
                                                    'assets/images/piao.png',
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    '10',
                                                    style: TextStyle(
                                                      fontFamily: 'Source Han Sans CN',
                                                      fontSize: 20,
                                                      color: selectMoney == 10 ? Color(0xffffffff) : Color(0xFF0E0F0F),
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    softWrap: false,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 20,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectMoney = 50;
                                              });
                                            },
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                  color: selectMoney == 50 ? Color(0XFF21A27C) : Color(0xFFFFFFFF),
                                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                                  border: Border.all(width: 1, color: Color(0xFFEBEBEB))),
                                              child: SizedBox(
                                                width: (con.maxWidth - 40) / 2,
                                                height: 56,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Image.asset(
                                                      'assets/images/piao.png',
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                      '50',
                                                      style: TextStyle(
                                                        fontFamily: 'Source Han Sans CN',
                                                        fontSize: 20,
                                                        color: selectMoney == 50 ? Color(0xffffffff) : Color(0xFF0E0F0F),
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                      softWrap: false,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 0, top: 18),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectMoney = 100;
                                              });
                                            },
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                  color: selectMoney == 100 ? Color(0XFF21A27C) : Color(0xFFFFFFFF),
                                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                                  border: Border.all(width: 1, color: Color(0xFFEBEBEB))),
                                              child: SizedBox(
                                                width: (con.maxWidth - 40) / 2,
                                                height: 56,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Image.asset(
                                                      'assets/images/piao.png',
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                      '100',
                                                      style: TextStyle(
                                                        fontFamily: 'Source Han Sans CN',
                                                        fontSize: 20,
                                                        color: selectMoney == 100 ? Color(0xffffffff) : Color(0xFF0E0F0F),
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                      softWrap: false,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 20,
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectMoney = 500;
                                                });
                                              },
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                    color: selectMoney == 500 ? Color(0XFF21A27C) : Color(0xFFFFFFFF),
                                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                                    border: Border.all(width: 1, color: Color(0xFFEBEBEB))),
                                                child: SizedBox(
                                                  width: (con.maxWidth - 40) / 2,
                                                  height: 56,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Image.asset(
                                                        'assets/images/piao.png',
                                                        width: 20,
                                                        height: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        '500',
                                                        style: TextStyle(
                                                          fontFamily: 'Source Han Sans CN',
                                                          fontSize: 20,
                                                          color: selectMoney == 500 ? Color(0xffffffff) : Color(0xFF0E0F0F),
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                        softWrap: false,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 18,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectMoney = 1000;
                                          });
                                        },
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              color: selectMoney == 1000 ? Color(0XFF21A27C) : Color(0xFFFFFFFF),
                                              borderRadius: BorderRadius.all(Radius.circular(4)),
                                              border: Border.all(width: 1, color: Color(0xFFEBEBEB))),
                                          child: SizedBox(
                                            width: (con.maxWidth - 20),
                                            height: 56,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Image.asset(
                                                  'assets/images/piao.png',
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  '1000',
                                                  style: TextStyle(
                                                    fontFamily: 'Source Han Sans CN',
                                                    fontSize: 20,
                                                    color: selectMoney == 1000 ? Color(0xffffffff) : Color(0xFF0E0F0F),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  softWrap: false,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                            getSubmitBuild(),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),

                if(showShoukuanma)getBigShoukuanma(),
                if(showOrderModal)getBigOrderModal(),
              ],
            );
          }
        ),
      ),
    );
  }

  getApplySuccessBuild(){
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Text(
              '提交成功',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xFF21A27C)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              '申请成功，请等待后台审核通过',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF21A27C)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Center(
              child: Image.asset(
                'assets/images/ordertime.png',
                width: 100,
                height: 100,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              '稍后门票自动到账',
              style: TextStyle(fontSize: 16, color: Color(0xFF333333)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              '您可以在申请记录中查看审核情况',
              style: TextStyle(fontSize: 16, color: Color(0xFF333333)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:50,left: 12.0,right: 12),
            child: InkWell(
              onTap: () async{
                Navigator.pop(context);
              },
              child: DecoratedBox(
                decoration: backGroundDecoration.copyWith(color: Color(0xffffffff)),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: InkWell(
                    child: Center(
                      child: Text(
                        '返回',
                        style: textStyleH3.copyWith(
                          color: Color(0xFF21A27C),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  getSubmitBuild(){
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          InkWell(
            onTap: ()  async {
              onSubmit();
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage("assets/images/button1.webp"), fit: BoxFit.fill),
                  ),
                  child: SizedBox(
                    width: 300,
                    height: 80,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          '提交',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffeeeeee)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              '提交后通常立即审核通过，0点到9点审核有所延迟',
              style: TextStyle(
                fontFamily: 'Source Han Sans CN',
                fontSize: 12,
                color: const Color(0xffff2c14),
                fontWeight: FontWeight.w700,
              ),
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }
  getBigShoukuanma(){
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return LayoutBuilder(
      builder: (context,con) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: GestureDetector(
            onTap: (){
              setState(() {
                showShoukuanma = false;
              });
            },
            child: Center(
                child: Image.asset(
                  'assets/images/shoukuanma.png',
                  width: con.maxWidth-20,
                  height: con.maxHeight-20,
                )),
          ),
        );
      }
    );
  }
  getBigOrderModal(){
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return LayoutBuilder(
        builder: (context,con) {
          return DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.white
            ),
            child: GestureDetector(
              onTap: (){
                setState(() {
                  showOrderModal = false;
                });
              },
              child: Center(
                  child: Image.asset(
                    'assets/images/jiaoyimode.png',
                    width: con.maxWidth-20,
                    height: con.maxHeight-20,
                  )),
            ),
          );
        }
    );
  }
  getShoukuanmaImageBuild(){
    var width = MediaQuery.of(context).size.width;
    var user = context.watch<SerUser>();
    return Padding(
      padding: EdgeInsets.only(right: 0),
      child: InkWell(
        onTap: () {
          setState(() {
            showShoukuanma = true;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                '第一步',
                style: TextStyle(
                  fontFamily: 'Source Han Sans CN',
                  fontSize: 16,
                  color: const Color(0xffff2c14),
                  fontWeight: FontWeight.w700,
                ),
                softWrap: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1),
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    border: Border.all(
                      color: Color(0xffffffff),
                      width: 2,
                    )),
                child: SizedBox(
                    width: 100,
                    height: 150,
                    child: Center(
                        child: Image.asset(
                          'assets/images/shoukuanma.png',
                          width: 100,
                          height: 150,
                        ))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                '点击二维码并截图\n扫描并支付\n与门票相等的金额',
                style: TextStyle(
                  fontFamily: 'Source Han Sans CN',
                  fontSize: 10,
                  color: const Color(0xffff2c14),
                  fontWeight: FontWeight.w700,
                ),
                softWrap: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
  getOrderModalImageBuild(){
    var width = MediaQuery.of(context).size.width;
    var user = context.watch<SerUser>();
    return Padding(
      padding: EdgeInsets.only(right: 0),
      child: InkWell(
        onTap: () {
          setState(() {
            showOrderModal = true;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                '第二步',
                style: TextStyle(
                  fontFamily: 'Source Han Sans CN',
                  fontSize: 16,
                  color: const Color(0xffff2c14),
                  fontWeight: FontWeight.w700,
                ),
                softWrap: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1),
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    border: Border.all(
                      color: Color(0xffffffff),
                      width: 2,
                    )),
                child: SizedBox(
                    width: 100,
                    height: 150,
                    child: Center(
                        child: Image.asset(
                          'assets/images/jiaoyimode.png',
                          width: 100,
                          height: 150,
                        ))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                '支付订单模板\n务必能看清红色字体\n',
                style: TextStyle(
                  fontFamily: 'Source Han Sans CN',
                  fontSize: 10,
                  color: const Color(0xffff2c14),
                  fontWeight: FontWeight.w700,
                ),
                softWrap: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
  getUpdateImageBuild(){
    var width = MediaQuery.of(context).size.width;
    var user = context.watch<SerUser>();
    return Padding(
      padding: EdgeInsets.only(right: 0),
      child: InkWell(
        onTap: () {
          onSelectImage(context,);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                '第三步',
                style: TextStyle(
                  fontFamily: 'Source Han Sans CN',
                  fontSize: 16,
                  color: const Color(0xffff2c14),
                  fontWeight: FontWeight.w700,
                ),
                softWrap: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1),
              child: null != _avatar
                  ? HeadImage.memory(
                // MemoryImage(Uint8List.fromList(_avatar!)),
                Uint8List.fromList(_avatar),
                width: 100,
                height: 150,
                borderRadius: BorderRadius.all(Radius.circular(4)),
                  border: Border.all(
                    color: Color(0xffffffff),
                    width: 2,
                  ),
              )
                  : DecoratedBox(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    border: Border.all(
                      color: Color(0xffffffff),
                      width: 2,
                    )),
                child: SizedBox(
                    width: 100,
                    height: 150,
                    child: Center(
                        child: Image.asset(
                          'assets/images/add.png',
                          width: 30,
                          height: 30,
                          color: Color(0XFF21A27C),
                        ))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                '上传订单截图\n多次上传无效截图将\n进行封号处理',
                style: TextStyle(
                  fontFamily: 'Source Han Sans CN',
                  fontSize: 10,
                  color: const Color(0xffff2c14),
                  fontWeight: FontWeight.w700,
                ),
                softWrap: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  toApplyHistory(){

  }

  onSubmit() async {
    var user = context.read<SerUser>();
    UserInfo userInfo = user.info;

    if(_avatar==null){
      showToast(context, '请上传支付凭证');
      return ;
    }
    var res = await LoadingCall.of(context).call((state, controller) async {
      var ret = await Network.of<NetFile>(context).updateAvatar(Uint8List.fromList(_avatar));
      _avatarUrl = (await ret.result).url;
      return true;
      // return await NetWork.getRoomMainInfo(context,widget.roomId);
    }, isShowLoading: true);

    setState(() {
      showApplySuccessBuild = true;
    });
  }

  Future<bool> _onInitLoading(BuildContext context) async {
    return true;
  }
}

const String _svg_i3q6wh =
    '<svg viewBox="1.5 6.4 22.8 14.4" ><path transform="matrix(-1.0, 0.0, 0.0, -1.0, 24.26, 20.86)" d="M 14.31960105895996 0.3926757872104645 C 13.76555919647217 0.9152726531028748 13.76555919647217 1.765827536582947 14.31960105895996 2.289395809173584 L 18.10688209533691 5.867764472961426 L 1.419087290763855 5.867764472961426 C 0.6353968381881714 5.867764472961426 0 6.468213558197021 0 7.208800792694092 C 0 7.949387073516846 0.6353968381881714 8.550809860229492 1.419087290763855 8.550809860229492 L 18.10623741149902 8.550809860229492 L 14.31960105895996 12.12917709350586 C 13.76555919647217 12.65177249908447 13.76555919647217 13.50232887268066 14.31960105895996 14.02589893341064 C 14.87364101409912 14.54849433898926 15.77267074584961 14.54849433898926 16.32671356201172 14.02589893341064 L 22.34805107116699 8.335739135742188 C 22.66985321044922 8.031068801879883 22.80432319641113 7.616061210632324 22.75160980224609 7.219081401824951 C 22.81175804138184 6.815980911254883 22.67795753479004 6.391677379608154 22.3501091003418 6.081862926483154 L 16.32671356201172 0.3926757872104645 C 16.0496940612793 0.1308923959732056 15.68642425537109 0 15.32315635681152 0 C 14.95989036560059 0 14.59662055969238 0.1308923959732056 14.31960105895996 0.3926757872104645 Z" fill="#0e0f0f" stroke="#0e0f0f" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
