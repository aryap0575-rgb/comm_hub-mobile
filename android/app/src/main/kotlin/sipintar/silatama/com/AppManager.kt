import android.app.ActivityManager
import android.content.Context
import android.os.Build
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import android.util.Log

class AppManagerPlugin : FlutterPlugin, ActivityAware {
    private var channel: MethodChannel? = null
    private var activity: android.app.Activity? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "app_manager")
        channel?.setMethodCallHandler { call, result ->
            if (call.method == "closeOtherApps") {
                closeOtherApps()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun closeOtherApps() {
        val activityManager = activity?.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val tasks = activityManager.runningAppProcesses
        val currentPackage = activity?.packageName

        tasks?.forEach { appProcess ->
            Log.d("TAG", "Process "+appProcess.processName ?: "Tidak ada")
            Log.d("TAG", "Current "+currentPackage ?: "Tidak ada")
            
            if (appProcess.processName != currentPackage) {
                activityManager.killBackgroundProcesses(appProcess.processName)
            }
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
    }
}
