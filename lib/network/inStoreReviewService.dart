import 'package:firebase_remote_config/firebase_remote_config.dart';

Future<FirebaseRemoteConfig> storeReviewConfig() async {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  await _remoteConfig.setConfigSettings(RemoteConfigSettings(fetchTimeout: Duration.zero, minimumFetchInterval: Duration.zero));
  await _remoteConfig.fetch();
  await _remoteConfig.fetchAndActivate();

  return _remoteConfig;
}
