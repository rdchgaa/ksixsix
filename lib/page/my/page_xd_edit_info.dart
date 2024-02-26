import 'dart:io';
import 'dart:ui' as ui;

import 'package:adobe_xd/pinned.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';
import 'package:ima2_habeesjobs/dialog/dialog_image.dart';
import 'package:ima2_habeesjobs/net/net_file.dart';
import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:ima2_habeesjobs/util/navigator.dart';
import 'package:ima2_habeesjobs/util/other.dart';
import 'package:ima2_habeesjobs/util/page_clip_image.dart';
import 'package:ima2_habeesjobs/widget/app_bar.dart';
import 'package:ima2_habeesjobs/widget/my_image.dart';
import 'package:provider/provider.dart';

class PageXdEditInfo extends StatefulWidget {

  const PageXdEditInfo({
    Key key,
  }) : super(key: key);

  @override
  _PageXdEditInfoState createState() => _PageXdEditInfoState();
}

class _PageXdEditInfoState extends State<PageXdEditInfo> {
  TextEditingController _unName = new TextEditingController(text: '');
  Gender gender = Gender.MALE;

  var headImage;

  List<int> _avatar;

  String _avatarUrl;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      // 强制竖屏
      DeviceOrientation.portraitUp
    ]);
    var user = context.read<SerUser>();
    _unName = TextEditingController(text: user.nickname);
    gender = user.info.gender;
    _avatarUrl = user.avatarUrl;
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

  onSubmit() async{
    var user = context.read<SerUser>();
    UserInfo userInfo = user.info;

    if (null != _avatar) {
      var ret = await Network.of<NetFile>(context).updateAvatar(Uint8List.fromList(_avatar));
      _avatarUrl = (await ret.result).url;
    }

    if (null != headImage) {
      userInfo.avatar = headImage;
    }
    if(_unName.text!=''){
      userInfo.name = _unName.text;
    }

    userInfo.gender = gender;
    user.info = userInfo;

    setUserInfo(userInfo);

    showToast(context, 'Successfully saved',alignment: Alignment(0, 0.8));
    Navigator.pop(context);
  }

  onEditHeadImage(BuildContext context, SerUser user) async {
    // var url = user.avatarUrl;
    // var ret = await PageEditImage(url: '',).push(context);
    // if (null != ret) {
    //   headImage = ret;
    //   // user.avatarUrl = ret;
    // }

    var val = await showSelectImageDialog(context);
    if (null == val) {
      return;
    }
    var img = await PageClipImage(image: FileImage(File(val))).push(context);
    if (null == img) {
      return;
    }
    encodeJpg(img as ui.Image, quality: 70).then((value) {
      setState(() {
        _avatar = value;
      });
    });

    setState(() {

    });
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
      child: Scaffold(
        backgroundColor: Color(0x00ffffff),
        appBar: MyAppBar(
          title: Text(
            '个人信息',
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
                    onSubmit();
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(6.4, 6.0, 6.4, 6.8),
                    child: Text(
                      '保存',
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
        body: Padding(
          padding: EdgeInsets.only(left: 20,right: 20),
          child: ListView(
            children: <Widget>[
              SafeArea(child: SizedBox()),
              Padding(
                padding: EdgeInsets.only(right: 0),
                child: InkWell(
                  onTap: (){
                    onEditHeadImage(context, user);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(1),
                        child: null != _avatar
                            ? HeadImage.memory(
                          // MemoryImage(Uint8List.fromList(_avatar!)),
                          Uint8List.fromList(_avatar),
                          width: 100,
                          height: 100,
                        )
                            : HeadImage.network(
                          _avatarUrl,
                          width: 100,
                          height: 100,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 16),
                      child: Text(
                        '修改头像',
                        style: TextStyle(
                          fontFamily: 'Source Han Sans CN',
                          fontSize: 14,
                          color: const Color(0xFF21A27C),
                          fontWeight: FontWeight.w700,
                        ),
                        softWrap: false,
                      ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 26,bottom: 10),
                child: Text(
                  '昵称',
                  style: TextStyle(
                    fontFamily: 'Source Han Sans CN',
                    fontSize: 16,
                    color: const Color(0xff0e0f0f),
                    fontWeight: FontWeight.w700,
                  ),
                  softWrap: false,
                ),
              ),
              SizedBox(
                height: 56,
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(width: 1.0, color: const Color(0xFFEBEBEB)),
                      ),
                    ),
                    Pinned.fromPins(Pin(size: MediaQuery.of(context).size.width - 60, start: 0.0), Pin(size: 50.0, middle: 0.4),
                        child: SizedBox(
                          height: 56,
                          width: double.infinity,
                          child: TextFormField(
                            autofocus: true,
                            onChanged: (val) {},
                            controller: _unName,
                            keyboardType: TextInputType.text,
                            cursorColor: Color(0xFF21A27C),
                            style: TextStyle(color: Color(0xFF0E0F0F), fontSize: 18, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0x22ffffff),
                              prefix: SizedBox(
                                width: 10,
                              ),
                              // prefixIconConstraints: BoxConstraints(),
                              // prefix: Text('+91 ',style: TextStyle(fontSize: 14,color: Color(0xff999999)),),
                              hintText: (user.info.name=='')?'昵称':user.info.name,
                              hintStyle: TextStyle(color: Color(0xFFCCCCCC), fontSize: 16),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                borderSide: BorderSide(style: BorderStyle.none),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                borderSide: BorderSide(style: BorderStyle.none),
                              ),
                              // border: InputBorder.none
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(20),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 32,bottom: 10),
                child: Text(
                  '性别',
                  style: TextStyle(
                    fontFamily: 'Source Han Sans CN',
                    fontSize: 16,
                    color: const Color(0xff0e0f0f),
                    fontWeight: FontWeight.w700,
                  ),
                  softWrap: false,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 0, top: 18),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          gender = Gender.MALE;
                        });
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: gender == Gender.MALE ? Color(0XFF21A27C) : Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          border: Border.all(width: 1,color: Color(0xFFEBEBEB))
                        ),
                        child: SizedBox(
                          width: (width-40-20)/2,
                          height: 56,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('assets/images/male.png',width: 18,height: 18,),
                              SizedBox(width: 4,),
                              Text(
                                '男',
                                style: TextStyle(
                                  fontFamily: 'Source Han Sans CN',
                                  fontSize: 16,
                                  color: gender == Gender.MALE ? Color(0xffffffff) : Color(0xFF0E0F0F),
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
                      padding: EdgeInsets.only(left:20,),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            gender = Gender.FEMALE;
                          });
                        },
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: gender == Gender.FEMALE ? Color(0XFF21A27C) : Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              border: Border.all(width: 1,color: Color(0xFFEBEBEB))
                          ),
                          child: SizedBox(
                            width: (width-40-20)/2,
                            height: 56,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset('assets/images/female.png',width: 18,height: 18,),
                                SizedBox(width: 4,),
                                Text(
                                  '女',
                                  style: TextStyle(
                                    fontFamily: 'Source Han Sans CN',
                                    fontSize: 16,
                                    color: gender == Gender.FEMALE ? Color(0xffffffff) : Color(0xFF0E0F0F),
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
            ],
          ),
        ),
      ),
    );
  }
}

const String _svg_i3q6wh =
    '<svg viewBox="1.5 6.4 22.8 14.4" ><path transform="matrix(-1.0, 0.0, 0.0, -1.0, 24.26, 20.86)" d="M 14.31960105895996 0.3926757872104645 C 13.76555919647217 0.9152726531028748 13.76555919647217 1.765827536582947 14.31960105895996 2.289395809173584 L 18.10688209533691 5.867764472961426 L 1.419087290763855 5.867764472961426 C 0.6353968381881714 5.867764472961426 0 6.468213558197021 0 7.208800792694092 C 0 7.949387073516846 0.6353968381881714 8.550809860229492 1.419087290763855 8.550809860229492 L 18.10623741149902 8.550809860229492 L 14.31960105895996 12.12917709350586 C 13.76555919647217 12.65177249908447 13.76555919647217 13.50232887268066 14.31960105895996 14.02589893341064 C 14.87364101409912 14.54849433898926 15.77267074584961 14.54849433898926 16.32671356201172 14.02589893341064 L 22.34805107116699 8.335739135742188 C 22.66985321044922 8.031068801879883 22.80432319641113 7.616061210632324 22.75160980224609 7.219081401824951 C 22.81175804138184 6.815980911254883 22.67795753479004 6.391677379608154 22.3501091003418 6.081862926483154 L 16.32671356201172 0.3926757872104645 C 16.0496940612793 0.1308923959732056 15.68642425537109 0 15.32315635681152 0 C 14.95989036560059 0 14.59662055969238 0.1308923959732056 14.31960105895996 0.3926757872104645 Z" fill="#0e0f0f" stroke="#0e0f0f" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
