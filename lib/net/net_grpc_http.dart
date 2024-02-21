import 'package:ima2_habeesjobs/net/grpc_http_transport.dart';
import 'package:ima2_habeesjobs/net/net_grpc.dart' as grpc;
import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_connection_interface.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';

class NetGrpc extends NetwordInterface<Client> {
  final String scheme;
  final String host;

  NetGrpc({
    List<Client> Function(ClientChannelBase channel, grpc.NetGrpcInterceptor interceptor) interface,
    this.scheme,
    this.host,
  }) : super([]) {
    interfaces.addAll(interface(HttpClientChannel(Uri.parse('$scheme://$host')), grpc.NetGrpcInterceptor()));
  }
}
