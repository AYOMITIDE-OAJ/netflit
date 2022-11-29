import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/components/VideoVolumeWidget.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Common.dart';
import 'package:streamit_flutter/utils/resources/Size.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../main.dart';

class TrailerVideoWidget extends StatefulWidget {
  final String? url;
  final String? title;
  final String? runTime;
  final String? image;
  final VoidCallback? onTap;
  final bool isShowTitle;
  final bool isVideoInLoop;

  TrailerVideoWidget({this.url, this.title, this.runTime, this.onTap, this.isShowTitle = false, this.image, this.isVideoInLoop = false});

  @override
  TrailerVideoWidgetState createState() => TrailerVideoWidgetState();
}

class TrailerVideoWidgetState extends State<TrailerVideoWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    _controller = YoutubePlayerController(
      initialVideoId: widget.url.toYouTubeId(),
      flags: YoutubePlayerFlags(
        mute: true,
        autoPlay: true,
        disableDragSeek: false,
        loop: widget.isVideoInLoop,
        isLive: false,
        forceHD: false,
        enableCaption: true,
        hideControls: true,
      ),
    );
    youtubePlayerController = _controller;
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = context.width();
    final Size cardSize = Size(width, context.height() * 0.3);

    return Container(
      width: context.width(),
      height: cardSize.height,
      decoration: BoxDecoration(borderRadius: radius(radius_container)),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: radius(radius_container)),
        margin: EdgeInsets.all(0),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            widget.url.validate().isEmpty
                ? commonCacheImageWidget(widget.image.validate(), width: cardSize.width, height: cardSize.height, fit: BoxFit.cover).cornerRadiusWithClipRRect(radius_container)
                : YoutubePlayerBuilder(
                    player: YoutubePlayer(
                      controller: _controller,
                      onReady: () {
                        //
                      },
                      onEnded: (data) {
                        //
                      },
                    ),
                    builder: (context, player) {
                      return player;
                    },
                  ),
            Container(
              width: width,
              height: cardSize.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    context.scaffoldBackgroundColor,
                  ],
                  stops: [0.3, 1.0],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  tileMode: TileMode.mirror,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.isShowTitle
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            itemTitle(context, parseHtmlString(widget.title.validate()), fontSize: ts_xlarge, maxLine: 2, textAlign: TextAlign.start),
                            Text(
                              widget.runTime.validate(),
                              style: boldTextStyle(size: 10, color: textSecondaryColorGlobal),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ).visible(widget.runTime.validate().isNotEmpty),
                          ],
                        ).paddingOnly(left: 16, bottom: 8, top: 50, right: 16).expand()
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.play_arrow_rounded, size: 24),
                            4.width,
                            itemTitle(context, language!.watchNow, fontSize: ts_large),
                          ],
                        ).paddingOnly(left: 16, bottom: 8, top: 50),
                  if (widget.url.validate().isNotEmpty) VideoVolumeWidget(controller: _controller),
                ],
              ),
            ),
          ],
        ),
      ).paddingBottom(spacing_control),
    ).onTap(() async {
      widget.onTap?.call();
    }, splashColor: Colors.transparent, highlightColor: Colors.transparent);
  }
}
