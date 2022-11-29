import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/components/ViewAllMovieGridList.dart';
import 'package:streamit_flutter/models/MovieData.dart';

// ignore: must_be_immutable
class ViewAllMovieGridScreen extends StatefulWidget {
  static String tag = '/ViewAllMovieScreen';
  String? title = "";
  final List<MovieData>? upcomingVideo;

  ViewAllMovieGridScreen({this.title, this.upcomingVideo});

  @override
  ViewAllMovieGridScreenState createState() => ViewAllMovieGridScreenState();
}

class ViewAllMovieGridScreenState extends State<ViewAllMovieGridScreen> {
  List<MovieData> movieList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(widget.title.validate(), color: Colors.transparent, textColor: Colors.white, elevation: 0),
      body: AllMovieGridList(widget.upcomingVideo.validate()),
    );
  }
}
