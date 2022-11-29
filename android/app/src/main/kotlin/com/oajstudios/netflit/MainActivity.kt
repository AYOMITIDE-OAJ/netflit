package com.oajstudios.netflit

import android.content.Intent
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private val channel = "webviewChannel"
    private val method = "webview"

    private val code = 100

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor, channel).setMethodCallHandler { call, result ->
            if (call.method == method) {
                val url: String = call.argument("url")!!
                val username: String = call.argument("username")!!
                val password: String = call.argument("password")!!
                val isLoggedIn: Boolean = call.argument("isLoggedIn")!!

                Log.d("url", call.arguments.toString())

                val intent = Intent(this, WebViewActivity::class.java)
                intent.putExtra("url", url)
                intent.putExtra("username", username)
                intent.putExtra("password", password)
                intent.putExtra("isLoggedIn", isLoggedIn)

                this.startActivity(intent)

                result.success("")
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (resultCode == RESULT_OK && requestCode == code) {
            //
        }
    }
}
