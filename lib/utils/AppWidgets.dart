import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';
import 'package:streamit_flutter/utils/resources/Size.dart';

import 'dots_indicator/DotsDecorator.dart';

Widget itemTitle(BuildContext context, String titleText, {double fontSize = ts_normal, int? maxLine, TextAlign? textAlign}) {
  return Text(
    titleText,
    style: TextStyle(
      fontSize: fontSize,
      color: Colors.white,
      fontWeight: FontWeight.normal,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 5.0,
          color: Colors.black,
        ),
      ],
    ),
    textAlign: textAlign ?? TextAlign.center,
    overflow: TextOverflow.ellipsis,
    maxLines: maxLine ?? 1,
  );
}

Widget itemSubTitle(BuildContext context, String titleText, {double fontSize = ts_normal, Color? textColor, isLongText = true}) {
  return Text(
    titleText,
    style: TextStyle(
      fontSize: fontSize,
      color: textColor ?? textPrimaryColorGlobal,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 5.0,
          color: Colors.black,
        ),
      ],
    ),
  );
}

Widget headingText(var titleText, {int? fontSize, int maxLines = 1}) {
  return Text(titleText, style: primaryTextStyle(size: fontSize ?? 18), maxLines: maxLines, overflow: TextOverflow.ellipsis);
}

Widget headingWidViewAll(BuildContext context, var titleText, {VoidCallback? callback, bool showViewMore = true}) {
  return GestureDetector(
    onTap: callback,
    child: Row(
      children: <Widget>[
        Expanded(child: headingText(titleText)),
        Icon(Icons.arrow_forward_ios, size: 14, color: context.iconColor),
      ],
    ),
  );
}

BoxDecoration boxDecoration(BuildContext context,
    {double radius = 2, Color color = Colors.transparent, Color bgColor = white, bool showShadow = false}) {
  return BoxDecoration(
      //gradient: LinearGradient(colors: [bgColor, whiteColor]),
      color: bgColor == white ? Theme.of(context).cardTheme.color : bgColor,
      boxShadow: showShadow
          ? [BoxShadow(color: Theme.of(context).hoverColor.withOpacity(0.2), blurRadius: 5, spreadRadius: 3, offset: Offset(1, 3))]
          : [BoxShadow(color: Colors.transparent)],
      border: Border.all(color: color),
      borderRadius: BorderRadius.all(Radius.circular(radius)));
}

Widget button(BuildContext context, buttonText, {VoidCallback? onTap, double? width}) {
  return AppButton(
    width: width ?? null,
    textColor: colorPrimary,
    color: colorPrimary,
    padding: EdgeInsets.only(top: 12, bottom: 12),
    child: Text(buttonText, style: primaryTextStyle(size: ts_normal.toInt(), color: Theme.of(context).textTheme.button!.color)),
    shapeBorder: RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(spacing_control),
      side: BorderSide(color: colorPrimary),
    ),
    onTap: onTap,
  );
}

Widget iconButton(context, buttonText, icon, callBack, {backgroundColor, borderColor, buttonTextColor, iconColor, padding = 12.0}) {
  return AppButton(
    color: Colors.grey.withOpacity(0.1),
    splashColor: Colors.grey.withOpacity(0.2),
    padding: EdgeInsets.only(top: padding, bottom: padding, left: 8, right: 8),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        iconColor == null
            ? Image.asset(
                icon,
                width: 16,
                height: 16,
                color: Colors.white,
              )
            : Image.asset(
                icon,
                width: 16,
                height: 16,
                color: iconColor,
              ),
        Text(
          buttonText,
          style: primaryTextStyle(
            size: ts_tiny.toInt(),
            color: buttonTextColor == null ? Theme.of(context).textTheme.button!.color : buttonTextColor,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ).paddingLeft(spacing_standard).expand(),
      ],
    ).center(),
    onTap: callBack,
  );
}

DotsDecorator dotsDecorator(context) {
  return DotsDecorator(
      color: Colors.grey.withOpacity(0.5),
      activeColor: colorPrimary,
      activeSize: Size.square(8.0),
      size: Size.square(6.0),
      spacing: EdgeInsets.all(spacing_control_half));
}

Widget loadingWidgetMaker() {
  return Container(
    alignment: Alignment.center,
    child: Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: spacing_control,
      margin: EdgeInsets.all(4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Container(
        width: 45,
        height: 45,
        padding: const EdgeInsets.all(8.0),
        child: CircularProgressIndicator(
          strokeWidth: 3,
        ),
      ),
    ),
  );
}

Widget subType(context, VoidCallback callback, icon, {bool showTrailIcon = true, String? title}) {
  return SettingItemWidget(
    onTap: callback,
    title: title!,
    titleTextStyle: primaryTextStyle(color: Colors.white),
    leading: icon != null
        ? Image.asset(
            icon,
            width: 16,
            height: 20,
            color: Theme.of(context).textTheme.headline6!.color,
          )
        : SizedBox(),
    trailing: Icon(
      Icons.arrow_forward_ios,
      size: 16,
      color: Theme.of(context).textTheme.caption!.color,
    ).visible(showTrailIcon),
  );
}

Widget hdWidget(context) {
  return Container(
    decoration: BoxDecoration(color: colorPrimary, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(4))),
    padding: EdgeInsets.only(top: 0, bottom: 2, left: 4, right: 4),
    child: Text("HD", style: primaryTextStyle(color: textColorPrimary, size: 10)),
  );
}

InputDecoration inputDecoration({String? hint, IconData? suffixIcon}) {
  return InputDecoration(
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade500)),
    disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade500)),
    labelText: hint,
    labelStyle: TextStyle(fontSize: ts_normal, color: textColorPrimary),
    suffixIcon: Icon(suffixIcon, color: colorPrimary),
  );
}

Widget placeholderWidget() => Image.asset('assets/images/grey.jpg', fit: BoxFit.cover);

Widget Function(BuildContext, String) placeholderWidgetFn() => (_, s) => placeholderWidget();

Widget commonCacheImageWidget(String? url, {double? width, BoxFit? fit, double? height, Color? color, Widget? placeHolderWidget}) {
  if (url.validate().isEmpty) {
    return Image.asset('assets/images/grey.jpg', height: height, width: width, fit: fit);
  }
  if (url.validate().startsWith('http')) {
    if (isMobile) {
      return CachedNetworkImage(
        placeholder: placeholderWidgetFn(),
        imageUrl: '$url',
        height: height,
        width: width,
        fit: fit,
        color: color,
      );
    } else {
      return Image.network(url.validate(), height: height, width: width, fit: fit, color: color);
    }
  } else {
    return Image.asset(url.validate(), height: height, width: width, fit: fit, color: color);
  }
}

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(id: 1, name: 'English', languageCode: 'en', fullLanguageCode: 'en-US', flag: 'assets/images/flag/ic_us.png'),
    LanguageDataModel(id: 2, name: 'Hindi', languageCode: 'hi', fullLanguageCode: 'hi-IN', flag: 'assets/images/flag/ic_india.png'),
    LanguageDataModel(id: 3, name: 'Arabic', languageCode: 'ar', fullLanguageCode: 'ar-AR', flag: 'assets/images/flag/ic_ar.png'),
    LanguageDataModel(id: 4, name: 'French', languageCode: 'fr', fullLanguageCode: 'fr-FR', flag: 'assets/images/flag/ic_france.png'),
  ];
}

String userProfileImage() {
  Random random = Random();
  return 'assets/images/smile_${random.nextInt(4)}.png';
}
