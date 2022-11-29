import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:streamit_flutter/local/AppLocalizations.dart';
import 'package:streamit_flutter/local/BaseLanguage.dart';
import 'package:streamit_flutter/screens/HomeScreen.dart';
import 'package:streamit_flutter/screens/SplashScreen.dart';
import 'package:streamit_flutter/store/AppStore.dart';
import 'package:streamit_flutter/utils/AppTheme.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

AppStore appStore = AppStore();
int mAPIQueueCount = 0;
bool mIsLoggedIn = false;
int? mUserId;
int adShowCount = 0;
BaseLanguage? language;

bool isMiniPlayer = false;
String miniPlayerUrl = '';

YoutubePlayerController? youtubePlayerController;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await initialize(aLocaleLanguageList: languageList());

  await appStore.setLanguage(getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: defaultLanguage));

  textPrimaryColorGlobal = Colors.white;
  textSecondaryColorGlobal = Colors.grey.shade500;

  mUserId = getIntAsync(USER_ID);
  appStore.setUserProfile(getStringAsync(USER_PROFILE));
  appStore.setFirstName(getStringAsync(NAME));
  appStore.setLastName(getStringAsync(LAST_NAME));
  appStore.setLogging(getBoolAsync(isLoggedIn));
  appStore.setUserProfile(getStringAsync(USER_PROFILE));

  if (isMobile) {
    MobileAds.instance.initialize();

    await OneSignal.shared.setAppId(mOneSignalAPPKey);
    OneSignal.shared.consentGranted(true);
    OneSignal.shared.promptUserForPushNotificationPermission();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setOrientationPortrait();

    return Observer(
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          HomeScreen.tag: (BuildContext context) => HomeScreen(),
        },
        builder: scrollBehaviour(),
        supportedLocales: LanguageDataModel.languageLocales(),
        localizationsDelegates: [
          AppLocalizations(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) => locale,
        locale: Locale(appStore.selectedLanguageCode),
      ),
    );
  }
}
