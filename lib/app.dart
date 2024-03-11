import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:xxc_flutter_utils/xxc_flutter_utils.dart';
import 'package:ima2_habeesjobs/dialog/alert_dialog.dart';
import 'package:ima2_habeesjobs/net/net_file.dart';
import 'package:ima2_habeesjobs/page/page_init.dart';
import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:ima2_habeesjobs/service/ser_base.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:ima2_habeesjobs/util/language.dart';
import 'package:ima2_habeesjobs/util/navigator.dart';
import 'package:ima2_habeesjobs/util/other.dart';
import 'package:provider/provider.dart';

const MaterialColor primarySwatch = MaterialColor(
  0xff703EFE,
  <int, Color>{
    50: Color(0xFFe7f7ed),
    100: Color(0xFFc5ebd4),
    200: Color(0xFFa0dfb8),
    300: Color(0xFF77d39c),
    400: Color(0xFF56c886),
    500: Color(0xff30be71),
    600: Color(0xFF28ae66),
    700: Color(0xFF1d9b59),
    800: Color(0xFF158a4e),
    900: Color(0xFF046a39),
  },
);

enum RunMode {
  debug,
  profile,
  release,
}

class AppConfig {
  String logicHost;
  int logicPort;
  String fileScheme;
  String fileHost;
  String apiScheme;
  String apiHost;
  String socketHost;
  RunMode mode;

  AppConfig({
    this.logicHost,
    this.logicPort,
    this.fileScheme,
    this.fileHost,
    this.apiScheme,
    this.apiHost,
    this.socketHost,
    this.mode = RunMode.debug,
  });
}

Future<void> run(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
  } else if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    SystemChrome.setPreferredOrientations([
      // 强制竖屏
      DeviceOrientation.landscapeLeft
    ]);
  }
  try {
  } catch (e) {
    print(e);
  }
  await initSharedPreferences();

  runApp(
    App(config: config),
  );
}

class AppAssetBundle extends CachingAssetBundle {
  final MethodChannel channel;

  AppAssetBundle({this.channel});

  @override
  Future<ByteData> load(String key) async {
    final String path = Uri(path: Uri.encodeFull(key)).path;
    final asset = await channel.invokeMethod("getAssets", path);
    if (asset == null) {
      throw FlutterError('Unable to load asset: $key');
    }
    return Uint8List.fromList(asset).buffer.asByteData();
  }
}

class App extends StatefulWidget {
  final AppConfig config;

  const App({Key key, this.config}) : super(key: key);

  @override
  _AppState createState() => _AppState();

  static _AppState of(BuildContext context) {
    return context.findAncestorStateOfType<_AppState>();
  }
}

class _AppState extends State<App> {
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final _streamController = StreamController.broadcast(sync: false);

  final channel = MethodChannel("flutter/application", StandardMethodCodec());

  Locale _locale;

  OverlayEntry _videoOverlay;

  OverlayEntry get videoOverlay => _videoOverlay;

  set videoOverlay(OverlayEntry value) {
    _videoOverlay = value;
  }

  Locale get locale => _locale;

  set locale(Locale value) {
    setLocale(value.languageCode);
    setState(() {
      _locale = value;
    });
  }

  List<Locale> _supportedLocales = [
    Locale('en', 'English'),
    Locale("zh", "中文"),
  ];

  List<Locale> get supportedLocales => _supportedLocales;

  Stream<T> on<T>() {
    if (T == dynamic) {
      return _streamController.stream as Stream<T>;
    } else {
      return _streamController.stream.where((event) => event is T).cast<T>();
    }
  }

  void event(event) {
    _streamController.add(event);
  }

  bool _alwaysDialog(BuildContext context, BaseRouterDelegate delegate) {
    return true;
  }

  bool _onlyPcDialog(BuildContext context, BaseRouterDelegate delegate) {
    return isPc(context);
  }

  AppAssetBundle _bundle;

  final MethodChannel _channel = const MethodChannel("flutter/application", StandardMethodCodec());

  void initState() {
    _bundle = AppAssetBundle(channel: _channel);
    channel.setMethodCallHandler(onMethodCallHandler);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultAssetBundle(
      bundle: _bundle ?? rootBundle,
      child: Network(create: (context) {
        return [
          NetFile(
            scheme: widget.config.fileScheme,
            host: widget.config.fileHost,
          ),
        ];
      }, builder: (context) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SerBase(() => _navigatorKey.currentState.overlay.context, serverUrl: widget.config.socketHost)),
            ChangeNotifierProvider(create: (_) => SerUser(_navigatorKey.currentState.overlay.context)),
          ],
          child: ToastTheme(
            data: ToastThemeData(textStyle: TextStyle(fontFamily: _getFontFamily())),
            child: LoadingCall(
              data: LoadingThemeData(
                color: Colors.white.withOpacity(0.3),
                indicatorBuilder: (context, value) {
                  return CupertinoActivityIndicator();
                },
              ),
              onError: _onError,
              builder: (context) {
                return Consumer<SerBase>(builder: (context, value, child) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: '炫牛',
                    navigatorKey: _navigatorKey,
                    theme: ThemeData(
                      fontFamily: _getFontFamily(),
                      scaffoldBackgroundColor: Color(0xffF8F8F8),
                      primarySwatch: primarySwatch,
                      navigationRailTheme: NavigationRailThemeData(backgroundColor: primarySwatch),
                      dividerColor: Color(0xffEBEBEB),
                      visualDensity: VisualDensity(),
                      appBarTheme: AppBarTheme(
                        elevation: 0,
                        iconTheme: IconThemeData(),
                      ),
                      bottomNavigationBarTheme: BottomNavigationBarThemeData(
                        backgroundColor: Color(0xffF8F8F8),
                      ),
                      inputDecorationTheme: InputDecorationTheme(
                        focusColor: Color(0xff009FE8),
                      ),
                    ),
                    localeResolutionCallback: _onLocaleResolutionCallback,
                    locale: _locale,
                    supportedLocales: _supportedLocales,
                    localizationsDelegates: [
                      GlobalMaterialLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      // Languages.delegate,
                      Languages.getDelegate(context),
                    ],
                    builder: (context, Widget child) {
                      return _BindingObserver(child: child);
                    },
                    home: PageInit(),
                  );
                });
                // return AutoRouter(
                //   home: "/",
                //   routers: {
                //     //base
                //     AutoPath("/"): (context, param) => PageInit(param: param),
                //     AutoPath("/login_username"): (context, param) => PageLogin(),
                //     AutoPath("/login_register"): (context, param) => PageRegister(),
                //     AutoPath("/set"): (context, param) => PageMy(param: param),
                //     AutoPath("/home/webview"): (context, param) => PageWebView(param: param),
                //     AutoPath("/user_agreement", _onlyPcDialog): (context, param) => PageUserAgreement(),
                //     AutoPath("/user_privacy_policy", _onlyPcDialog): (context, param) => PageUserPrivacyPolicy(),
                //     AutoPath("/edit_image", _onlyPcDialog): (context, param) => PageEditImage(param: param),
                //     AutoPath("/home"): (context, param) => PageHome(),
                //     AutoPath("/home/aboutus", _onlyPcDialog): (context, param) => PageUserAboutUs(),
                //     AutoPath("/self_info", _onlyPcDialog): (context, param) => PageUserInfo(),
                //     AutoPath("/dialog_alert", _alwaysDialog): (context, param) => DialogAlertBox(param: param),
                //     AutoPath("/dialog_select_image", _alwaysDialog): (context, param) => DialogSelectImageBox(),
                //     AutoPath("/dialog_time", _alwaysDialog): (context, param) => TimeDialog(param: param),
                //     AutoPath("/dialog_policy", _alwaysDialog): (context, param) => PolicyDialog(),
                //
                //     //page
                //     AutoPath("/job_details"): (context, param) => PageXdJobDetails(
                //           param: param,
                //         ),
                //     AutoPath("/company_details"): (context, param) => PageXdCompanyDetails(param: param),
                //     AutoPath("/search"): (context, param) => PageXdSearch(),
                //     AutoPath("/all_job"): (context, param) => PageXdAllJob(),
                //     AutoPath("/all_company"): (context, param) => PageXdAllCompany(),
                //     AutoPath("/my_edit_info"): (context, param) => PageXdEditInfo(),
                //     AutoPath("/my_collection"): (context, param) => PageXdMyCollection(),
                //
                //     //房间页面
                //     //加人房间
                //     AutoPath("/room_main"): (context, param) => PageRoomMain(param: param),
                //     //游戏页面
                //     AutoPath("/game_main"): (context, param) => PageGameMain(param: param),
                //   },
                //   builder: (context, appRouter) {
                //     if (null == _navigatorKey) {
                //       _navigatorKey = appRouter.navigatorKey;
                //     }
                //
                //     return Consumer<SerBase>(builder: (context, value, child) {
                //       return MaterialApp.router(
                //         debugShowCheckedModeBanner: false,
                //         routerDelegate: appRouter,
                //         routeInformationParser: appRouter,
                //         routeInformationProvider: appRouter.provider,
                //         title: '炫牛',
                //         theme: ThemeData(
                //           fontFamily: _getFontFamily(),
                //           scaffoldBackgroundColor: Color(0xffF8F8F8),
                //           primarySwatch: primarySwatch,
                //           navigationRailTheme: NavigationRailThemeData(backgroundColor: primarySwatch),
                //           dividerColor: Color(0xffEBEBEB),
                //           visualDensity: VisualDensity(),
                //           appBarTheme: AppBarTheme(
                //             elevation: 0,
                //             iconTheme: IconThemeData(),
                //           ),
                //           bottomNavigationBarTheme: BottomNavigationBarThemeData(
                //             backgroundColor: Color(0xffF8F8F8),
                //           ),
                //           inputDecorationTheme: InputDecorationTheme(
                //             focusColor: Color(0xff009FE8),
                //           ),
                //         ),
                //         localeResolutionCallback: _onLocaleResolutionCallback,
                //         locale: _locale,
                //         supportedLocales: _supportedLocales,
                //         localizationsDelegates: [
                //           GlobalMaterialLocalizations.delegate,
                //           GlobalCupertinoLocalizations.delegate,
                //           GlobalWidgetsLocalizations.delegate,
                //           // Languages.delegate,
                //           Languages.getDelegate(context),
                //           FlutterAppUpdateLanguages.delegate,
                //         ],
                //         builder: (context, Widget child) {
                //           return _BindingObserver(child: child);
                //         },
                //       );
                //     });
                //   },
                // );
              },
            ),
          ),
        );
      }),
    );
  }

  Locale _onLocaleResolutionCallback(Locale locale, Iterable<Locale> supported) {
    _locale = supported.firstWhere((element) => element.languageCode == getLocale(), orElse: () => supported.toList()[0]);
    return _locale;
  }

  Future _onError(BuildContext context, error) async {
    print(error);

    if (error is DioError) {
      return ERequest(code: error.type.index, msg: '网络错误，请稍后再试');
    }
    if (true) {
      // setToken(null);
      // App.of(context).setTitle(" ");
      // setUserId(null);
      // setDeviceId(null);
      // setChannel(null);
      // context.read<SerBase>().close();

      showAlertDialog(
        context,
        title: '提示',
        content: '网络异常断开',
        buttonOk: '重新登录',
      ).then((value) {
        PageInit().push(context);
      });
      return null;
    }

    return error;
  }

  Future onMethodCallHandler(MethodCall call) async {
    if ("onActivate" == call.method) {
      setState(() {});
    }
  }

  String _getFontFamily() {
    if (Platform.isWindows) {
      return "Microsoft Yahei";
    }

    return null;
  }
}

class _BindingObserver extends StatefulWidget {
  final Widget child;

  const _BindingObserver({Key key, this.child}) : super(key: key);

  @override
  _BindingObserverState createState() => _BindingObserverState();
}

class _BindingObserverState extends State<_BindingObserver> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    context.read<SerBase>().resumed = AppLifecycleState.resumed == state;
  }

  @override
  Future<bool> didPopRoute() async {
    var ret = await super.didPopRoute();
    if (!Navigator.canPop(context)) {
      exit(0);
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child,
      onTap: () {
        hideTextInput();
      },
    );
  }
}

class ERequest {
  final int code;
  final String msg;

  ERequest({
    this.code,
    this.msg,
  });

  @override
  String toString() {
    return msg;
  }
}