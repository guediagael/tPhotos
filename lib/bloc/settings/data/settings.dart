
import 'package:tphotos/data/local/preferences/preferences_settings_api.dart';

class Settings {
  final bool autoSync;
  final bool deleteAfterSave;
  final List<String> selectedFolders;
  final String termsOfService = "Terms of Services url (Link to github readme";
  final String privacyPolicies = 'Privacy Policies url (link to github readme)';
  final String legalNotice = "Legal Notice (link to github readme)";

  Settings(
      {required this.autoSync,
      required this.deleteAfterSave,
      required this.selectedFolders});

  Settings copyWith(
      {bool? autoSync, bool? deleteAfterSave, List<String>? selectedFolders}) {
    return Settings(
        autoSync: autoSync ?? this.autoSync,
        deleteAfterSave: deleteAfterSave ?? this.deleteAfterSave,
        selectedFolders: selectedFolders ?? this.selectedFolders);
  }

  static Settings fromSharedPreferences(
      PreferencesSettingsApi preferencesSettingsApi) {
    bool autoSync = preferencesSettingsApi.getAutoSyncStatus();
    bool deleteAfterSave = preferencesSettingsApi.getDeleteAfterSaveStatus();
    List<String> selectedFolders = preferencesSettingsApi.getSyncedFolders();
    return Settings(
        autoSync: autoSync,
        deleteAfterSave: deleteAfterSave,
        selectedFolders: selectedFolders);
  }
}
