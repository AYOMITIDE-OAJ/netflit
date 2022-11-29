import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/network/RestApis.dart';
import 'package:streamit_flutter/screens/HomeScreen.dart';
import 'package:streamit_flutter/screens/InAppWebviewScreen.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';
import 'package:streamit_flutter/utils/resources/Images.dart';
import 'package:streamit_flutter/utils/resources/Size.dart';

class SignInScreen extends StatefulWidget {
  static String tag = '/SignInScreen';

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode passFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

  bool passwordVisible = false;
  bool isLoading = false;

  Future<void> doSignIn() async {
    hideKeyboard(context);

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      Map req = {
        "username": emailController.text,
        "password": passwordController.text,
      };

      hideKeyboard(context);
      isLoading = true;
      setState(() {});

      await token(req).then((res) async {
        isLoading = false;

        await setValue(PASSWORD, passwordController.text);
        setState(() {});
        finish(context);
        HomeScreen().launch(context, isNewTask: true);
      }).catchError((e) {
        isLoading = false;
        FocusScope.of(context).requestFocus(passFocus);
        setState(() {});
        toast(e.toString());
        log(e.toString());
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setStatusBarColor(Colors.transparent, delayInMilliSeconds: 500);
  }

  @override
  void dispose() {
    setStatusBarColor(appBackground);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          commonCacheImageWidget(
            'assets/images/background_ek49.png',
            fit: BoxFit.fill,
            width: context.width(),
            height: context.height(),
          ),
          Container(width: context.width(), height: context.height(), color: Colors.black.withOpacity(0.5)),
          Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    child: Column(
                      children: [
                        commonCacheImageWidget(ic_logo, height: 32),
                        24.height,
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: language!.email,
                            labelStyle: primaryTextStyle(color: Colors.white),
                            suffixIcon: Icon(Icons.mail_outline, color: colorPrimary),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade500)),
                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                            border: OutlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                          ),
                          maxLines: 1,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) return language!.thisFieldIsRequired;
                            //if (!value.validateEmail()) return 'Email is invalid';
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          focusNode: emailFocus,
                          onFieldSubmitted: (s) {
                            FocusScope.of(context).requestFocus(passFocus);
                          },
                        ),
                        24.height,
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: language!.password,
                            labelStyle: primaryTextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                            border: OutlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade500)),
                            suffixIcon: Icon(
                              passwordVisible ? Icons.visibility : Icons.visibility_off,
                              color: colorPrimary,
                            ).onTap(() {
                              passwordVisible = !passwordVisible;
                              setState(() {});
                            }),
                          ),
                          obscureText: !passwordVisible,
                          validator: (value) {
                            if (value!.isEmpty) return language!.thisFieldIsRequired;
                            if (value.length < passwordLength) return language!.passwordLengthShouldBeMoreThan6;
                            return null;
                          },
                          focusNode: passFocus,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (s) {
                            doSignIn();
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            language!.forgotPasswordData,
                            style: boldTextStyle(size: ts_small.toInt(), color: Colors.white),
                          ).paddingSymmetric(vertical: spacing_standard_new, horizontal: spacing_standard).onTap(() {
                            onForgotPasswordClicked(context);
                          }),
                        ),
                        AppButton(
                          width: context.width(),
                          child: Text(language!.login, style: boldTextStyle()),
                          color: colorPrimary,
                          onTap: () {
                            doSignIn();
                          },
                        ),
                        16.height,
                        GestureDetector(
                          onTap: () {
                            if (getStringAsync(REGISTRATION_PAGE).isNotEmpty) {
                              // UrlLauncherScreen(getStringAsync(REGISTRATION_PAGE)).launch(context);
                              InAppWebViewScreen(Uri.parse(getStringAsync(REGISTRATION_PAGE))).launch(context);
                              // launchCustomTabURL(url: getStringAsync(REGISTRATION_PAGE));
                            } else {
                              toast(redirectionUrlNotFound);
                            }
                          },
                          child: RichTextWidget(
                            list: <TextSpan>[
                              TextSpan(
                                text: language!.dontHaveAnAccount + ' ',
                                style: boldTextStyle(size: 12, fontFamily: GoogleFonts.nunito().fontFamily),
                              ),
                              TextSpan(
                                text: language!.registerNow,
                                style: boldTextStyle(size: 14, color: colorPrimary, fontFamily: GoogleFonts.nunito().fontFamily),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ).paddingSymmetric(horizontal: 16, vertical: 24),
              ),
            ).center(),
          ),
          Center(child: Image.asset(ic_loading_gif, fit: BoxFit.cover, height: 100, width: 100).visible(isLoading)),
          BackButton().paddingTop(24),
        ],
      ),
    );
  }

  Future<void> onForgotPasswordClicked(BuildContext context) async {
    var emailCont = TextEditingController();

    void loginClick() async {
      if (formKey1.currentState!.validate()) {
        formKey1.currentState!.save();

        if (emailCont.text.trim().isEmpty) {
          toast(language!.thisFieldIsRequired);
          return;
        }
        if (!emailCont.text.trim().validateEmail()) {
          toast(language!.enterValidEmail);
          return;
        }
        appStore.setLoading(true);

        await forgotPassword({'email': emailCont.text.trim()}).then((value) {
          hideKeyboard(context);
          toast(value.message.validate());
          appStore.setLoading(false);
          finish(context);
        }).catchError((e) {
          appStore.setLoading(false);
          toast(e.toString());
        });
      }
    }

    await showInDialog(
      context,
      contentPadding: EdgeInsets.all(16),
      backgroundColor: Colors.grey.shade800.withAlpha(170),
      builder: (context) {
        return Observer(
          builder: (context) {
            return Stack(
              children: [
                Form(
                  key: formKey1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(language!.forgotPasswordData, style: boldTextStyle(size: 18)),
                          IconButton(
                            onPressed: () {
                              finish(context);
                            },
                            icon: Icon(Icons.close),
                          ),
                        ],
                      ),
                      16.height,
                      TextFormField(
                        controller: emailCont,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: language!.email,
                          labelStyle: primaryTextStyle(color: Colors.white),
                          suffixIcon: Icon(Icons.mail_outline, color: colorPrimary),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade500)),
                          errorBorder: OutlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                          border: OutlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return language!.thisFieldIsRequired;
                          return null;
                        },
                        autofocus: true,
                        onFieldSubmitted: (s) {
                          loginClick();
                        },
                      ),
                      24.height,
                      AppButton(
                        onTap: () async {
                          loginClick();
                        },
                        color: colorPrimary,
                        child: Text(language!.submit, style: boldTextStyle(color: Colors.white)),
                      ).center(),
                    ],
                  ),
                ),
                Image.asset(ic_loading_gif, fit: BoxFit.cover).withSize(height: 100, width: 100).center().visible(appStore.isLoading),
              ],
            );
          },
        );
      },
    );
  }
}
