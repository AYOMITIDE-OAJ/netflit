import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/fragments/SubHomeFragment.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/screens/EditProfileScreen.dart';
import 'package:streamit_flutter/screens/Signin.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Common.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';
import 'package:streamit_flutter/utils/resources/Images.dart';
import 'package:streamit_flutter/utils/resources/Size.dart';

class HomeFragment extends StatefulWidget {
  static String tag = '/HomeFragment';

  @override
  HomeFragmentState createState() => HomeFragmentState();
}

class HomeFragmentState extends State<HomeFragment> {
  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).cardColor,
            centerTitle: false,
            title: commonCacheImageWidget(ic_logo, height: 32),
            automaticallyImplyLeading: false,
            actions: [
              appStore.isLogging
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: commonCacheImageWidget(
                        appStore.userProfileImage.validate(),
                        fit: appStore.userProfileImage.validate().contains("http") ? BoxFit.cover : BoxFit.cover,
                      ).onTap(() {
                        EditProfileScreen().launch(context);
                      }, highlightColor: Colors.transparent, splashColor: Colors.transparent),
                    )
                  : commonCacheImageWidget(
                      add_user,
                      width: 20,
                      fit: BoxFit.cover,
                      height: 20,
                      color: Colors.white,
                    ).paddingAll(16).onTap(() {
                      SignInScreen().launch(context);
                    }, borderRadius: BorderRadius.circular(60)),
            ],
            bottom: PreferredSize(
              preferredSize: Size(context.width(), 45),
              child: Align(
                alignment: Alignment.topLeft,
                child: TabBar(
                  isScrollable: true,
                  indicatorPadding: EdgeInsets.only(left: 30, right: 30),
                  indicatorWeight: 0.0,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: boldTextStyle(size: ts_small.toInt()),
                  indicatorColor: colorPrimary,
                  indicator: TabIndicator(),
                  onTap: (i) {
                    index = i;
                    setState(() {});
                  },
                  unselectedLabelStyle: secondaryTextStyle(size: ts_small.toInt()),
                  unselectedLabelColor: Theme.of(context).textTheme.headline6!.color,
                  labelColor: colorPrimary,
                  labelPadding: EdgeInsets.only(left: spacing_large, right: spacing_large),
                  tabs: [
                    Tab(child: Text(language!.home)),
                    Tab(child: Text(language!.movies)),
                    Tab(child: Text(language!.tVShows)),
                    Tab(child: Text(language!.videos)),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              HomeCategoryFragment(type: dashboardTypeHome),
              HomeCategoryFragment(type: dashboardTypeMovie),
              HomeCategoryFragment(type: dashboardTypeTVShow),
              HomeCategoryFragment(type: dashboardTypeVideo),
            ],
          ),
        ),
      ),
    );
  }
}
