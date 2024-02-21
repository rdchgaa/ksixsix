import 'dart:convert';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:ima2_habeesjobs/util/other.dart';
import 'package:shared_preferences/shared_preferences.dart';

const deviceIdKey = "device_id";
const userIdKey = "user_id";
const tokenKey = "token";
const channelKey = "channel";
const maxSYNKey = "max_syn";
const localeKey = "locale";
const beforeVersionKey = "before_version";
const policyKey = "policy";

const applyKey = "apply";

const collectJobKey = "collect_job";
const collectCompanyKey = "collect_company";

const worksKey = "works";

const genderKey = "gender";

const birthDayKey = "birthDay";

const userInfoKey = "userInfo";

const filesPathKey = "files_path";

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

Int64 _userId;

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

void setPolicy(bool flg) {
  if (null == flg) {
    _sharedPreferences.remove(policyKey);
  } else {
    _sharedPreferences.setBool(policyKey, flg);
  }
}

bool getPolicy() {
  return _sharedPreferences.getBool(policyKey);
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


void setCollectJob(int id) {
  List<String> list = _sharedPreferences.getStringList(collectJobKey)??[];
  if(list.contains(id.toString())){

  }else{
    list.add(id.toString());
  }
  _sharedPreferences.setStringList(collectJobKey, list);
}

List<int> getCollectJob() {
  List<String> list = _sharedPreferences.getStringList(collectJobKey)??[];

  List<int> intList = [];
  for(var i = 0 ;i<list.length;i++){
    intList.add(int.tryParse(list[i])??0);
  }
  return intList;
}

void removeCollectJob(int id) {
  List<String> list = _sharedPreferences.getStringList(collectJobKey)??[];
  if(list.contains(id.toString())){
    list.remove(id.toString());
  }else{
  }
  _sharedPreferences.setStringList(collectJobKey, list);
}


void setCollectCompany(int id) {
  List<String> list = _sharedPreferences.getStringList(collectCompanyKey)??[];
  if(list.contains(id.toString())){

  }else{
    list.add(id.toString());
  }
  _sharedPreferences.setStringList(collectCompanyKey, list);
}

List<int> getCollectCompany() {
  List<String> list = _sharedPreferences.getStringList(collectCompanyKey)??[];

  List<int> intList = [];
  for(var i = 0 ;i<list.length;i++){
    intList.add(int.tryParse(list[i])??0);
  }
  return intList;
}

void removeCollectCompany(int id) {
  List<String> list = _sharedPreferences.getStringList(collectCompanyKey)??[];
  if(list.contains(id.toString())){
    list.remove(id.toString());
  }else{
  }
  _sharedPreferences.setStringList(collectCompanyKey, list);
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
