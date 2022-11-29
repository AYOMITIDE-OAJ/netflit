import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/components/LanguageSelectionWidget.dart';

import '../main.dart';

class LanguageScreen extends StatefulWidget {
  static String tag = '/languageScreen';

  @override
  LanguageScreenState createState() => LanguageScreenState();
}

class LanguageScreenState extends State<LanguageScreen> {
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
    return Scaffold(
      appBar: appBarWidget(language!.language, color: Colors.transparent, textColor: Colors.white, elevation: 0),
      body: LanguageSelectionWidget(
        onLanguageChange: (local) async {
          if (await isNetworkAvailable()) {
            await appStore.setLanguage(local.languageCode);

            setState(() {});
          } else {
            toast(errorInternetNotAvailable);
          }
        },
      ),
    );
  }
}
