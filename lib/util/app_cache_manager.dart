import 'dart:async';
import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:http/src/streamed_response.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class HttpFileService extends FileService {
  http.Client _httpClient;

  Map<String, http.Client> cancelToken;

  HttpFileService({this.cancelToken = const {}}) {
    _httpClient = http.Client();
  }

  @override
  Future<FileServiceResponse> get(String url, {Map<String, String> headers = const {}}) async {
    final req = http.Request('GET', Uri.parse(url));
    req.headers.addAll(headers);

    if (cancelToken.containsKey(url)) {
      var client = cancelToken[url] ??= http.Client();
      final httpResponse = await client.send(req);
      return AppHttpGetResponse(httpResponse, url, cancelToken);
    } else {
      final httpResponse = await _httpClient.send(req);
      return AppHttpGetResponse(httpResponse, url, null);
    }
  }
}

class AppHttpGetResponse extends HttpGetResponse {
  final String url;

  final Map<String, http.Client> cancelToken;

  AppHttpGetResponse(StreamedResponse response, this.url, this.cancelToken) : super(response);

  @override
  String get fileExtension {
    var index = url.lastIndexOf(".");
    if (-1 == index) {
      return super.fileExtension;
    }
    return url.substring(index);
  }

  @override
  Stream<List<int>> get content {
    if (null == cancelToken) {
      return super.content;
    }
    print(contentLength);
    return ContentStream(super.content, onDone: () {
      cancelToken.remove(url);
    }, onError: (e, stack) {
      cancelToken.remove(url);
    });
  }
}

class ContentStream extends StreamView<List<int>> {
  final Function onError;
  final void Function() onDone;

  ContentStream(Stream stream, {this.onError, this.onDone}) : super(stream);

  @override
  StreamSubscription<List<int>> listen(void onData(List<int> value), {Function onError, void onDone(), bool cancelOnError}) {
    return super.listen((data) {
      onData(data);
    }, onDone: () {
      onDone();
      this.onDone?.call();
    }, onError: (e, stack) {
      onError(e, stack);
      this.onError?.call(e, stack);
    }, cancelOnError: cancelOnError);
  }
}

class AppCacheManager extends CacheManager with ImageCacheManager {
  static const key = 'AppCachedData';

  static AppCacheManager _instance;

  int userId;
  Config _config;

  Map<String, http.Client> _cancelToken = {};

  factory AppCacheManager() {
    var _cancelToken = <String, http.Client>{};
    _instance ??= AppCacheManager._(
      Config(
        key,
        repo: CacheObjectProvider(databaseName: key),
        fileService: HttpFileService(cancelToken: _cancelToken),
      ),
      _cancelToken,
    );

    return _instance;
  }

  AppCacheManager._(Config config, Map<String, http.Client> cancelToken) : super(config) {
    _config = config;
    _cancelToken = cancelToken;
  }

  Stream<FileResponse> downloadFileStream(String url, {String key, Map<String, String> headers, bool withProgress}) {
    _cancelToken[url] = null;
    return super.getFileStream(url, key: key, headers: headers, withProgress: withProgress);
  }

  Future<void> clearCache() async {
    Directory dir = await getTemporaryDirectory();
    dir = Directory(p.join(dir.path, _getKey()));
    await clearDirectory(dir);
  }


  Future<void> clearDirectory(Directory dir) async {
    if (await dir.exists()) {
      for (var item in await dir.list().toList()) {
        if (item is Directory) {
          await clearDirectory(item);
        } else if (item is File) {
          try {
            await item.delete();
          } catch (e) {
            print(e is Error ? (e).stackTrace : e);
          }
        }
      }
    }
  }


  void cancel(String url) {
    _cancelToken[url]?.close();
  }

  bool checkDownload(String url) {
    return _cancelToken.containsKey(url);
  }

  Future<int> getCacheSize() async {
    Directory dir = await getTemporaryDirectory();
    dir = Directory(p.join(dir.path, _getKey()));
    return await getDirectorySize(dir);
  }

  String _getKey() => null == userId ? key : p.join(key, userId.toString());

  Future<int> getDirectorySize(Directory dir) async {
    int size = 0;
    if (await dir.exists()) {
      for (var item in await dir.list().toList()) {
        if (item is Directory) {
          size += await getDirectorySize(item);
        } else if (item is File) {
          size += await item.length();
        }
      }
    }
    return size;
  }

  Future<void> reSetConfig({int userId, Duration stalePeriod}) async {
    this.userId = userId;
    Directory dir = await getTemporaryDirectory();
    dir = Directory(p.join(dir.path, _getKey()));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    var temp = _config;
    var _cancelToken = <String, http.Client>{};
    _instance = AppCacheManager._(
      Config(
        _getKey(),
        repo: CacheObjectProvider(databaseName: _getKey()),
        stalePeriod: stalePeriod,
        fileService: HttpFileService(cancelToken: _cancelToken),
      ),
      _cancelToken,
    );

    if (temp.repo is CacheObjectProvider && null != (temp.repo as CacheObjectProvider).db) {
      temp.repo.close();
    }
  }
}
