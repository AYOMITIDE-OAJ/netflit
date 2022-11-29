import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/local/AppLocalizations.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/models/DownloadData.dart';
import 'package:streamit_flutter/utils/Constants.dart';

part 'AppStore.g.dart';

class AppStore = AppStoreBase with _$AppStore;

abstract class AppStoreBase with Store {
  //region User Details
  @observable
  String? userProfileImage = '';

  @observable
  String? userFirstName = '';

  @observable
  String? userLastName = '';

  @observable
  bool isLoading = false;

  @action
  void setUserProfile(String? image) {
    userProfileImage = image;
  }

  @action
  void setFirstName(String? name) {
    userFirstName = name;
  }

  @action
  void setLastName(String? name) {
    userLastName = name;
  }

  //endregion

  //region Subscription Plan Details
  @observable
  String subscriptionPlanId = "";

  @observable
  String subscriptionPlanStartDate = "";

  @observable
  String subscriptionPlanExpDate = "";

  @observable
  String subscriptionPlanStatus = "";

  @observable
  String subscriptionPlanTrialStatus = "";

  @observable
  String subscriptionPlanName = "";

  @observable
  String subscriptionPlanAmount = "";

  @observable
  String subscriptionTrialPlanEndDate = "";

  @observable
  String subscriptionTrialPlanStatus = "";

  @observable
  int downloadPercentage = 0;

  @observable
  bool hasErrorWhenDownload = false;

  @observable
  ObservableList<DownloadData> downloadedItemList = ObservableList.of(<DownloadData>[]);

  @observable
  bool isDownloading = false;

  @observable
  bool isTrailerVideoPlaying = false;

  @action
  void setTrailerVideoPlayer(bool value) {
    isTrailerVideoPlaying = value;
  }

  @action
  void setDownloading(bool val) {
    isDownloading = val;
  }

  @action
  void setDownloadError(bool val) {
    hasErrorWhenDownload = val;
  }

  @action
  void setDownloadPercentage(int val) {
    downloadPercentage = val;
  }

  @action
  void setSubscriptionPlanId(String id) {
    subscriptionPlanId = id;
  }

  @action
  void setSubscriptionTrialPlanStatus(String trialStatus) {
    subscriptionTrialPlanStatus = trialStatus;
  }

  @action
  void setSubscriptionPlanStartDate(String date) {
    subscriptionPlanStartDate = date;
  }

  @action
  void setSubscriptionPlanExpDate(String date) {
    subscriptionPlanExpDate = date;
  }

  @action
  void setSubscriptionPlanStatus(String status) {
    subscriptionPlanStatus = status;
  }

  @action
  void setSubscriptionPlanName(String name) {
    subscriptionPlanName = name;
  }

  @action
  void setSubscriptionPlanAmount(String amount) {
    subscriptionPlanAmount = amount;
  }

  @action
  void setSubscriptionTrialPlanEndDate(String planEndDate) {
    subscriptionTrialPlanEndDate = planEndDate;
  }

  //endregion

  //region App setting
  @observable
  bool hasInFullScreen = false;

  @observable
  String selectedLanguageCode = defaultLanguage;

  @observable
  bool isLogging = false;

  @action
  void setLogging(bool value) {
    isLogging = value;
  }

  @action
  void setToFullScreen(bool value) {
    hasInFullScreen = value;
  }

  @action
  void setLoading(bool aIsLoading) {
    isLoading = aIsLoading;
  }

  @action
  Future<void> setLanguage(String val) async {
    selectedLanguageCode = val;
    selectedLanguageDataModel = getSelectedLanguageModel();

    await setValue(SELECTED_LANGUAGE_CODE, selectedLanguageCode);

    language = await AppLocalizations().load(Locale(selectedLanguageCode));

    errorInternetNotAvailable = language!.yourInterNetNotWorking;
    errorMessage = language!.pleaseTryAgain;
    errorSomethingWentWrong = language!.somethingWentWrong;
    errorThisFieldRequired = language!.pleaseTryAgain;
  }
//endregion
}
