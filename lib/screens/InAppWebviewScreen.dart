import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/screens/HomeScreen.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';

// ignore: must_be_immutable
class InAppWebViewScreen extends StatefulWidget {
  static String tag = '/InAppWebViewScreen';
  Uri? url;

  InAppWebViewScreen(this.url);

  @override
  InAppWebViewScreenState createState() => InAppWebViewScreenState();
}

class InAppWebViewScreenState extends State<InAppWebViewScreen> {
  InAppWebViewController? webView;

  double progress = 0;
  String? title = '';
  bool isLogin = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (webView != null && (await webView?.canGoBack())!) {
          await webView!.goBack();
          return false;
        } else {
          webView!.clearCache();
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: appBackground,
        appBar: appBarWidget(title.validate(), color: navigationBackground, textColor: white),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: widget.url),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                    //debuggingEnabled: false,
                    javaScriptEnabled: true,
                    javaScriptCanOpenWindowsAutomatically: true,
                    cacheEnabled: false,
                    preferredContentMode: UserPreferredContentMode.MOBILE,
                    userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.150 Safari/537.36'),
                android: AndroidInAppWebViewOptions(
                  allowContentAccess: true,
                  allowFileAccess: true,
                  //allowFileAccessFromFileURLs: true,
                  //allowUniversalAccessFromFileURLs: true,
                  databaseEnabled: true,
                  useWideViewPort: false,
                  domStorageEnabled: true,
                  useOnRenderProcessGone: true,
                  thirdPartyCookiesEnabled: true,
                  saveFormData: true,
                  hardwareAcceleration: true,
                ),
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
              },
              onLoadStart: (InAppWebViewController controller, Uri? url) {
                isLoading = true;
                widget.url = url;

                log("Launch: " + url.toString());

                setState(() {});
              },
              onLoadStop: (InAppWebViewController controller, Uri? url) async {
                isLoading = false;
                title = await controller.getTitle();

                widget.url = url;

                if (!isLogin) {
                  var name = getStringAsync(USERNAME);
                  var pass = getStringAsync(PASSWORD);

                  webView!.evaluateJavascript(source: "document.getElementById('user_login').value ='$name'");
                  webView!.evaluateJavascript(source: "document.getElementById('user_pass').value = '$pass'");

                  Future.delayed(Duration(milliseconds: 500));

                  await webView!.evaluateJavascript(source: "document.getElementById('pms_login').submit()");

                  isLogin = true;
                }

                if (url.toString().contains('checkout/done')) {
                  HomeScreen().launch(context, isNewTask: true);
                }

                setState(() {});
              },
              onProgressChanged: (InAppWebViewController controller, int progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
            ),
            LinearProgressIndicator(backgroundColor: white).visible(isLoading)
            // Loader().visible(!isLogin),
          ],
        ),
      ),
    );
  }
}
