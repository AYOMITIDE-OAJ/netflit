package com.oaj.netflit_flutter

import android.annotation.SuppressLint
import android.graphics.Bitmap
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.util.Log
import android.view.MenuItem
import android.view.View
import android.webkit.ValueCallback
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity
import kotlinx.android.synthetic.main.activity_streamit_web_view.*

@SuppressLint("SetJavaScriptEnabled")
class WebViewActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_streamit_web_view)

        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        supportActionBar?.setHomeAsUpIndicator(R.drawable.back_button)
        supportActionBar?.setIcon(R.drawable.back_button)
        supportActionBar?.setBackgroundDrawable(ColorDrawable(Color.parseColor("#141414")))

        val url = intent.getStringExtra("url")!!
        val username: String = intent.getStringExtra("username")!!
        val password: String = intent.getStringExtra("password")!!
        var isLoggedIn: Boolean = intent.getBooleanExtra("isLoggedIn", false)

        val myWebView: WebView = findViewById(R.id.streamitNativeWebView)


        Log.d("url", url)

        streamitNativeWebView.setBackgroundColor(Color.parseColor("#000000"))

        streamitNativeWebView.clearCache(true)

        streamitNativeWebView.settings.javaScriptEnabled = true
        streamitNativeWebView.settings.allowFileAccess = true;
        streamitNativeWebView.settings.allowContentAccess = true;
        streamitNativeWebView.settings.domStorageEnabled = true

        Log.d("Final URL", "URL: $url")

        streamitNativeWebView.loadUrl(url)

        streamitNativeWebView.webViewClient = object : WebViewClient() {
            override fun shouldOverrideUrlLoading(view: WebView?, url: String?): Boolean {
                view?.loadUrl(url!!)
                return true
            }

            override fun onPageFinished(view: WebView?, url: String?) {
                super.onPageFinished(view, url)
                Log.d("onPageFinished", url!!)
                progressBar.visibility = View.GONE

                if (!isLoggedIn && url.contains("_wpnonce")) {
                    streamitNativeWebView.evaluateJavascript("document.getElementById('pms_login').submit()") {
                        //
                    }
                }

                if (isLoggedIn) {

                    streamitNativeWebView.evaluateJavascript("document.getElementById('user_login').value ='${username}'", ValueCallback {
                        //
                    })
                    streamitNativeWebView.evaluateJavascript("document.getElementById('user_pass').value = '${password}'") {
                        //
                    }

                    streamitNativeWebView.evaluateJavascript("document.getElementById('pms_login').submit()") {
                        //
                    }
                    isLoggedIn = false
                }
            }

            override fun onPageStarted(view: WebView?, url: String?, favicon: Bitmap?) {
                super.onPageStarted(view, url, favicon)
                Log.d("onPageFinished", url!!)
                progressBar.visibility = View.VISIBLE
            }
        }


    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        // Handle presses on the action bar menu items
        when (item.itemId) {
            android.R.id.home -> {
                onBackPressed()
                return true
            }
        }
        return super.onOptionsItemSelected(item)
    }

    override fun onBackPressed() {
        if (streamitNativeWebView.canGoBack()) {
            streamitNativeWebView.evaluateJavascript(
                    "var check = document.getElementsByClassName('pms-account-navigation-link--logout');\n" +
                            "if (check.length > 0) {\n" +
                            "// elements with class \"snake--mobile\" exist\n" +
                            "document.querySelector('.pms-account-navigation-link--logout a').click();\n" +
                            "}", ValueCallback {})


            streamitNativeWebView.goBack()
        } else {
            streamitNativeWebView.evaluateJavascript(
                    "var check = document.getElementsByClassName('pms-account-navigation-link--logout');\n" +
                            "if (check.length > 0) {\n" +
                            "    // elements with class \"snake--mobile\" exist\n" +
                            "document.querySelector('.pms-account-navigation-link--logout a').click();\n" +
                            "}", ValueCallback {})


            streamitNativeWebView.clearCache(true)
            streamitNativeWebView.clearFormData()
            streamitNativeWebView.clearHistory()
            streamitNativeWebView.clearMatches()
            streamitNativeWebView.clearSslPreferences()
            super.onBackPressed()
        }
    }


}