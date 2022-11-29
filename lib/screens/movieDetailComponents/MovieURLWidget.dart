import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/screens/movieDetailComponents/MovieFileWidget.dart';
import 'package:streamit_flutter/utils/Common.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../main.dart';

// ignore: must_be_immutable
class MovieURLWidget extends StatefulWidget {
  static String tag = '/MovieURLWidget';

  String? url;

  MovieURLWidget(this.url);

  @override
  MovieURLWidgetState createState() => MovieURLWidgetState();
}

class MovieURLWidgetState extends State<MovieURLWidget> {
  bool isYoutubeUrl = true;
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isYoutubeUrl = widget.url.validate().isYoutubeUrl;
    if (isYoutubeUrl) {
      _controller = YoutubePlayerController(
        initialVideoId: widget.url.toYouTubeId(),
        flags: const YoutubePlayerFlags(),
      );
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isYoutubeUrl
        ? Observer(builder: (context) {
            return SizedBox(
              width: context.width(),
              height: appStore.hasInFullScreen ? context.height() - context.statusBarHeight : null,
              child: YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: _controller!,
                  onReady: () {
                    //
                  },
                  onEnded: (data) {
                    //
                  },
                ),
                onEnterFullScreen: () {
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
                  appStore.setToFullScreen(true);
                },
                onExitFullScreen: () {
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
                  appStore.setToFullScreen(false);
                },
                builder: (context, player) {
                  return player;
                },
              ),
            );
          })
        : widget.url.validate().isVideoPlayerFile
            ? MovieFileWidget(widget.url.validate())
            : SizedBox(
                width: context.width(),
                height: appStore.hasInFullScreen ? context.height() - context.statusBarHeight : null,
                child: Stack(
                  children: [
                    WebView(
                      initialUrl: widget.url,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebResourceError: (e) {
                        log(e.toString());
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          if (appStore.hasInFullScreen) {
                            appStore.setToFullScreen(false);
                            SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
                          } else {
                            appStore.setToFullScreen(true);
                            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
                          }
                        },
                        icon: Icon(appStore.hasInFullScreen ? Icons.fullscreen_exit : Icons.fullscreen_sharp),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
  }
}
