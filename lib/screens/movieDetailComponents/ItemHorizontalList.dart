import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/network/NetworkUtils.dart';
import 'package:streamit_flutter/network/RestApis.dart';
import 'package:streamit_flutter/screens/MovieDetailScreen.dart';
import 'package:streamit_flutter/screens/UrlLauncherScreen.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Common.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Size.dart';

// ignore: must_be_immutable
class ItemHorizontalList extends StatefulWidget {
  List<MovieData> list = [];
  bool isMovie = false;

  ItemHorizontalList(this.list, {this.isMovie = false});

  @override
  _ItemHorizontalListState createState() => _ItemHorizontalListState();
}

class _ItemHorizontalListState extends State<ItemHorizontalList> {
  @override
  Widget build(BuildContext context) {
    return HorizontalList(
      itemCount: widget.list.length,
      padding: EdgeInsets.symmetric(horizontal: 8),
      itemBuilder: (context, index) {
        MovieData data = widget.list[index];

        return SizedBox(
          height: 140,
          width: 190,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 110,
                    child: commonCacheImageWidget(
                      data.image.validate(),
                      height: context.height(),
                      width: context.width(),
                      fit: BoxFit.cover,
                    ).cornerRadiusWithClipRRect(radius_container),
                  ),
                  hdWidget(context).visible(data.isHD.validate()),
                ],
              ),
              6.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  itemTitle(context, parseHtmlString(data.title.validate()), fontSize: ts_small, textAlign: TextAlign.start).expand(),
                  Text(
                    data.run_time.validate(),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      shadows: <Shadow>[
                        Shadow(blurRadius: 5.0, color: Colors.black),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ).visible(data.run_time.validate().isNotEmpty),
                ],
              ).paddingSymmetric(horizontal: 4),
            ],
          ).onTap(() async {
            youtubePlayerController!.pause();
            if (RestrictionTypeRedirect == data.restrictionSetting!.restrict_type) {
              await UrlLauncherScreen(data.restrictionSetting!.restrict_url).launch(context).then((value) async {
                await refreshToken();
                getUserProfileDetails().then((value) {
                  setState(() {});
                });
              });
            } else {
              appStore.setTrailerVideoPlayer(true);
              await MovieDetailScreen(movieData: data).launch(context);
            }
            youtubePlayerController!.play();
          }, borderRadius: BorderRadius.circular(radius_container)),
        ).paddingSymmetric(horizontal: 8);
      },
    );
  }
}
