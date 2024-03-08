import 'dart:async';

import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xxc_flutter_utils/xxc_flutter_utils.dart';
import 'package:ima2_habeesjobs/app.dart';
import 'package:ima2_habeesjobs/net/network.dart';
import 'package:ima2_habeesjobs/page/login/page_register.dart';
import 'package:ima2_habeesjobs/page/page_init.dart';
import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:ima2_habeesjobs/util/language.dart';
import 'package:ima2_habeesjobs/util/navigator.dart';
import 'package:ima2_habeesjobs/widget/app_content.dart';

class XdRegisterBuild extends StatefulWidget {
  XdRegisterBuild({
    Key key,
  }) : super(key: key);

  @override
  _XdRegisterBuildState createState() => _XdRegisterBuildState();
}

class _XdRegisterBuildState extends State<XdRegisterBuild> with SingleTickerProviderStateMixin {
  GlobalKey _formKey = new GlobalKey<FormState>();
  TextEditingController _unPhone = new TextEditingController();
  TextEditingController _unPassword = new TextEditingController();
  TextEditingController _unConfirmPassword = new TextEditingController();

  TextEditingController _unName = new TextEditingController();

  bool _isLock = false;
  Timer _timer;
  DateTime _endTime = DateTime.now().add(const Duration(seconds: 60));

  bool _isCountDown = false;
  bool passwordVisible = true;
  bool passwordComVisible = true;

  @override
  Future<void> init(BuildContext context) async {
    passwordVisible = true;
    passwordComVisible = true;
  }

  void _onTimer(Timer timer) {
    var val = DateTime.now().compareTo(_endTime);
    if (1 == val) {
      _timer?.cancel();
      _timer = null;
    }
    setState(() {});
  }

  Future<void> _onGetCode(BuildContext context) async {
    if (_isLock) {
      return;
    }
    if (_unPhone.text.length < 1) {
      showToast(context, 'Please enter the correct account');
      return;
    }
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), _onTimer);
    _isLock = true;
    _isCountDown = true;
    showToast(context, 'Verification code sent successfully');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  Future<void> _onSubmit(BuildContext context) async {
    var deviceId = getDeviceId();
    if(_unPhone.text.length>15||_unPhone.text.length<6){
      showToast(context, '请输入6-15位账号');
      return;
    }
    if(_unPassword.text.length>15||_unPassword.text.length<6){
      showToast(context, '请输入6-15位密码');
      return;
    }
    if(_unPassword.text!=_unConfirmPassword.text){
      showToast(context, '两次密码不一致');
      return;
    }
    if(_unName.text==''){
      showToast(context, '请输入昵称');
      return;
    }
    // var res = await NetWork.toRegister(context,_unPhone.text,_unPassword.text,_unName.text);

    var res = await LoadingCall.of(context).call((state, controller) async {
      return await NetWork.toRegister(context,_unPhone.text,_unPassword.text,_unName.text);
    },isShowLoading: true);
    if (res!=null) {
      saveLoginInfo(res);
      goHome();
    } else {
      // showToast(context, '注册失败，请稍后再试');
    }
    // Navigator.pop(context);


    // await LoadingCall.of(context).call((state, controller) async {
    //   await Network.of<ApiUser>(context).addInfoTag(add_tag_req(tag: _unLabel.text));
    //   _label.add(query_tag_res_tag_detail(tag: _unLabel.text, clickNum: 0));
    // });
    // Navigator.pop(context);
    return;
  }
  saveLoginInfo(var res){
    setToken(res['token']);
    setUserId(res['user_id']);
    setUserName(_unPhone.text);
    setPassword(_unPassword.text);
  }

  goHome(){
    PageInit(needLogin: false,).pushAndRemoveUntil(context, (route) => true);
  }

  visibleBuild(bool isShow) {
    return Pinned.fromPins(
      Pin(size: 20.0, end: 20.0),
      Pin(size: 20.0, middle: 0.4773),
      child: Stack(
        children: <Widget>[
          !isShow
              ? Pinned.fromPins(
                  Pin(start: 0.8, end: 0.8),
                  Pin(size: 12.4, middle: 0.5),
                  child: Stack(
                    children: <Widget>[
                      SizedBox.expand(
                          child: SvgPicture.string(
                        _svg_op9c4z,
                        allowDrawingOutsideViewBox: true,
                        fit: BoxFit.fill,
                      )),
                      Pinned.fromPins(
                        Pin(size: 8.4, middle: 0.4922),
                        Pin(start: 1.8, end: 2.1),
                        child: SvgPicture.string(
                          _svg_op9c4z,
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                )
              : Pinned.fromPins(
                  Pin(start: 0.0, end: 0.0),
                  Pin(size: 11.7, middle: 0.4844),
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.5),
                        child: SizedBox.expand(
                            child: SvgPicture.string(
                          _svg_bs2n5,
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        )),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.6, vertical: 0.0),
                        child: SizedBox.expand(
                            child:
                                // Adobe XD layer: '路径 2489' (shape)
                                SvgPicture.string(
                          _svg_yzm50,
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        )),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Loading(
        child: LoadingCall(
            onInitLoading: _onInitLoading,
            emptyBuilder: (context) {
              return UiEmptyView(type: EmptyType.data);
            },
            errorBuilder: (context, error) {
              return UiEmptyView(type: EmptyType.network, onPressed: () => _onInitLoading(context));
            },
            builder: (context) {
            return DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login_back.webp'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.only(top: 0),
                  children: [
                    SizedBox(
                      width: width,
                      height: height,
                      child: Stack(
                        children: <Widget>[
                          Pinned.fromPins(
                            Pin(start: 0.0, end: 0.0),
                            Pin(size: 44.0, start: 0.0),
                            child:
                                // Adobe XD layer: '蒙版组 9' (shape)
                                Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: const AssetImage(''),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(start: 20.0, end: 20.0),
                            Pin(size: 56.0, middle: 0.3108),
                            child: SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: TextFormField(
                                autofocus: true,
                                onChanged: (val) {},
                                controller: _unPhone,
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: Color(0xFF21A27C),
                                style: TextStyle(color: Color(0xFF333333), fontSize: 18, fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0x22000000),
                                  prefix: SizedBox(
                                    width: 10,
                                  ),
                                  // prefixIconConstraints: BoxConstraints(),
                                  // prefix: Text('+91 ',style: TextStyle(fontSize: 14,color: Color(0xff999999)),),
                                  hintText: '账号',
                                  hintStyle: TextStyle(color: Color(0xFF999999), fontSize: 16),
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
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(start: 20.0, end: 20.0),
                            Pin(size: 56.0, middle: 0.4114),
                            child: SizedBox(
                              height: 60,
                              width: double.infinity,
                              child: TextFormField(
                                onChanged: (val) {
                                  // widget.data._number = val;
                                },
                                cursorColor: Color(0xFF21A27C),
                                controller: _unPassword,
                                style: TextStyle(color: Color(0xFF333333), fontSize: 18, fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0x22000000),
                                  hintText: '密码',
                                  prefix: SizedBox(
                                    width: 10,
                                  ),
                                  hintStyle: TextStyle(color: Color(0xFF999999), fontSize: 16),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    borderSide: BorderSide(style: BorderStyle.none),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    borderSide: BorderSide(style: BorderStyle.none),
                                  ),
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.only(right: 0),
                                    child: SizedBox(
                                      width: 60,
                                      height: 50,
                                      child: InkWell(
                                        //根据passwordVisible状态显示不同的图标
                                        child: passwordVisible ? visibleBuild(true) : visibleBuild(false),
                                        onTap: () {
                                          //更新状态控制密码显示或隐藏
                                          setState(() {
                                            passwordVisible = !passwordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                obscureText: passwordVisible,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(20),
                                ],
                              ),
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(start: 20.0, end: 20.0),
                            Pin(size: 56.0, middle: 0.5119),
                            child: SizedBox(
                              height: 60,
                              width: double.infinity,
                              child: TextFormField(
                                onChanged: (val) {
                                  // widget.data._number = val;
                                },
                                cursorColor: Color(0xFF21A27C),
                                controller: _unConfirmPassword,
                                style: TextStyle(color: Color(0xFF333333), fontSize: 18, fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0x22000000),
                                  hintText: '确认密码',
                                  prefix: SizedBox(
                                    width: 10,
                                  ),
                                  hintStyle: TextStyle(color: Color(0xFF999999), fontSize: 16),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    borderSide: BorderSide(style: BorderStyle.none),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    borderSide: BorderSide(style: BorderStyle.none),
                                  ),
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.only(right: 0),
                                    child: SizedBox(
                                      width: 60,
                                      height: 50,
                                      child: InkWell(
                                        //根据passwordVisible状态显示不同的图标
                                        child: passwordComVisible ? visibleBuild(true) : visibleBuild(false),
                                        onTap: () {
                                          //更新状态控制密码显示或隐藏
                                          setState(() {
                                            passwordComVisible = !passwordComVisible;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                obscureText: passwordComVisible,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(20),
                                ],
                                validator: (v) {
                                  if (v.trim().length > 0) {
                                    if (v != _unPassword.text) {
                                      return '两次输入密码不一致';
                                    }
                                    return null;
                                  }
                                  return '密码不能为空';
                                },
                              ),
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(start: 20.0, end: 20.0),
                            Pin(size: 56.0, middle: 0.5119 + 0.1005),
                            child: SizedBox(
                              height: 60,
                              width: double.infinity,
                              child: TextFormField(
                                onChanged: (val) {
                                  // widget.data._number = val;
                                },
                                keyboardType: TextInputType.text,
                                cursorColor: Color(0xFF21A27C),
                                controller: _unName,
                                // maxLength: 10,
                                style: TextStyle(color: Color(0xFF333333), fontSize: 20),
                                decoration: InputDecoration(
                                  prefixIconConstraints: BoxConstraints(),
                                  filled: true,
                                  fillColor: Color(0x22000000),
                                  hintText: '昵称',
                                  prefix: SizedBox(
                                    width: 10,
                                  ),
                                  hintStyle: TextStyle(color: Color(0xFF999999), fontSize: 16),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    borderSide: BorderSide(style: BorderStyle.none),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    borderSide: BorderSide(style: BorderStyle.none),
                                  ),
                                  suffixIconConstraints: BoxConstraints(),
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(8),
                                ],
                                // obscureText: passwordComVisible,
                                validator: (v) {
                                  if (v.trim().length > 0) {
                                    return null;
                                  }
                                  return '’请输入昵称';
                                },
                                // inputFormatters: [
                                //   LengthLimitingTextInputFormatter(15),
                                // ],
                              ),
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(size: 124.0, start: 20.0),
                            Pin(size: 46.0, middle: 0.1862),
                            child: Text(
                              '注册',
                              style: TextStyle(
                                fontFamily: 'Source Han Sans CN',
                                fontSize: 32,
                                color: const Color(0xff0e0f0f),
                                fontWeight: FontWeight.w800,
                              ),
                              softWrap: false,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(start: 0.0, end: 0.0),
                            Pin(size: 44.0, start: 44.0),
                            child:
                                // Adobe XD layer: 'tit' (group)
                                Stack(
                              children: <Widget>[
                                // Adobe XD layer: '矩形' (shape)
                                Container(
                                  decoration: BoxDecoration(),
                                ),
                                Pinned.fromPins(
                                  Pin(size: 26.0, start: 20.0),
                                  Pin(size: 26.0, middle: 0.5),
                                  child: InkWell(
                                    onTap: () {
                                      // AutoRouter.of(context).pop();
                                      Navigator.pop(context);
                                    },
                                    child: Stack(
                                      children: <Widget>[
                                        Pinned.fromPins(
                                          Pin(start: 1.9, end: 1.4),
                                          Pin(size: 14.4, middle: 0.5864),
                                          child: SvgPicture.string(
                                            _svg_i3q6wh,
                                            allowDrawingOutsideViewBox: true,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(start: 20.0, end: 20.0),
                            Pin(size: 80.0, middle: 0.7500),
                            child: InkWell(
                              onTap: ()  async {
                                _onSubmit(context);
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
                                            '注册',
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffeeeeee)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  Future<bool> _onInitLoading(BuildContext context) async {
    return true;
  }
}

const String _svg_i3q6wh =
    '<svg viewBox="1.5 6.4 22.8 14.4" ><path transform="matrix(-1.0, 0.0, 0.0, -1.0, 24.26, 20.86)" d="M 14.31960105895996 0.3926757872104645 C 13.76555919647217 0.9152726531028748 13.76555919647217 1.765827536582947 14.31960105895996 2.289395809173584 L 18.10688209533691 5.867764472961426 L 1.419087290763855 5.867764472961426 C 0.6353968381881714 5.867764472961426 0 6.468213558197021 0 7.208800792694092 C 0 7.949387073516846 0.6353968381881714 8.550809860229492 1.419087290763855 8.550809860229492 L 18.10623741149902 8.550809860229492 L 14.31960105895996 12.12917709350586 C 13.76555919647217 12.65177249908447 13.76555919647217 13.50232887268066 14.31960105895996 14.02589893341064 C 14.87364101409912 14.54849433898926 15.77267074584961 14.54849433898926 16.32671356201172 14.02589893341064 L 22.34805107116699 8.335739135742188 C 22.66985321044922 8.031068801879883 22.80432319641113 7.616061210632324 22.75160980224609 7.219081401824951 C 22.81175804138184 6.815980911254883 22.67795753479004 6.391677379608154 22.3501091003418 6.081862926483154 L 16.32671356201172 0.3926757872104645 C 16.0496940612793 0.1308923959732056 15.68642425537109 0 15.32315635681152 0 C 14.95989036560059 0 14.59662055969238 0.1308923959732056 14.31960105895996 0.3926757872104645 Z" fill="#0e0f0f" stroke="#0e0f0f" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_m61b =
    '<svg viewBox="20.0 462.5 14.0 14.0" ><path transform="translate(20.0, 580.0)" d="M 7.000200271606445 -103.5 C 3.140280246734619 -103.5 2.716064386731887e-07 -106.6402816772461 2.716064386731887e-07 -110.5002059936523 C 2.716064386731887e-07 -114.3601303100586 3.140280246734619 -117.5004119873047 7.000200271606445 -117.5004119873047 C 10.86011981964111 -117.5004119873047 14.00040054321289 -114.3601303100586 14.00040054321289 -110.5002059936523 C 14.00040054321289 -106.6402816772461 10.86011981964111 -103.5 7.000200271606445 -103.5 Z M 4.294812679290771 -111.0960006713867 L 4.294800281524658 -111.0959854125977 L 2.999700307846069 -109.8629989624023 C 4.006280422210693 -109.334358215332 5.41411018371582 -108.3711166381836 6.403500080108643 -106.7934265136719 C 6.430360317230225 -106.7505950927734 6.44644021987915 -106.7249450683594 6.453000068664551 -106.7183990478516 C 6.538660049438477 -106.8554611206055 6.620520114898682 -106.9893188476562 6.699680328369141 -107.118782043457 C 7.195250034332275 -107.9292449951172 7.66273021697998 -108.6937561035156 9.042300224304199 -110.2328948974609 C 10.74915981292725 -112.1836090087891 12.23331069946289 -112.693977355957 12.24810028076172 -112.6989059448242 L 12.24810028076172 -113.5008010864258 C 8.347450256347656 -111.976676940918 6.287950038909912 -108.8459396362305 6.267600059509277 -108.8144989013672 C 5.476011753082275 -110.2750930786133 4.307235240936279 -111.0874710083008 4.294812679290771 -111.0960006713867 Z" fill="#383838" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_wpcyco =
    '<svg viewBox="326.0 622.0 17.9 11.3" ><path transform="translate(325.99, 622.0)" d="M 11.25649738311768 11.02527141571045 C 10.82097053527832 10.61446380615234 10.82097053527832 9.945850372314453 11.25649738311768 9.534278869628906 L 14.23364353179932 6.721359252929688 L 1.115530610084534 6.721359252929688 C 0.499479204416275 6.721359252929688 0 6.249351978302002 0 5.667183399200439 C 0 5.085015773773193 0.499479204416275 4.612243175506592 1.115530610084534 4.612243175506592 L 14.23313426971436 4.612243175506592 L 11.25649738311768 1.799323201179504 C 10.82097053527832 1.388516068458557 10.82097053527832 0.719902515411377 11.25649738311768 0.3083303570747375 C 11.69202327728271 -0.1024767905473709 12.39874172210693 -0.1024767905473709 12.83426856994629 0.3083303570747375 L 17.56758308410645 4.781308650970459 C 17.82054901123047 5.020806789398193 17.92625427246094 5.347040176391602 17.88481521606445 5.659101963043213 C 17.93209838867188 5.975975513458252 17.82691955566406 6.309515953063965 17.56920051574707 6.55305814743042 L 12.83426856994629 11.02527141571045 C 12.61650562286377 11.23105716705322 12.3309440612793 11.33395004272461 12.04538249969482 11.33395004272461 C 11.75982189178467 11.33395004272461 11.4742603302002 11.23105716705322 11.25649738311768 11.02527141571045 Z" fill="#ffffff" stroke="#ffffff" stroke-width="0.20000000298023224" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_bs2n5 =
    '<svg viewBox="0.0 211.8 20.0 11.7" ><path transform="translate(9798.0, -1136.8)" d="M -9787.998046875 1360.3408203125 C -9788.712890625 1360.3408203125 -9789.4306640625 1360.271728515625 -9790.1318359375 1360.135498046875 L -9788.6796875 1358.683471679688 C -9788.453125 1358.69970703125 -9788.224609375 1358.708129882812 -9787.998046875 1358.708129882812 C -9786.4462890625 1358.708129882812 -9784.9423828125 1358.3359375 -9783.529296875 1357.601928710938 C -9782.1201171875 1356.869140625 -9780.8759765625 1355.815063476562 -9779.83203125 1354.468872070312 C -9780.51953125 1353.58251953125 -9781.3076171875 1352.8115234375 -9782.1748046875 1352.178344726562 L -9781.0068359375 1351.010375976562 C -9779.9287109375 1351.83203125 -9778.966796875 1352.837646484375 -9778.1474609375 1353.999145507812 C -9777.94921875 1354.27880859375 -9777.94921875 1354.65625 -9778.1474609375 1354.9384765625 C -9780.5703125 1358.371704101562 -9784.1611328125 1360.3408203125 -9787.998046875 1360.3408203125 Z M -9794.994140625 1357.926391601562 L -9794.9951171875 1357.925903320312 C -9796.0693359375 1357.106079101562 -9797.03125 1356.100952148438 -9797.8515625 1354.9384765625 C -9798.0498046875 1354.658813476562 -9798.0498046875 1354.281372070312 -9797.8515625 1353.999145507812 C -9795.4296875 1350.56591796875 -9791.837890625 1348.596801757812 -9787.998046875 1348.596801757812 C -9787.283203125 1348.596801757812 -9786.56640625 1348.665893554688 -9785.8662109375 1348.802124023438 L -9787.3193359375 1350.254150390625 C -9787.544921875 1350.237915039062 -9787.7724609375 1350.2294921875 -9787.998046875 1350.2294921875 C -9789.5517578125 1350.2294921875 -9791.056640625 1350.60205078125 -9792.4697265625 1351.336669921875 C -9793.87890625 1352.069213867188 -9795.123046875 1353.123046875 -9796.1669921875 1354.468872070312 C -9795.4814453125 1355.354248046875 -9794.693359375 1356.125122070312 -9793.826171875 1356.7587890625 L -9794.9931640625 1357.92578125 L -9794.994140625 1357.926391601562 Z" fill="#696969" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_yzm50 =
    '<svg viewBox="3.6 211.3 12.8 12.8" ><path transform="translate(1.13, 0.33)" d="M 3.739858150482178 223.7471771240234 L 2.467068195343018 222.4743804931641 L 14.00617790222168 210.9352569580078 L 15.27897834777832 212.2080535888672 L 3.739858150482178 223.7471771240234 Z" fill="#696969" stroke="none" stroke-width="1.7999999523162842" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_op9c4z =
    '<svg viewBox="26.9 192.0 18.4 12.4" ><path transform="translate(0.0, 0.0)" d="M 44.77887725830078 196.9345703125 C 41.92770385742188 193.6627502441406 39.02892303466797 192 36.083740234375 192 C 33.1385498046875 192 30.23976707458496 193.6627502441406 27.38859748840332 196.9345703125 C 26.70829582214355 197.7152099609375 26.69527244567871 198.874267578125 27.35786247253418 199.6700134277344 C 29.96133995056152 202.7960205078125 32.87760162353516 204.3828125 36.083740234375 204.3828125 C 39.28987121582031 204.3828125 42.20613861083984 202.7960205078125 44.80960845947266 199.6700134277344 C 45.47219848632812 198.874267578125 45.45917510986328 197.7152099609375 44.77887725830078 196.9345703125 Z M 43.88332366943359 198.8992309570312 C 41.49439239501953 201.7678527832031 38.90236663818359 203.1781005859375 36.083740234375 203.1781005859375 C 33.26510620117188 203.1781005859375 30.6730785369873 201.7678527832031 28.28414344787598 198.8992309570312 C 28.00030326843262 198.5581970214844 28.00591850280762 198.0615844726562 28.29739952087402 197.72705078125 C 30.94005393981934 194.6944885253906 33.53509521484375 193.205322265625 36.083740234375 193.205322265625 C 38.63236999511719 193.205322265625 41.22801971435547 194.6944885253906 43.87006378173828 197.7264404296875 C 44.16175079345703 198.0615234375 44.16717529296875 198.55810546875 43.88332366943359 198.8992309570312 Z" fill="#0e0f0f" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_i02txq =
    '<svg viewBox="0.0 211.8 20.0 6.7" ><path transform="translate(-0.01, -0.1)" d="M 19.19588661193848 218.5856018066406 C 18.94002532958984 218.5856018066406 18.68806648254395 218.4645233154297 18.52790832519531 218.2398986816406 C 16.41654777526855 215.2476806640625 13.31103229522705 213.5308532714844 10.01019954681396 213.5308532714844 C 6.709366321563721 213.5308532714844 3.603850364685059 215.2476806640625 1.492489457130432 218.2398986816406 C 1.232719898223877 218.6071166992188 0.7229461669921875 218.6969451904297 0.3557530343532562 218.4371795654297 C -0.01339325960725546 218.1774139404297 -0.1012852340936661 217.6676483154297 0.1584843844175339 217.3004302978516 C 2.580397129058838 213.8687438964844 6.170295238494873 211.8999633789062 10.01019954681396 211.8999633789062 C 13.85010242462158 211.8999633789062 17.44000053405762 213.8687438964844 19.86191368103027 217.3004302978516 C 20.12168502807617 217.6695709228516 20.03379249572754 218.1774139404297 19.66464424133301 218.4371795654297 C 19.52206611633301 218.5387420654297 19.35799789428711 218.5856018066406 19.19588661193848 218.5856018066406 Z" fill="#696969" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_tpq3e =
    '<svg viewBox="0.0 211.8 20.0 11.7" ><path transform="translate(0.0, 0.0)" d="M 10.00113105773926 223.5423431396484 C 6.161228656768799 223.5423431396484 2.571329116821289 221.5735626220703 0.1494168341159821 218.1418762207031 C -0.04980498552322388 217.8606109619141 -0.04980498552322388 217.4836578369141 0.1494168341159821 217.2004547119141 C 2.571329116821289 213.7687683105469 6.161228179931641 211.7999725341797 10.00113105773926 211.7999725341797 C 13.84103488922119 211.7999725341797 17.43093299865723 213.7687683105469 19.85284614562988 217.2004547119141 C 20.05206489562988 217.4817199707031 20.05206489562988 217.8586578369141 19.85284614562988 218.1418762207031 C 17.43093490600586 221.5735626220703 13.84103488922119 223.5423431396484 10.00113105773926 223.5423431396484 Z M 1.833036541938782 217.6711578369141 C 3.92877197265625 220.3723754882812 6.878036499023438 221.9095153808594 10.00113105773926 221.9095153808594 C 13.12422466278076 221.9095153808594 16.07348823547363 220.3723754882812 18.16922569274902 217.6711578369141 C 16.07349014282227 214.9699554443359 13.12617874145508 213.4328155517578 10.00113105773926 213.4328155517578 C 6.876083374023438 213.4328155517578 3.92877197265625 214.9699554443359 1.833036065101624 217.6711578369141 Z" fill="#696969" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_qojei =
    '<svg viewBox="6.9 214.6 6.1 6.1" ><path transform="translate(-348.8, -141.48)" d="M 358.8027648925781 362.2055358886719 C 357.119140625 362.2055358886719 355.75 360.8363952636719 355.75 359.1527709960938 C 355.75 357.4691467285156 357.119140625 356.1000061035156 358.8027648925781 356.1000061035156 C 360.4863586425781 356.1000061035156 361.8555603027344 357.4691467285156 361.8555603027344 359.1527709960938 C 361.8555603027344 360.8363952636719 360.4863586425781 362.2055358886719 358.8027648925781 362.2055358886719 Z M 358.8027648925781 357.7328186035156 C 358.0195617675781 357.7328186035156 357.3828430175781 358.3695678710938 357.3828430175781 359.1527709960938 C 357.3828430175781 359.9359741210938 358.0195617675781 360.5727233886719 358.8027648925781 360.5727233886719 C 359.5859985351562 360.5727233886719 360.2227172851562 359.9359741210938 360.2227172851562 359.1527709960938 C 360.2227172851562 358.3695678710938 359.5859985351562 357.7328186035156 358.8027648925781 357.7328186035156 Z" fill="#696969" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
