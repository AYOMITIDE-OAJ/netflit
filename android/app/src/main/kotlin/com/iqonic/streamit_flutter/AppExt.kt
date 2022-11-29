package com.oaj.netflit_flutter

fun getSharedPrefInstance(): SharedPrefUtils = SharedPrefUtils()

fun getUsername(): String = getSharedPrefInstance().getStringValue("flutter.USERNAME")
fun getPassword(): String = getSharedPrefInstance().getStringValue("flutter.PASSWORD")
fun isLoggedIn(): Boolean = getSharedPrefInstance().getBooleanValue("flutter.isLoggedIn")