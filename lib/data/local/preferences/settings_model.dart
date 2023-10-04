class SettingsModel {
  final bool deleteAfterSave;
  final bool autoSync;
  final List<String> syncedFoldersUrl;

  SettingsModel(
      {required this.syncedFoldersUrl,
      required this.deleteAfterSave,
      required this.autoSync});

  SettingsModel copyWith(
      {bool? deleteAfterSave, bool? autoSync, List<String>? syncedFolders}) {
    return SettingsModel(
        syncedFoldersUrl: syncedFolders ?? syncedFoldersUrl,
        deleteAfterSave: deleteAfterSave ?? this.deleteAfterSave,
        autoSync: autoSync ?? this.autoSync);
  }
}
