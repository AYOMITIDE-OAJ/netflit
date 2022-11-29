import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/network/RestApis.dart';
import 'package:streamit_flutter/utils/Common.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';

import '../Signin.dart';

class MovieDetailLikeWatchListWidget extends StatefulWidget {
  static String tag = '/LikeWatchlistWidget';
  final MovieData? movie;

  MovieDetailLikeWatchListWidget(this.movie);

  @override
  MovieDetailLikeWatchListWidgetState createState() => MovieDetailLikeWatchListWidgetState();
}

class MovieDetailLikeWatchListWidgetState extends State<MovieDetailLikeWatchListWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  Future<void> watchlistClick() async {
    if (!mIsLoggedIn) {
      SignInScreen().launch(context);
      return;
    }
    Map req = {
      'post_id': widget.movie!.id.validate(),
      'user_id': getIntAsync(USER_ID),
    };

    widget.movie!.isInWatchList = !widget.movie!.isInWatchList.validate();
    setState(() {});

    await watchlistMovie(req).then((res) {
      //widget.movie.isInWatchList = res.isAdded.validate();
      //setState(() {});
    }).catchError((e) {
      widget.movie!.isInWatchList = !widget.movie!.isInWatchList.validate();
      toast(e.toString());

      setState(() {});
    });
  }

  Future<void> likeClick() async {
    if (!mIsLoggedIn) {
      SignInScreen().launch(context);
      return;
    }

    Map req = {
      'post_id': widget.movie!.id.validate(),
    };
    widget.movie!.isLiked = !widget.movie!.isLiked.validate();

    if (widget.movie!.isLiked.validate()) {
      widget.movie!.likes = widget.movie!.likes.validate() + 1;
    } else {
      widget.movie!.likes = widget.movie!.likes.validate() - 1;
    }
    setState(() {});

    await likeMovie(req).then((res) {}).catchError((e) {
      widget.movie!.isLiked = !widget.movie!.isLiked.validate();
      if (widget.movie!.isLiked.validate()) {
        widget.movie!.likes = widget.movie!.likes! + 1;
      } else {
        widget.movie!.likes = widget.movie!.likes! - 1;
      }
      toast(e.toString());

      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            AppButton(
              color: Colors.grey.withOpacity(0.1),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(widget.movie!.isLiked.validate() ? Icons.favorite : Icons.favorite_border, color: colorPrimary),
                  4.width,
                  AutoSizeText(
                    buildLikeCountText(widget.movie!.likes.validate()),
                    style: primaryTextStyle(color: textColorPrimary),
                  ).paddingLeft(4)
                ],
              ),
              onTap: () {
                likeClick();
              },
            ).expand(),
            8.width,
            AppButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.movie!.isInWatchList.validate() ? Icons.check : Icons.add, color: colorPrimary),
                  4.width,
                  AutoSizeText(
                    widget.movie!.isInWatchList.validate() ? language!.addedToList : language!.myList,
                    style: primaryTextStyle(color: textColorPrimary),
                  )
                ],
              ),
              onTap: () => watchlistClick(),
              color: Colors.grey.withOpacity(0.1),
            ).expand(),
          ],
        ),
      ],
    );
  }
}
