import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Platform-independent vibration methods.
class Vibration {
  /// Method channel to communicate with native code.
  static const MethodChannel _channel = const MethodChannel('vibration');

  /// Check if vibrator is available on device.
  ///
  /// ```dart
  /// if (await Vibration.hasVibrator()) {
  ///   Vibration.vibrate();
  /// }
  /// ```
  static Future<bool> hasVibrator() async {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      return await _channel.invokeMethod("hasVibrator");
    }
    return false;
  }

  /// Check if the vibrator has amplitude control.
  ///
  /// ```dart
  /// if (await Vibration.hasAmplitudeControl()) {
  ///   Vibration.vibrate(amplitude: 128);
  /// }
  /// ```
  static Future<bool> hasAmplitudeControl() async {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      return await _channel.invokeMethod("hasAmplitudeControl");
    }
    return false;
  }

  /// Check if the device is able to vibrate with a custom
  /// [duration], [pattern] or [intensities].
  /// May return `true` even if the device has no vibrator.
  ///
  /// ```dart
  /// if (await Vibration.hasCustomVibrationsSupport()) {
  ///   Vibration.vibrate(duration: 1000);
  /// } else {
  ///   Vibration.vibrate();
  ///   await Future.delayed(Duration(milliseconds: 500));
  ///   Vibration.vibrate();
  /// }
  /// ```
  static Future<bool> hasCustomVibrationsSupport() async {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      return await _channel.invokeMethod("hasCustomVibrationsSupport");
    }
    return false;
  }

  /// Vibrate with [duration] at [amplitude] or [pattern] at [intensities].
  ///
  /// The default vibration duration is 500ms.
  /// Amplitude is a range from 1 to 255, if supported.
  ///
  /// ```dart
  /// Vibration.vibrate(duration: 1000);
  ///
  /// if (await Vibration.hasAmplitudeControl()) {
  ///   Vibration.vibrate(duration: 1000, amplitude: 1);
  ///   Vibration.vibrate(duration: 1000, amplitude: 255);
  /// }
  /// ```
  static Future<void> vibrate({int duration = 500, List<int> pattern = const [], int repeat = -1, List<int> intensities = const [], int amplitude = -1}) async {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      _channel.invokeMethod(
        "vibrate",
        {"duration": duration, "pattern": pattern, "repeat": repeat, "amplitude": amplitude, "intensities": intensities},
      );
    }
  }

  /// Cancel ongoing vibration.
  ///
  /// ```dart
  /// Vibration.vibrate(duration: 10000);
  /// Vibration.cancel();
  /// ```
  static Future<void> cancel() async {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      _channel.invokeMethod("cancel");
    }
  }
}
