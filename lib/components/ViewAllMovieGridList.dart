import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/screens/MovieDetailScreen.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/resources/Size.dart';

// ignore: must_be_immutable
class AllMovieGridList extends StatelessWidget {
  List<MovieData> list = [];
  bool isHorizontal = false;

  AllMovieGridList(this.list);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Wrap(
        runSpacing: 16,
        spacing: 16,
        children: list.map((bookDetail) {
          return InkWell(
            onTap: () {
              appStore.setTrailerVideoPlayer(true);
              MovieDetailScreen(title: language!.action, movieData: bookDetail).launch(context);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonCacheImageWidget(
                  bookDetail.image.validate(),
                  fit: BoxFit.cover,
                  width: context.width() / 2 - 24,
                  height: 100,
                ).cornerRadiusWithClipRRect(radius_container),
                6.height,
                SizedBox(
                  width: context.width() / 2 - 24,
                  child: itemTitle(context, bookDetail.title!, fontSize: ts_small, textAlign: TextAlign.start),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
