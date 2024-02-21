import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_connection_interface.dart';
import 'package:grpc/src/client/transport/web_streams.dart';
import 'package:grpc/src/shared/status.dart';
import 'package:meta/meta.dart';

const _contentTypeKey = 'Content-Type';

class HttpTransportStream implements GrpcTransportStream {
  HttpClientRequest _request;
  final ErrorHandler _onError;
  final Function(HttpTransportStream stream) _onDone;
  final StreamController<ByteBuffer> _incomingProcessor = StreamController();
  final StreamController<GrpcMessage> _incomingMessages = StreamController();
  final StreamController<List<int>> _outgoingMessages = StreamController();

  @override
  Stream<GrpcMessage> get incomingMessages => _incomingMessages.stream;

  @override
  StreamSink<List<int>> get outgoingMessages => _outgoingMessages.sink;

  HttpTransportStream(Future<HttpClientRequest> request, {ErrorHandler onError, onDone})
      : _onError = onError,
        _onDone = onDone {
    void _onResponse(HttpClientResponse response) {
      _onHeadersReceived(response);
      if (_incomingProcessor.isClosed) {
        return;
      }

      response.listen((event) {
        _incomingProcessor.add(Uint8List.fromList(event).buffer);
      }, onDone: () {
        _incomingProcessor.close();
      });
    }

    request.then((value) {
      _request = value;
      _outgoingMessages.stream.map(frame).listen((data) {
        _request?.add(data);
      }, onDone: () {
        _request?.close().then(
          _onResponse,
          onError: (e) {
            _onError(GrpcError.unavailable('XhrConnection request null response', null), StackTrace.current);
          },
        );
      }, cancelOnError: true);
    }, onError: (e) {
      if (_incomingProcessor.isClosed) {
        return;
      }
      _onError(GrpcError.unavailable('XhrConnection connection-error'), StackTrace.current);
      terminate();
    });

    _incomingProcessor.stream
        .transform(GrpcWebDecoder())
        .transform(grpcDecompressor())
        .listen(_incomingMessages.add, onError: _onError, onDone: _incomingMessages.close);
  }

  bool _validateResponseState(HttpClientResponse response, Map<String, String> metadata) {
    try {
      validateHttpStatusAndContentType(response.statusCode, metadata, rawResponse: "");
      return true;
    } catch (e, st) {
      _onError(e, st);
      return false;
    }
  }

  void _onHeadersReceived(HttpClientResponse response) {
    Map<String, String> metadata = {};
    response.headers.forEach((name, values) {
      metadata[name] = values.join(";");
    });

    if (!_validateResponseState(response, metadata)) {
      return;
    }
    _incomingMessages.add(GrpcMetadata(metadata));
  }

  void _close() {
    _incomingProcessor.close();
    _outgoingMessages.close();
    _onDone(this);
  }

  @override
  Future<void> terminate() async {
    _close();
    await _request?.close();
  }
}

class HttpClientConnection extends ClientConnection {
  final Uri uri;

  final _requests = <HttpTransportStream>{};

  final _httpClient = HttpClient();

  HttpClientConnection(this.uri) {
    _httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }

  @override
  String get authority => uri.authority;

  @override
  String get scheme => uri.scheme;

  @visibleForTesting
  HttpClient createHttpRequest() => _httpClient;

  @override
  GrpcTransportStream makeRequest(String path, Duration timeout, Map<String, String> metadata, ErrorHandler onError, {CallOptions callOptions}) {
    // gRPC-web headers.
    _getContentTypeHeader(metadata);
    metadata['Content-Type'] = 'application/grpc-web';
    metadata['X-User-Agent'] = 'grpc-web-dart/0.1';
    metadata['X-Grpc-Web'] = '1';

    var requestUri = uri.resolve(path);

    var request = createHttpRequest().postUrl(requestUri).then((value) {
      _initializeRequest(value, metadata);
      return value;
    });
    final transportStream = HttpTransportStream(request, onError: onError, onDone: _removeStream);
    _requests.add(transportStream);
    return transportStream;
  }

  void _removeStream(HttpTransportStream stream) {
    _requests.remove(stream);
  }

  @override
  Future<void> terminate() async {
    for (var request in List.of(_requests)) {
      request.terminate();
    }
  }

  @override
  void dispatchCall(ClientCall call) {
    call.onConnectionReady(this);
  }

  @override
  Future<void> shutdown() async {}

  void _initializeRequest(HttpClientRequest request, Map<String, String> metadata) {
    for (final item in metadata.entries) {
      request.headers.add(item.key, item.value);
    }
  }

  @override
  set onStateChanged(void Function(ConnectionState p1) cb) {}
}

MapEntry<String, String> _getContentTypeHeader(Map<String, String> metadata) {
  for (var entry in metadata.entries) {
    if (entry.key.toLowerCase() == _contentTypeKey.toLowerCase()) {
      return entry;
    }
  }
  return null;
}

class HttpClientChannel extends ClientChannelBase {
  final Uri uri;

  HttpClientChannel(this.uri) : super();

  @override
  ClientConnection createConnection() {
    return HttpClientConnection(uri);
  }
}
