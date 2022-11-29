import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/components/CastDetailTabWidget.dart';
import 'package:streamit_flutter/models/CastModel.dart';
import 'package:streamit_flutter/network/RestApis.dart';
import 'package:streamit_flutter/screens/MovieDetailScreen.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Common.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';
import 'package:streamit_flutter/utils/resources/Images.dart';
import 'package:streamit_flutter/utils/resources/Size.dart';

import '../main.dart';

class CastDetailScreen extends StatefulWidget {
  static String tag = '/CastDetailScreen';
  final String? castId;

  CastDetailScreen({this.castId});

  @override
  CastDetailScreenState createState() => CastDetailScreenState();
}

class CastDetailScreenState extends State<CastDetailScreen> with TickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    _controller = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<CastModel>(
        future: getCastDetails(widget.castId!),
        builder: (context, snap) {
          if (snap.hasData) {
            CastModel cast = snap.data!;

            if (cast.data != null) {
              return SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.only(top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BackButton(),
                    //region imageAndName
                    Container(
                      width: context.width(),
                      child: Row(
                        children: [
                          commonCacheImageWidget(
                            cast.data!.image.validate(),
                            fit: BoxFit.cover,
                            width: context.width(),
                            height: context.height() * 0.3,
                          ).cornerRadiusWithClipRRect(radius_container).paddingSymmetric(horizontal: 16, vertical: 8).expand(flex: 3),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(cast.data!.title!.validate(), style: boldTextStyle(size: 22, color: Colors.white)).paddingAll(8),
                              Text(
                                cast.data!.description.validate(),
                                style: primaryTextStyle(color: Colors.white),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ).paddingAll(8),
                            ],
                          ).expand(flex: 4),
                        ],
                      ),
                    ),
                    16.height,
                    //endregion

                    Divider(thickness: 0.1, color: Colors.grey.shade500, height: 0),

                    //region personalDetail
                    headingText(language!.personalInfo).paddingAll(16),
                    Row(
                      children: [
                        personalInfoWidget(context, cast.data!.category.validate(), language!.knownFor).expand(),
                        Container(height: 50, width: 0.2, color: Colors.grey.shade500),
                        personalInfoWidget(context, cast.data!.credits.toString().validate(), language!.knownCredits).expand(),
                      ],
                    ),
                    16.height,
                    Row(
                      children: [
                        personalInfoWidget(context, cast.data!.placeOfBirth.validate(), language!.placeOfBirth).center().expand(),
                        Container(height: 50, width: 0.2, color: Colors.grey.shade500),
                        personalInfoWidget(context, cast.data!.alsoKnownAs.validate(), language!.alsoKnownAs).expand(),
                      ],
                    ),
                    16.height,
                    Row(
                      children: [
                        personalInfoWidget(context, '${cast.data!.birthday.validate(value: '-')}', language!.birthday).expand(),
                        Container(height: 50, width: 0.2, color: Colors.grey.shade500),
                        personalInfoWidget(context, '${cast.data!.deathDay.validate(value: '-')}', language!.deathDay).expand(),
                      ],
                    ),
                    16.height,
                    //endregion

                    Divider(thickness: 0.1, color: Colors.grey.shade500),

                    //region mostViewList
                    headingText(language!.mostViewed).paddingAll(16).visible(cast.mostViewMovieTvShow!.isNotEmpty),
                    HorizontalList(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      itemCount: cast.mostViewMovieTvShow!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commonCacheImageWidget(
                              cast.mostViewMovieTvShow![index].image,
                              fit: BoxFit.cover,
                              height: 120,
                              width: 180,
                            ).cornerRadiusWithClipRRect(radius_container),
                            SizedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    parseHtmlString(cast.mostViewMovieTvShow![index].title),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      shadows: <Shadow>[Shadow(color: Colors.black, blurRadius: 5.0)],
                                    ),
                                  ).flexible(),
                                  if (cast.mostViewMovieTvShow![index].run_time != null)
                                    Text(
                                      cast.mostViewMovieTvShow![index].run_time,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        shadows: <Shadow>[
                                          Shadow(color: Colors.black, blurRadius: 5.0),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              width: 180,
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 8).onTap(() {
                          appStore.setTrailerVideoPlayer(true);
                          MovieDetailScreen(movieData: cast.mostViewMovieTvShow![index]).launch(context);
                        }, highlightColor: Colors.transparent, splashColor: Colors.transparent);
                      },
                    ),
                    //endregion
                    Divider(thickness: 0.1, color: Colors.grey.shade500),
                    AppButton(
                      width: context.width(),
                      color: colorPrimary,
                      onTap: () {
                        openSheet(context);
                      },
                      child: Text(
                        '${cast.data!.title.validate()}\'${language!.sActing}',
                        style: boldTextStyle(color: textColorPrimary),
                      ),
                    ).paddingAll(8),
                  ],
                ),
              );
            } else {
              return NoDataWidget(
                imageWidget: Image.asset(ic_empty, height: 130),
                title: language!.noData,
              ).center();
            }
          }
          return snapWidgetHelper(
            snap,
            loadingWidget: Image.asset(ic_loading_gif, fit: BoxFit.cover, height: 100, width: 100),
          ).center();
        },
      ),
    );
  }

  Widget personalInfoWidget(BuildContext context, String title, String subTitle) {
    return Container(
      alignment: Alignment.center,
      width: context.width() / 2 - 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title.validate(),
            style: boldTextStyle(color: colorPrimary.withOpacity(0.8), size: 20),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ).paddingAll(4),
          Text(subTitle.validate(), style: primaryTextStyle(color: Colors.white, size: 14)).paddingBottom(4),
        ],
      ),
    );
  }

  openSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      elevation: 10,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 600),
          height: context.height() * 0.7,
          decoration: BoxDecoration(
            color: scaffoldDarkColor,
            borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
          ),
          child: Column(
            children: [
              SizedBox(
                height: kToolbarHeight,
                child: TabBar(
                  controller: _controller,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 24),
                  labelStyle: TextStyle(fontSize: ts_normal),
                  indicatorColor: colorPrimary,
                  indicator: TabIndicator(),
                  unselectedLabelColor: Theme.of(context).textTheme.headline6!.color,
                  labelColor: colorPrimary,
                  tabs: [
                    Tab(child: Text(language!.all)),
                    Tab(child: Text(language!.movies)),
                    Tab(child: Text(language!.tVShows)),
                  ],
                ),
              ),
              Container(
                height: context.height() * 0.7 - kToolbarHeight,
                child: TabBarView(
                  controller: _controller,
                  children: [
                    CastDetailTabWidget(type: '', castId: widget.castId.toInt()),
                    CastDetailTabWidget(type: 'movie', castId: widget.castId.toInt()),
                    CastDetailTabWidget(type: 'tv_show', castId: widget.castId.toInt()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
