import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';
import 'package:streamit_flutter/utils/resources/Images.dart';

/// todo: add languages keys
class VoiceSearchScreen extends StatefulWidget {
  const VoiceSearchScreen({Key? key}) : super(key: key);

  @override
  State<VoiceSearchScreen> createState() => _VoiceSearchScreenState();
}

class _VoiceSearchScreenState extends State<VoiceSearchScreen> {
  SpeechToText speech = SpeechToText();
  bool isListening = false;

  String text = language!.listening;
  bool showButton = false;

  Future<void> listen() async {
    if (!isListening) {
      bool available = await speech.initialize();

      if (available) {
        showButton = false;
        isListening = true;
        setState(() {});

        speech.listen(onResult: (val) {
          text = val.recognizedWords;
          isListening = false;
          setState(() {});
        });

        await 5.seconds.delay;

        if (text == language!.listening) {
          showButton = true;
          setState(() {});
        } else {
          finish(context, text);
        }
      }
    } else {
      isListening = false;
      setState(() {});
      speech.stop();
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    listen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: boldTextStyle(size: 24)).visible(!showButton),
          Icon(
            Icons.keyboard_voice,
            size: 50,
            color: colorPrimary,
          ).onTap(() {
            isListening = false;
            setState(() {});
            listen();
          }).visible(showButton),
          30.height.visible(showButton),
          Image.asset(
            ic_voice,
            height: 150,
            width: 150,
            color: colorPrimary,
          ).visible(!showButton),
          Text(
            language!.tapToSpeak,
            style: boldTextStyle(size: 20),
            textAlign: TextAlign.center,
          ).paddingSymmetric(horizontal: 40).visible(showButton)
        ],
      ).center(),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Text(language!.searchMoviesTvShowsVideos, style: primaryTextStyle(), textAlign: TextAlign.center),
      ),
    );
  }
}
