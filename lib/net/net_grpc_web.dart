import 'package:ima2_habeesjobs/net/net_grpc.dart' as grpc;
import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_connection_interface.dart';
import 'package:grpc/grpc_web.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';

class NetGrpc extends NetwordInterface<Client> {
  final String host;
  final int port;

  NetGrpc({List<Client> Function(ClientChannelBase channel, grpc.NetGrpcInterceptor interceptor) interface, this.host, this.port}) : super([]) {
    interfaces.addAll(interface(GrpcWebClientChannel.xhr(Uri(host: host, port: port)), grpc.NetGrpcInterceptor()));
  }
}
