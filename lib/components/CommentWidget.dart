import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/models/CommentModel.dart';
import 'package:streamit_flutter/network/RestApis.dart';
import 'package:streamit_flutter/screens/Signin.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Common.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';

import '../main.dart';
import '../utils/resources/Images.dart';

// ignore: must_be_immutable
class CommentWidget extends StatefulWidget {
  static String tag = '/CommentWidget';
  final int? postId;
  int? noOfComments;

  CommentWidget({this.postId, this.noOfComments});

  @override
  CommentWidgetState createState() => CommentWidgetState();
}

class CommentWidgetState extends State<CommentWidget> {
  TextEditingController firstInnerCommCont = TextEditingController();
  TextEditingController secondInnerCommCont = TextEditingController();
  TextEditingController mainCommentCont = TextEditingController();

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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CommentModel>>(
      future: getComments(postId: widget.postId, page: 1, commentPerPage: postPerPage),
      builder: (context, snap) {
        if (snap.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      headingText('${buildCommentCountText(widget.noOfComments.validate())}'),
                      8.height,
                      mIsLoggedIn
                          ? Container(
                              constraints: BoxConstraints(maxHeight: 100),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                padding: EdgeInsetsDirectional.all(0),
                                reverse: true,
                                child: AppTextField(
                                  controller: mainCommentCont,
                                  textFieldType: TextFieldType.MULTILINE,
                                  maxLines: 5,
                                  minLines: 2,
                                  keyboardType: TextInputType.multiline,
                                  textStyle: primaryTextStyle(color: textColorPrimary),
                                  errorThisFieldRequired: errorThisFieldRequired,
                                  decoration: InputDecoration(
                                    hintText: language!.addAComment,
                                    hintStyle: secondaryTextStyle(),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.send),
                                      color: colorPrimary,
                                      onPressed: () {
                                        hideKeyboard(context);
                                        appStore.setLoading(true);

                                        buildComment(content: mainCommentCont.text.trim(), postId: widget.postId).then((value) {
                                          mainCommentCont.clear();
                                          appStore.setLoading(false);

                                          widget.noOfComments = widget.noOfComments.validate() + 1;

                                          setState(() {});
                                        }).catchError((error) {
                                          toast(language!.pleaseEnterComment);
                                          appStore.setLoading(false);
                                        });
                                      },
                                    ),
                                    border: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                                  ),
                                ),
                              ),
                            )
                          : Text(language!.loginToAddComment, style: primaryTextStyle(color: colorPrimary, size: 18)).onTap(() {
                              SignInScreen().launch(context);
                            }),
                    ],
                  ),
                  Observer(builder: (context) {
                    return Image.asset(ic_loading_gif, fit: BoxFit.cover, height: 100, width: 100).center().visible(appStore.isLoading);
                  }),
                ],
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: 24),
                itemCount: snap.data!.length,
                itemBuilder: (_, index) {
                  CommentModel comment = snap.data![index];

                  return comment.parent == 0
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                              child: Text(
                                comment.authorName![0].validate(),
                                style: boldTextStyle(color: colorPrimary, size: 20),
                              ).center(),
                            ),
                            16.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(comment.authorName.validate(), style: boldTextStyle(color: Colors.white)),
                                        TextIcon(
                                          prefix: Icon(Icons.calendar_today_outlined, size: 14, color: textSecondaryColorGlobal),
                                          edgeInsets: EdgeInsets.zero,
                                          text: DateFormat(dateFormat).format(DateTime.parse(comment.date.validate())),
                                          textStyle: secondaryTextStyle(),
                                        )
                                      ],
                                    ).expand(),
                                  ],
                                ),
                                4.height,
                                Text(
                                  parseHtmlString(comment.content!.rendered.validate()),
                                  style: primaryTextStyle(color: Colors.grey, size: 14),
                                ),
                              ],
                            ).expand(),
                          ],
                        ).paddingAll(16)
                      : SizedBox();
                },
                separatorBuilder: (_, index) => Divider(color: textColorPrimary, thickness: 0.1, height: 0),
              ),
            ],
          );
        }

        return SizedBox();
      },
    );
  }
}
