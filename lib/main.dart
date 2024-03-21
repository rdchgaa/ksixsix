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
    // fileHost: "127.0.0.1:12345/", //web
    apiScheme: "http",
    // apiHost: 'http://192.168.6.117:12345/',//本地
    apiHost: 'http://47.97.250.198:12345/',//阿里
    // apiHost: 'http://127.0.0.1:12345/',//web·
    mode: RunMode.profile,
  ));
}
