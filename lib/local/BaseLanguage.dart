import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage of(BuildContext context) => Localizations.of<BaseLanguage>(context, BaseLanguage)!;

  String get changePasswordText;

  String get watchVideosOffline;

  String get tapToSpeak;

  String get listening;

  String get danger;

  String get areYouSureYou;

  String get deleteAccount;

  String get deleteMovieSuccessfully;

  String get downloadedVideos;

  String get areYouSureYouWantDeleteThisMovie;

  String get delete;

  String get downloads;

  String get done;

  String get downloadSuccessfully;

  String get quality;

  String get player;

  String get date;

  String get links;

  String get sources;

  String get settings;

  String get dontHaveAnAccount;

  String get watchNow;

  String get signIn;

  String get somethingWantWrongPleaseContactYourAdministrator;

  String get writeSomething;

  String get commentAdded;

  String get sActing;

  String get addAComment;

  String get yourInterNetNotWorking;

  String get somethingWentWrong;

  String get thisFieldIsRequired;

  String get pleaseTryAgain;

  String get addReply;

  String get viewreply;

  String get readLess;

  String get readMore;

  String get noData;

  String get upgradePlan;

  String get subscribeNow;

  String get recommendedMovies;

  String get upcomingMovies;

  String get upcomingVideo;

  String get action;

  String get movies;

  String get tVShows;

  String get videos;

  String get home;

  String get more;

  String get membershipPlan;

  String get generalSettings;

  String get accountSettings;

  String get others;

  String get termsConditions;

  String get privacyPolicy;

  String get logOut;

  String get doYouWantToLogout;

  String get cancel;

  String get ok;

  String get search;

  String get searchMoviesTvShowsVideos;

  String get watchList;

  String get pleaseWait;

  String get addedToList;

  String get myList;

  String get changePassword;

  String get all;

  String get mostViewed;

  String get personalInfo;

  String get knownFor;

  String get knownCredits;

  String get placeOfBirth;

  String get alsoKnownAs;

  String get birthday;

  String get deathDay;

  String get password;

  String get newPassword;

  String get confirmPassword;

  String get bothPasswordShouldBeMatched;

  String get submit;

  String get changeAvatar;

  String get firstName;

  String get lastName;

  String get email;

  String get editProfile;

  String get save;

  String get viewInfo;

  String get loginNow;

  String get previous;

  String get next;

  String get trailerLink;

  String get runTime;

  String get episodes;

  String get loginToAddComment;

  String get views;

  String get starring;

  String get getStarted;

  String get login;

  String get forgotPassword;

  String get registerNow;

  String get enterValidEmail;

  String get forgotPasswordData;

  String get username;

  String get emailIsInvalid;

  String get passWordNotMatch;

  String get signUpNow;

  String get createAccount;

  String get signUpToDiscoverOurFeature;

  String get streamTermsConditions;

  String get back;

  String get jumanjiTheNextLevel;

  String get title;

  String get viewAll;

  String get language;

  String get selectTheme;

  String get as;

  String get validTill;

  String get resultFor;

  String get episode;

  String get likes;

  String get like;

  String get comments;

  String get comment;

  String get passwordLengthShouldBeMoreThan6;

  String get aboutUs;

  String get no;

  String get yes;

  String get profileHasBeenUpdatedSuccessfully;

  String get pleaseEnterPassword;

  String get pleaseEnterNewPassword;

  String get pleaseEnterConfirmPassword;

  String get pleaseEnterComment;
}
