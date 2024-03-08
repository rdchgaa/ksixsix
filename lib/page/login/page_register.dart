import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xxc_flutter_utils/xxc_flutter_utils.dart';
import 'package:ima2_habeesjobs/page/login/login_page/xd_register_build.dart';
import 'package:ima2_habeesjobs/util/language.dart';
import 'package:ima2_habeesjobs/widget/my_button.dart';

class _ControlPageRegister extends RouterDataNotifier {
  GlobalKey _formKey = new GlobalKey<FormState>();
  TextEditingController _unPhone = new TextEditingController();
  TextEditingController _unPassword = new TextEditingController();
  TextEditingController _unConfirmPassword = new TextEditingController();
  TextEditingController _unInvitationCode = new TextEditingController();
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
    value = true;
    // _timer = Timer.periodic(const Duration(seconds: 1), _onTimer);
  }

  void _onTimer(Timer timer) {
    var val = DateTime.now().compareTo(_endTime);
    if (1 == val) {
      _timer?.cancel();
      _timer = null;
    }
    notifyListeners();
  }

  Future<void> _onGetCode(BuildContext context) async {
    if (_isLock) {
      return;
    }
    if (_unPhone.text.length != 10) {
      showToast(context, 'Please enter the correct phone number');
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
    showToast(context, 'Verification code error');
    return;

  }
}

class PageRegister extends RouterDataWidget<_ControlPageRegister> {
  @override
  _PageRegisterState createState() => _PageRegisterState();

  @override
  _ControlPageRegister initData(BuildContext context) {
    return _ControlPageRegister();
  }
}

class _PageRegisterState extends RouterDataWidgetState<PageRegister> {

  @override
  Widget buildContent(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: XdRegisterBuild(),
    );
  }
}

//倒计时组件
class UiCountDown extends StatefulWidget {
  final Duration duration;

  final void Function() onEnd;

  const UiCountDown({Key key, this.duration, this.onEnd}) : super(key: key);

  @override
  State<UiCountDown> createState() => _UiCountDownState();
}

class _UiCountDownState extends State<UiCountDown> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener(_onStatusListener);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 30,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          border: Border.all(width: 1, color: Color(0xff999999)),
        ),
        child: Stack(
          children: [
            // Positioned(
            //   top: 2,
            //   right: 2,
            //   left: 2,
            //   bottom: 2,
            //   child: CircularProgressIndicator(
            //     color: Color(0xff703EFE),
            //     value: _controller.value,
            //   ),
            // ),
            Center(
              child: Text(
                "${(widget.duration.inSeconds * (1 - _controller.value)).toInt()}s",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff000000),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onStatusListener(AnimationStatus status) {
    if (_controller.isCompleted) {
      widget.onEnd();
    }
  }
}
