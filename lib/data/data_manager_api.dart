import 'package:tphotos/data/local/databases/media_database_api.dart';
import 'package:tphotos/data/local/preferences/preferences_id_api.dart';
import 'package:tphotos/data/local/preferences/preferences_settings_api.dart';
import 'package:tphotos/data/remote/api/telegram_api_helper.dart';

abstract class DataManagerApi {

  PreferencesIdApi get preferencesIdApi ;

  PreferencesSettingsApi get preferencesSettingsApi ;

  MediaDatabase get mediaDatabase;

  // FirebaseAnalytics get firebaseAnalyticsInstance;

  TelegramApiHelper get telegramApiHelper;
}
