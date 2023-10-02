import 'package:shared_preferences/shared_preferences.dart';
import 'package:tphotos/data/data_manager_api.dart';
import 'package:tphotos/data/local/preferences/preference_id_impl.dart';
import 'package:tphotos/data/local/preferences/preferences_id_api.dart';
import 'package:tphotos/data/local/preferences/preferences_settings_api.dart';
import 'package:tphotos/data/local/preferences/preferences_settings_impl.dart';
import 'package:tphotos/services/telegram.dart';

class DataManagerImpl implements DataManagerApi {
  static late final PreferencesIdApi _preferencesIdApi;
  static late final PreferencesSettingsApi _preferencesSettingsApi;

  const DataManagerImpl._internal();

  static Future<DataManagerApi> init(TelegramService telegramService) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _preferencesIdApi = PreferenceIdImpl(
        sharedPreferences: sharedPreferences, telegramService: telegramService);
    _preferencesSettingsApi = PreferencesSettingsImpl(sharedPreferences);
    return const DataManagerImpl._internal();
  }

  static DataManagerApi getInstance() {
    return const DataManagerImpl._internal();
  }

  @override
  PreferencesIdApi get preferencesIdApi => _preferencesIdApi;

  @override
  PreferencesSettingsApi get preferencesSettingsApi => _preferencesSettingsApi;
}
