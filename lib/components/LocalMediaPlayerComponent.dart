
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/models/DownloadData.dart';
import 'package:streamit_flutter/screens/movieDetailComponents/MovieFileWidget.dart';
import 'package:streamit_flutter/utils/Common.dart';

class LocalMediaPlayerComponent extends StatefulWidget {
  final DownloadData data;

  const LocalMediaPlayerComponent({required this.data});

  @override
  State<LocalMediaPlayerComponent> createState() => _LocalMediaPlayerComponentState();
}

class _LocalMediaPlayerComponentState extends State<LocalMediaPlayerComponent> {
  @override
  void initState() {
    super.initState();
    afterBuildCreated(() => init());
  }

  Future<void> init() async {
    //
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MovieFileWidget(widget.data.filePath.validate(), isFromLocalStorage: true),
            8.height,
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(parseHtmlString(widget.data.title.validate()), style: boldTextStyle(size: 22)),
                  4.height,
                  if (widget.data.duration.validate().isNotEmpty) Text(widget.data.duration.validate(), style: secondaryTextStyle(size: 16)),
                  8.height,
                  HtmlWidget(widget.data.description.validate(), textStyle: secondaryTextStyle()),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
