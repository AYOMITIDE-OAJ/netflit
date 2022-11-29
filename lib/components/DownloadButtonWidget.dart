import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:internet_file/internet_file.dart';
import 'package:internet_file/storage_io.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/models/DownloadData.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/screens/DownloadItemScreen.dart';
import 'package:streamit_flutter/utils/Common.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Images.dart';

import '../main.dart';
import '../utils/resources/Colors.dart';

class DownloadButtonWidget extends StatefulWidget {
  final MovieData? movie;
  final Episode? episode;

  const DownloadButtonWidget({this.movie, this.episode});

  @override
  State<DownloadButtonWidget> createState() => _DownloadButtonWidgetState();
}

class _DownloadButtonWidgetState extends State<DownloadButtonWidget> {
  late String _localPath;
  bool _permissionReady = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    _permissionReady = await checkPermission();

    if (_permissionReady) {
      await prepareSaveDir().then((value) {
        if (mounted) {
          setState(() {
            _localPath = value;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DownloadButtonComponent(movie: widget.movie, episode: widget.episode).onTap(() async {
      if (!await isNetworkAvailable()) return;
      if (appStore.downloadedItemList.any((e) => e.id == (widget.movie != null ? widget.movie!.id.validate() : widget.episode!.id.validate())) && !appStore.isDownloading) {
        DownloadItemScreen().launch(context);
      } else if (!appStore.downloadedItemList.any((e) => e.id == (widget.movie != null ? widget.movie!.id.validate() : widget.episode!.id.validate())) && appStore.isDownloading) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(language!.pleaseWait, style: primaryTextStyle())));
      } else {
        if (_permissionReady) {
          appStore.setDownloading(true);
          final storageIO = InternetFileStorageIO();
          final savedDir = Directory("$_localPath/downloads");
          bool hasExisted = await savedDir.exists();
          if (!hasExisted) {
            savedDir.create();
          }

          await InternetFile.get(
            widget.movie != null ? widget.movie!.file.validate() : widget.episode!.file.validate(),
            storage: storageIO,
            storageAdditional: {
              'filename': widget.movie != null ? widget.movie!.file.validate().split('/').last : widget.episode!.file.validate().split('/').last,
              'location': savedDir.path,
            },
            process: (percentage) {
              appStore.setDownloadPercentage(percentage.toInt());
            },
          ).then((value) async {
            appStore.setDownloading(false);
            appStore.setDownloadPercentage(0);
            DownloadData data = DownloadData();
            data.id = widget.movie != null ? widget.movie!.id.validate() : widget.episode!.id.validate();
            data.title = widget.movie != null ? widget.movie!.title.validate() : widget.episode!.title.validate();
            data.image = widget.movie != null ? widget.movie!.image.validate() : widget.episode!.image.validate();
            data.description = widget.movie != null ? widget.movie!.description.validate() : widget.episode!.description.validate();
            data.duration = widget.movie != null ? widget.movie!.run_time.validate() : widget.episode!.run_time.validate();
            data.filePath = widget.movie != null ? "${savedDir.path}/${widget.movie!.file.validate().split('/').last}" : "${savedDir.path}/${widget.episode!.file.validate().split('/').last}";
            data.userId = getIntAsync(USER_ID);
            addOrRemoveFromLocalStorage(data);
          }).catchError((e) {
            appStore.setDownloading(false);
            appStore.setDownloadPercentage(0);
            addOrRemoveFromLocalStorage(DownloadData.fromJson(widget.movie != null ? widget.movie!.toJson() : widget.episode!.toJson()), isDelete: true);
            if (e is SocketException) {
              toast(language!.yourInterNetNotWorking);
            } else if (e is TimeoutException) {
              toast(timeOutMsg);
            }
            log("Error when Download File : ${e.toString()}");
          });
        } else {
          _retryRequestPermission();
        }
      }
    }, highlightColor: Colors.transparent, splashColor: Colors.transparent);
  }

  Future<void> _retryRequestPermission() async {
    final hasGranted = await checkPermission();
    if (hasGranted) {
      await prepareSaveDir().then((value) {
        setState(() {
          _localPath = value;
          _permissionReady = hasGranted;
        });
      });
    }
  }
}

class DownloadButtonComponent extends StatelessWidget {
  final MovieData? movie;
  final Episode? episode;

  DownloadButtonComponent({this.movie, this.episode});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Container(
          width: 50,
          height: 50,
          margin: EdgeInsets.only(top: 8, right: 8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (!appStore.downloadedItemList.any((e) => e.id == (movie != null ? movie!.id.validate() : episode!.id.validate())) && !appStore.isDownloading) Lottie.asset(download_lottie),
              if (appStore.isDownloading && !appStore.downloadedItemList.any((e) => e.id == (movie != null ? movie!.id.validate() : episode!.id.validate())))
                Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(value: (appStore.downloadPercentage / 100), color: colorPrimary),
                    Align(alignment: Alignment.center, child: Text("${appStore.downloadPercentage} %", style: boldTextStyle(size: 14))),
                  ],
                ),
              if (appStore.downloadedItemList.any((e) => e.id == (movie != null ? movie!.id.validate() : episode!.id.validate())) && !appStore.isDownloading)
                Icon(Icons.check, color: colorPrimary, size: 32),
            ],
          ),
        );
      },
    );
  }
}
