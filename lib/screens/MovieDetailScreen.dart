import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/components/CommentWidget.dart';
import 'package:streamit_flutter/components/DownloadButtonWidget.dart';
import 'package:streamit_flutter/components/LoadingDotWidget.dart';
import 'package:streamit_flutter/components/SourcesDataWidget.dart';
import 'package:streamit_flutter/components/TrailerVideoWidget.dart';
import 'package:streamit_flutter/components/UpcomingRelatedMovieListWidget.dart';
import 'package:streamit_flutter/components/VideoContentWidget.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/models/MovieDetailResponse.dart';
import 'package:streamit_flutter/network/NetworkUtils.dart';
import 'package:streamit_flutter/network/RestApis.dart';
import 'package:streamit_flutter/screens/CastDetailScreen.dart';
import 'package:streamit_flutter/screens/Signin.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Common.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';
import 'package:streamit_flutter/utils/resources/Size.dart';

import 'movieDetailComponents/MovieDetailLikeWatchListWidget.dart';
import 'movieDetailComponents/SeasonDataWidget.dart';

class MovieDetailScreen extends StatefulWidget {
  final String? title;
  final MovieData movieData;

  MovieDetailScreen({this.title = "", required this.movieData});

  @override
  MovieDetailScreenState createState() => MovieDetailScreenState();
}

class MovieDetailScreenState extends State<MovieDetailScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();

  late MovieData _movie;

  List<MovieData> mMovieList = [];
  List<MovieData> mMovieOriginalsList = [];

  bool isSubscribe = false;

  Future<MovieDetailResponse>? future;

  int page = 1;
  String genre = '';

  InterstitialAd? interstitialAd;

  PostType? postType;

  @override
  void initState() {
    super.initState();
    _movie = widget.movieData;
    postType = _movie.post_type!;

    if (postType == PostType.MOVIE) {
      future = movieDetail(_movie.id.validate());
    } else if (postType == PostType.TV_SHOW) {
      future = tvShowDetail(_movie.id.validate());
    } else if (postType == PostType.EPISODE) {
      future = episodeDetail(_movie.id.validate());
    } else if (postType == PostType.VIDEO) {
      future = getVideosDetail(_movie.id.validate());
    }
    //fetch user plan data from shared pref

    if (!disabledAds) {
      log('ads count $adShowCount');
      if (adShowCount < 5) {
        adShowCount++;
      } else {
        adShowCount = 0;
        buildInterstitialAd();
      }
    }
    init();
  }

  Future<void> init() async {
    isSubscribe = await getUserPlanData(_movie.restSubPlan.validate());
  }

  void showInterstitialAd() {
    if (interstitialAd == null) {
      log('Warning: attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        //
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        buildInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        buildInterstitialAd();
      },
    );
    interstitialAd!.show();
    interstitialAd = null;
  }

  /// todo: remove commented code
  void buildInterstitialAd() {
    InterstitialAd.load(
      adUnitId: mAdMobInterstitialId,
      // adUnitId: kReleaseMode ? mAdMobInterstitialId : InterstitialAd.testAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Keep a reference to the ad so you can show it later.
          this.interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  double roundDouble({required double value, int? places}) => ((value * 10).round().toDouble() / 10);

  Widget subscriptionWidget() {
    return Observer(
      builder: (_) {
        if (!appStore.isTrailerVideoPlaying) {
          if (!_movie.is_post_restricted.validate()) {
            return Stack(
              children: [
                VideoContentWidget(
                  choice: _movie.choice,
                  image: _movie.image,
                  embedContent: _movie.embed_content,
                  urlLink: _movie.url_link,
                  fileLink: _movie.file,
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, size: 24),
                    onPressed: () {
                      finish(context);
                    },
                  ).visible(isAndroid),
                ),
              ],
            );
          } else {
            return Container(
              width: context.width(),
              height: appStore.hasInFullScreen ? context.height() - 25 : context.height() * 0.3,
              child: Stack(
                children: [
                  commonCacheImageWidget(
                    _movie.image.validate(),
                    width: context.width(),
                    fit: BoxFit.cover,
                  ),
                  Container(color: Colors.black.withOpacity(0.7), width: context.width()),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_movie.is_post_restricted.validate() && mIsLoggedIn)
                        if (_movie.restrictionSetting!.restrict_type == RestrictionTypeMessage ||
                            _movie.restrictionSetting!.restrict_type == RestrictionTypeTemplate ||
                            _movie.restrictionSetting!.restrict_type.validate().isEmpty)
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  openInfoBottomSheet(
                                    context: context,
                                    restrictSubscriptionPlan: _movie.restSubPlan,
                                    data: HtmlWidget(
                                      '<html>${_movie.restrictionSetting!.restrict_message.validate().replaceAll('&lt;', '<').replaceAll('&gt;', '>').replaceAll('&quot;', '"').replaceAll('[embed]', '<embed>').replaceAll('[/embed]', '</embed>').replaceAll('[caption]', '<caption>').replaceAll('[/caption]', '</caption>')}</html>',
                                    ),
                                    btnText: language!.subscribeNow,
                                    onTap: () async {
                                      finish(context);
                                      if (getStringAsync(ACCOUNT_PAGE).isNotEmpty) {
                                        await launchURL(getStringAsync(REGISTRATION_PAGE)).then((value) async {
                                          await refreshToken();
                                          getUserProfileDetails().then((value) {
                                            setState(() {});
                                          });
                                        });
                                      } else {
                                        toast(redirectionUrlNotFound);
                                      }
                                    },
                                  );
                                },
                                child: Text(language!.viewInfo, style: boldTextStyle(color: Colors.white)),
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(colorPrimary)),
                              ),
                            ],
                          ),
                      if (_movie.is_post_restricted.validate() && !mIsLoggedIn)
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                openInfoBottomSheet(
                                  context: context,
                                  restrictSubscriptionPlan: _movie.restSubPlan,
                                  data: HtmlWidget(
                                    '<html>${_movie.restrictionSetting!.restrict_message.validate().replaceAll('&lt;', '<').replaceAll('&gt;', '>').replaceAll('&quot;', '"').replaceAll('[embed]', '<embed>').replaceAll('[/embed]', '</embed>').replaceAll('[caption]', '<caption>').replaceAll('[/caption]', '</caption>')}</html>',
                                  ),
                                  btnText: language!.loginNow,
                                  onTap: () {
                                    finish(context);
                                    SignInScreen().launch(context);
                                  },
                                );
                              },
                              child: Text(language!.viewInfo, style: boldTextStyle(color: Colors.white)),
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(colorPrimary)),
                            ),
                          ],
                        ),
                    ],
                  ).center(),
                ],
              ),
            );
          }
        } else {
          return TrailerVideoWidget(
            url: _movie.trailer_link,
            image: _movie.image.validate(),
            onTap: () async {
              youtubePlayerController!.pause();
              appStore.setTrailerVideoPlayer(false);
              setState(() {});
            },
          );
        }
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    scrollController.dispose();
    showInterstitialAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (appStore.hasInFullScreen) {
          appStore.setToFullScreen(false);
          setOrientationPortrait();
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: _movie.is_post_restricted.validate() || appStore.isTrailerVideoPlaying ? Size(context.width(), kToolbarHeight) : Size(0, 0),
          child: appBarWidget(
            parseHtmlString(_movie.title.validate()),
            color: Colors.transparent,
            textColor: Colors.white,
            elevation: 0,
          ),
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: FutureBuilder<MovieDetailResponse>(
            future: future!.then((value) => value),
            builder: (_, snap) {
              if (snap.hasData) {
                _movie = snap.data!.data!;

                if (_movie.post_type == PostType.TV_SHOW) {
                  log(snap.data!.seasons.validate().length);
                }

                if (snap.data!.data!.genre != null) {
                  snap.data!.data!.genre!.forEach((element) {
                    genre = '';
                    if (genre.isNotEmpty) {
                      genre = '$genre • ${element.name.validate()}';
                    } else {
                      genre = element.name.validate();
                    }
                  });
                }

                if (snap.data!.data!.cat != null) {
                  snap.data!.data!.cat!.forEach((element) {
                    genre = '';
                    if (genre.isNotEmpty) {
                      genre = '$genre • ${element.name.validate()}';
                    } else {
                      genre = element.name.validate();
                    }
                  });
                }
              }
              return Observer(
                builder: (ctx) {
                  if (!appStore.hasInFullScreen) {
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
                    setOrientationPortrait();
                  } else {
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
                    setOrientationLandscape();
                  }
                  return SingleChildScrollView(
                    physics: appStore.hasInFullScreen ? NeverScrollableScrollPhysics() : ScrollPhysics(),
                    controller: scrollController,
                    padding: EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        subscriptionWidget(),
                        8.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                headingText(parseHtmlString(_movie.title.validate()), fontSize: 30, maxLines: 2),
                                8.height,
                                _movie.imdb_rating != null && _movie.imdb_rating != 0.0
                                    ? Row(
                                        children: [
                                          RatingBarIndicator(
                                            rating: roundDouble(value: _movie.imdb_rating.toDouble() ?? 0, places: 1),
                                            itemBuilder: (context, index) => Icon(Icons.star, color: colorPrimary),
                                            itemCount: 5,
                                            itemSize: 14.0,
                                            unratedColor: Colors.white12,
                                          ),
                                          4.width,
                                          Text(
                                            '(${roundDouble(value: _movie.imdb_rating.toDouble() ?? 0, places: 1)})',
                                            style: primaryTextStyle(color: Colors.white, size: 12),
                                          ),
                                        ],
                                      ).visible(_movie.post_type == PostType.MOVIE)
                                    : SizedBox(),
                                4.height,
                                itemSubTitle(
                                  context,
                                  genre,
                                  fontSize: ts_small,
                                  textColor: Colors.grey.shade500,
                                ).visible(genre.trim().isNotEmpty),
                                4.height,
                                if (snap.hasData)
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              snap.data!.data!.censor_rating.validate(),
                                              style: boldTextStyle(color: Colors.black, size: 12),
                                            ),
                                            padding: EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2),
                                            decoration: BoxDecoration(color: Colors.white),
                                          ).cornerRadiusWithClipRRect(4).visible(snap.data!.data!.censor_rating.validate().isNotEmpty),
                                          8.width.visible(snap.data!.data!.censor_rating != null),
                                          Container(
                                            child: Row(
                                              children: [
                                                Icon(Icons.visibility_outlined, color: Colors.black, size: 12),
                                                4.width,
                                                Text(
                                                  '${snap.data!.data!.views.validate()}',
                                                  style: boldTextStyle(size: 12, color: Colors.black),
                                                ),
                                                4.width,
                                                Text(language!.views, style: boldTextStyle(size: 12, color: Colors.black)),
                                              ],
                                            ),
                                            padding: EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2),
                                            decoration: BoxDecoration(color: Colors.white),
                                          ).cornerRadiusWithClipRRect(4).visible(_movie.post_type == PostType.VIDEO),
                                          8.width.visible(_movie.post_type == PostType.VIDEO),
                                          itemTitle(
                                            context,
                                            snap.data!.data!.run_time.validate(),
                                            fontSize: 12.0,
                                          ).visible(snap.data!.data!.run_time.validate().isNotEmpty),
                                        ],
                                      ),
                                    ],
                                  ),
                              ],
                            ).expand(),
                            if (_movie.file.validate().isNotEmpty && appStore.isLogging && !_movie.is_post_restricted.validate()) ...[
                              16.height,
                              DownloadButtonWidget(movie: _movie),
                            ],
                          ],
                        ).paddingSymmetric(horizontal: 16),
                        HtmlWidget(
                          _movie.description.validate(),
                          textStyle: primaryTextStyle(color: Colors.white, size: 14),
                          onTapUrl: (s) {
                            try {
                              launchUrl(s, forceWebView: true);
                            } catch (e) {
                              print(e);
                            }
                            return true;
                          },
                        ).paddingSymmetric(horizontal: 16, vertical: 8),
                        8.height,
                        MovieDetailLikeWatchListWidget(_movie).paddingSymmetric(horizontal: 16),
                        8.height,
                        Divider(thickness: 0.1, color: Colors.grey.shade500).visible(snap.hasData),
                        if (snap.hasData && _movie.castsList!.isNotEmpty) headingText(language!.starring).paddingOnly(right: 16, left: 16, top: 16),
                        if (snap.hasData && _movie.castsList != null)
                          HorizontalList(
                            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                            itemCount: _movie.castsList!.length,
                            itemBuilder: (context, index) {
                              Casts data = _movie.castsList![index];
                              return Column(
                                children: [
                                  commonCacheImageWidget(data.image.validate(), fit: BoxFit.cover, width: 70, height: 70)
                                      .cornerRadiusWithClipRRect(60)
                                      .paddingOnly(left: 4, right: 4),
                                  4.height,
                                  Text(data.character.validate(), style: primaryTextStyle())
                                ],
                              ).onTap(() async {
                                youtubePlayerController!.pause();
                                await CastDetailScreen(castId: data.id).launch(context);
                              }, borderRadius: BorderRadius.circular(defaultRadius), highlightColor: Colors.transparent);
                            },
                          ),
                        if (snap.hasData && _movie.castsList!.isNotEmpty) Divider(thickness: 0.1, color: Colors.grey.shade500),
                        if (snap.hasData && _movie.post_type != PostType.TV_SHOW && _movie.sourcesList!.isNotEmpty)
                          headingText(language!.sources).paddingOnly(right: 16, left: 16, top: 16),
                        if (snap.hasData && _movie.post_type != PostType.TV_SHOW && _movie.sourcesList!.isNotEmpty)
                          SourcesDataWidget(
                            sourceList: _movie.sourcesList,
                            onLinkTap: (sources) async {
                              youtubePlayerController!.pause();
                              _movie.choice = sources.choice;
                              if (sources.choice == "movie_url") {
                                _movie.url_link = sources.link;
                              } else if (sources.choice == "movie_embed") {
                                _movie.embed_content = sources.embedContent;
                              }
                              appStore.setTrailerVideoPlayer(false);
                              await MovieDetailScreen(movieData: widget.movieData).launch(context);
                              youtubePlayerController!.play();
                            },
                          ).paddingSymmetric(horizontal: 12, vertical: 16),
                        if (snap.hasData && _movie.post_type != PostType.TV_SHOW && _movie.sourcesList!.isNotEmpty)
                          Divider(thickness: 0.1, color: Colors.grey.shade500),
                        if (snap.hasData && _movie.post_type == PostType.TV_SHOW) SeasonDataWidget(snap.data!.seasons.validate(), widget.movieData),
                        if (snap.hasData) UpcomingRelatedMovieListWidget(snap: snap),
                        if (snap.hasData &&
                            (snap.data!.upcomming_movie.validate().isNotEmpty ||
                                snap.data!.recommended_movie.validate().isNotEmpty ||
                                snap.data!.upcomming_video.validate().isNotEmpty))
                          Divider(thickness: 0.1, color: Colors.grey.shade500),
                        CommentWidget(postId: _movie.id, noOfComments: _movie.no_of_comments)
                            .paddingAll(16)
                            .visible(_movie.is_comment_open.validate()),
                        8.height,
                        if (!snap.hasData) LoadingDotsWidget(),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
