import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:ima2_habeesjobs/util/logger.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_connection_interface.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';

class NetGrpcInterceptor extends ClientInterceptor {
  Map<String, String> getMetadata() {
    Map<String, String> metadata = {};
    var deviceId = getDeviceId();
    if (deviceId != null) {
      metadata["device_id"] = deviceId.toString();
    }
    var userId = getUserId();
    if (userId != null) {
      metadata["user_id"] = userId.toString();
    }
    var token = getToken();
    if (token != null) {
      metadata["token"] = token;
    }
    var groupId = getGroupId();
    if (groupId != null) {
      metadata["group_id"] = groupId.toString();
    }
    return metadata;
  }

  @override
  ResponseFuture<R> interceptUnary<Q, R>(ClientMethod<Q, R> method, Q request, CallOptions options, invoker) {
    var metadata = getMetadata();
    metadata.forEach((key, value) {
      if (value == null) {
        metadata.remove(key);
      }
    });

    metadata.addAll(options.metadata);
    var newOptions = CallOptions(metadata: metadata, providers: options.metadataProviders, timeout: Duration(seconds: 30));

    logger.i("request method:${method.path}\nrequest:$request options:$newOptions metadata:$metadata");
    ResponseFuture<R> response;
    response = invoker.call(method, request, newOptions);
    response.then((value) {
      logger.i("request method:${method.path}\n response:$value");
    });
    return response;
  }
}

class NetGrpc extends NetwordInterface<Client> {
  final String host;
  final int port;
  final Duration connectionTimeout;

  NetGrpc({
    List<Client> Function(ClientChannelBase channel, NetGrpcInterceptor interceptor) interface,
    this.host,
    this.port,
    this.connectionTimeout = const Duration(minutes: 10),
  }) : super([]) {
    interfaces.addAll(interface(
      ClientChannel(
        host,
        port: port,
        options: ChannelOptions(
          credentials: ChannelCredentials.insecure(),
          connectionTimeout: connectionTimeout,
        ),
      ),
      NetGrpcInterceptor(),
    ));
  }
}
