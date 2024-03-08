import 'package:flutter_svg/flutter_svg.dart';
import 'package:ima2_habeesjobs/app.dart';
import 'package:ima2_habeesjobs/util/language.dart';
import 'package:ima2_habeesjobs/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:xxc_flutter_utils/xxc_flutter_utils.dart';

class PageUserAgreement extends RouterDataWidget {
  PageUserAgreement({Key key}) : super(key: key);

  @override
  _PageUserAgreementState createState() => _PageUserAgreementState();

  @override
  initData(BuildContext context) {}
}

class _PageUserAgreementState extends State<PageUserAgreement> {
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
            '用户协议',
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
          },
        ),
      ),
    );
  }

  Future<bool> _onInitLoading(BuildContext context) async {
    _html = await DefaultAssetBundle.of(context).loadString("assets/html/${App.of(context).locale.languageCode}/userAgreement.html");
    return true;
  }
}
