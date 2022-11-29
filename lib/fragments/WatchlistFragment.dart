import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/network/RestApis.dart';
import 'package:streamit_flutter/screens/MovieDetailScreen.dart';
import 'package:streamit_flutter/screens/Signin.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';
import 'package:streamit_flutter/utils/resources/Images.dart';
import 'package:streamit_flutter/utils/resources/Size.dart';

import '../main.dart';

class WatchlistFragment extends StatefulWidget {
  static String tag = '/WatchlistFragment';

  @override
  WatchlistFragmentState createState() => WatchlistFragmentState();
}

class WatchlistFragmentState extends State<WatchlistFragment> {
  int userId = 0;

  BannerAd? bannerAd;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    bannerAd = buildBannerAds()..load();
    userId = getIntAsync(USER_ID);
  }

  /// todo: remove commented code
  BannerAd buildBannerAds() {
    return BannerAd(
      size: AdSize.banner,
      request: AdRequest(),
      adUnitId: mAdMobBannerId,
      // adUnitId: kReleaseMode ? mAdMobBannerId : BannerAd.testAdUnitId,
      listener: BannerAdListener(onAdLoaded: (ad) {
        //
      }),
    );
  }

  @override
  void dispose() {
    bannerAd!.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language!.watchList, showBack: false, color: Theme.of(context).cardColor, textColor: Colors.white),
      body: SnapHelperWidget<MovieResponse>(
        future: getWatchList(),
        onSuccess: (MovieResponse? res) {
          if (res!.data!.isEmpty) {
            return NoDataWidget(
              imageWidget: Image.asset(ic_empty, height: 130),
              title: language!.noData,
            ).center();
          }
          return SizedBox(
            height: context.height(),
            width: context.width(),
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 65),
                  child: Wrap(
                    runSpacing: 16,
                    spacing: 16,
                    children: res.data!.map((e) {
                      MovieData data = res.data![res.data!.indexOf(e)];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: context.width() / 2 - 24,
                            height: 100,
                            child: Stack(
                              children: <Widget>[
                                commonCacheImageWidget(data.image.validate(), width: context.width() / 2, height: 130, fit: BoxFit.cover),
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(60.0),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.1),
                                        ),
                                        child: Icon(Icons.bookmark, size: 18, color: colorPrimary).paddingAll(2).onTap(() {
                                          if (!mIsLoggedIn) {
                                            SignInScreen().launch(context);
                                            return;
                                          }
                                          Map req = {
                                            'post_id': data.id.validate(),
                                            'user_id': userId,
                                          };

                                          res.data!.remove(data);
                                          setState(() {});

                                          toast(language!.pleaseWait);
                                          watchlistMovie(req).then((value) {
                                            setState(() {});
                                          }).catchError((e) {
                                            toast(e.toString());
                                          });
                                        }),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ).onTap(() {
                              appStore.setTrailerVideoPlayer(true);
                              MovieDetailScreen(movieData: data).launch(context);
                            }).cornerRadiusWithClipRRect(radius_container),
                          ),
                          6.height,
                          SizedBox(
                            width: context.width() / 2 - 24,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                itemTitle(context, data.title.validate(), maxLine: 2),
                                itemTitle(context, data.run_time.validate(), fontSize: 10),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: AdSize.banner.height.toDouble(),
                    width: context.width(),
                    child: AdWidget(ad: bannerAd!),
                  ).visible(!disabledAds),
                )
              ],
            ),
          ).paddingAll(16);
        },
        loadingWidget: Image.asset(ic_loading_gif, fit: BoxFit.cover, height: 100, width: 100).center(),
        errorWidget: Text(errorInternetNotAvailable, style: boldTextStyle(color: Colors.white)).center(),
      ),
    );
  }
}
