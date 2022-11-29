import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/network/RestApis.dart';
import 'package:streamit_flutter/screens/movieDetailComponents/MovieGridWidget.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Images.dart';

// ignore: must_be_immutable
class ViewAllMoviesScreen extends StatefulWidget {
  static String tag = '/ViewAllMoviesScreen';
  int index;
  String? type;

  ViewAllMoviesScreen(this.index, this.type);

  @override
  ViewAllMoviesScreenState createState() => ViewAllMoviesScreenState();
}

class ViewAllMoviesScreenState extends State<ViewAllMoviesScreen> {
  List<MovieData> movies = [];
  ScrollController scrollController = ScrollController();

  BannerAd? bannerAd;

  int page = 1;

  bool isLoading = true;
  bool loadMore = true;
  bool hasError = false;

  String title = '';

  @override
  void initState() {
    super.initState();
    init();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (loadMore) {
          page++;
          isLoading = true;

          setState(() {});

          init();
        }
      }
    });
  }

  Future<void> init() async {
    bannerAd = buildBannerAds()..load();
    viewAll(widget.index, widget.type ?? dashboardTypeHome, page: page).then((value) {
      isLoading = false;

      if (page == 1) movies.clear();
      loadMore = value.data!.length == postPerPage;

      title = value.title.validate();

      movies.addAll(value.data!);

      setState(() {});
    }).catchError((e) {
      log(e);
      isLoading = false;
      hasError = true;

      toast(e.toString());
      setState(() {});
    });
  }

  /// todo: remove commented code
  BannerAd buildBannerAds() {
    return BannerAd(
      size: AdSize.banner,
      request: AdRequest(),
      adUnitId: mAdMobBannerId,
      //adUnitId: kReleaseMode ? mAdMobBannerId : BannerAd.testAdUnitId,
      listener: BannerAdListener(onAdLoaded: (ad) {
        //
      }),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    bannerAd!.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(title, color: Theme.of(context).cardColor, textColor: Colors.white, textSize: 22),
      body: Container(
        height: context.height(),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 70),
              child: MovieGridList(movies),
              controller: scrollController,
            ),
            Image.asset(ic_loading_gif, fit: BoxFit.cover, height: 100, width: 100).center().visible(isLoading),
            NoDataWidget(
              imageWidget: Image.asset(ic_empty, height: 130),
              title: language!.noData,
            ).center().visible(!isLoading && movies.isEmpty && !hasError),
            Text(errorSomethingWentWrong, style: boldTextStyle(color: Colors.white)).center().visible(hasError),
            if (bannerAd != null && !disabledAds)
              Positioned(
                child: Container(color: Colors.white, child: AdWidget(ad: bannerAd!)),
                bottom: 0,
                height: AdSize.banner.height.toDouble(),
                width: context.width(),
              )
          ],
        ),
      ),
    );
  }
}
