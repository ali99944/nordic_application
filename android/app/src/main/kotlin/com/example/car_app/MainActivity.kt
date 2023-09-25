package com.example.car_app

import android.content.Context
import android.provider.Settings.Secure
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
class MainActivity: FlutterActivity() {
    private val CHANNEL = "unique_id"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getAndroidId") {
                val androidId = getAndroidId()
                result.success(androidId)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getAndroidId(): String {
        val contentResolver = applicationContext.contentResolver
        return Secure.getString(contentResolver, Secure.ANDROID_ID) ?: ""
    }
}
