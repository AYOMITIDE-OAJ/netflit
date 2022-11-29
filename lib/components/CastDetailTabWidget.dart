import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/network/RestApis.dart';
import 'package:streamit_flutter/screens/MovieDetailScreen.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Images.dart';

// ignore: must_be_immutable
class CastDetailTabWidget extends StatefulWidget {
  static String tag = '/CastDetailTabWidget';
  final int? castId;
  final String? type;

  CastDetailTabWidget({this.castId, this.type});

  @override
  CastDetailTabWidgetState createState() => CastDetailTabWidgetState();
}

class CastDetailTabWidgetState extends State<CastDetailTabWidget> {
  ScrollController _controller = ScrollController();
  List<MovieData> _list = [];

  int page = 1;
  bool loadMore = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    init();

    _controller
      ..addListener(() {
        if (_controller.position.pixels == _controller.position.maxScrollExtent) {
          if (loadMore) {
            page++;
            isLoading = true;

            init();
            setState(() {});
          }
        }
      });
  }

  Future<void> init() async {
    AsyncMemoizer<List<MovieData>>()
        .runOnce(
      () => getCastMovieTvShowList(page: page, castId: widget.castId, type: widget.type),
    )
        .then((value) {
      loadMore = value.length == postPerPage;
      if (page == 1) _list.clear();
      _list.addAll(value);

      isLoading = false;

      setState(() {});
    }).catchError((error) {
      toast(error.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          controller: _controller,
          padding: EdgeInsets.all(8),
          shrinkWrap: true,
          itemCount: _list.length,
          itemBuilder: (context, index) {
            MovieData data = _list[index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                commonCacheImageWidget(
                  data.image.validate(),
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ).cornerRadiusWithClipRRect(defaultRadius),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(data.title.validate(), style: boldTextStyle(size: 22)),
                    4.height,
                    Text('${language!.as} ${data.character_name.validate()}', style: secondaryTextStyle(color: Colors.grey.shade500)),
                    4.height,
                    Text(data.release_year.validate(), style: primaryTextStyle(color: Colors.grey.shade500)),
                  ],
                ).paddingSymmetric(horizontal: 12).expand()
              ],
            ).onTap(() {
              finish(context);
              appStore.setTrailerVideoPlayer(true);
              MovieDetailScreen(movieData: data).launch(context);
            }, borderRadius: BorderRadius.circular(defaultRadius)).paddingAll(8);
          },
        ),
        NoDataWidget(
          imageWidget: Image.asset(ic_empty, height: 130),
          title: language!.noData,
        ).center().visible(_list.isEmpty && !isLoading),
        Image.asset(ic_loading_gif, fit: BoxFit.cover, height: 100, width: 100).center().visible(isLoading),
      ],
    );
  }
}
