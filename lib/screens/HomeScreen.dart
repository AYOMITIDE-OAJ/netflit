import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:streamit_flutter/fragments/HomeFragment.dart';
import 'package:streamit_flutter/fragments/MoreFragment.dart';
import 'package:streamit_flutter/fragments/SearchFragment.dart';
import 'package:streamit_flutter/fragments/WatchlistFragment.dart';
import 'package:streamit_flutter/fragments/genre_fragment.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/models/DownloadData.dart';
import 'package:streamit_flutter/models/MovieDetailResponse.dart';
import 'package:streamit_flutter/network/RestApis.dart';
import 'package:streamit_flutter/screens/MovieDetailScreen.dart';
import 'package:streamit_flutter/screens/Signin.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';
import 'package:streamit_flutter/utils/resources/Images.dart';

class HomeScreen extends StatefulWidget {
  static String tag = '/HomeScreen';

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  HomeFragment homeFragment = HomeFragment();
  SearchFragment searchFragment = SearchFragment();
  WatchlistFragment myFilesFragment = WatchlistFragment();
  GenreFragment genreFragment = GenreFragment();
  MoreFragment moreFragment = MoreFragment();

  late List<Widget> viewContainer;

  @override
  void initState() {
    super.initState();
    viewContainer = [
      homeFragment,
      searchFragment,
      myFilesFragment,
      genreFragment,
      moreFragment,
    ];
    init();
  }

  Future<void> init() async {
    OneSignal.shared.setNotificationOpenedHandler((notification) async {
      if (getBoolAsync(isLoggedIn)) {
        if (notification.notification.additionalData != null) {
          if (notification.notification.additionalData!.containsKey('id')) {
            String? postId = notification.notification.additionalData!["id"];
            String? postType = notification.notification.additionalData!["post_type"];

            Future<MovieDetailResponse>? future;

            if (postType == 'movie') {
              future = movieDetail(postId.toInt().validate());
            } else if (postType == 'tv_show') {
              future = tvShowDetail(postId.toInt().validate());
            } else if (postType == 'episode') {
              future = episodeDetail(postId.toInt().validate());
            } else if (postType == 'video') {
              future = getVideosDetail(postId.toInt().validate());
            }

            if (postId.validate().isNotEmpty && future != null) {
              await future.then((value) {
                appStore.setTrailerVideoPlayer(true);
                MovieDetailScreen(movieData: value.data!).launch(context);
              });
            }
          }
        }
      }
    });

    if (getStringAsync(DOWNLOADED_DATA).isNotEmpty) {
      List<DownloadData> listData = (jsonDecode(getStringAsync(DOWNLOADED_DATA)) as List).map((e) => DownloadData.fromJson(e)).toList();
      for (DownloadData data in listData) {
        if (data.userId.validate() == getIntAsync(USER_ID)) {
          appStore.downloadedItemList.add(data);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      onWillPop: () async {
        if (selectedIndex == 0) return true;
        setState(() {
          selectedIndex = 0;
        });
        return false;
      },
      child: Scaffold(
        body: viewContainer[selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).splashColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                offset: Offset.fromDirection(3, 1),
                spreadRadius: 3,
                blurRadius: 5,
              ),
            ],
          ),
          child: NavigationBar(
            animationDuration: Duration(milliseconds: 300),
            backgroundColor: Theme.of(context).splashColor,
            selectedIndex: selectedIndex,
            onDestinationSelected: (i) async {
              if ((i == 2) && !mIsLoggedIn) {
                SignInScreen().launch(context);
              } else {
                selectedIndex = i;
                setState(() {});
              }
            },
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              NavigationDestination(
                icon: Image.asset(ic_home, fit: BoxFit.fitHeight, color: Colors.white, height: 20, width: 20),
                selectedIcon: Image.asset(ic_home, color: colorPrimary, height: 20, width: 20),
                label: language!.home,
                tooltip: language!.home,
              ),
              NavigationDestination(
                icon: Image.asset(ic_search, fit: BoxFit.fitHeight, color: Colors.white, height: 20, width: 20),
                selectedIcon: Image.asset(ic_search, color: colorPrimary, height: 20, width: 20),
                label: language!.search,
              ),
              NavigationDestination(
                icon: Icon(Icons.bookmark_border, size: 26, color: Colors.white),
                selectedIcon: Icon(Icons.bookmark_border, color: colorPrimary, size: 26),
                label: language!.watchList,
              ),
              NavigationDestination(
                icon: Image.asset(ic_genre, fit: BoxFit.fitHeight, color: Colors.white, height: 22, width: 22),
                selectedIcon: Image.asset(ic_genre, color: colorPrimary, height: 22, width: 22),
                label: 'Genre',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined, size: 22, color: Colors.white),
                selectedIcon: Icon(Icons.settings_outlined, size: 22, color: colorPrimary),
                label: language!.settings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
