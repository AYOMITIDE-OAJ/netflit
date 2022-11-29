import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/screens/EditProfileScreen.dart';
import 'package:streamit_flutter/screens/GenreListScreen.dart';
import 'package:streamit_flutter/screens/Signin.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Common.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';
import 'package:streamit_flutter/utils/resources/Images.dart';
import 'package:streamit_flutter/utils/resources/Size.dart';

class GenreFragment extends StatefulWidget {
  static String tag = '/Genre  Fragment';

  @override
  GenreFragmentState createState() => GenreFragmentState();
}

class GenreFragmentState extends State<GenreFragment> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          centerTitle: false,
          title: commonCacheImageWidget(ic_logo, height: 32),
          automaticallyImplyLeading: false,
          actions: [
            appStore.isLogging
                ? Container(
                    width: 50,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: commonCacheImageWidget(
                      appStore.userProfileImage.validate(),
                      fit: appStore.userProfileImage.validate().contains("http") ? BoxFit.cover : null,
                    ).onTap(() {
                      EditProfileScreen().launch(context);
                    }, borderRadius: BorderRadius.circular(60)),
                  )
                : commonCacheImageWidget(add_user, width: 20, height: 20, color: Colors.white).paddingAll(16).onTap(() {
                    SignInScreen().launch(context);
                  }, borderRadius: BorderRadius.circular(60)),
          ],
          bottom: PreferredSize(
            preferredSize: Size(context.width(), 45),
            child: Align(
              alignment: Alignment.topLeft,
              child: TabBar(
                indicatorWeight: 0.0,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: boldTextStyle(size: ts_small.toInt()),
                indicatorColor: colorPrimary,
                indicator: TabIndicator(),
                isScrollable: true,
                onTap: (i) {
                  index = i;
                  setState(() {});
                },
                unselectedLabelStyle: secondaryTextStyle(size: ts_small.toInt()),
                unselectedLabelColor: Theme.of(context).textTheme.headline6!.color,
                labelColor: colorPrimary,
                labelPadding: EdgeInsets.only(left: spacing_large, right: spacing_large),
                tabs: [
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
            GenreListScreen(type: dashboardTypeMovie),
            GenreListScreen(type: dashboardTypeTVShow),
            GenreListScreen(type: dashboardTypeVideo),
          ],
        ),
      ),
    );
  }
}
