import 'package:ima2_habeesjobs/app.dart';
import 'package:ima2_habeesjobs/util/language.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';

Future<bool> showPolicyDialog(BuildContext context) {
  return AutoRouter.of(context).pushNamed("/dialog_policy");
}

class _ControlPolicyDialog extends RouterDataNotifier {
  String _html;

  init(BuildContext context) async {
    _html = await DefaultAssetBundle.of(context).loadString("assets/html/${App.of(context).locale.languageCode}/privacyPolicy.html");
    value = true;
  }

}

class PolicyDialog extends RouterDataWidget<_ControlPolicyDialog> implements PageSize {
  PolicyDialog();

  @override
  State<PolicyDialog> createState() => _DialogAlertBoxState();

  @override
  _ControlPolicyDialog initData(BuildContext context) {
    return _ControlPolicyDialog();
  }

  @override
  SizePage get size => SizePage(640, 567);
}

class _DialogAlertBoxState extends RouterDataWidgetState<PolicyDialog> {
  @override
  Widget buildContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, con) {
        var width = (con.smallest.width - 1) / 2 ;
        return Material(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top:17.0,bottom: 21),
                child: Text(Languages.of(context).privacyAndSecurityText,style: TextStyle(fontSize: 20,color: Color(0xff575757)),),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 21),
                  child: SingleChildScrollView(
                    padding:EdgeInsets.only(left: 21,right: 21) ,
                    child: HtmlWidget(this.widget.data._html ?? '',textStyle: TextStyle(fontSize: 14,color: Color(0xff575757)),),
                  ),
                ),
              ),
              SizedBox(
                width: con.smallest.width,
                child: Divider(height: 1),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                    SizedBox(
                      width: width,
                      height: 53,
                      child: TextButton(
                        onPressed: () {
                          AutoRouter.of(context).pop(false);
                        },
                        child: Text(
                          Languages.of(context).cancelButtonLabel,
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          foregroundColor: MaterialStateProperty.all(Color(0xff8B8B8B)),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                        ),
                      ),
                    ),

                    SizedBox(
                      child: VerticalDivider(
                        width: 1,
                      ),
                      height: 53,
                    ),

                    SizedBox(
                      width: width,
                      height: 53,
                      child: TextButton(
                        onPressed: () {
                          AutoRouter.of(context).pop(true);
                        },
                        child: Text(
                          Languages.of(context).okButtonLabel,
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          foregroundColor: MaterialStateProperty.all(Color(0xff414141)),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
