import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/components/GenreGridListWidget.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/models/GenreData.dart';
import 'package:streamit_flutter/network/RestApis.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Images.dart';

class GenreListScreen extends StatefulWidget {
  static String tag = '/GenreListScreen';
  final String? type;

  GenreListScreen({this.type});

  @override
  GenreListScreenState createState() => GenreListScreenState();
}

class GenreListScreenState extends State<GenreListScreen> {
  ScrollController scrollController = ScrollController();
  List<GenreData> genreList = [];

  bool isLoading = true;
  bool loadMore = true;
  bool hasError = false;

  int page = 1;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(
      () {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          if (loadMore) {
            page++;
            isLoading = true;
            setState(() {});

            init();
          }
        }
      },
    );
    init();
  }

  Future<void> init() async {
    getGenreList(type: widget.type, page: page).then((value) {
      isLoading = false;

      if (page == 1) genreList.clear();
      loadMore = value.length == postPerPage;

      genreList.addAll(value);

      setState(() {});
    }).catchError((error) {
      isLoading = false;
      hasError = true;
      log(error.toString());
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: context.height(),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: GenreGridListWidget(genreList, widget.type!),
              controller: scrollController,
            ),
            Image.asset(ic_loading_gif, fit: BoxFit.cover, height: 100, width: 100).center().visible(isLoading),
            NoDataWidget(
              imageWidget: Image.asset(ic_empty, height: 130),
              title: language!.noData,
            ).center().visible(!isLoading && genreList.isEmpty && !hasError),
            Text(errorInternetNotAvailable, style: boldTextStyle(color: Colors.white)).center().visible(hasError),
          ],
        ),
      ),
    );
  }
}
