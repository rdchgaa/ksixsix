import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xxc_flutter_utils/xxc_flutter_utils.dart';
import 'package:ima2_habeesjobs/page/my/page_user_agreement.dart';
import 'package:ima2_habeesjobs/page/my/page_user_privacy_policy.dart';
import 'package:ima2_habeesjobs/util/language.dart';
import 'package:ima2_habeesjobs/util/navigator.dart';
import 'package:ima2_habeesjobs/widget/app_bar.dart';
import 'package:ima2_habeesjobs/widget/ui_layout.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PageUserAboutUs extends RouterDataWidget {
  PageUserAboutUs({Key key}) : super(key: key);

  @override
  _PageUserAboutUsState createState() => _PageUserAboutUsState();

  @override
  initData(BuildContext context) {}
}

class _PageUserAboutUsState extends State<PageUserAboutUs> {
  PackageInfo _info;

  @override
  Widget build(BuildContext context) {
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
            '关于我们',
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
        body: LoadingCall(
          onInitLoading: _onLoading,
          initBuilder: (context) {
            return Container();
          },
          builder: (context) {
            return Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 48.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/app_icon.png'),
                            fit: BoxFit.fill,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x33b3b3b3),
                              offset: Offset(0, 0),
                              blurRadius: 24,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Text('版本'+' ${_info.version}'),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10,left: 10,right: 10),
                        margin: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0x66000000),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontFamily: 'Source Han Sans CN',
                              fontSize: 14,
                              color: const Color(0xffdddddd),
                              height: 1.5714285714285714,
                            ),
                            children: [
                              TextSpan(
                                text:
                                '我们致力于为用户提供安全可靠的娱乐应用。\n本产品为炫牛，进入游戏前需出示门票，游戏内不含任何交易行为，仅供娱乐。是我们相信，通过我们的专业团队和创新技术，K1.GAME将帮助您获得极佳的游玩体验。\n如果您对我们的团队有任何问题或建议，请访问',
                              ),
                              TextSpan(
                                text: 'https://x.six.game',
                                style: TextStyle(
                                  color: const Color(0xff21a27c),
                                ),
                              ),
                            ],
                          ),
                          textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
                        ),
                      ),


                      // Spacer(),
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10,left: 10,right: 10),
                        margin: EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                await PageUserAgreement().push(context);
                              },
                              child: Text(
                                '用户协议',
                                style: textStyleH4.copyWith(
                                  fontSize: 14,
                                  color: Color(0xffdddddd),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:20),
                              child: InkWell(
                                onTap: () async {
                                  await PageUserPrivacyPolicy().push(context);
                                },
                                child: Text(
                                  '隐私政策',
                                  style: textStyleH4.copyWith(
                                    fontSize: 14,
                                    color: Color(0xffdddddd),
                                    decoration: TextDecoration.underline,
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
              ],
            );
          },
        ),
      ),
    );
  }


  Future<bool> _onLoading(BuildContext context) async {
    _info = await PackageInfo.fromPlatform();
    return true;
  }
}

const String _svg_i3q6wh =
    '<svg viewBox="1.5 6.4 22.8 14.4" ><path transform="matrix(-1.0, 0.0, 0.0, -1.0, 24.26, 20.86)" d="M 14.31960105895996 0.3926757872104645 C 13.76555919647217 0.9152726531028748 13.76555919647217 1.765827536582947 14.31960105895996 2.289395809173584 L 18.10688209533691 5.867764472961426 L 1.419087290763855 5.867764472961426 C 0.6353968381881714 5.867764472961426 0 6.468213558197021 0 7.208800792694092 C 0 7.949387073516846 0.6353968381881714 8.550809860229492 1.419087290763855 8.550809860229492 L 18.10623741149902 8.550809860229492 L 14.31960105895996 12.12917709350586 C 13.76555919647217 12.65177249908447 13.76555919647217 13.50232887268066 14.31960105895996 14.02589893341064 C 14.87364101409912 14.54849433898926 15.77267074584961 14.54849433898926 16.32671356201172 14.02589893341064 L 22.34805107116699 8.335739135742188 C 22.66985321044922 8.031068801879883 22.80432319641113 7.616061210632324 22.75160980224609 7.219081401824951 C 22.81175804138184 6.815980911254883 22.67795753479004 6.391677379608154 22.3501091003418 6.081862926483154 L 16.32671356201172 0.3926757872104645 C 16.0496940612793 0.1308923959732056 15.68642425537109 0 15.32315635681152 0 C 14.95989036560059 0 14.59662055969238 0.1308923959732056 14.31960105895996 0.3926757872104645 Z" fill="#0e0f0f" stroke="#0e0f0f" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
