import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:xxc_flutter_utils/xxc_flutter_utils.dart';

class DioUtils {
  static final DioUtils _singleton = DioUtils._internal();

  static DioUtils get instance => DioUtils();

  factory DioUtils() {
    return _singleton;
  }

  static Dio _dio;

  Dio getDio() {
    return _dio;
  }

  DioUtils._internal() {
    var options = BaseOptions(
      connectTimeout: 15000,
      receiveTimeout: 15000,
      responseType: ResponseType.plain,
      validateStatus: (status) {
        // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
        return true;
      },
      // baseUrl: 'https://api.pub.flutter-io.cn/'
      //   baseUrl: 'http://192.168.6.117:12345/',//本地
      // baseUrl:'http://47.97.250.198:12345/',//阿里
        baseUrl:'http://127.0.0.1:12345/',//网页
//      contentType: ContentType('application', 'x-www-form-urlencoded', charset: 'utf-8'),
    );
    _dio = Dio(options);

    /// 统一添加身份验证请求头

    /// 刷新Token
//    _dio.interceptors.add(TokenInterceptor());

    /// 打印Log(生产模式去除)
    /// 适配数据(根据自己的数据结构，可自行选择添加)
//    _dio.interceptors.add(AdapterInterceptor());
  }

  var baseUirl = '';
  ///直接返回数据
  Future<Response> getRequest(Method method, String url,
      {dynamic data,
        Map<String, dynamic> queryParameters,
        CancelToken cancelToken,
        Options options}) async {
    print('request------------------------------url:$url');
    if(queryParameters ==null){
      print('request------------------------------queryParameters:$queryParameters');
    }
    String _method = _getRequestMethod(method);
    var response = await _dio.request(url,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions(_method, options),
        cancelToken: cancelToken);
    try {
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Options _checkOptions(method, options) {
    if (options == null) {
      options = Options();
    }
    options.method = method;
    return options;
  }



  String _getRequestMethod(Method method) {
    String m;
    switch (method) {
      case Method.get:
        m = 'GET';
        break;
      case Method.post:
        m = 'POST';
        break;
      case Method.put:
        m = 'PUT';
        break;
      case Method.patch:
        m = 'PATCH';
        break;
      case Method.delete:
        m = 'DELETE';
        break;
      case Method.head:
        m = 'HEAD';
        break;
    }
    return m;
  }
}

Map<String, dynamic> parseData(String data) {
  return json.decode(data);
}

enum Method { get, post, put, patch, delete, head }

