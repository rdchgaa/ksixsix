import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate{
    var channel: FlutterMethodChannel?;
    

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    ApplicationPlugin.register(with: self.registrar(forPlugin: "ApplicationPlugin")!)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
