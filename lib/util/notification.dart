import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static LocalNotification _instance;

  static LocalNotification get instance => _instance ??= LocalNotification._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  bool isInit = false;

  LocalNotification._();

  Future<void> showNotification({int id, String title, String body, bool isSound = true}) async {
    if (Platform.isAndroid && Platform.isMacOS) {
      return;
    }

    AndroidNotificationDetails android = AndroidNotificationDetails(
      '${id}',
      '${title}',
      sound: RawResourceAndroidNotificationSound('slow_spring_board'),
    );
    const IOSNotificationDetails ios = IOSNotificationDetails(sound: 'slow_spring_board.aiff');
    const MacOSNotificationDetails mac = MacOSNotificationDetails(sound: 'slow_spring_board.aiff');

    NotificationDetails details = NotificationDetails(
      android: android,
      iOS: ios,
      macOS: mac,
    );

    await _plugin.show(
      id,
      title,
      body,
      details,
    );
  }

  Future<void> init() async {
    if (isInit) {
      return;
    }

    WidgetsFlutterBinding.ensureInitialized();
    final NotificationAppLaunchDetails launchDetails = await _plugin.getNotificationAppLaunchDetails();
    // String initialRoute = HomePage.routeName;
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      // selectedNotificationPayload = launchDetails.payload;
      // initialRoute = SecondPage.routeName;
    }

    const AndroidInitializationSettings settingAndroid = AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings settingIos = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (int id, String title, String body, String payload) async {
          // didReceiveLocalNotificationSubject.add(
          //   ReceivedNotification(
          //     id: id,
          //     title: title,
          //     body: body,
          //     payload: payload,
          //   ),
          // );
        });
    const MacOSInitializationSettings settingMacOs = MacOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings setting = InitializationSettings(
      android: settingAndroid,
      iOS: settingIos,
      macOS: settingMacOs,
    );
    await _plugin.initialize(setting, onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      // selectedNotificationPayload = payload;
      // selectNotificationSubject.add(payload);
    });
    isInit = true;
  }
}
