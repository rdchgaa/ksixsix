//
//  ApplicationPlugin.swift
//  Runner
//
//  Created by 丰游 on 2022/1/30.
//

import Foundation
import Flutter
import AVFoundation

public class ApplicationPlugin:  NSObject, FlutterPlugin{
    
    public static func register(with registrar: FlutterPluginRegistrar) {
          let channel = FlutterMethodChannel(name: "flutter/application", binaryMessenger: registrar.messenger(),codec: FlutterStandardMethodCodec())
          let instance = ApplicationPlugin()
          registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "setSpeakerphoneOn" {
            self.setSpeakerphoneOn(call.arguments as? Bool ?? false,result: result)
        }else  if call.method == "getSpeakerphoneOn" {
            self.getSpeakerphoneOn(result)
        } else {
          result(FlutterMethodNotImplemented)
        }
    }
    
    private func setSpeakerphoneOn(_ isSpeaker : Bool, result: @escaping FlutterResult) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            if isSpeaker == false {
                try audioSession.overrideOutputAudioPort(.none)
            } else {
                try audioSession.overrideOutputAudioPort(.speaker)
            }
            try audioSession.setActive(true)
            result(nil)
        } catch {
            result(FlutterError(code: "error", message: error.localizedDescription, details: nil))
        }
      
    }
    
    private func getSpeakerphoneOn(_ result: @escaping FlutterResult) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
         
            try audioSession.setActive(true)
            result(audioSession)
        } catch {
            result(FlutterError(code: "error", message: error.localizedDescription, details: nil))
        }
      
    }
}

