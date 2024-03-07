import 'package:flutter_svg/svg.dart';
import 'package:ima2_habeesjobs/util/language.dart';
import 'package:ima2_habeesjobs/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:xxc_flutter_utils/xxc_flutter_utils.dart';

import '../../app.dart';

class PageUserPrivacyPolicy extends RouterDataWidget {
  PageUserPrivacyPolicy({Key key}) : super(key: key);

  @override
  _PageUserPrivacyPolicyState createState() => _PageUserPrivacyPolicyState();

  @override
  initData(BuildContext context) {}
}

class _PageUserPrivacyPolicyState extends State<PageUserPrivacyPolicy> {
  String _html;

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
            '隐私政策',
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
            onInitLoading: _onInitLoading,
            initBuilder: (context) {
              return Container();
            },
            builder: (context) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: HtmlWidget(_html ?? ''),
              );
            }),
      ),
    );
  }

  Future<bool> _onInitLoading(BuildContext context) async {
    // _html = await DefaultAssetBundle.of(context).loadString("assets/html/en/privacyPolicy.html");
    _html = await DefaultAssetBundle.of(context).loadString("assets/html/${App.of(context).locale.languageCode}/privacyPolicy.html");
    // _html = await rootBundle.loadString("assets/html/${App.of(context).locale.languageCode}/privacyPolicy.html");
    return true;
  }
}

const String _svg_i3q6wh =
    '<svg viewBox="1.5 6.4 22.8 14.4" ><path transform="matrix(-1.0, 0.0, 0.0, -1.0, 24.26, 20.86)" d="M 14.31960105895996 0.3926757872104645 C 13.76555919647217 0.9152726531028748 13.76555919647217 1.765827536582947 14.31960105895996 2.289395809173584 L 18.10688209533691 5.867764472961426 L 1.419087290763855 5.867764472961426 C 0.6353968381881714 5.867764472961426 0 6.468213558197021 0 7.208800792694092 C 0 7.949387073516846 0.6353968381881714 8.550809860229492 1.419087290763855 8.550809860229492 L 18.10623741149902 8.550809860229492 L 14.31960105895996 12.12917709350586 C 13.76555919647217 12.65177249908447 13.76555919647217 13.50232887268066 14.31960105895996 14.02589893341064 C 14.87364101409912 14.54849433898926 15.77267074584961 14.54849433898926 16.32671356201172 14.02589893341064 L 22.34805107116699 8.335739135742188 C 22.66985321044922 8.031068801879883 22.80432319641113 7.616061210632324 22.75160980224609 7.219081401824951 C 22.81175804138184 6.815980911254883 22.67795753479004 6.391677379608154 22.3501091003418 6.081862926483154 L 16.32671356201172 0.3926757872104645 C 16.0496940612793 0.1308923959732056 15.68642425537109 0 15.32315635681152 0 C 14.95989036560059 0 14.59662055969238 0.1308923959732056 14.31960105895996 0.3926757872104645 Z" fill="#0e0f0f" stroke="#0e0f0f" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
