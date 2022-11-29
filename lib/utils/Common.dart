import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tab;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:streamit_flutter/models/CommentModel.dart';
import 'package:streamit_flutter/models/DownloadData.dart';
import 'package:streamit_flutter/models/LoginResponse.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/network/RestApis.dart';
import 'package:streamit_flutter/screens/UrlLauncherScreen.dart';
import 'package:streamit_flutter/screens/movieDetailComponents/MovieURLWidget.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:url_launcher/url_launcher_string.dart';

import '../main.dart';

Future<void> launchURL(String url, {bool forceWebView = true, Map<String, String>? header}) async {
  await url_launcher.launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView);
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

String buildLikeCountText(int like) {
  if (like > 1) {
    return '$like ${language!.likes}';
  } else {
    return '$like ${language!.like}';
  }
}

String buildCommentCountText(int comment) {
  if (comment > 1) {
    return '$comment ${language!.comments}';
  } else {
    return '$comment ${language!.comment}';
  }
}

extension SExt on String {
  int getYear() {
    return DateTime.parse(this).year;
  }

  String? getFormattedDate({String format = defaultDateFormat}) {
    try {
      return DateFormat(format).format(DateTime.parse(this));
    } on FormatException catch (e) {
      return e.source;
    }
  }

  bool get isVideoPlayerFile => this.contains("mp4") || this.contains("m4v") || this.contains("mkv") || this.contains("mov");

  String get urlFromIframe {
    var document = parse(this);
    dom.Element? link = document.querySelector('iframe');
    String? iframeLink = link != null ? link.attributes['src'].validate() : '';
    return iframeLink.validate();
  }

  bool get isYoutubeUrl {
    for (var exp in [
      RegExp(r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
    ]) {
      Match? match = exp.firstMatch(this);
      if (match != null && match.groupCount >= 1) return true;
    }
    return false;
  }
}

String getPostType(PostType postType) {
  if (postType == PostType.MOVIE) {
    return 'Movie';
  } else if (postType == PostType.TV_SHOW) {
    return 'TV Show';
  } else if (postType == PostType.EPISODE) {
    return 'Episode';
  }
  return '';
}

Future<void> getDetails({required LoginResponse logRes, required String image}) async {
  await setValue(USER_ID, logRes.user_id);
  await setValue(NAME, logRes.firstName);
  await setValue(LAST_NAME, logRes.lastName);
  await setValue(USER_PROFILE, logRes.profile_image.validate().isEmpty ? image : logRes.profile_image.validate());
  await setValue(USER_EMAIL, logRes.user_email);
  await setValue(USERNAME, logRes.username);

  mUserId = getIntAsync(USER_ID);

  await Future.forEach(logRes.plan!.subscriptions.validate(), (dynamic data) async {
    await setValue(SUBSCRIPTION_PLAN_STATUS, data.status);

    if (data.status == userPlanStatus) {
      await setValue(SUBSCRIPTION_PLAN_ID, data.subscription_plan_id);
      await setValue(SUBSCRIPTION_PLAN_START_DATE, data.start_date);
      await setValue(SUBSCRIPTION_PLAN_EXP_DATE, data.expiration_date);
      await setValue(SUBSCRIPTION_PLAN_TRIAL_STATUS, data.trail_status);
      await setValue(SUBSCRIPTION_PLAN_NAME, data.subscription_plan_name);
      await setValue(SUBSCRIPTION_PLAN_AMOUNT, data.billing_amount);
      await setValue(SUBSCRIPTION_PLAN_TRIAL_END_DATE, data.trial_end);

      appStore.setSubscriptionPlanId(data.subscription_plan_id);
      appStore.setSubscriptionPlanStartDate(data.start_date);
      appStore.setSubscriptionPlanExpDate(data.expiration_date);
      appStore.setSubscriptionPlanStatus(data.status);
      appStore.setSubscriptionPlanName(data.subscription_plan_name);
      appStore.setSubscriptionPlanAmount(data.billing_amount);
      appStore.setSubscriptionTrialPlanStatus(data.trail_status);
      appStore.setSubscriptionTrialPlanEndDate(data.trial_end);
    }
  });
}

Future<void> callNativeWebView(Map params) async {
  const platform = const MethodChannel('webviewChannel');

  if (isMobile) {
    await platform.invokeMethod('webview', params);
  }
}

Future<void> checkPlatformSpecific(BuildContext context) async {
  if (getStringAsync(ACCOUNT_PAGE).isNotEmpty) {
    await UrlLauncherScreen('${getStringAsync(ACCOUNT_PAGE)}').launch(context);
  } else {
    toast(redirectionUrlNotFound);
  }
}

Future<void> openInfoBottomSheet({required BuildContext context, Widget? data, String? btnText, VoidCallback? onTap, List<RestrictSubscriptionPlan>? restrictSubscriptionPlan}) async {
  double height = mIsLoggedIn ? 0.2 : 0.35;
  return showModalBottomSheet(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    builder: (_) => FractionallySizedBox(
      heightFactor: height,
      widthFactor: 1.0,
      child: DraggableScrollableSheet(
        initialChildSize: 1.0,
        minChildSize: 0.95,
        builder: (_, controller) {
          return Stack(
            children: [
              Container(
                height: context.height() * height,
                padding: EdgeInsets.all(16),
                width: context.width(),
                color: Colors.white,
                child: SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      data!,
                      16.height,
                      if (restrictSubscriptionPlan!.isNotEmpty && mIsLoggedIn)
                        Text(
                          "You can subscribe any of these plan(s)",
                          style: primaryTextStyle(size: 18, color: colorPrimary),
                          textAlign: TextAlign.center,
                        ),
                      8.height,
                      if (restrictSubscriptionPlan.isNotEmpty && mIsLoggedIn)
                        UL(
                          children: restrictSubscriptionPlan.map((e) => Text(e.label.validate(), style: primaryTextStyle(color: Colors.black))).toList(),
                          symbolType: SymbolType.Numbered,
                          symbolColor: Colors.black,
                        ),
                      24.height,
                    ],
                  ).center(),
                ),
              ).cornerRadiusWithClipRRectOnly(topRight: 32, topLeft: 32).paddingBottom(24),
              Positioned(
                bottom: 0,
                width: context.width(),
                child: Container(
                  color: Colors.white,
                  child: ElevatedButton(
                    child: Text(btnText!, style: boldTextStyle(color: white), textAlign: TextAlign.center),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(colorPrimary)),
                    onPressed: onTap,
                  ).paddingOnly(left: 64, right: 64),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

Future<void> movieTrialDialog(BuildContext context, String? url) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.9),
    barrierDismissible: false,
    builder: (_) {
      return Stack(
        children: [
          Positioned(
            right: 8,
            top: 16,
            child: GestureDetector(
              onTap: () {
                finish(context);
              },
              child: Icon(Icons.close),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: MovieURLWidget(url),
          ).paddingSymmetric(vertical: 50, horizontal: 8),
        ],
      );
    },
  );
}

Future<bool> getUserPlanData(List<RestrictSubscriptionPlan>? restPlan) async {
  for (var i in restPlan!) {
    if (appStore.subscriptionPlanName.validate().toLowerCase() == i.label!.toLowerCase() && appStore.subscriptionPlanStatus.validate() == userPlanStatus) {
      return true;
    }
  }
  return false;
}

Future<CommentModel> buildComment({int? parentId, required String content, required int? postId}) async {
  if (content.isNotEmpty) {
    CommentModel comment = CommentModel();

    comment.post = postId;
    comment.parent = parentId ?? 0;
    comment.author = getIntAsync(USER_ID).toInt();
    comment.authorName = getStringAsync(USERNAME);
    comment.date = DateTime.now().toString();
    comment.dateGmt = DateTime.now().toString();
    comment.commentData = content;
    comment.authorUrl = '';
    comment.link = '';

    return await addComment(comment.toJson()).then((value) {
      toast(language!.commentAdded);
      return value;
    }).catchError((error) {
      toast(error.toString());
    });
  } else {
    throw (language!.writeSomething);
  }
}

Future<void> multiCommentSheet(
    {BuildContext? context, int? id, List<CommentModel>? list, TextEditingController? controller, required int postId, int? parentId, Function(CommentModel)? onCommentSubmit}) async {
  return showModalBottomSheet(
    context: context!,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
    ),
    builder: (_) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                Column(
                  children: list!.map(
                    (e) {
                      return e.parent == id
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                  child: Text(
                                    e.authorName![0].validate(),
                                    style: boldTextStyle(color: colorPrimary, size: 20),
                                  ).center(),
                                ),
                                16.width,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(e.authorName.validate(), style: boldTextStyle(color: Colors.white54)),
                                            TextIcon(
                                              prefix: Icon(Icons.calendar_today_outlined, size: 14, color: textSecondaryColorGlobal),
                                              edgeInsets: EdgeInsets.zero,
                                              text: DateFormat('yyyy-MM-dd').format(DateTime.parse(e.date.validate())),
                                              textStyle: secondaryTextStyle(),
                                            )
                                          ],
                                        ).expand(),
                                        Container(
                                          child: TextButton(
                                            onPressed: () {
                                              e.isAddReply = !e.isAddReply;
                                              setState(() {});
                                            },
                                            child: Text('Add reply', style: primaryTextStyle(color: white, size: 14)),
                                            style: ButtonStyle(side: MaterialStateProperty.all(BorderSide(color: colorPrimary))),
                                          ),
                                        ).visible(mIsLoggedIn),
                                      ],
                                    ),
                                    4.height,
                                    Text(
                                      parseHtmlString(e.content!.rendered.validate()),
                                      style: primaryTextStyle(color: Colors.grey, size: 14),
                                    ),
                                    AppTextField(
                                      controller: controller!,
                                      textFieldType: TextFieldType.MULTILINE,
                                      maxLines: 3,
                                      textStyle: primaryTextStyle(color: textColorPrimary),
                                      decoration: InputDecoration(
                                        hintText: reply,
                                        hintStyle: secondaryTextStyle(),
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.send, size: 18),
                                          color: colorPrimary,
                                          onPressed: () {
                                            buildComment(content: controller.text.trim(), postId: postId, parentId: parentId).then((value) {
                                              controller.clear();
                                              onCommentSubmit!.call(value);
                                            }).catchError((error) {
                                              toast(errorSomethingWentWrong);
                                            });
                                          },
                                        ),
                                        border: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                                      ),
                                    ).visible(e.isAddReply),
                                    8.height,
                                    Divider(thickness: 0.1, color: textColorPrimary, height: 0),
                                    16.height,
                                    Column(
                                      children: list.map(
                                        (i) {
                                          return i.parent == e.id
                                              ? Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.all(12),
                                                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                                      child: Text(
                                                        i.authorName![0].validate(),
                                                        style: boldTextStyle(color: colorPrimary, size: 20),
                                                      ).center(),
                                                    ),
                                                    16.width,
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(i.authorName.validate(), style: boldTextStyle(color: Colors.white)),
                                                            TextIcon(
                                                              prefix: Icon(
                                                                Icons.calendar_today_outlined,
                                                                size: 14,
                                                                color: textSecondaryColorGlobal,
                                                              ),
                                                              edgeInsets: EdgeInsets.zero,
                                                              text: DateFormat('yyyy-MM-dd').format(DateTime.parse(i.date.validate())),
                                                              textStyle: secondaryTextStyle(),
                                                            )
                                                          ],
                                                        ),
                                                        8.height,
                                                        Text(
                                                          parseHtmlString(i.content!.rendered.validate()),
                                                          style: primaryTextStyle(color: Colors.grey, size: 14),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : SizedBox();
                                        },
                                      ).toList(),
                                    )
                                  ],
                                ).expand(),
                              ],
                            ).paddingSymmetric(vertical: 8, horizontal: 16)
                          : SizedBox();
                    },
                  ).toList(),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class TabIndicator extends Decoration {
  final BoxPainter painter = TabPainter();

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => painter;
}

class TabPainter extends BoxPainter {
  Paint? _paint;

  TabPainter() {
    _paint = Paint()..color = colorPrimary;
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Size size = Size(configuration.size!.width, 3);
    Offset _offset = Offset(offset.dx, offset.dy + 40);
    final Rect rect = _offset & size;
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect,
          bottomRight: Radius.circular(0),
          bottomLeft: Radius.circular(0),
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        _paint!);
  }
}

Future<void> launchUrl(String url, {bool forceWebView = false}) async {
  log(url);
  await url_launcher.launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView).catchError((e) {
    log(e);
    toast('Invalid URL: $url');
  });
}

String urlFromIframe({required String embedContent}) => parse(embedContent).getElementsByTagName('iframe')[0].attributes['src']!;

Future<void> launchCustomTabURL({required String url}) async {
  try {
    await custom_tab.launch(
      url.validate(),
      customTabsOption: custom_tab.CustomTabsOption(
        toolbarColor: colorPrimary,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        animation: custom_tab.CustomTabsSystemAnimation.slideIn(),
        extraCustomTabs: const <String>[
          // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
          'org.mozilla.firefox',
          // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
          'com.microsoft.emmx',
        ],
      ),
      safariVCOption: custom_tab.SafariViewControllerOption(
        preferredBarTintColor: Colors.white,
        preferredControlTintColor: Colors.white,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: false,
        dismissButtonStyle: custom_tab.SafariViewControllerDismissButtonStyle.close,
      ),
    );
  } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
  }
}

Future<bool> checkPermission() async {
  if (Platform.isIOS) return true;

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  if (isAndroid && androidInfo.version.sdkInt.validate() <= 28) {
    final status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      final result = await Permission.storage.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    } else {
      return true;
    }
  } else {
    return true;
  }
  return false;
}

Future<String> prepareSaveDir() async {
  final _localPath = (await getCachedDirPath())!;
  final savedDir = Directory(_localPath);
  bool hasExisted = await savedDir.exists();
  if (!hasExisted) {
    savedDir.create();
  }
  return savedDir.path;
}

Future<String?> getCachedDirPath() async {
  var externalStorageDirPath;
  if (Platform.isAndroid) {
    try {
      final directory = await getTemporaryDirectory();
      externalStorageDirPath = directory.path;
    } catch (e) {
      log("No path detected.");
    }
  } else if (Platform.isIOS) {
    externalStorageDirPath = (await getApplicationDocumentsDirectory()).absolute.path;
  }
  return externalStorageDirPath;
}

Future<void> addOrRemoveFromLocalStorage(DownloadData data, {bool isDelete = false}) async {
  List<DownloadData> list = getStringAsync(DOWNLOADED_DATA).isNotEmpty ? (jsonDecode(getStringAsync(DOWNLOADED_DATA)) as List).map((e) => DownloadData.fromJson(e)).toList() : [];

  if (list.isNotEmpty) {
    if (isDelete) {
      for (var i in list) {
        if (i.id == data.id) {
          list.remove(data);
          appStore.downloadedItemList.remove(data);
          break;
        }
      }
    } else {
      list.add(data);
      appStore.downloadedItemList.add(data);
    }
  } else {
    list.add(data);
    appStore.downloadedItemList.add(data);
  }

  log("Downloaded Item : ${list.map((e) => e.id)}");
  await setValue(DOWNLOADED_DATA, jsonEncode(list));
  log("Decoded downloaded items : ${getStringAsync(DOWNLOADED_DATA)}");
}

Future<File> getFilePath(String fileName) async {
  final filePath = await getCachedDirPath();
  File srcFilepath = File("$filePath/downloads/$fileName");
  return srcFilepath;
}
