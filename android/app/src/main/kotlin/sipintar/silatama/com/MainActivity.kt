package com.example.fincome_mobile

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.net.Uri
import android.provider.Settings
import android.widget.Toast
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.screen_pinning"
    private lateinit var methodChannel: MethodChannel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Set secure flag to prevent screenshot
      
        // Register MethodChannel on FlutterEngine
        methodChannel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startPinning" -> {
                    startScreenPinning()
                    result.success(null)
                }
                "stopPinning" -> {
                    stopScreenPinning()
                    result.success(null)
                }
                "isScreenPinningActive" -> {
                    result.success(isInLockTaskMode())
                }
                
                else -> result.notImplemented()
            }
        }
    }

    private fun startScreenPinning() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            startLockTask()
        }
    }

    private fun stopScreenPinning() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            stopLockTask()
        }
    }

    private fun isInLockTaskMode(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            return activityManager.lockTaskModeState != ActivityManager.LOCK_TASK_MODE_NONE
        }
        return false
    }



    // Check Floating Windows
    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        if(isInLockTaskMode()){
            // Create a channel to send focus state to Flutter
            MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).invokeMethod(
            "windowFocusChanged", hasFocus
        )
        }
        
    }

    override fun onStop() {
        super.onStop()
        if (!isInLockTaskMode()) {
            navigateBackToPreviousScreen() 
           // Navigate back to the previous screen
        }
    }

    private fun navigateBackToPreviousScreen() {
        methodChannel.invokeMethod("navigateBack", null)
    }
}
