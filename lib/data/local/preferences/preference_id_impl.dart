import 'package:shared_preferences/shared_preferences.dart';
import 'package:tphotos/data/local/preferences/preferences_id_api.dart';
import 'package:tphotos/data/remote/api/telegram_api_helper.dart';
import 'package:tphotos/data/remote/api/telegram_helper_impl.dart';
import 'package:tphotos/services/telegram.dart';

class PreferenceIdImpl implements PreferencesIdApi {
  final SharedPreferences sharedPreferences;
  late final TelegramHelperImplementation telegramService;
  static const String _profilePictureKey = "ProfilePicture";
  static const String _sessionIdKey = "sessionId";
  static const String _tokenKey = "token";
  static const String _usernameKey = "username";

  PreferenceIdImpl(
      {required this.sharedPreferences, required TelegramService telegramService}){
    this.telegramService = TelegramHelperImplementation(telegramService);
  }

  @override
  String? getAvatarUrl() {
    return sharedPreferences.getString(_profilePictureKey);
  }

  @override
  String? getSessionId() {
    return sharedPreferences.getString(_sessionIdKey);
  }

  @override
  String? getToken() {
    return sharedPreferences.getString(_tokenKey);
  }

  @override
  String? getUsername() {
    return sharedPreferences.getString(_usernameKey);
  }

  @override
  void saveAvatarUrl(String avatarUrl) {
    sharedPreferences.setString(_profilePictureKey, avatarUrl);
  }

  @override
  void saveSessionId(String sessionId) {
    sharedPreferences.setString(_sessionIdKey, sessionId);
  }

  @override
  void saveToken(String token) {
    sharedPreferences.setString(_tokenKey, token);
  }

  @override
  void saveUsername(String username) {
    sharedPreferences.setString(_usernameKey, username);
  }

  @override
  TelegramApiHelper getTelegramService() => telegramService;
}
