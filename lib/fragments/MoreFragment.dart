import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/components/SubscriptionDetailWidget.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/network/RestApis.dart';
import 'package:streamit_flutter/screens/ChangePasswordScreen.dart';
import 'package:streamit_flutter/screens/DownloadItemScreen.dart';
import 'package:streamit_flutter/screens/EditProfileScreen.dart';
import 'package:streamit_flutter/screens/LanguageScreen.dart';
import 'package:streamit_flutter/screens/Signin.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Common.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';
import 'package:streamit_flutter/utils/resources/Images.dart';
import 'package:streamit_flutter/utils/resources/Size.dart';

class MoreFragment extends StatefulWidget {
  static String tag = '/MoreFragment';

  @override
  MoreFragmentState createState() => MoreFragmentState();
}

class MoreFragmentState extends State<MoreFragment> {
  String userName = "";
  String userEmail = "";
  bool isLoaderShow = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    userName = '${getStringAsync(NAME)} ${getStringAsync(LAST_NAME)}';
    userEmail = getStringAsync(USER_EMAIL);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(language!.settings, style: primaryTextStyle(size: ts_large.toInt(), color: textColorPrimary)),
          backgroundColor: Theme.of(context).cardColor,
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Observer(
                    builder: (_) => Container(
                      color: Theme.of(context).cardColor,
                      padding: EdgeInsets.only(
                        left: spacing_standard_new,
                        top: spacing_standard_new,
                        right: 12,
                        bottom: spacing_standard_new,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: spacing_standard_new,
                            margin: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
                            child: commonCacheImageWidget(
                              appStore.userProfileImage.validate(),
                              height: 70,
                              width: 70,
                              fit: BoxFit.cover,
                            ).visible(
                              appStore.userProfileImage!.isNotEmpty,
                              defaultWidget: commonCacheImageWidget(
                                appStore.userProfileImage.validate(),
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          20.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('${appStore.userFirstName} ${appStore.userLastName}', style: boldTextStyle(size: 22)),
                                Text(userEmail, style: secondaryTextStyle(color: Colors.grey.shade500)),
                              ],
                            ),
                          ),
                          Image.asset(
                            ic_edit_profile,
                            width: 20,
                            height: 20,
                            color: colorPrimary,
                          ).paddingAll(spacing_control).onTap(() {
                            EditProfileScreen().launch(context);
                          })
                        ],
                      ),
                    ).visible(appStore.isLogging),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Divider(height: 0, thickness: 1),
                      Observer(
                        builder: (_) => Container(
                          width: context.width(),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(color: context.cardColor),
                          child: Text(language!.membershipPlan, style: boldTextStyle(size: 22, color: Colors.white)),
                        ).visible(appStore.isLogging),
                      ),
                      SubscriptionDetailWidget().visible(appStore.isLogging),
                      if (appStore.isLogging) ...[
                        Divider(height: 0),
                        SettingSection(
                          title: Text(language!.downloads, style: boldTextStyle(size: 22, color: Colors.white)),
                          headingDecoration: BoxDecoration(color: context.cardColor),
                          items: [
                            SettingItemWidget(
                              title: language!.downloadedVideos,
                              subTitle: language!.watchVideosOffline,
                              titleTextStyle: primaryTextStyle(color: Colors.white),
                              leading: Image.asset(ic_download, color: Colors.white),
                              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).textTheme.caption!.color),
                              onTap: () {
                                DownloadItemScreen().launch(context);
                              },
                            ),
                          ],
                        ),
                      ],
                      Divider(height: 0),
                      SettingSection(
                        headingDecoration: BoxDecoration(color: context.cardColor),
                        title: Text(language!.generalSettings, style: boldTextStyle(size: 22, color: Colors.white)),
                        items: [
                          SettingItemWidget(
                            title: language!.changePassword,
                            subTitle: language!.changePasswordText,
                            titleTextStyle: primaryTextStyle(color: Colors.white),
                            leading: Image.asset(ic_password, color: Colors.white),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).textTheme.caption!.color),
                            onTap: () {
                              ChangePasswordScreen().launch(context);
                            },
                          ).visible(getBoolAsync(isLoggedIn)),
                          SettingItemWidget(
                            leading: Icon(FontAwesome.language, color: context.iconColor),
                            title: language!.language,
                            titleTextStyle: primaryTextStyle(color: Colors.white),
                            subTitle: getSelectedLanguageModel()?.name.validate(),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).textTheme.caption!.color),
                            onTap: () {
                              LanguageScreen().launch(context);
                            },
                          ),
                        ],
                      ),
                      Divider(height: 0),
                      SettingSection(
                        title: Text(language!.others, style: boldTextStyle(size: 22, color: Colors.white)),
                        headingDecoration: BoxDecoration(color: context.cardColor),
                        items: [
                          SettingItemWidget(
                            title: language!.aboutUs,
                            titleTextStyle: primaryTextStyle(color: Colors.white),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).textTheme.caption!.color),
                            onTap: () {
                              launchCustomTabURL(url: aboutUsURL);
                            },
                          ),
                          SettingItemWidget(
                            title: language!.termsConditions,
                            titleTextStyle: primaryTextStyle(color: Colors.white),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).textTheme.caption!.color),
                            onTap: () {
                              launchCustomTabURL(url: termsConditionURL);
                            },
                          ),
                          SettingItemWidget(
                            title: language!.privacyPolicy,
                            titleTextStyle: primaryTextStyle(color: Colors.white),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).textTheme.caption!.color),
                            onTap: () {
                              launchCustomTabURL(url: privacyPolicyURL);
                            },
                          ),
                          SettingItemWidget(
                            title: language!.logOut,
                            titleTextStyle: primaryTextStyle(color: Colors.white),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).textTheme.caption!.color),
                            onTap: () {
                              showConfirmDialogCustom(
                                context,
                                title: language!.doYouWantToLogout,
                                primaryColor: colorPrimary,
                                negativeText: language!.no,
                                positiveText: language!.yes,
                                onAccept: (context) async {
                                  String? path = await getCachedDirPath();
                                  Directory _file = Directory("$path/downloads/");
                                  if (_file.existsSync()) {
                                    _file.deleteSync(recursive: true);
                                    await removeKey(DOWNLOADED_DATA);
                                    appStore.downloadedItemList.clear();
                                  }
                                  logout(context);
                                  finish(context);
                                },
                              );
                            },
                          ).visible(getBoolAsync(isLoggedIn)),
                          SettingItemWidget(
                            title: language!.login,
                            titleTextStyle: primaryTextStyle(color: Colors.white),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).textTheme.caption!.color),
                            onTap: () async {
                              await SignInScreen().launch(context);
                            },
                          ).visible(!getBoolAsync(isLoggedIn)),
                        ],
                      ),
                      SettingSection(
                        title: Text(language!.danger, style: boldTextStyle(size: 22, color: Colors.red)),
                        headingDecoration: BoxDecoration(color: Colors.red.withOpacity(0.1)),
                        items: [
                          SettingItemWidget(
                            title: language!.deleteAccount,
                            titleTextStyle: primaryTextStyle(color: Colors.redAccent),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.redAccent),
                            onTap: () async {
                              bool? isDeleteAccount = await showConfirmDialogCustom(
                                context,
                                title: language!.areYouSureYou,
                                primaryColor: colorPrimary,
                                negativeText: language!.no,
                                positiveText: language!.yes,
                                onAccept: (context) async {
                                  finish(context, true);
                                },
                              );
                              if (isDeleteAccount.validate()) {
                                appStore.setLoading(true);
                                await deleteUserAccount().then((value) {
                                  appStore.setLoading(false);
                                  logout(context);
                                  SignInScreen().launch(context, isNewTask: true);
                                }).catchError((e) {
                                  appStore.setLoading(false);
                                  toast(language!.somethingWentWrong);
                                  log("Delete user account error : ${e.toString()}");
                                });
                              }
                            },
                          ),
                        ],
                      ).visible(getBoolAsync(isLoggedIn)),
                    ],
                  ).paddingBottom(spacing_large)
                ],
              ),
            ),
            Observer(
                builder: (_) => Image.asset(
                      ic_loading_gif,
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    ).center().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
