import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/resources/Images.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language!.aboutUs, color: context.cardColor),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          commonCacheImageWidget(ic_logo, width: 120),
          16.height,
          Text("Streamit - Video Streaming App", style: boldTextStyle(size: 22)),
          8.height,
          Text(aboutApp, style: secondaryTextStyle()),
        ],
      ).paddingAll(16),
    );
  }

  String get aboutApp =>
      "STREAMIT – Video Streaming Full App for WordPress is a powerful media and video streaming WordPress project. Build your site with this easy-to-customize and feature-rich WordPress Theme. Streamit App is a perfect package for video, movie, show streaming related mobile app. It also allows you to to create a list of movies, videos and TV shows. It has a user interface with an amazing UX, and multiple homepage versions. Streamit gives a very rich native feel and is optimized for fast responsiveness.";
}
