import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigService {
  /* ... */

  late final FirebaseRemoteConfig _remoteConfig;

  String getString(String key) => _remoteConfig.getString(key); // NEW
  bool getBool(String key) =>_remoteConfig.getBool(key); // NEW
  int getInt(String key) =>_remoteConfig.getInt(key); // NEW
  double getDouble(String key) =>_remoteConfig.getDouble(key); // NEW
}

// Dışarıdan erişirken bu şekilde görünecek
final message = FirebaseRemoteConfigService().getString(FirebaseRemoteConfigKeys.welcomeMessage);

class FirebaseRemoteConfigKeys {
  static const String welcomeMessage = 'welcome_message';
}
