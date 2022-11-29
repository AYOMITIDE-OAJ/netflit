import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/utils/Common.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';

// ignore: must_be_immutable
class UrlLauncherScreen extends StatefulWidget {
  static String tag = '/UrlLauncherScreen';
  String? url;

  UrlLauncherScreen(this.url);

  @override
  UrlLauncherScreenState createState() => UrlLauncherScreenState();
}

class UrlLauncherScreenState extends State<UrlLauncherScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    init();

    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> init() async {
    String? u = '';

    var name = getStringAsync(USERNAME);
    var pass = getStringAsync(PASSWORD);

    if (getBoolAsync(isLoggedIn)) {
      u = '${widget.url}?user_login=$name&user_pass=$pass';

      log('URL : $u');
      await callNativeWebView({"url": widget.url, 'username': name, 'password': pass, 'isLoggedIn': getBoolAsync('isLoggedIn')});
    } else {
      u = widget.url;

      log('URL : $u');

      await callNativeWebView({"url": u, 'username': name, 'password': pass, 'isLoggedIn': getBoolAsync('isLoggedIn')});
    }
  }

  String generateNonce() {
    var rand = new Random();
    var codeUnits = new List.generate(10, (index) {
      return rand.nextInt(26) + 97;
    });

    return String.fromCharCodes(codeUnits);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      finish(context);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      body: FutureBuilder(
        future: 1.seconds.delay,
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return SizedBox();
          }
          return AppButton(
            color: colorPrimary,
            text: language!.back,
            onTap: () {
              finish(context);
            },
          ).center().visible(Platform.isAndroid);
        },
      ),
    );
  }
}
