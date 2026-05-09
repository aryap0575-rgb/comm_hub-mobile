import android.app.Service
import android.content.Intent
import android.graphics.PixelFormat
import android.os.IBinder
import android.view.Gravity
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.util.Log

class OverlayService : Service() {

    private lateinit var overlayView: View

    override fun onCreate() {
        super.onCreate()

        
       

        

       
    }

    override fun onDestroy() {
        super.onDestroy()
       
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}
