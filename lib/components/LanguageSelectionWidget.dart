import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';

class LanguageSelectionWidget extends StatelessWidget {
  final Function(Locale) onLanguageChange;

  const LanguageSelectionWidget({Key? key, required this.onLanguageChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: LanguageDataModel.languageLocales().map(
        (e) {
          LanguageDataModel data = localeLanguageList[LanguageDataModel.languageLocales().indexOf(e)];
          return Container(
            width: (context.width() / 3) - 16,
            height: 60,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                commonCacheImageWidget(
                  data.flag,
                  fit: BoxFit.cover,
                  height: context.height(),
                  width: context.width(),
                ).cornerRadiusWithClipRRect(8),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Theme.of(context).scaffoldBackgroundColor],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 1.0],
                      tileMode: TileMode.repeated,
                    ),
                  ),
                ),
                Positioned(bottom: 4, left: 4, right: 4, child: Text(data.name.validate(), style: boldTextStyle())),
                if (getStringAsync(SELECTED_LANGUAGE_CODE) == data.languageCode.validate())
                  Positioned(
                    top: 4,
                    right: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          padding: EdgeInsets.only(left: 4, top: 4, right: 4, bottom: 4),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white70),
                          child: Icon(Icons.favorite, size: 14, color: colorPrimary),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ).onTap(
            () {
              onLanguageChange.call(e);
            },
          );
        },
      ).toList(),
    ).paddingAll(8);
  }
}
