import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/network/NetworkUtils.dart';
import 'package:streamit_flutter/network/RestApis.dart';
import 'package:streamit_flutter/screens/EpisodeDetailScreen.dart';
import 'package:streamit_flutter/screens/MovieDetailScreen.dart';
import 'package:streamit_flutter/screens/UrlLauncherScreen.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Common.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Size.dart';

// ignore: must_be_immutable
class MovieGridList extends StatefulWidget {
  List<MovieData> list = [];

  MovieGridList(this.list);

  @override
  State<MovieGridList> createState() => _MovieGridListState();
}

class _MovieGridListState extends State<MovieGridList> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: widget.list.map((e) {
        MovieData data = e;

        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            if (RestrictionTypeRedirect == data.restrictionSetting!.restrict_type) {
              await UrlLauncherScreen(data.restrictionSetting!.restrict_url).launch(context).then((value) async {
                await refreshToken();
                getUserProfileDetails().then((value) {
                  setState(() {});
                });
              });
            } else {
              if (data.post_type == PostType.EPISODE) {
                Episode episode = Episode();
                episode.title = data.title;
                episode.image = data.image;
                episode.id = data.id;
                episode.post_type = "episode";
                episode.description = data.description;
                episode.excerpt = data.excerpt;
                episode.restrict_subscription_plan = data.restSubPlan;
                episode.restrict_user_status = data.restrict_user_status;
                episode.is_post_restricted = data.is_post_restricted;
                episode.user_has_pms_member = data.user_has_pms_member;
                episode.trailer_link = data.trailer_link;

                await EpisodeDetailScreen(episode: episode, episodes: []).launch(context);
              } else {
                appStore.setTrailerVideoPlayer(true);
                await MovieDetailScreen(movieData: data).launch(context);
              }
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              commonCacheImageWidget(
                data.image.validate(),
                fit: BoxFit.cover,
                width: context.width() / 2 - 24,
                height: 100,
              ).cornerRadiusWithClipRRect(radius_container),
              6.height,
              SizedBox(
                width: context.width() / 2 - 24,
                child: Text(
                  parseHtmlString(data.title.validate()),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: ts_small,
                    shadows: <Shadow>[
                      Shadow(blurRadius: 5.0, color: Colors.black),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ).paddingSymmetric(horizontal: 8),
              ),
            ],
          ),
        );
      }).toList(),
    ).paddingAll(16);
  }
}
