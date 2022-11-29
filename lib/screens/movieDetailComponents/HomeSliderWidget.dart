import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/components/TrailerVideoWidget.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/screens/MovieDetailScreen.dart';
import 'package:streamit_flutter/utils/resources/Size.dart';

class DashboardSliderWidget extends StatefulWidget {
  final List<MovieData> mSliderList;

  DashboardSliderWidget(this.mSliderList);

  @override
  State<DashboardSliderWidget> createState() => _DashboardSliderWidgetState();
}

class _DashboardSliderWidgetState extends State<DashboardSliderWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = context.width();
    final Size cardSize = Size(width, context.height() * 0.26);

    return Container(
      height: cardSize.height,
      margin: EdgeInsets.only(top: 16),
      child: PageView.builder(
        itemCount: widget.mSliderList.length,
        onPageChanged: (i) {
          //
        },
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, idx) {
          MovieData slider = widget.mSliderList[idx];

          return Container(
            width: context.width(),
            height: cardSize.height,
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(borderRadius: radius(radius_container)),
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 0,
              margin: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius_container)),
              child: TrailerVideoWidget(
                  url: slider.trailer_link,
                  title: slider.title,
                  runTime: slider.run_time,
                  image: slider.attachment,
                  isVideoInLoop: true,
                  isShowTitle: true,
                  onTap: () async {
                    youtubePlayerController!.pause();
                    appStore.setTrailerVideoPlayer(true);
                    await MovieDetailScreen(movieData: slider, title: slider.title).launch(context);
                    youtubePlayerController!.play();
                  }),
            ),
          );
        },
      ),
    );
  }
}
