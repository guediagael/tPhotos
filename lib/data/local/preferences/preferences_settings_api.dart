abstract class PreferencesSettingsApi{

  void resetSettings();

  void switchDeleteAfterSave(bool on);
  void switchAutoSync(bool on);
  void updateSyncedFoldersList(List<String> folders);

  bool getAutoSyncStatus();
  bool getDeleteAfterSaveStatus();
  List<String> getSyncedFolders();
}