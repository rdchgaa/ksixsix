import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';

class UploadProgress {
  final int count;

  final int total;

  UploadProgress({
    this.count = 0,
    this.total = 1,
  });

  double get progress {
    return (count ?? 0) / (total ?? 1);
  }

  @override
  String toString() {
    return 'UploadProgress{count: $count, total: $total}';
  }
}

class UploadTask<T> extends ValueNotifier<UploadProgress> {
  CancelToken _cancelToken = CancelToken();

  String _key;

  List<Completer<T>> _list = [];

  UploadTask() : super(UploadProgress());

  void cancel() {}

  void onSendProgress(int count, int total) {
    value = UploadProgress(count: count, total: total);
    notifyListeners();
  }

  Future<T> get result {
    Completer<T> completer = Completer<T>.sync();
    _list.add(completer);
    return completer.future;
  }

  String get key => _key;
}

class NetFile extends NetwordInterface {
  final Dio _dio = Dio();
  final CookieJar _cookie = CookieJar();
  final String scheme;
  final String host;
  final Map<String, UploadTask> _task = {};

  String token;

  NetFile({
    this.scheme,
    this.host,
  })  : assert(null != scheme),
        assert(null != host),
        super([]) {
    _dio.options.baseUrl = '$scheme://$host';

    _dio.options.connectTimeout = 30000; //5s
    _dio.options.receiveTimeout = 30000;

    _dio.interceptors.add(CookieManager(_cookie));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: _onRequest,
      onResponse: _onResponse,
      onError: _onError,
    ));

    for (var item in interfaces) {
      item._onMap = _onMap;
      item._dio = _dio;
      item._scheme = scheme;
      item._host = host;
    }
  }

  @override
  T getInterfaces<T>() {
    if (this is T) {
      return this as T;
    }
    for (var item in interfaces) {
      if (item is T) {
        return item;
      }
    }
    return null;
  }

  void _onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['TOKEN'] = token;
    options.headers['OS'] = kIsWeb ? "WEB" : Platform.operatingSystem;
    assert(() {
      log('----HttpApi Open--------------------------------------------');
      log('Url:      ${options.uri}');
      log('Method:   ${options.method}');
      log('Headers:  ${options.headers}');
      return true;
    }());
    handler.next(options);
  }

  void _onResponse(Response<dynamic> e, ResponseInterceptorHandler handler) {
    assert(() {
      log('Url:      ${e}');
      log('----HttpApi End--------------------------------------------');
      return true;
    }());
    handler.next(e);
  }

  void _onError(DioError e, ErrorInterceptorHandler handler) {
    assert(() {
      log('Url:      ${e}');
      return true;
    }());
    handler.next(e);
  }

  Future<T> _onMap<T>(Future<Response<Map>> request, T Function(dynamic map) call, {String key}) {
    return request.then<T>((value) {
      var ret = _ERequest<T>.fromMap(value.data, call);
      if (0 == ret.code) {
        return Future.value(ret.data);
      } else if (0 == ret.code) {
        if (null != token) {
          token = null;
        }
      }
      return Future.error(value);
    });
  }

  String getUrl(String url) {
    if (0 == (url?.indexOf('http') ?? 0)) {
      return url;
    }
    return '$scheme://$host$url';
  }

  UploadTask<T> _createTask<T>(String key, Future<T> Function(UploadTask task) func) {
    if (_task.containsKey(key)) {
      return _task[key];
    }

    var task = UploadTask<T>();
    if (null != key && key.isNotEmpty) {
      _task[key] = task;
    }
    func(task).then((value) {
      task._list.forEach((element) => element.complete(value));
      if (null != key && key.isNotEmpty) {
        _task.remove(key);
      }
    }, onError: (e) {
      task._list.forEach((element) => element.completeError(e));
      if (null != key && key.isNotEmpty) {
        _task.remove(key);
      }
    });
    return task;
  }





  Future dioGet(String url, {Map<String, dynamic> queryParameters}) async {
    Response response;
    // response = await _dio.get('/test?id=12&name=dio');
    // print(response.data.toString());
    // The below request is the same as above.

    // url = 'https://api.pub.flutter-io.cn/not-exist';
    url = '/not-exist';
    // queryParameters = {'id': 12, 'name': 'dio'};
    queryParameters = null;
    response = await _dio.get(
      url,
      queryParameters: queryParameters,
    );
    print(response.data.toString());
    return response.data;
  }

  Future dioPost(String url, {Map<String, dynamic> queryParameters}) async {
    Response response;
    // response = await _dio.get('/test?id=12&name=dio');
    // print(response.data.toString());
    // The below request is the same as above.

    // url = 'https://api.pub.flutter-io.cn/not-exist';
    url = '/not-exist';
    queryParameters = {'id': 12, 'name': 'dio'};
    response = await _dio.post(
      url,
      queryParameters: queryParameters,
    );
    print(response.data.toString());
    return response.data;
  }

  UploadTask<ModelUpdateAvatar> updateAvatar(Uint8List _imageBytes, {String key}) {
    return _createTask<ModelUpdateAvatar>(key, (task) async {
      var request = _dio.post<Map>(
        "/upload",
        data: FormData.fromMap({
          "file": await MultipartFile.fromBytes(_imageBytes, filename: "avatar.png"),
        }),
        onSendProgress: task.onSendProgress,
        cancelToken: task._cancelToken,
      );
      return _onMap(request, (map) => ModelUpdateAvatar.fromMap(map));
    });
  }

  UploadTask<ModelUpdateFile> updateFileByBytes(Uint8List _dataBytes, {String filename, String key}) {
    return _createTask<ModelUpdateFile>(key, (task) async {
      var request = _dio.post<Map>(
        "/upload",
        data: FormData.fromMap({
          "file": await MultipartFile.fromBytes(_dataBytes, filename: filename),
        }),
        onSendProgress: task.onSendProgress,
        cancelToken: task._cancelToken,
      );
      return _onMap(request, (map) => ModelUpdateFile.fromMap(map));
    });
  }

  UploadTask<ModelUpdateFile> updateFileByPath(String path, {String filename, String key}) {
    return _createTask<ModelUpdateFile>(key, (task) async {
      var request = _dio.post<Map>(
        "/upload",
        data: FormData.fromMap({
          "file": await MultipartFile.fromFile(path, filename: filename),
        }),
        onSendProgress: task.onSendProgress,
        cancelToken: task._cancelToken,
      );
      return _onMap(request, (map) => ModelUpdateFile.fromMap(map));
    });
  }

  UploadTask<ModelUpdateFile> updateImageByPath(String path, {String filename, String key}) {
    return _createTask<ModelUpdateFile>(key, (task) async {
      var request = _dio.post<Map>(
        "/upload",
        data: FormData.fromMap({
          "file": await MultipartFile.fromFile(path, filename: filename),
        }),
        onSendProgress: task.onSendProgress,
        cancelToken: task._cancelToken,
      );
      return _onMap(request, (map) => ModelUpdateFile.fromMap(map));
    });
  }

  UploadTask getTask(String key) {
    return _task[key];
  }
}

class _ERequest<T> {
  final int code;
  final String message;
  final T data;

  _ERequest({
    this.code,
    this.message,
    this.data,
  });

  factory _ERequest.fromMap(dynamic map, T Function(dynamic map) callT) {
    if (null == map) return null;
    var temp;
    return _ERequest(
      code: null == (temp = map['code']) ? null : (temp is num ? temp.toInt() : int.tryParse(temp)),
      message: map['message']?.toString(),
      data: callT(map['data']),
    );
  }
}

class ModelUpdateAvatar {
  String url;

  ModelUpdateAvatar({
    this.url,
  });

  factory ModelUpdateAvatar.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return ModelUpdateAvatar(
      url: map['url']?.toString(),
    );
  }
}

class ModelUpdateFile {
  String url;

  ModelUpdateFile({
    this.url,
  });

  factory ModelUpdateFile.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return ModelUpdateFile(
      url: map['url']?.toString(),
    );
  }
}

class ModelUpdateImage {
  String url;

  ModelUpdateImage({
    this.url,
  });

  factory ModelUpdateImage.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return ModelUpdateImage(
      url: map['url']?.toString(),
    );
  }
}
