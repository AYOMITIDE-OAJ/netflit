import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/network/NetworkUtils.dart';
import 'package:streamit_flutter/network/RestApis.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Common.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';
import 'package:streamit_flutter/utils/resources/Images.dart';
import 'package:streamit_flutter/utils/resources/Size.dart';

class SubscriptionDetailWidget extends StatefulWidget {
  @override
  _SubscriptionDetailWidgetState createState() => _SubscriptionDetailWidgetState();
}

class _SubscriptionDetailWidgetState extends State<SubscriptionDetailWidget> {
  Map req = {
    "username": getStringAsync(USERNAME),
    "password": getStringAsync(PASSWORD),
  };

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return appStore.subscriptionPlanStatus.validate() == userPlanStatus
            ? Container(
                width: context.width(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 3)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appStore.subscriptionPlanName.validate(),
                      style: primaryTextStyle(color: white, size: 24),
                    ).paddingOnly(top: 8, left: 16, right: 16, bottom: 4),
                    if (appStore.subscriptionPlanName.validate() != planName)
                      Text(
                        language!.validTill + appStore.subscriptionPlanExpDate.validate().getFormattedDate()!,
                        style: primaryTextStyle(color: white),
                      ).paddingOnly(top: 4, left: 16, right: 16),
                    AppButton(
                      child: Text(language!.upgradePlan, style: boldTextStyle(color: white)),
                      color: colorPrimary,
                      onTap: () async {
                        if (getStringAsync(ACCOUNT_PAGE).isNotEmpty) {
                          await checkPlatformSpecific(context).then((value) async {
                            appStore.setLoading(true);
                            await refreshToken();
                            await getUserProfileDetails().then((value) {
                              setState(() {});
                            });
                            appStore.setLoading(false);
                          }).catchError((e) {
                            appStore.setLoading(false);
                          });
                        } else {
                          appStore.setLoading(false);
                          toast(redirectionUrlNotFound);
                        }
                      },
                      width: context.width(),
                    ).paddingOnly(left: 8, right: 8, top: 8, bottom: 8)
                  ],
                ),
              ).paddingOnly(left: spacing_standard_new, right: spacing_standard_new, top: 6, bottom: 6)
            : subType(
                context,
                () async {
                  if (getStringAsync(ACCOUNT_PAGE).isNotEmpty) {
                    await checkPlatformSpecific(context).then((value) async {
                      appStore.setLoading(true);
                      await refreshToken();
                      await getUserProfileDetails().then((value) {
                        setState(() {});
                      });
                    });
                    appStore.setLoading(false);
                  } else {
                    toast(language!.somethingWantWrongPleaseContactYourAdministrator);
                  }
                },
                ic_subscribe,
                title: language!.subscribeNow,
              );
      },
    );
  }
}
