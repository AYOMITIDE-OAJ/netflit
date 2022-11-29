import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/components/DownloadButtonWidget.dart';
import 'package:streamit_flutter/components/SourcesDataWidget.dart';
import 'package:streamit_flutter/components/VideoContentWidget.dart';
import 'package:streamit_flutter/models/CommentModel.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/network/NetworkUtils.dart';
import 'package:streamit_flutter/network/RestApis.dart';
import 'package:streamit_flutter/screens/Signin.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Common.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';
import 'package:streamit_flutter/utils/resources/Images.dart';
import 'package:streamit_flutter/utils/resources/Size.dart';

import '../main.dart';

class EpisodeDetailScreen extends StatefulWidget {
  static String tag = '/EpisodeDetailScreen';
  final String? title;
  final Episode? episode;
  final List<Episode>? episodes;
  final int? index;
  final int? lastIndex;

  EpisodeDetailScreen({this.title, this.episode, this.episodes, this.index, this.lastIndex});

  @override
  EpisodeDetailScreenState createState() => EpisodeDetailScreenState();
}

class EpisodeDetailScreenState extends State<EpisodeDetailScreen> with WidgetsBindingObserver, TickerProviderStateMixin {
  ScrollController scrollController = ScrollController();

  TextEditingController mainCommentCont = TextEditingController();

  bool isLoaded = false;

  List<MovieData> actors = [];
  bool isExpanded = false;

  bool isSubscribe = false;

  List<CommentModel> commentList = [];

  int page = 1;

  bool showEpisodes = false;

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  Episode? data;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    Future.delayed(Duration(seconds: 1), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: [SystemUiOverlay.top]);
    });
    init();
  }

  Future<void> init() async {
    _controller = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _offsetAnimation = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate));

    afterBuildCreated(() {
      getEpisodeDetails();
    });
  }

  void getEpisodeDetails() async {
    appStore.setLoading(true);
    await getEpisodeDetail(widget.episode!.id).then((value) {
      data = value;
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      toast(e.toString());
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack, overlays: [SystemUiOverlay.top]);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget subscriptionEpisode(Episode _episode) {
    if (!_episode.is_post_restricted.validate()) {
      return GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy <= 0 && details.delta.dx == 0) {
            _controller.forward();
          }
          if (details.delta.dy >= 0 && details.delta.dx == 0) {
            _controller.reverse();
          }
        },
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            VideoContentWidget(
              choice: _episode.choice,
              image: _episode.image,
              urlLink: _episode.url_link,
              embedContent: _episode.embed_content,
              fileLink: _episode.file,
            ),
            if (appStore.hasInFullScreen)
              SlideTransition(
                position: _offsetAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Theme.of(context).scaffoldBackgroundColor],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 1.0],
                      tileMode: TileMode.repeated,
                    ),
                  ),
                  child: episodeListWidget(),
                ),
              ),
          ],
        ),
      );
    } else {
      return Container(
        width: context.width(),
        height: context.height() * 0.3,
        child: Stack(
          children: [
            commonCacheImageWidget(
              _episode.image.validate(),
              width: context.width(),
              fit: BoxFit.cover,
            ),
            Container(color: Colors.black.withOpacity(0.7), width: context.width()),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_episode.is_post_restricted.validate() && mIsLoggedIn)
                  if (_episode.restriction_setting!.restrict_type == RestrictionTypeMessage ||
                      _episode.restriction_setting!.restrict_type == RestrictionTypeTemplate ||
                      _episode.restriction_setting!.restrict_type == " ")
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            openInfoBottomSheet(
                              context: context,
                              restrictSubscriptionPlan: _episode.restrict_subscription_plan,
                              data: HtmlWidget(
                                '<html>${_episode.restriction_setting!.restrict_message.validate().replaceAll('&lt;', '<').replaceAll('&gt;', '>').replaceAll('&quot;', '"').replaceAll('[embed]', '<embed>').replaceAll('[/embed]', '</embed>').replaceAll('[caption]', '<caption>').replaceAll('[/caption]', '</caption>')}</html>',
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
                if (_episode.is_post_restricted.validate() && !mIsLoggedIn)
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          openInfoBottomSheet(
                            context: context,
                            restrictSubscriptionPlan: _episode.restrict_subscription_plan,
                            data: HtmlWidget(
                              '<html>${_episode.restriction_setting!.restrict_message.validate().replaceAll('&lt;', '<').replaceAll('&gt;', '>').replaceAll('&quot;', '"').replaceAll('[embed]', '<embed>').replaceAll('[/embed]', '</embed>').replaceAll('[caption]', '<caption>').replaceAll('[/caption]', '</caption>')}</html>',
                            ),
                            btnText: language!.loginNow,
                            onTap: () async {
                              await SignInScreen().launch(context);
                              setState(() {});
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
        ).paddingBottom(16),
      );
    }
  }

  Widget episodeListWidget() {
    return HorizontalList(
      itemCount: widget.episodes!.length,
      itemBuilder: (context, index) {
        Episode episode = widget.episodes![index];

        return Container(
          width: 180,
          height: 130,
          decoration: widget.index == index ? boxDecoration(context, color: colorPrimary, radius: 5) : null,
          child: InkWell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: spacing_control_half,
                    margin: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(spacing_control)),
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: <Widget>[
                        commonCacheImageWidget(episode.image.validate(), width: double.infinity, height: double.infinity, fit: BoxFit.cover),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: boxDecoration(context, bgColor: Colors.white.withOpacity(0.8)),
                              padding: EdgeInsets.only(left: spacing_control, right: spacing_control),
                              child: Text(language!.episode.capitalizeFirstLetter() + " " + (index + 1).toString(), style: boldTextStyle(color: Colors.black, size: 14)),
                            ),
                            4.height.visible(episode.release_date != null),
                            itemSubTitle(context, "${episode.release_date.validate()}", fontSize: ts_small).visible(episode.release_date != null),
                          ],
                        ).paddingAll(4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            onTap: () async {
              if (appStore.hasInFullScreen) {
                appStore.setToFullScreen(false);
                setOrientationPortrait();
              }
              finish(context);
              youtubePlayerController!.pause();
              EpisodeDetailScreen(title: episode.title.validate(), episode: episode, episodes: widget.episodes, index: index, lastIndex: widget.episodes!.length).launch(context);
            },
            radius: spacing_control,
          ),
        );
      },
    );
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
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: data != null && data!.is_post_restricted.validate() ? Size(context.width(), kToolbarHeight) : Size(0, 0),
            child: appBarWidget(
              parseHtmlString(data != null ? data!.title.validate() : ""),
              color: Colors.transparent,
              textColor: Colors.white,
              elevation: 0,
            ),
          ),
          key: UniqueKey(),
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              if (data != null)
                Container(
                  width: context.width(),
                  height: context.height(),
                  child: SingleChildScrollView(
                    physics: context.width() >= 480 ? NeverScrollableScrollPhysics() : ScrollPhysics(),
                    controller: scrollController,
                    padding: EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        subscriptionEpisode(data!),
                        8.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commonCacheImageWidget(
                              data!.image,
                              width: 80,
                              height: 100,
                              fit: BoxFit.fill,
                            ).cornerRadiusWithClipRRect(4),
                            8.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                headingText(widget.title.validate(), fontSize: 18),
                                4.height,
                                itemSubTitle(
                                  context,
                                  "${data!.episode_number.validate()}, ${data!.release_date.validate()}",
                                  fontSize: 14,
                                  textColor: Colors.grey.shade500,
                                ),
                                4.height,
                                itemSubTitle(context, data!.run_time.validate(), fontSize: 14, textColor: Colors.grey.shade500),
                              ],
                            ).expand(),
                            if (data!.file.validate().isNotEmpty && appStore.isLogging && !data!.is_post_restricted.validate()) ...[
                              16.height,
                              DownloadButtonWidget(episode: data),
                            ],
                          ],
                        ).paddingOnly(left: spacing_standard, right: spacing_standard),
                        HtmlWidget(
                          data!.description.validate(),
                          textStyle: primaryTextStyle(color: Colors.white, size: 14),
                          onTapUrl: (s) {
                            try {
                              launchUrl(s, forceWebView: true);
                            } catch (e) {
                              print(e);
                            }
                            return true;
                          },
                        ).paddingAll(8),
                        Divider(thickness: 0.1, color: Colors.grey.shade500).visible(data!.sourcesList.validate().isNotEmpty),
                        if (data!.sourcesList!.isNotEmpty) headingText(language!.sources).paddingAll(8),
                        if (data!.sourcesList!.isNotEmpty)
                          SourcesDataWidget(
                            sourceList: data!.sourcesList,
                            onLinkTap: (sources) async {
                              youtubePlayerController!.pause();
                              data!.choice = sources.choice;

                              if (sources.choice == "episode_embed") {
                                if (sources.embedContent!.contains('<iframe')) {
                                  data!.embed_content = sources.embedContent;
                                  data!.choice = "episode_embed";
                                } else if (sources.embedContent!.contains('http')) {
                                  data!.url_link = sources.embedContent;
                                  data!.choice = "episode_url";
                                }
                              }
                              setState(() {});
                            },
                          ).paddingAll(8),
                        Divider(
                          thickness: 0.1,
                          color: Colors.grey.shade500,
                        ).visible(widget.episode != null && widget.episode!.sourcesList.validate().isNotEmpty),
                        if (widget.episode != null && widget.episode!.sourcesList.validate().isNotEmpty)
                          SourcesDataWidget(
                            sourceList: widget.episode!.sourcesList,
                          ).paddingAll(8),
                        Divider(thickness: 0.1, color: Colors.grey.shade500).visible(widget.episodes.validate().isNotEmpty),
                        headingWidViewAll(context, language!.episodes, showViewMore: false).paddingOnly(left: spacing_standard, right: spacing_standard).visible(widget.episodes.validate().isNotEmpty),
                        episodeListWidget().visible(widget.episodes.validate().isNotEmpty),
                        8.height,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            headingText('${buildCommentCountText(widget.episode!.no_of_comments.validate())}'),
                            16.height,
                            mIsLoggedIn
                                ? AppTextField(
                                    controller: mainCommentCont,
                                    textFieldType: TextFieldType.MULTILINE,
                                    maxLines: 3,
                                    textStyle: primaryTextStyle(color: textColorPrimary),
                                    errorThisFieldRequired: errorThisFieldRequired,
                                    decoration: InputDecoration(
                                      hintText: comment,
                                      hintStyle: secondaryTextStyle(),
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.send),
                                        color: colorPrimary,
                                        onPressed: () {
                                          hideKeyboard(context);

                                          buildComment(
                                            content: mainCommentCont.text.trim(),
                                            postId: widget.episode!.id,
                                          ).then((value) {
                                            mainCommentCont.clear();

                                            commentList.add(value);
                                            widget.episode!.no_of_comments = widget.episode!.no_of_comments! + 1;
                                          }).catchError((error) {
                                            toast(errorSomethingWentWrong);
                                          });
                                        },
                                      ),
                                      border: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                                    ),
                                  )
                                : Text(
                                    language!.loginToAddComment,
                                    style: primaryTextStyle(color: colorPrimary, size: 18),
                                  ).onTap(
                                    () {
                                      SignInScreen().launch(context);
                                    },
                                  ),
                          ],
                        ).paddingAll(16),
                      ],
                    ),
                  ),
                ),
              Observer(builder: (context) => Image.asset(ic_loading_gif, fit: BoxFit.cover, height: 100, width: 100).center().visible(appStore.isLoading))
            ],
          ),
        ),
      ),
    );
  }
}
