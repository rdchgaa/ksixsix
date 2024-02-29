import 'package:ima2_habeesjobs/dao/dao_user.dart';

import 'package:ima2_habeesjobs/net/api.dart';
import 'package:ima2_habeesjobs/net/network.dart';
import 'package:ima2_habeesjobs/page/page_init.dart';

import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:ima2_habeesjobs/util/app_cache_manager.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';
import 'package:ima2_habeesjobs/util/navigator.dart';
import 'package:ima2_habeesjobs/util/other.dart';

///用户状态服务
class SerUser extends ChangeNotifier {
  final BuildContext context;

  //用户信息
  // {
  //         "user_id": 1,
  //         "account": "test",
  //         "nick_name": "test",
  //         "avatar": "",
  //         "created_at": 1707355621
  //     },
  var _userInfo = null;

  get userInfo => _userInfo??{
    "user_id": null,
    "account": null,
    "nick_name": null,
    "avatar": null,
    "created_at": null
  };

  bool _isRoomMaster = false;

  bool get isRoomMaster => _isRoomMaster;

  set isRoomMaster(bool value) {
    _isRoomMaster = value;
    notifyListeners();
  }

  bool _canChange = false;

  bool get canChange => _canChange;

  set canChange(bool value) {
    _canChange = value;
    notifyListeners();
  }

  int _gameId = null;

  int get gameId => _gameId;

  set gameId(int value) {
    _gameId = value;
    notifyListeners();
  }


  UserInfo _info = UserInfo();

  SerUser(this.context);

  String get nickname {
    return _info.name;
  }

  String get uesrname => _info.userName;

  bool get isStaff => _info.isWaiter ?? false;

  set nickname(String value) {
    _info.name = value;
    notifyListeners();
    save();
  }

  String get avatarUrl {
    return _info.avatar ?? "";
  }

  set avatarUrl(String value) {
    _info.avatar = value;
    notifyListeners();
    save();
  }

  String get phoneNumber {
    return _info.mobile;
  }

  set phoneNumber(String value) {
    _info.mobile = value;
    notifyListeners();
    save();
  }

  Gender get gender {
    var gen = getGender();
    _info.gender = gen;
    return _info.gender;
  }

  set gender(Gender value) {
    _info.gender = value;
    notifyListeners();
    // save();
    setGender(value);
  }

  int get userId {
    return _info.userId?.toInt();
  }

  int get user {
    return _info.user?.toInt();
  }

  set userId(int value) {
    _info.userId = value;
    notifyListeners();
    save();
  }

  set signature(String value) {
    _info.signature = value;
    notifyListeners();
    save();
  }

  String get signature {
    return _info.signature;
  }

  set birthday(DateTime value) {
    _info.birthday = value;
    notifyListeners();
    // save();
    setBirthDay(value);
  }

  DateTime get birthday {
    var day = getBirthDay();
    _info.birthday = day;
    return _info.birthday;
  }

  UserInfo get info => _info;

  set info(UserInfo value) {
    _info = value;
    notifyListeners();
  }

  void save() async {
    await DaoUser.set(
      _info,
    );
    // var val = await DaoUser.get();
    // _info = val.info;
  }

  Future<void> init() async {
    // var val = await DaoUser.get();
    // if (null != val) {
    //   _info = val.info ?? null;
    // }else{
    //   await _update();
    // }
    // // await _update();
    // Duration stalePeriod = Duration(days: 3) ;
    // await AppCacheManager().reSetConfig(userId: getUserId().toInt(), stalePeriod: stalePeriod);

    // _info = getUserInfo()??UserInfo();

    if(getUserId()==0||getUserId()==null){
      return;
    }
    var res = await NetWork.getUserInfo(context,getUserId());
    _userInfo = res;
    setInfo(res);
  }

  setInfo(var user) {
    _info.userId = user['user_id'];

    _info.userName = user['account'];
    _info.name = user['nick_name'];
    _info.avatar = user['avatar'];

    userId = user['user_id'];
    nickname = user['nick_name'];
    avatarUrl = user['avatar'];

    if(user['is_vip'] == 1){
      canChange = true;
    }

    notifyListeners();
    // _info = getUserInfo()??UserInfo();
  }

  Future<void> _update() async {
    // var res = await NetWork.getUserInfo(context,getUserId());
    // _userInfo = res;
    //
    // save();
    // notifyListeners();
  }

  void updateByUserInfo(info) {
    _info.signature = info.signature;
    _info.mobile = info.phonoNumber;
    _info.userId = info.userId;
    _info.name = info.nickname;
    // _info.gender = Gender.valueOf(info.sex ?? 0);
    _info.avatar = info.avatarUrl;

    notifyListeners();
  }
  Future<void> unLogin() async {
    // var res = await NetWork.toLogin(context);
    var res = '';
    if (res!=null) {
      await unLoginData();
    } else {
      showToast(context, '退出登录失败，请稍后再试');
    }
  }

  unLoginData(){
    setToken(null);
    setUserId(null);
    setUserInfo(null);
    setPassword(null);

    canChange = false;
    var user = {
      "user_id": null,
      "account": null,
      "nick_name": null,
      "avatar": null,
      "created_at": null
    };
    setInfo(user);
  }
}

class UserInfo {
  String name;
  String signature;
  String mobile;
  int userId;
  Gender gender;
  String avatar;
  String userName;
  bool isWaiter;
  int user;
  DateTime birthday;

  UserInfo({
    this.name = 'name',
    this.signature = '',
    this.mobile = '',
    this.userId = 0,
    this.gender = Gender.MALE,
    this.avatar = '',
    this.userName = '',
    this.isWaiter,
    this.user,
    this.birthday,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'signature': signature,
      'mobile': mobile,
      'userId': userId,
      'gender': gender?.index,
      'avatar': avatar,
      'userName': userName,
      'isWaiter': isWaiter,
      'user': user,
      'birthday': birthday?.toString(),
    };
  }

  static UserInfo fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return UserInfo(
      name: map['name']?.toString(),
      signature: map['signature']?.toString(),
      mobile: map['mobile']?.toString(),
      userId: null == (temp = map['userId']) ? null : (temp is num ? temp.toInt() : int.tryParse(temp)),
      gender: null == (temp = map['gender']) ? null : (temp is num ? Gender.values[temp.toInt()] : Gender.values[int.tryParse(temp)]),
      avatar: map['avatar']?.toString(),
      userName: map['userName']?.toString(),
      isWaiter: null == (temp = map['isWaiter']) ? null : (temp is bool ? temp : (temp is num ? 0 != temp.toInt() : ('true' == temp.toString()))),
      user: null == (temp = map['user']) ? null : (temp is num ? temp.toInt() : int.tryParse(temp)),
      birthday: null == (temp = map['birthday']) ? null : (temp is DateTime ? temp : DateTime.tryParse(temp)),
    );
  }
}

class Company {
  int id;
  String name;
  String avatar;
  String address;
  String profile;

  Company({this.id, this.name, this.avatar, this.address, this.profile});
}

class Job {
  int id;
  String avatar;
  int companyId;
  String name;
  String years;
  String time;
  String address;
  List<String> tips;
  String describe;
  String ageReq;
  String salary;
  String vacation;
  bool sign;

  Job(
      {this.id,
      this.avatar,
      this.companyId = 1,
      this.name,
      this.years,
      this.time,
      this.address,
      this.tips,
      this.describe,
      this.ageReq,
      this.salary,
      this.vacation,
      this.sign = false});
}
