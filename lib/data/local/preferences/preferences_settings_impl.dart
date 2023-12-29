import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tphotos/data/local/preferences/preferences_settings_api.dart';

class PreferencesSettingsImpl implements PreferencesSettingsApi {
  final SharedPreferences sharedPreferences;
  static const String _deleteAfterSaveKey = "deleteAfterSave";
  static const String _autoSyncKey = "autoSync";
  static const String _syncedFolders = "autoSyncFolders";
  static const String _firstLaunchFlag = "firstLaunch";
  static const String _foldersUpdated = "foldersUpdated";

  const PreferencesSettingsImpl(this.sharedPreferences);

  @override
  void resetSettings() {
    sharedPreferences.setBool(_autoSyncKey, false);
    sharedPreferences.setBool(_deleteAfterSaveKey, false);
  }

  @override
  void switchAutoSync(bool on) {
    sharedPreferences.setBool(_autoSyncKey, on);
  }

  @override
  void switchDeleteAfterSave(bool on) {
    sharedPreferences.setBool(_deleteAfterSaveKey, on);
  }


  @override
  bool getAutoSyncStatus() {
    return sharedPreferences.getBool(_autoSyncKey) ?? false;
  }

  @override
  bool getDeleteAfterSaveStatus() {
    return sharedPreferences.getBool(_deleteAfterSaveKey) ?? false;
  }

  @override
  List<String> getSyncedFolders() {
    return sharedPreferences.getStringList(_syncedFolders) ?? <String>[];
  }

  @override
  void updateSyncedFoldersList(List<String> folders) {
    debugPrint("preferences_settings_impl $folders");
    sharedPreferences.setStringList(_syncedFolders, folders);
    sharedPreferences.setBool(_foldersUpdated, true);
  }

  @override
  bool checkIsFirstLaunch() {
   return  sharedPreferences.getBool(_firstLaunchFlag) ?? true;
  }

  @override
  void updateFirstLaunchFlag(bool firstLaunch) {
    sharedPreferences.setBool(_firstLaunchFlag, firstLaunch);
  }

  @override
  void updateFoldersUpdatesFlag(bool updated) {
    sharedPreferences.setBool(_foldersUpdated, updated);
  }

  @override
  bool checkFoldersUpdatedFlag() {
    return sharedPreferences.getBool(_foldersUpdated) ?? false;
  }

}
