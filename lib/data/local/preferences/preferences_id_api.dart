import 'package:tphotos/data/remote/api/telegram_api_helper.dart';
import 'package:tphotos/services/telegram.dart';

abstract class PreferencesIdApi{


  void saveToken(String token);
  String? getToken();
  void saveSessionId(String sessionId);
  String? getSessionId();
  void saveUsername(String username);
  String? getUsername();
  void saveAvatarUrl(String avatarUrl);
  String? getAvatarUrl();

  TelegramApiHelper getTelegramService();
}