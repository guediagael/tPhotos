abstract class PreferencesSettingsApi{

  void resetSettings();

  void switchDeleteAfterSave(bool on);
  void switchAutoSync(bool on);
  void updateSyncedFoldersList(List<String> folders);
  void updateFirstLaunchFlag(bool firstLaunch);
  void updateFoldersUpdatesFlag(bool updated);

  bool getAutoSyncStatus();
  bool getDeleteAfterSaveStatus();
  List<String> getSyncedFolders();

  bool checkIsFirstLaunch();
  bool checkFoldersUpdatedFlag();
}