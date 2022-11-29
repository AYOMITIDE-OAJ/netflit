import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

class MovieFileWidget extends StatefulWidget {
  final String url;
  final bool isFromLocalStorage;

  MovieFileWidget(this.url, {this.isFromLocalStorage = false});

  @override
  MovieFileWidgetState createState() => MovieFileWidgetState();
}

class MovieFileWidgetState extends State<MovieFileWidget> {
  late BetterPlayerController _betterPlayerController;
  late BetterPlayerDataSource betterPlayerDataSource;

  @override
  void initState() {
    if (widget.isFromLocalStorage) {
      betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.file,
        widget.url.validate(),
      );
    } else {
      betterPlayerDataSource = BetterPlayerDataSource(BetterPlayerDataSourceType.network, widget.url);
    }
    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(),
      betterPlayerDataSource: betterPlayerDataSource,
    );
    super.initState();

    _betterPlayerController.addEventsListener((p0) {
      if (_betterPlayerController.isFullScreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
      }
    });
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return BetterPlayer(
      controller: _betterPlayerController,
    );
  }
}
