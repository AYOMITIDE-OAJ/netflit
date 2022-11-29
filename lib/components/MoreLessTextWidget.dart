import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';
import 'package:streamit_flutter/utils/resources/Size.dart';

// ignore: must_be_immutable
class MoreLessText extends StatefulWidget {
  String? titleText;
  var fontSize = ts_normal;
  var colorThird = false;

  MoreLessText(this.titleText, {this.fontSize = ts_normal, this.colorThird = false});

  @override
  MoreLessTextState createState() => MoreLessTextState();
}

class MoreLessTextState extends State<MoreLessText> {
  var isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.titleText!,
          style: secondaryTextStyle(size: widget.fontSize.toInt(), color: textSecondaryColor),
          overflow: TextOverflow.ellipsis,
          maxLines: isExpanded ? 20 : 2,
        ),
        Text(
          isExpanded ? language!.readLess : language!.readMore,
          style: primaryTextStyle(color: textColorPrimary, size: widget.fontSize.toInt()),
        ).onTap(
          () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
        ),
      ],
    );
  }
}
