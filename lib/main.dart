import 'app.dart';

void main() {
  run(AppConfig(
    logicHost: "",
    logicPort: 0,
    // fileScheme: "https",
    // fileHost: "file.k1.game/",
    fileScheme: "http",
    // fileHost: " http://192.168.6.117:12345/",//本地
    fileHost: "47.97.250.198:12345/", //阿里
    apiScheme: "http",
    // apiHost: 'http://192.168.6.117:12345/',//本地
    apiHost: 'http://47.97.250.198:12345/',//阿里
    socketHost: "",
    mode: RunMode.profile,
  ));
}
