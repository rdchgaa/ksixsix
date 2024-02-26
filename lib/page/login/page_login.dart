import 'dart:io';

import 'package:ima2_habeesjobs/app.dart';
import 'package:ima2_habeesjobs/dialog/policy_dialog.dart';
import 'package:ima2_habeesjobs/page/login/login_page/login_build.dart';
import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:ima2_habeesjobs/util/language.dart';
import 'package:ima2_habeesjobs/widget/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';

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
