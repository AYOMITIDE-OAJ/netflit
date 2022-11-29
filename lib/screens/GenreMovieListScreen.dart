import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/network/RestApis.dart';
import 'package:streamit_flutter/screens/MovieDetailScreen.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Common.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Images.dart';
import 'package:streamit_flutter/utils/resources/Size.dart';

class GenreMovieListScreen extends StatefulWidget {
  static String tag = '/GenreMovieListScreen';
  final String? genre;
  final String? type;

  GenreMovieListScreen({this.genre, this.type});

  @override
  GenreMovieListScreenState createState() => GenreMovieListScreenState();
}

class GenreMovieListScreenState extends State<GenreMovieListScreen> {
  ScrollController scrollController = ScrollController();
  List<MovieData> genreMovieList = [];

  bool loadMore = true;
  bool hasError = false;

  int page = 1;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
    scrollController.addListener(
      () {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          if (loadMore) {
            page++;
            appStore.setLoading(true);
            setState(() {});

            init();
          }
        }
      },
    );
  }

  Future<void> init() async {
    if (await isNetworkAvailable()) {
      appStore.setLoading(true);
      await getMovieListByGenre(widget.genre!, widget.type!, page).then((value) {
        appStore.setLoading(false);

        if (page == 1) genreMovieList.clear();
        loadMore = value.genreMovieList!.length == genrePostPerPage;

        genreMovieList.addAll(value.genreMovieList!);

        setState(() {});
      }).catchError((error) {
        appStore.setLoading(false);
        hasError = true;
        setState(() {});

        log(error.toString());
      });
    } else {
      hasError = true;
      setState(() {});
    }
  }

  String getYear(String date) {
    log(date);
    try {
      return DateFormat('yyyy').parse(date).year.toString();
    } catch (e) {
      return date;
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        parseHtmlString(widget.genre!.validate().toUpperCase()),
        color: Colors.transparent,
        textColor: Colors.white,
      ),
      body: Observer(builder: (context) {
        return Container(
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.all(16),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: genreMovieList.map((e) {
                    MovieData data = e;
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        appStore.setTrailerVideoPlayer(true);
                        MovieDetailScreen(title: data.title, movieData: data).launch(context);
                      },
                      child: Column(
                        children: [
                          commonCacheImageWidget(
                            data.image.validate(),
                            fit: BoxFit.cover,
                            height: 100,
                            width: context.width() / 2 - 24,
                          ).cornerRadiusWithClipRRect(radius_container),
                          6.height,
                          SizedBox(
                            width: context.width() / 2 - 24,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                itemTitle(context, parseHtmlString(data.title.validate()), fontSize: 16, maxLine: 1),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (data.run_time.validate().isNotEmpty)
                                      Text(
                                        data.run_time.validate(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          shadows: <Shadow>[
                                            Shadow(blurRadius: 5.0, color: Colors.black),
                                          ],
                                        ),
                                        textAlign: TextAlign.start,
                                      ).paddingOnly(bottom: 4),
                                    if (data.censor_rating.validate().isNotEmpty || data.isHD.validate())
                                      Row(
                                        children: <Widget>[
                                          if (data.isHD.validate()) hdWidget(context).paddingRight(spacing_standard),
                                          if (data.censor_rating.validate().isNotEmpty)
                                            Container(
                                              child: Text(data.censor_rating.validate(), style: boldTextStyle(color: Colors.black, size: 10)),
                                              padding: EdgeInsets.all(2),
                                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                                            ),
                                          itemSubTitle(context, getYear(data.release_date.validate()), fontSize: 12).paddingLeft(4),
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              Image.asset(ic_loading_gif, fit: BoxFit.cover, height: 100, width: 100).center().visible(appStore.isLoading),
              NoDataWidget(
                imageWidget: Image.asset(ic_empty, height: 130),
                title: language!.noData,
              ).center().visible(!appStore.isLoading && genreMovieList.isEmpty && !hasError),
              Text(errorInternetNotAvailable, style: boldTextStyle(color: Colors.white)).center().visible(hasError),
            ],
          ),
        );
      }),
    );
  }
}

/*
  child: GridView.builder(
                  itemCount: genreMovieList.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.all(4),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 7 / 9),
                  scrollDirection: Axis.vertical,
                  controller: ScrollController(keepScrollOffset: false),
                  itemBuilder: (context, index) {
                    MovieData data = genreMovieList[index];

                    return InkWell(
                      onTap: () {
                        appStore.setTrailerVideoPlayer(true);
                        MovieDetailScreen(title: data.title, movieData: data).launch(context);
                      },
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 2,
                        margin: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(borderRadius: radius(radius_container)),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            commonCacheImageWidget(data.image.validate(), fit: BoxFit.cover),
                            Container(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                colors: [Colors.transparent, Colors.black],
                                stops: [0.0, 1.0],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              )),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                itemTitle(context, parseHtmlString(data.title.validate()), fontSize: 18, maxLine: 2),
                                if (data.run_time.validate().isNotEmpty)
                                  Text(
                                    data.run_time.validate(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      shadows: <Shadow>[
                                        Shadow(blurRadius: 5.0, color: Colors.black),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ).paddingOnly(bottom: 4),
                                if (data.censor_rating.validate().isNotEmpty || data.isHD.validate())
                                  Row(
                                    children: <Widget>[
                                      if (data.isHD.validate()) hdWidget(context).paddingRight(spacing_standard),
                                      if (data.censor_rating.validate().isNotEmpty)
                                        Container(
                                          child: Text(data.censor_rating.validate(), style: boldTextStyle(color: Colors.black, size: 10)),
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                                        ),
                                      itemSubTitle(context, getYear(data.release_date.validate()), fontSize: 12).paddingLeft(4),
                                    ],
                                  ),
                              ],
                            ).paddingOnly(left: 8, bottom: 0),
                          ],
                        ),
                      ),
                    ).paddingAll(6);
                  },
                ),
 */
