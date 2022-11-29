import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/components/EmbedWidget.dart';
import 'package:streamit_flutter/screens/movieDetailComponents/MovieFileWidget.dart';
import 'package:streamit_flutter/screens/movieDetailComponents/MovieURLWidget.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Constants.dart';

import '../main.dart';

class VideoContentWidget extends StatelessWidget {
  final String? choice;
  final String? urlLink;
  final String? embedContent;
  final String? fileLink;
  final String? image;

  VideoContentWidget({
    this.choice,
    this.urlLink,
    this.embedContent,
    this.fileLink,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    if (choice.validate() == movieChoiceURL || choice.validate() == videoChoiceURL || choice.validate() == episodeChoiceURL) {
      return MovieURLWidget(urlLink.validate());
    } else if (choice.validate() == movieChoiceEmbed || choice.validate() == videoChoiceEmbed || choice.validate() == episodeChoiceEmbed) {
      return EmbedWidget(embedContent.validate());
    } else if (choice.validate() == movieChoiceFile || choice.validate() == videoChoiceFile || choice.validate() == episodeChoiceFile) {
      return MovieFileWidget(fileLink.validate());
    } else {
      return Container(
        width: context.width(),
        height: appStore.hasInFullScreen ? context.height() - context.statusBarHeight : context.height() * 0.3,
        child: commonCacheImageWidget(image.validate(), fit: BoxFit.cover),
      );
    }
  }
}
