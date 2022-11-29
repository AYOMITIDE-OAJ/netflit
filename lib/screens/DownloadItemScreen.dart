import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/components/LocalMediaPlayerComponent.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/models/DownloadData.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Common.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';
import 'package:streamit_flutter/utils/resources/Images.dart';

class DownloadItemScreen extends StatefulWidget {
  const DownloadItemScreen({Key? key}) : super(key: key);

  @override
  State<DownloadItemScreen> createState() => _DownloadItemScreenState();
}

enum Menu { Delete }

class _DownloadItemScreenState extends State<DownloadItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text(language!.downloadedVideos, style: primaryTextStyle(size: 18)),
          ),
          body: appStore.downloadedItemList.isNotEmpty
              ? SingleChildScrollView(
                  child: Wrap(
                    children: appStore.downloadedItemList.map((e) {
                      int index = appStore.downloadedItemList.indexOf(e);
                      DownloadData data = appStore.downloadedItemList[index];
                      return data.userId == getIntAsync(USER_ID)
                          ? Container(
                              margin: EdgeInsets.all(8),
                              width: context.width() / 2 - 24,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Stack(
                                    children: [
                                      commonCacheImageWidget(
                                        data.image.validate(),
                                        height: 120,
                                        width: context.width() / 2 - 24,
                                        fit: BoxFit.cover,
                                      ).cornerRadiusWithClipRRect(defaultRadius),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(100),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0, tileMode: TileMode.mirror),
                                            child: Container(
                                              padding: EdgeInsets.all(4),
                                              margin: EdgeInsets.all(4),
                                              child: Icon(Icons.delete, color: colorPrimary, size: 18),
                                            ),
                                          ),
                                        ).paddingAll(4).onTap(() async {
                                          await showConfirmDialogCustom(
                                            context,
                                            primaryColor: colorPrimary,
                                            cancelable: false,
                                            title: language!.areYouSureYouWantDeleteThisMovie,
                                            onAccept: (_) async {
                                              try {
                                                addOrRemoveFromLocalStorage(data, isDelete: true);
                                                finish(context);
                                              } catch (e) {
                                                finish(context);
                                                log("Error : ${e.toString()}");
                                              }
                                            },
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  8.height,
                                  Text(parseHtmlString(data.title.validate()),
                                      style: boldTextStyle(size: 18), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  4.height,
                                  itemSubTitle(context, data.duration.validate(), fontSize: 14, textColor: textColorSecondary),
                                ],
                              ),
                            ).onTap(() {
                              LocalMediaPlayerComponent(data: data).launch(context);
                            })
                          : Offstage();
                    }).toList(),
                  ).paddingAll(8),
                )
              : NoDataWidget(
                  imageWidget: Image.asset(ic_empty, height: 130),
                  title: language!.noData,
                ).center(),
        );
      },
    );
  }
}
