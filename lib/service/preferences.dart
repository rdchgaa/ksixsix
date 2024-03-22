import 'dart:convert';
import 'dart:io';

import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:ima2_habeesjobs/util/other.dart';
import 'package:shared_preferences/shared_preferences.dart';

const deviceIdKey = "device_id";
const userIdKey = "user_id";
const tokenKey = "token";
const channelKey = "channel";
const localeKey = "locale";
const beforeVersionKey = "before_version";

const applyKey = "apply";

const worksKey = "works";

const genderKey = "gender";

const birthDayKey = "birthDay";

const userInfoKey = "userInfo";

const filesPathKey = "files_path";

const userName = "user_name";

const password = "password";

const cuopaiTypeKey = "cuopaiType";


SharedPreferences _sharedPreferences;

Future<void> initSharedPreferences() async {
  _sharedPreferences = await SharedPreferences.getInstance();
}

int getChannel() {
  var val = _sharedPreferences.getInt(channelKey);
  if (null == val) {
    return null;
  }
  return val;
}

void setChannel(int id) {
  if (null == id) {
    _sharedPreferences.remove(channelKey);
  } else {
    _sharedPreferences.setInt(channelKey, id);
  }
}

String getDeviceId() {
  var val = _sharedPreferences.getString(deviceIdKey);
  if (null == val) {
    return null;
  }
  return val;
}

void setDeviceId(String id) {
  if (null == id) {
    _sharedPreferences.remove(deviceIdKey);
  } else {
    _sharedPreferences.setString(deviceIdKey, id);
  }
}

void setUserId(int id) {
  // if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
  //   _userId = null == id ? null : Int64(id);
  // } else {
  if (null == id) {
    _sharedPreferences.remove(userIdKey);
  } else {
    _sharedPreferences.setInt(userIdKey, id);
    // }
  }
}

int getUserId() {
  // if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
  //   return _userId;
  // } else {
  var val = _sharedPreferences.getInt(userIdKey);
  if (null == val) {
    return null;
  }
  return val;
  // }
}

String _token;

void setToken(String token) {
  // if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
  //   _token = token;
  // } else {
  if (null == token) {
    _sharedPreferences.remove(tokenKey);
  } else {
    _sharedPreferences.setString(tokenKey, token);
  }
  // }
}

int getGroupId() {
  return 0;
}

String getToken() {
  // if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
  //   return _token;
  // } else {
  return _sharedPreferences.getString(tokenKey);
  // }
}

void setBeforeVersion(int version) {
  if (null == version) {
    _sharedPreferences.remove(beforeVersionKey);
  } else {
    _sharedPreferences.setInt(beforeVersionKey, version);
  }
}

int getBeforeVersion() {
  return _sharedPreferences.getInt(beforeVersionKey);
}

void setLocale(String locale) {
  if (null == locale) {
    _sharedPreferences.remove(localeKey);
  } else {
    _sharedPreferences.setString(localeKey, locale);
  }
}

String getLocale() {
  return _sharedPreferences.getString(localeKey);
}



void setApply(int id) {
  // _sharedPreferences.setInt(userIdKey, id);
  List<String> applyList = _sharedPreferences.getStringList(applyKey)??[];
  if(applyList.contains(id.toString())){

  }else{
    applyList.add(id.toString());
  }
  _sharedPreferences.setStringList(applyKey, applyList);
}

List<int> getApply() {
  List<String> applyList = _sharedPreferences.getStringList(applyKey)??[];

  List<int> intList = [];
  for(var i = 0 ;i<applyList.length;i++){
    intList.add(int.tryParse(applyList[i])??0);
  }
  return intList;
}

void removeApply(int id) {
  List<String> applyList = _sharedPreferences.getStringList(applyKey)??[];
  if(applyList.contains(id.toString())){
    applyList.remove(id.toString());
  }else{
  }
  _sharedPreferences.setStringList(applyKey, applyList);
}


void setGender(Gender gender) {


  _sharedPreferences.setInt(genderKey, gender.index);
}

Gender getGender() {
  int gen = _sharedPreferences.getInt(genderKey);
  var gender = null;
  if(gen==0){
    gender = Gender.MALE;
  }else if(gen==1){
    gender = Gender.FEMALE;
  }else if(gen==2){
    gender = Gender.UNKNOWN;
  }
  return gender;
}

void setBirthDay(DateTime day) {
  _sharedPreferences.setInt(birthDayKey, day.millisecondsSinceEpoch);
}

DateTime getBirthDay() {
  int day = _sharedPreferences.getInt(birthDayKey);
  DateTime birthDay = null;
  if(day!=null){
    birthDay = DateTime.fromMillisecondsSinceEpoch(day);
  }
  return birthDay;
}



void setUserInfo(UserInfo user) {
  String str = json.encode(user.toMap());
  _sharedPreferences.setString(userInfoKey, str);
}

UserInfo getUserInfo() {
  String str = _sharedPreferences.getString(userInfoKey);
  if(str==null){
    return null;
  }
  var user = UserInfo.fromMap(json.decode(str));
  return user;
}



void setFilesPath(String path) {
  List<String> list = _sharedPreferences.getStringList(filesPathKey)??[];
  if(list.contains(path)){
  }else{
    list.add(path);
  }
  _sharedPreferences.setStringList(filesPathKey, list);
}

List<String> getFilesPath() {
  List<String> list = _sharedPreferences.getStringList(filesPathKey)??[];

  List<String> strList = [];
  for(var i = 0 ;i<list.length;i++){
    strList.add(list[i]);
  }
  return strList;
}

void removeFilesPath(String path) {
  List<String> list = _sharedPreferences.getStringList(filesPathKey)??[];
  if(list.contains(path)){
    list.remove(path);
  }else{
  }
  _sharedPreferences.setStringList(filesPathKey, list);
}



void setUserName(String value) {
  if (null == value) {
    _sharedPreferences.remove(userName);
  } else {
    _sharedPreferences.setString(userName, value);
  }
}

String getUserName() {
  return _sharedPreferences.getString(userName);
}

void setPassword(String value) {
  if (null == value) {
    _sharedPreferences.remove(password);
  } else {
    _sharedPreferences.setString(password, value);
  }
}

String getPassword() {
  return _sharedPreferences.getString(password);
}


int getCuopaiType() {
  var val = _sharedPreferences.getInt(cuopaiTypeKey);
  if (null == val) {
    return 3;
  }
  return val;
}

void setCuopaiType(int id) {
  if (null == id) {
    _sharedPreferences.remove(cuopaiTypeKey);
  } else {
    _sharedPreferences.setInt(cuopaiTypeKey, id);
  }
}