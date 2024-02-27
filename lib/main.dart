import 'app.dart';

void main() {
  run(AppConfig(
    logicHost: "",
    logicPort: 0,
    // fileScheme: "https",
    // fileHost: "file.k1.game/",
    fileScheme: "http",
    fileHost: "192.168.6.117:12345/",
    // fileHost: " http://192.168.6.117:12345/",
    apiScheme: "http",
    apiHost: 'http://192.168.6.117:12345/',//本地
    // apiHost: 'http://47.108.83.190:12345/',//阿里
    socketHost: "",
    mode: RunMode.profile,
  ));
}
