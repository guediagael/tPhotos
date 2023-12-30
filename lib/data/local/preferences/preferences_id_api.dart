

abstract class PreferencesIdApi {
  void saveToken(String token);

  String? getToken();

  void saveSessionId(String sessionId);

  String? getSessionId();

  void saveUsername(String username);

  String? getUsername();

  void saveAvatarUrl(String avatarUrl);

  String? getAvatarUrl();
}
