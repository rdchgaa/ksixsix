import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:ima2_habeesjobs/util/app_cache_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';
import 'package:provider/src/provider.dart';

class SerBase extends ChangeNotifier {
  final BuildContext Function() _context;

  Duration _duration = Duration.zero;

  BuildContext get context => _context();

  bool _resumed = true;

  SerBase(this._context, {String serverUrl}) {
  }

  Future init() async {
    // await _socket.connect();
    notifyListeners();
  }

  Future refresh() async {
    await _syncTime();
    notifyListeners();
  }

  Duration get duration => _duration;

  set duration(Duration value) {
    _duration = value;
  }

  void close() {
  }

  @override
  void dispose() {
    close();
    super.dispose();
  }

  _syncTime() async {
    // var start = DateTime.now();
    // var ret =
    //     await LoadingCall.of(context).call((state, controller) => Network.of<pb.LogicExtClient>(context).syncTime(pb.SyncTimeReq()), isShowLoading: false);
    // var sTime = DateTime.fromMicrosecondsSinceEpoch(ret.time.toInt());
    // var now = DateTime.now();
    // _duration = sTime.difference(start) < sTime.difference(now) ? sTime.difference(start) : sTime.difference(now);
  }

  //获得服务器的当前时间
  DateTime get now => DateTime.now().subtract(_duration);

  //将服务器时间转为本地时间
  DateTime toLocalTime(DateTime time) {
    if (null == time) {
      return time;
    }
    return time.add(_duration);
  }

  //将本地时间转为服务器时间
  DateTime toServerTime(DateTime time) {
    if (null == time) {
      return time;
    }
    return time.subtract(_duration);
  }

  bool get resumed => _resumed;

  set resumed(bool value) {
    _resumed = value;
    if (_resumed) {
    }
  }
}


