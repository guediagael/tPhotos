import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tphotos/data/data_manager_api.dart';
import 'package:tphotos/data/local/databases/database_impl.dart';
import 'package:tphotos/data/local/databases/media_database_api.dart';
import 'package:tphotos/data/local/preferences/preference_id_impl.dart';
import 'package:tphotos/data/local/preferences/preferences_id_api.dart';
import 'package:tphotos/data/local/preferences/preferences_settings_api.dart';
import 'package:tphotos/data/local/preferences/preferences_settings_impl.dart';
import 'package:tphotos/data/remote/api/telegram_api_helper.dart';
import 'package:tphotos/data/remote/api/telegram_helper_impl.dart';
import 'package:tphotos/services/telegram.dart';

class DataManagerImpl implements DataManagerApi {
  static late final PreferencesIdApi _preferencesIdApi;
  static late final PreferencesSettingsApi _preferencesSettingsApi;
  static late final MediaDatabase _mediaDatabase;
  static late final FirebaseAnalytics _firebaseAnalytics;
  static late final TelegramApiHelper _telegramApiHelper;

  const DataManagerImpl._internal();

  static Future<DataManagerApi> init(Map<String, dynamic> keys) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final tgService = await TelegramService.build(keys);
    _telegramApiHelper = TelegramHelperImplementation(tgService);
    _preferencesIdApi = PreferenceIdImpl(sharedPreferences: sharedPreferences);
    _preferencesSettingsApi = PreferencesSettingsImpl(sharedPreferences);
    _mediaDatabase = await DatabaseImpl.open();
    _firebaseAnalytics = FirebaseAnalytics.instance;
    return const DataManagerImpl._internal();
  }

  static DataManagerApi getInstance() {
    return const DataManagerImpl._internal();
  }

  @override
  PreferencesIdApi get preferencesIdApi => _preferencesIdApi;

  @override
  PreferencesSettingsApi get preferencesSettingsApi => _preferencesSettingsApi;

  @override
  MediaDatabase get mediaDatabase => _mediaDatabase;

  @override
  FirebaseAnalytics get firebaseAnalyticsInstance => _firebaseAnalytics;

  @override
  TelegramApiHelper get telegramApiHelper => _telegramApiHelper;
}
