import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/models/GenreData.dart';
import 'package:streamit_flutter/screens/GenreMovieListScreen.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Common.dart';
import 'package:streamit_flutter/utils/resources/Size.dart';

// ignore: must_be_immutable
class GenreGridListWidget extends StatelessWidget {
  List<GenreData> list = [];
  String type;

  GenreGridListWidget(this.list, this.type);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 16,
      spacing: 16,
      children: list.map(
        (e) {
          GenreData data = list[list.indexOf(e)];

          return InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              GenreMovieListScreen(genre: data.slug, type: type).launch(context);
            },
            child: Container(
              width: context.width() / 2 - 24,
              height: 100,
              child: Stack(
                children: [
                  commonCacheImageWidget(
                    data.genreImage.validate(),
                    fit: BoxFit.cover,
                    width: context.width(),
                    height: context.height(),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.only(top: 18, bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: radiusOnly(bottomLeft: defaultRadius, bottomRight: defaultRadius),
                        gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            ...List<Color>.generate(16, (index) => Colors.black.withAlpha(index * 10)),
                          ],
                        ),
                        // color: Colors.black.withAlpha(100),
                      ),
                      child: Text(
                        '${parseHtmlString(data.name.validate())}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          shadows: <Shadow>[Shadow(color: Colors.black, blurRadius: 5.0)],
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ).cornerRadiusWithClipRRect(radius_container),
            ),
          );
        },
      ).toList(),
    ).paddingAll(16);
  }
}
