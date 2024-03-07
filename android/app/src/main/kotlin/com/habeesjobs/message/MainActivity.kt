package com.habeesjobs.message

import android.content.Context
import android.content.Intent
import android.media.AudioManager
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec
import com.snail.antifake.jni.EmulatorDetectUtil
import com.github.gzuliyujiang.oaid.DeviceID
import com.github.gzuliyujiang.oaid.DeviceIdentifier
import com.github.gzuliyujiang.oaid.IGetter
import java.security.MessageDigest
import java.io.File
import java.io.InputStream

class MainActivity : FlutterActivity(), MethodChannel.MethodCallHandler {
    private val handler = Handler(Looper.getMainLooper()!!)
    private lateinit var channel: MethodChannel
    private var deviceIdResult: MethodChannel.Result? = null
    private var _deviceId: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        this.channel = MethodChannel(flutterEngine?.dartExecutor!!, "flutter/application", StandardMethodCodec.INSTANCE)
        channel.setMethodCallHandler(this)
        readDeviceId();
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method.equals("goBackToSystemHome")) {
            val intent = Intent();
            intent.action = Intent.ACTION_MAIN;
            intent.addCategory(Intent.CATEGORY_HOME);
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK;
            startActivity(intent);
            result.success(null)
            return
        } else if (call.method.equals("getAssets")) {
            result.success(getAssetsData(call.arguments as String))
            return
        } else if (call.method.equals("setSpeakerphoneOn")) {
            (call.arguments as Boolean).also { audioManager().isSpeakerphoneOn = it };
            result.success(null)
        } else if (call.method.equals("getSpeakerphoneOn")) {
            result.success(audioManager().isSpeakerphoneOn)
            return
        } else if (call.method.equals("setNotify")) {
            result.success(null)
        } else if (call.method == "getDeviceId") {
            getDeviceId(result)
            return
        } else if (call.method == "isEmulator") {
            isEmulator(result)
            return
        }
        result.notImplemented();
    }

    private fun getAssetsData(path: String): ByteArray? {
        var input: InputStream
        try {
            input = assets.open("flutter_assets/$path")
            var data = input.readBytes()
            return data
        } catch (e: Exception) {
            return null
        }
    }

    private fun isEmulator(result: MethodChannel.Result) {
        try {
            result.success(EmulatorDetectUtil.isEmulatorFromAll(this@MainActivity))
        } catch (e: Exception) {
            result.error("checkEmulatorError", e.toString(), e);
        }
    }
    /**
     * 初始化音频管理器
     */
    private fun audioManager(): AudioManager {
        var audioManager = context.getSystemService(AUDIO_SERVICE) as AudioManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
            audioManager.mode = AudioManager.MODE_IN_COMMUNICATION
        } else {
            audioManager.mode = AudioManager.MODE_IN_CALL
        }
        return audioManager
    }


    private fun readDeviceId() {
        DeviceID.getOAID(this, object : IGetter {
            override fun onOAIDGetComplete(aid: String) {
                var pseudoId = "00000000000000000000000000000000" + DeviceIdentifier.getPseudoID();
                pseudoId = pseudoId.subSequence(pseudoId.length - 32, pseudoId.length).toString()

                var oaId = "00000000000000000000000000000000" + aid
                oaId = oaId.subSequence(oaId.length - 32, oaId.length).toString()

                val digest: MessageDigest = MessageDigest.getInstance("MD5")
                digest.update(pseudoId.toByteArray())
                digest.update(oaId.toByteArray())

                _deviceId = byte2hex(digest.digest())
                if (null != deviceIdResult) {
                    handler.post {
                        deviceIdResult!!.success(_deviceId);
                        deviceIdResult = null;
                    }
                }
            }

            override fun onOAIDGetError(error: java.lang.Exception) {
                var pseudoId = "00000000000000000000000000000000" + DeviceIdentifier.getPseudoID();
                pseudoId = pseudoId.subSequence(pseudoId.length - 32, pseudoId.length).toString()
                val digest: MessageDigest = MessageDigest.getInstance("MD5")
                digest.update(pseudoId.toByteArray())
                _deviceId = byte2hex(digest.digest())

                if (null != deviceIdResult) {
                    handler.post {
                        deviceIdResult!!.success(_deviceId);
                        deviceIdResult = null;
                    }
                }
            }
        })
    }

    private fun getDeviceId(result: MethodChannel.Result) {
        if (null != _deviceId) {
            result.success(_deviceId)
        } else {
            deviceIdResult = result
        }
    }

    fun byte2hex(a: ByteArray): String? {
        var hexString: String? = ""
        for (i in a.indices) {
            val thisByte = String.format("%x", a[i])
            hexString += thisByte
        }
        return hexString
    }


}

