// @dart = 2.12

import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:hbuf_dart/hbuf_dart.dart';

class ERequest {
  final int code;
  final String msg;

  ERequest({
    required this.code,
    required this.msg,
  });

  @override
  String toString() {
    return msg;
  }
}

class Api {
  static Api? _api;

  // late UserAppApi user;

  late CookieJar _cookie;

  late Http _http;

  String? _lang;

  static String baseUrl = "";

  static String? deviceId;

  Api._() {
    _cookie = CookieJar();
    _http = Http();
    var clientJson = HttpClientJson(
      baseUrl: "$baseUrl/api",
    );
    clientJson.insertRequestInterceptor((request, data, next) async {
      if (null != _lang) {
        request.headers.add("lang", _lang!);
      }
      if (null != deviceId) {
        // request.headers.add(HeadTag.DEVICES.name, deviceId!);
      }
      // request.headers.add(HeadTag.PLATFORM.name, OsToPlatform()?.name ?? "");
      request.cookies.addAll(await _cookie.loadForRequest(request.uri));
      next?.invoke!(request, data, next.next);
    });
    clientJson.insertResponseInterceptor((request, response, data, next) async {
      await _cookie.saveFromResponse(request.uri, response.cookies);
      return await next?.invoke!(request, response, data, next.next) ?? data;
    });

    // user = UserAppApiClient(clientJson);
  }

  set lang(String lang) {
    _lang = lang;
  }

  Future<String> updateImageData(List<int> data, {required String name}) async {
    var request = await _http.post(Uri.parse("$baseUrl/file/upload/image?name=${Uri.encodeComponent(name)}"));
    request.cookies.addAll(await _cookie.loadForRequest(request.uri));
    request.add(data);
    var response = await request.close();
    await _cookie.saveFromResponse(request.uri, response.cookies);
    if (StatusCode.ok != response.statusCode) {
      throw HttpException(response.statusCode, uri: request.uri);
    }

    data = [];
    for (var item in await response.toList()) {
      data.addAll(item);
    }
    var result = Result.fromMap(json.decode(utf8.decode(data)));
    if (0 != result?.code) {
      throw result!;
    }
    return result!.data!;
  }

  Future<String> updateFileData(List<int> data, {required String name}) async {
    var request = await _http.post(Uri.parse("$baseUrl/file/upload/file?name=${Uri.encodeComponent(name)}"));
    request.cookies.addAll(await _cookie.loadForRequest(request.uri));
    request.add(data);
    var response = await request.close();
    await _cookie.saveFromResponse(request.uri, response.cookies);
    if (StatusCode.ok != response.statusCode) {
      throw HttpException(response.statusCode, uri: request.uri);
    }

    data = [];
    for (var item in await response.toList()) {
      data.addAll(item);
    }
    var result = Result.fromMap(json.decode(utf8.decode(data)));
    if (0 != result?.code) {
      throw result!;
    }
    return result!.data!;
  }

  factory Api() {
    return _api ??= Api._();
  }
}
