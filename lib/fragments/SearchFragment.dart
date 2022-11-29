import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/components/LoadingDotWidget.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/network/RestApis.dart';
import 'package:streamit_flutter/screens/VoiceSearchScreen.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';
import 'package:streamit_flutter/utils/resources/Images.dart';
import 'package:streamit_flutter/utils/resources/Size.dart';

import '../screens/movieDetailComponents/MovieGridWidget.dart';

class SearchFragment extends StatefulWidget {
  static String tag = '/SearchFragment';

  @override
  SearchFragmentState createState() => SearchFragmentState();
}

class SearchFragmentState extends State<SearchFragment> {
  List<MovieData> movies = [];
  ScrollController scrollController = ScrollController();

  TextEditingController searchController = TextEditingController();
  String searchText = "";

  int page = 1;

  bool isLoading = false;
  bool loadMore = true;
  bool hasError = false;

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
    if (searchText.isNotEmpty) {
      isLoading = true;
      setState(() {});

      searchMovie(searchController.text, page: page).then((value) {
        setState(() {
          isLoading = false;
        });

        if (page == 1) movies.clear();
        loadMore = value.data!.length == postPerPage;

        movies.addAll(value.data!);

        setState(() {});
      }).catchError((e) {
        isLoading = false;
        setState(() {});
        log(e);

        hasError = true;
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language!.search, showBack: false, color: Theme.of(context).cardColor, textColor: Colors.white),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 24),
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 52,
                  color: search_edittext_color,
                  padding: EdgeInsets.only(left: spacing_standard_new, right: spacing_standard),
                  child: Column(
                    children: [
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: searchController,
                              textInputAction: TextInputAction.search,
                              style: TextStyle(fontSize: ts_normal, color: Theme.of(context).textTheme.headline6!.color),
                              decoration: InputDecoration(
                                hintText: language!.searchMoviesTvShowsVideos,
                                hintStyle: TextStyle(color: Theme.of(context).textTheme.subtitle2!.color),
                                border: InputBorder.none,
                                filled: false,
                              ),
                              onChanged: (s) {
                                searchText = s;

                                page = 1;
                                if (s.isNotEmpty) init();
                              },
                              onFieldSubmitted: (s) {
                                searchText = s;

                                page = 1;
                                if (s.isNotEmpty) init();
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              searchText = '';
                              searchController.clear();
                              hideKeyboard(context);

                              movies.clear();
                              setState(() {});
                            },
                            icon: Icon(Icons.cancel, color: colorPrimary, size: 20),
                          ).visible(searchController.text.isNotEmpty),
                          IconButton(
                            onPressed: () {
                              VoiceSearchScreen().launch(context).then((value) {
                                if (value != null) {
                                  searchController.text = value;
                                  searchText = value;

                                  hideKeyboard(context);
                                  page = 1;
                                  init();
                                }
                              });
                            },
                            icon: Icon(Icons.keyboard_voice, color: colorPrimary, size: 20),
                          ).visible(searchController.text.isEmpty),
                        ],
                      ),
                    ],
                  ),
                ),
                headingText(language!.resultFor + " \'" + searchText + "\'")
                    .paddingOnly(left: 16, right: 16, top: 16, bottom: 12)
                    .visible(searchText.isNotEmpty),
                MovieGridList(movies),
                if (isLoading && page > 1) LoadingDotsWidget().paddingTop(8).center()
              ],
            ),
          ),
          if (isLoading && page == 1) Image.asset(ic_loading_gif, fit: BoxFit.cover, height: 100, width: 100).center(),
          if (!isLoading && movies.isEmpty && !hasError)
            NoDataWidget(
              imageWidget: Image.asset(ic_empty, height: 130),
              title: language!.noData,
            ).center(),
          if (hasError) Text(errorInternetNotAvailable, style: boldTextStyle(color: Colors.white)).center(),
        ],
      ),
    );
  }
}
