package com.oaj.netflit_flutter

class App : io.flutter.app.FlutterApplication() {

    override fun onCreate() {
        super.onCreate()

        app = this
    }

    companion object {
        lateinit var app: App
        fun getAppInstance(): App {
            return app
        }
    }
}