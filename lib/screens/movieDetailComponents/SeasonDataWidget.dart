import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/screens/EpisodeDetailScreen.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Common.dart';
import 'package:streamit_flutter/utils/resources/Size.dart';

class SeasonDataWidget extends StatefulWidget {
  static String tag = '/SeasonDataWidget';
  final List<Season> seasons;
  final MovieData? movie;

  SeasonDataWidget(this.seasons, this.movie);

  @override
  SeasonDataWidgetState createState() => SeasonDataWidgetState();
}

class SeasonDataWidgetState extends State<SeasonDataWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.seasons.map(
        (e) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(e.name.validate(), style: boldTextStyle(color: Colors.white)).paddingLeft(16),
              16.height,
              Container(
                child: HorizontalList(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  itemCount: e.episode!.length,
                  itemBuilder: (_, index) {
                    Episode episode = e.episode![index];

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      width: 200,
                      child: Stack(
                        children: [
                          commonCacheImageWidget(
                            episode.image.validate(),
                            width: 200,
                            height: 110,
                            fit: BoxFit.cover,
                          ).cornerRadiusWithClipRRect(radius_container),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 200,
                              height: 110,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Theme.of(context).scaffoldBackgroundColor],
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.mirror,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 4,
                            top: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  episode.run_time.validate(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    shadows: <Shadow>[
                                      Shadow(blurRadius: 8.0, color: Colors.black),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            left: 4,
                            right: 4,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  episode.title.validate(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    shadows: <Shadow>[
                                      Shadow(blurRadius: 5.0, color: Colors.black),
                                    ],
                                  ),
                                ),
                                Text(
                                  parseHtmlString(episode.description.validate()),
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                    shadows: <Shadow>[
                                      Shadow(blurRadius: 5.0, color: Colors.black),
                                    ],
                                  ),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).onTap(() async {
                      youtubePlayerController!.pause();
                      EpisodeDetailScreen(
                        title: episode.title.validate(),
                        episode: episode,
                        episodes: e.episode,
                        index: index,
                        lastIndex: e.episode!.length,
                      ).launch(context);
                    });
                  },
                ),
              )
            ],
          ).paddingOnly(top: 8);
        },
      ).toList(),
    ).visible(widget.seasons.isNotEmpty);
  }
}
