import 'package:flutter/material.dart';
import 'package:xxc_flutter_utils/xxc_flutter_utils.dart';
import 'package:ima2_habeesjobs/page/login/login_page/login_build.dart';

class _controlPageLogin extends RouterDataNotifier {
  GlobalKey _formKey = new GlobalKey<FormState>();
  TextEditingController _unPhone = new TextEditingController(text: '');
  TextEditingController _unPassword = new TextEditingController(text: '');
  TextEditingController _unInvitationCode = new TextEditingController();

  bool passwordVisible = true;

  bool _repeatLogin = false;

  @override
  Future<void> init(BuildContext context) async {
    passwordVisible = true;
    // _onAgreenment(context);
    value = true;
  }


}

class PageLogin extends RouterDataWidget<_controlPageLogin> {

  @override
  _PageLoginState createState() => _PageLoginState();

  @override
  _controlPageLogin initData(BuildContext context) {
    return _controlPageLogin();
  }
}

class _PageLoginState extends RouterDataWidgetState<PageLogin> {

  @override
  Widget buildContent(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoginBuild(),
    );
  }
}
